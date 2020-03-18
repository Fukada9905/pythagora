DROP PROCEDURE IF EXISTS pyt_p_103030;
DELIMITER //
CREATE PROCEDURE pyt_p_103030(
	IN p_process_divide tinyint
,	IN p_target_divide tinyint
,   IN p_target_date date
,	IN p_selections text
,	IN p_user_id varchar(20)
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
    
    SELECT GROUP_CONCAT(CONCAT('\'',NNSICD,'\'')) INTO @nnsicd FROM pyt_m_ninushi;
    
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
		,	WGT decimal(10,1) NOT NULL DEFAULT 0		
		);
        
        
        SET @sql_ins = 'INSERT INTO tmp_data';
		SET @sql_ins = CONCAT(@sql_ins,' SELECT');
        SET @sql_ins = CONCAT(@sql_ins,' UNSKSCD');
		SET @sql_ins = CONCAT(@sql_ins,',UNSKSNM');
        SET @sql_ins = CONCAT(@sql_ins,',NHNSKCD');
		SET @sql_ins = CONCAT(@sql_ins,',NHNSKNM');
		SET @sql_ins = CONCAT(@sql_ins,',JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,',JGSNM');
		SET @sql_ins = CONCAT(@sql_ins,',SNTCD');
		SET @sql_ins = CONCAT(@sql_ins,',SNTNM');
		SET @sql_ins = CONCAT(@sql_ins,',NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,',NNSINM');
        SET @sql_ins = CONCAT(@sql_ins,',KKTSR1');
        SET @sql_ins = CONCAT(@sql_ins,',WGT');
        
        SET @sql_ins = CONCAT(@sql_ins,' FROM pyt_w_103040_details');
		IF p_selections IS NOT NULL THEN
			SET @sql_ins = CONCAT(@sql_ins,' WHERE user_id = \'',p_user_id,'\'');
			SET @sql_ins = CONCAT(@sql_ins,' AND process_divide = ',p_process_divide);
			SET @sql_ins = CONCAT(@sql_ins,' AND work_id IN(',p_selections,')');
		ELSE
			SET @sql_ins = CONCAT(@sql_ins,' WHERE user_id = \'',p_user_id,'\'');
			SET @sql_ins = CONCAT(@sql_ins,' AND process_divide = ',p_process_divide);
		END IF;
		SET @sql_ins = CONCAT(@sql_ins,' AND DENPYOYMD = \'',p_target_date,'\'');
        
        
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
		,	WGT decimal(10,1) NOT NULL DEFAULT 0		
		);
        
        
        
        SET @sql_ins = 'INSERT INTO tmp_data';
		SET @sql_ins = CONCAT(@sql_ins,' SELECT');
        SET @sql_ins = CONCAT(@sql_ins,' JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,',JGSNM');
		SET @sql_ins = CONCAT(@sql_ins,',SNTCD');
		SET @sql_ins = CONCAT(@sql_ins,',SNTNM');
		SET @sql_ins = CONCAT(@sql_ins,',NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,',NNSINM');
        SET @sql_ins = CONCAT(@sql_ins,',NHNSKCD');
		SET @sql_ins = CONCAT(@sql_ins,',NHNSKNM');        
        SET @sql_ins = CONCAT(@sql_ins,',UNSKSCD');
		SET @sql_ins = CONCAT(@sql_ins,',UNSKSNM');        		
        SET @sql_ins = CONCAT(@sql_ins,',KKTSR1');
        SET @sql_ins = CONCAT(@sql_ins,',WGT');
        
        SET @sql_ins = CONCAT(@sql_ins,' FROM pyt_w_103040_details');
		IF p_selections IS NOT NULL THEN
			SET @sql_ins = CONCAT(@sql_ins,' WHERE user_id = \'',p_user_id,'\'');
			SET @sql_ins = CONCAT(@sql_ins,' AND process_divide = ',p_process_divide);
			SET @sql_ins = CONCAT(@sql_ins,' AND work_id IN(',p_selections,')');
		ELSE
			SET @sql_ins = CONCAT(@sql_ins,' WHERE user_id = \'',p_user_id,'\'');
			SET @sql_ins = CONCAT(@sql_ins,' AND process_divide = ',p_process_divide);
		END IF;
		SET @sql_ins = CONCAT(@sql_ins,' AND DENPYOYMD = \'',p_target_date,'\'');
        
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
DELIMITER ;
