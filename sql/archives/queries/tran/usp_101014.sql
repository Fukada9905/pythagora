DROP PROCEDURE IF EXISTS usp_101014;
delimiter //

CREATE PROCEDURE usp_101014(
	IN p_process_divide tinyint
,	IN p_is_partner tinyint
,	IN p_date_divide tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_management_cd varchar(10)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_ymd_total;
		DROP TABLE IF EXISTS tmp_data_total;
		DROP TABLE IF EXISTS tmp_data;
        RESIGNAL;
    END;
    	
    
	CREATE TEMPORARY TABLE tmp_data(
		DATEYMD date
	,	NNSICD varchar(10)
    ,	NNSINM varchar(50)
    ,	KKTSR1 int NOT NULL DEFAULT 0
    ,	KKTSR3 int NOT NULL DEFAULT 0
    ,	WGT int NOT NULL DEFAULT 0    
    );
	

    
    SET @sql_ins = 'INSERT INTO tmp_data';
	SET @sql_ins = CONCAT(@sql_ins, ' SELECT');
    IF p_date_divide = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins, '  SH.SYUKAYMD AS DATEYMD');
    ELSE
		SET @sql_ins = CONCAT(@sql_ins, '  SH.NOHINYMD AS DATEYMD');
    END IF;
    SET @sql_ins = CONCAT(@sql_ins, ', SH.NNSICD');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.NNSINM');
    
	IF p_process_divide = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins, ', SD.JCSR1 AS KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins, ', SD.JCSR3 AS KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins, ', TRUNCATE(SD.JCSJR+0.9, 0) AS WGT');
        SET @sql_ins = CONCAT(@sql_ins, '  FROM shipment_provisionals AS SH');
        SET @sql_ins = CONCAT(@sql_ins, '  INNER JOIN shipment_provisional_details AS SD');
        SET @sql_ins = CONCAT(@sql_ins, '  ON SH.ID = SD.ID');		
	ELSE
		SET @sql_ins = CONCAT(@sql_ins, ', SD.KKTSR1 AS KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins, ', SD.KKTSR3 AS KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins, ', TRUNCATE(SD.WGT+0.9, 0) AS WGT');
        SET @sql_ins = CONCAT(@sql_ins, '  FROM shipment_confirms AS SH');
        SET @sql_ins = CONCAT(@sql_ins, '  INNER JOIN shipment_confirm_details AS SD');
        SET @sql_ins = CONCAT(@sql_ins, '  ON SH.ID = SD.ID');    
    END IF;
    
    
    IF p_is_partner = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN mtb_sp_conditions AS SP');
		SET @sql_ins = CONCAT(@sql_ins,' ON SH.NNSICD = SP.NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,' AND SD.JGSCD = SP.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR SD.SNTCD = SP.SNTCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.UNSKSCD IS NULL OR SH.UNSKSCD = SP.UNSKSCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SYUKAP IS NULL OR SH.SYUKAP = SP.SYUKAP)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SEKKBN IS NULL OR SD.SEKKBN = SP.SEKKBN)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.NHNSKCD IS NULL OR SH.NHNSKCD = SP.NHNSKCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND SP.SKTISFRG = 1');			        
	END IF;
    
    SET @sql_where = null;
    IF p_process_divide = 1 THEN
		SET @sql_where = ' WHERE SH.DKBN = \'AM\'';	
	ELSE
		SET @sql_where = ' WHERE SH.SKHNYKBN1 != \'A2\'';			
	END IF;
        
	IF p_date_from IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		IF p_date_divide = 1 THEN
			SET @sql_where = CONCAT(@sql_where,' SH.SYUKAYMD >= \'',p_date_from,'\'');
		ELSE
			SET @sql_where = CONCAT(@sql_where,' SH.NOHINYMD >= \'',p_date_from,'\'');
		END IF;					
	END IF;
	
	IF p_date_to IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		IF p_date_divide = 1 THEN
			SET @sql_where = CONCAT(@sql_where,' SH.SYUKAYMD <= \'',p_date_to,'\'');
		ELSE
			SET @sql_where = CONCAT(@sql_where,' SH.NOHINYMD <= \'',p_date_to,'\'');
		END IF;					
	END IF;
    
    IF p_jgscd IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		SET @sql_where = CONCAT(@sql_where,' SD.JGSCD IN(',p_jgscd,')');				
	END IF;
	IF p_is_partner = 1 THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		SET @sql_where = CONCAT(@sql_where,' SP.PTNCD = \'',p_management_cd,'\'');		
	END IF;
        

	SET @sql_ins = CONCAT(@sql_ins,IFNULL(@sql_where,''));

	
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
            
    IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
		CREATE TEMPORARY TABLE tmp_data_details
        SELECT
			ufn_get_date_format(DATEYMD) AS DATEYMD
		,	NNSICD
        ,	NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(WGT) AS WGT
        ,	1 AS DATA_DIVIDE
		FROM tmp_data
        GROUP BY
			DATEYMD
		,	NNSICD
        ,	NNSINM;
        
        CREATE TEMPORARY TABLE tmp_data_ymd_total
        SELECT
			CONCAT(ufn_get_date_format(DATEYMD),' 集計') AS DATEYMD
		,	'ZZZZZZZZZZ' AS NNSICD
        ,	'' AS NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(WGT) AS WGT
        ,	2 AS DATA_DIVIDE
		FROM tmp_data
        GROUP BY
			DATEYMD
		;
        
        CREATE TEMPORARY TABLE tmp_data_total
        SELECT
			'ZZZZZZZZZZ' AS DATEYMD
		,	'ZZZZZZZZZZ' AS NNSICD
        ,	'' AS NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(WGT) AS WGT
        ,	3 AS DATA_DIVIDE
		FROM tmp_data
        ;
		
                
        SELECT
			*
		FROM tmp_data_details
		UNION ALL
		SELECT
			*
		FROM tmp_data_ymd_total
		UNION ALL
		SELECT
			*
		FROM tmp_data_total
		ORDER BY DATEYMD,DATA_DIVIDE,NNSICD;    			
	ELSE
		SELECT * FROM tmp_data;
    END IF;
    
    
    DROP TABLE IF EXISTS tmp_data_details;
	DROP TABLE IF EXISTS tmp_data_ymd_total;
	DROP TABLE IF EXISTS tmp_data_total;
	DROP TABLE IF EXISTS tmp_data;
        
    
END//

delimiter ;