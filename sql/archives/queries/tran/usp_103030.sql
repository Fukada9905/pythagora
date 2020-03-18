DROP PROCEDURE IF EXISTS usp_103030;
delimiter //

CREATE PROCEDURE usp_103030(
	IN p_target_divide tinyint
,   IN p_target_date date
,	IN p_jgscd text
,	IN p_is_partner tinyint
,	IN p_ptncd varchar(10)
)
BEGIN
	    
    
    
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TEMPORARY TABLE IF EXISTS tmp_data;
		DROP TEMPORARY TABLE IF EXISTS tmp_data_details;
		DROP TEMPORARY TABLE IF EXISTS tmp_data_detail_totals;
		DROP TEMPORARY TABLE IF EXISTS tmp_data_totals;
        RESIGNAL;
    END;
    
    
    
    IF p_target_divide = 1 THEN
		-- 機材別補給物量
        CREATE TEMPORARY TABLE tmp_data(
			UNSKSCD varchar(10)
		,	UNSKSNM varchar(50)
        ,	NHNSKCD varchar(10)
		,	NHNSKNM varchar(50)
		,	JGSCD varchar(10)
		,	JGSNM varchar(50)    
        ,	SNTCD varchar(10)
		,	SNTNM varchar(50)            
        ,	NNSICD varchar(10)
		,	NNSINM varchar(50)    
		,	KKTSR1 int NOT NULL DEFAULT 0
		,	WGT int NOT NULL DEFAULT 0		
		);
        
        
        SET @sql_ins = 'INSERT INTO tmp_data';
		SET @sql_ins = CONCAT(@sql_ins,' SELECT');
		SET @sql_ins = CONCAT(@sql_ins,'  SH.UNSKSCD');
		SET @sql_ins = CONCAT(@sql_ins,', SH.UNSKSNM');
		SET @sql_ins = CONCAT(@sql_ins,', SH.NHNSKCD');
		SET @sql_ins = CONCAT(@sql_ins,', SH.NHNSKNM');
        SET @sql_ins = CONCAT(@sql_ins,', SD.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,', SD.JGSNM');
        SET @sql_ins = CONCAT(@sql_ins,', SD.SNTCD');
		SET @sql_ins = CONCAT(@sql_ins,', SD.SNTNM');
		SET @sql_ins = CONCAT(@sql_ins,', SH.NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,', SH.NNSINM');            
		SET @sql_ins = CONCAT(@sql_ins,', SD.KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SD.WGT+0.9, 0)');
		SET @sql_ins = CONCAT(@sql_ins,' FROM shipment_confirms AS SH');
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN shipment_confirm_details AS SD');
		SET @sql_ins = CONCAT(@sql_ins,' ON SH.ID = SD.ID');		
        IF p_is_partner = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins,' LEFT JOIN mtb_sp_conditions AS SP');
			SET @sql_ins = CONCAT(@sql_ins,' ON SH.NNSICD = SP.NNSICD');
			SET @sql_ins = CONCAT(@sql_ins,' AND SD.JGSCD = SP.JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR SD.SNTCD = SP.SNTCD)');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.UNSKSCD IS NULL OR SH.UNSKSCD = SP.UNSKSCD)');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SYUKAP IS NULL OR SH.SYUKAP = SP.SYUKAP)');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SEKKBN IS NULL OR SD.SEKKBN = SP.SEKKBN)');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.NHNSKCD IS NULL OR SH.NHNSKCD = SP.NHNSKCD)');
			SET @sql_ins = CONCAT(@sql_ins,' AND SP.SKTISFRG = 1');			
        END IF;
		SET @sql_ins = CONCAT(@sql_ins,' WHERE SH.SKHNYKBN1 = \'A2\'');
        SET @sql_ins = CONCAT(@sql_ins,' AND SH.DENPYOYMD = \'',p_target_date,'\'');
		IF p_jgscd IS NOT NULL THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SD.JGSCD IN(',p_jgscd,')');				
		END IF;
        IF p_is_partner = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SP.PTNCD = \'',p_ptncd,'\'');				
        END IF;
        
        
		PREPARE _stmt_ins from @sql_ins;
		EXECUTE _stmt_ins;
		DEALLOCATE PREPARE _stmt_ins;
        
        
        IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
        
			CREATE TEMPORARY TABLE tmp_data_details
			SELECT
				UNSKSCD
			,	UNSKSNM
			,	NHNSKCD
			,	NHNSKNM
			,	JGSCD
			,	JGSNM
			,	SNTCD
			,	SNTNM
			,	NNSICD
			,	NNSINM           
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(WGT) AS WGT        
			,	1 AS DATA_DIVIDE
			FROM tmp_data AS DD
			GROUP BY
				UNSKSCD
			,	UNSKSNM
			,	NHNSKCD
			,	NHNSKNM
			,	JGSCD
			,	JGSNM
			,	SNTCD
			,	SNTNM
			,	NNSICD
			,	NNSINM;
            
            
            CREATE TEMPORARY TABLE tmp_data_detail_totals
			SELECT
				UNSKSCD
			,	UNSKSNM
			,	NHNSKCD
			,	CONCAT(NHNSKNM,' 集計') AS NHNSKNM
			,	'ZZZZZZZZZZ' AS JGSCD
			,	'' AS JGSNM
			,	'ZZZZZZZZZZ' AS SNTCD
			,	'' AS SNTNM
			,	'ZZZZZZZZZZ' AS NNSICD
			,	'' AS NNSINM
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(WGT) AS WGT        
			,	2 AS DATA_DIVIDE
			FROM tmp_data AS DD
			GROUP BY
				UNSKSCD
			,	UNSKSNM
			,	NHNSKCD
			,	NHNSKNM
			;
            
            CREATE TEMPORARY TABLE tmp_data_unsks_totals
			SELECT
				UNSKSCD
			,	CONCAT(UNSKSNM,' 集計') AS UNSKSNM
			,	'ZZZZZZZZZZ' AS NHNSKCD
			,	'' AS NHNSKNM
			,	'ZZZZZZZZZZ' AS JGSCD
			,	'' AS JGSNM
			,	'ZZZZZZZZZZ' AS SNTCD
			,	'' AS SNTNM
			,	'ZZZZZZZZZZ' AS NNSICD
			,	'' AS NNSINM
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(WGT) AS WGT        
			,	3 AS DATA_DIVIDE
			FROM tmp_data AS DD
			GROUP BY
				UNSKSCD
			,	UNSKSNM			
			;
            
            
            CREATE TEMPORARY TABLE tmp_data_totals
			SELECT
				'ZZZZZZZZZZ'
			,	'' AS UNSKSNM
			,	'ZZZZZZZZZZ' AS NHNSKCD
			,	'' AS NHNSKNM
			,	'ZZZZZZZZZZ' AS JGSCD
			,	'' AS JGSNM
			,	'ZZZZZZZZZZ' AS SNTCD
			,	'' AS SNTNM
			,	'ZZZZZZZZZZ' AS NNSICD
			,	'' AS NNSINM
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(WGT) AS WGT        
			,	4 AS DATA_DIVIDE
			FROM tmp_data AS DD
			;
            
            
            SELECT * FROM tmp_data_details
            UNION ALL
            SELECT * FROM tmp_data_detail_totals
            UNION ALL
            SELECT * FROM tmp_data_unsks_totals
            UNION ALL
            SELECT * FROM tmp_data_totals
            ORDER BY UNSKSCD,NHNSKCD,DATA_DIVIDE,JGSCD,SNTCD,NNSICD;

        ELSE
			SELECT * FROM tmp_data;
        END IF;
        
        
        
    ELSE
		-- 出荷倉庫別補給物量
        CREATE TEMPORARY TABLE tmp_data(
			JGSCD varchar(10)
		,	JGSNM varchar(50)    
        ,	SNTCD varchar(10)
		,	SNTNM varchar(50)            
        ,	NNSICD varchar(10)
		,	NNSINM varchar(50)    
        ,	NHNSKCD varchar(10)
		,	NHNSKNM varchar(50)
        ,	UNSKSCD varchar(10)
		,	UNSKSNM varchar(50)
        ,	KKTSR1 int NOT NULL DEFAULT 0
		,	WGT int NOT NULL DEFAULT 0		
		);
        
        
        SET @sql_ins = 'INSERT INTO tmp_data';
		SET @sql_ins = CONCAT(@sql_ins,' SELECT');
		SET @sql_ins = CONCAT(@sql_ins,'  SD.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,', SD.JGSNM');
        SET @sql_ins = CONCAT(@sql_ins,', SD.SNTCD');
		SET @sql_ins = CONCAT(@sql_ins,', SD.SNTNM');
		SET @sql_ins = CONCAT(@sql_ins,', SH.NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,', SH.NNSINM');            
		SET @sql_ins = CONCAT(@sql_ins,', SH.NHNSKCD');
		SET @sql_ins = CONCAT(@sql_ins,', SH.NHNSKNM');
        SET @sql_ins = CONCAT(@sql_ins,', SH.UNSKSCD');
		SET @sql_ins = CONCAT(@sql_ins,', SH.UNSKSNM');		
        SET @sql_ins = CONCAT(@sql_ins,', SD.KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SD.WGT+0.9, 0)');
		SET @sql_ins = CONCAT(@sql_ins,' FROM shipment_confirms AS SH');
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN shipment_confirm_details AS SD');
		SET @sql_ins = CONCAT(@sql_ins,' ON SH.ID = SD.ID');		
        IF p_is_partner = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins,' LEFT JOIN mtb_sp_conditions AS SP');
			SET @sql_ins = CONCAT(@sql_ins,' ON SH.NNSICD = SP.NNSICD');
			SET @sql_ins = CONCAT(@sql_ins,' AND SD.JGSCD = SP.JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR SD.SNTCD = SP.SNTCD)');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.UNSKSCD IS NULL OR SH.UNSKSCD = SP.UNSKSCD)');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SYUKAP IS NULL OR SH.SYUKAP = SP.SYUKAP)');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SEKKBN IS NULL OR SD.SEKKBN = SP.SEKKBN)');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.NHNSKCD IS NULL OR SH.NHNSKCD = SP.NHNSKCD)');
			SET @sql_ins = CONCAT(@sql_ins,' AND SP.SKTISFRG = 1');
			SET @sql_ins = CONCAT(@sql_ins,' LEFT JOIN mtb_partners AS PN');
			SET @sql_ins = CONCAT(@sql_ins,' ON SP.PTNCD = PN.PTNCD');
        END IF;
        SET @sql_ins = CONCAT(@sql_ins,' WHERE SH.SKHNYKBN1 = \'A2\'');
		SET @sql_ins = CONCAT(@sql_ins,' AND SH.DENPYOYMD = \'',p_target_date,'\'');
		IF p_jgscd IS NOT NULL THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SD.JGSCD IN(',p_jgscd,')');				
		END IF;
        IF p_is_partner = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SP.PTNCD = \'',p_ptncd,'\'');				
        END IF;
        
        PREPARE _stmt_ins from @sql_ins;
		EXECUTE _stmt_ins;
		DEALLOCATE PREPARE _stmt_ins;
        
        
        IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
        
			CREATE TEMPORARY TABLE tmp_data_details
			SELECT
				JGSCD
			,	JGSNM
			,	SNTCD
			,	SNTNM
            ,	NNSICD
			,	NNSINM           
            ,	NHNSKCD
			,	NHNSKNM
            ,	UNSKSCD
			,	UNSKSNM
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(WGT) AS WGT        
			,	1 AS DATA_DIVIDE
			FROM tmp_data AS DD
			GROUP BY
				JGSCD
			,	JGSNM
			,	SNTCD
			,	SNTNM
            ,	NNSICD
			,	NNSINM           
            ,	NHNSKCD
			,	NHNSKNM
            ,	UNSKSCD
			,	UNSKSNM;
            
            
            CREATE TEMPORARY TABLE tmp_data_detail_totals
			SELECT
				JGSCD
			,	JGSNM
			,	SNTCD
			,	SNTNM
            ,	NNSICD
			,	CONCAT(NNSINM ,' 集計') AS NNSINM       
            ,	'ZZZZZZZZZZ' AS NHNSKCD
			,	'' AS NHNSKNM
            ,	'ZZZZZZZZZZ' AS UNSKSCD
			,	'' AS UNSKSNM
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(WGT) AS WGT        
			,	2 AS DATA_DIVIDE
			FROM tmp_data AS DD
			GROUP BY
				JGSCD
			,	JGSNM
			,	SNTCD
			,	SNTNM
            ,	NNSICD
            ,	NNSINM
			;
            
            CREATE TEMPORARY TABLE tmp_data_sntcd_totals
			SELECT
				JGSCD
			,	JGSNM
			,	SNTCD
			,	CONCAT(SNTNM,' 集計') AS SNTNM
            ,	'ZZZZZZZZZZ' AS NNSICD
			,	'' AS NNSINM       
            ,	'ZZZZZZZZZZ' AS NHNSKCD
			,	'' AS NHNSKNM
            ,	'ZZZZZZZZZZ' AS UNSKSCD
			,	'' AS UNSKSNM
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(WGT) AS WGT        
			,	3 AS DATA_DIVIDE
			FROM tmp_data AS DD
			GROUP BY
				JGSCD
			,	JGSNM
			,	SNTCD
			,	SNTNM
            ;
            
            CREATE TEMPORARY TABLE tmp_data_totals
			SELECT
				'ZZZZZZZZZZ' AS JGSCD
			,	'' AS JGSNM
			,	'ZZZZZZZZZZ' AS SNTCD
			,	'' AS SNTNM
            ,	'ZZZZZZZZZZ' AS NNSICD
			,	'' AS NNSINM       
            ,	'ZZZZZZZZZZ' AS NHNSKCD
			,	'' AS NHNSKNM
            ,	'ZZZZZZZZZZ' AS UNSKSCD
			,	'' AS UNSKSNM
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(WGT) AS WGT        
			,	4 AS DATA_DIVIDE
			FROM tmp_data AS DD
			;
            
            
            SELECT * FROM tmp_data_details
            UNION ALL
            SELECT * FROM tmp_data_detail_totals
            UNION ALL
            SELECT * FROM tmp_data_sntcd_totals
            UNION ALL
            SELECT * FROM tmp_data_totals
            ORDER BY JGSCD,SNTCD,NNSICD,DATA_DIVIDE,NHNSKCD,UNSKSCD;

        ELSE
			SELECT * FROM tmp_data;
        END IF;
        
    END IF;
    
 
    DROP TEMPORARY TABLE IF EXISTS tmp_data;
    DROP TEMPORARY TABLE IF EXISTS tmp_data_details;
    DROP TEMPORARY TABLE IF EXISTS tmp_data_detail_totals;
    DROP TEMPORARY TABLE IF EXISTS tmp_data_unsks_totals;
    DROP TEMPORARY TABLE IF EXISTS tmp_data_sntcd_totals;
    DROP TEMPORARY TABLE IF EXISTS tmp_data_totals;
        
    
END//

delimiter ;