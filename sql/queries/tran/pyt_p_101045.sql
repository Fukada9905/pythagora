DROP PROCEDURE IF EXISTS pyt_p_101045;
delimiter //

CREATE PROCEDURE pyt_p_101045(
	IN p_process_divide tinyint
,	IN p_selections text
,	IN p_user_id varchar(20)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_ymd_total;
		DROP TABLE IF EXISTS tmp_data_total;
		DROP TABLE IF EXISTS tmp_data;
        DROP TABLE IF EXISTS tmp_order_data_type;
        RESIGNAL;
    END;
    	
    
	CREATE TEMPORARY TABLE tmp_data(
    	DATEYMD date
	,	NHNSKCD varchar(10)
    ,	NHNSKNM varchar(10)
    ,	JYUSYO varchar(100)
    ,	BIKO varchar(200)
    ,	NNSICD varchar(10)
    ,	NNSINM varchar(50)    
    ,	KKTSR1 int NOT NULL DEFAULT 0
    ,	KKTSR3 int NOT NULL DEFAULT 0
    ,	WGT decimal(10,1) NOT NULL DEFAULT 0    
    );
    
	 
    SET @sql_ins = 'INSERT INTO tmp_data';
    SET @sql_ins = CONCAT(@sql_ins, ' SELECT');
    SET @sql_ins = CONCAT(@sql_ins, ' DATEYMD');
    SET @sql_ins = CONCAT(@sql_ins, ', NHNSKCD');
    SET @sql_ins = CONCAT(@sql_ins, ', NHNSKNM');
    SET @sql_ins = CONCAT(@sql_ins, ', JYUSYO');
    SET @sql_ins = CONCAT(@sql_ins, ', BIKO');    
	SET @sql_ins = CONCAT(@sql_ins, ', NNSICD');
    SET @sql_ins = CONCAT(@sql_ins, ', NNSINM');
    SET @sql_ins = CONCAT(@sql_ins, ', KKTSR1');
    SET @sql_ins = CONCAT(@sql_ins, ', KKTSR3');
    SET @sql_ins = CONCAT(@sql_ins, ', WGT');
    SET @sql_ins = CONCAT(@sql_ins,' FROM pyt_w_101040_details');
	IF p_selections IS NOT NULL THEN
		SET @sql_ins = CONCAT(@sql_ins,' WHERE user_id = \'',p_user_id,'\'');
		SET @sql_ins = CONCAT(@sql_ins,' AND process_divide = ',p_process_divide);
		SET @sql_ins = CONCAT(@sql_ins,' AND work_id IN(',p_selections,')');
	ELSE
		SET @sql_ins = CONCAT(@sql_ins,' WHERE user_id = \'',p_user_id,'\'');
		SET @sql_ins = CONCAT(@sql_ins,' AND process_divide = ',p_process_divide);
	END IF;
        
   
   
    
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
            
    IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
		CREATE TEMPORARY TABLE tmp_data_details
        SELECT
			pyt_ufn_get_date_format(DATEYMD) AS DATEYMD
		,	NHNSKCD
		,	NHNSKNM
        ,	JYUSYO
        ,	BIKO
		,	NNSICD
        ,	NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(WGT) AS WGT
        ,	1 AS DATA_DIVIDE
		FROM tmp_data
        GROUP BY
			DATEYMD
		,	NHNSKCD
		,	NHNSKNM
        ,	JYUSYO
        ,	BIKO
		,	NNSICD
        ,	NNSINM;
        
        CREATE TEMPORARY TABLE tmp_data_ymd_total
        SELECT
			CONCAT(pyt_ufn_get_date_format(DATEYMD),' 集計') AS DATEYMD
		,	'ZZZZZZZZZZ' AS NHNSKCD
		,	'' AS NHNSKNM
        ,	'' AS JYUSYO
        ,	'' AS BIKO
        ,	'' AS NNSICD
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
		,	'ZZZZZZZZZZ' AS NHNSKCD
		,	'' AS NHNSKNM
        ,	'' AS JYUSYO
        ,	'' AS BIKO
        ,	'' AS NNSICD
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
		ORDER BY DATEYMD,DATA_DIVIDE,JYUSYO,NHNSKCD;    			
	ELSE
		SELECT * FROM tmp_data;
    END IF;
    
    
    DROP TABLE IF EXISTS tmp_data_details;
	DROP TABLE IF EXISTS tmp_data_ymd_total;
	DROP TABLE IF EXISTS tmp_data_total;
	DROP TABLE IF EXISTS tmp_data;
    DROP TABLE IF EXISTS tmp_order_data_type;
        
    
END//
DELIMITER ;
