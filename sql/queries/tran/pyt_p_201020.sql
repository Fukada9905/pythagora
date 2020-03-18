DROP PROCEDURE IF EXISTS pyt_p_201020;
delimiter //

CREATE PROCEDURE pyt_p_201020(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(20)
)
BEGIN
	
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
    	DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_ymd_total;
		DROP TABLE IF EXISTS tmp_data_total;
		DROP TABLE IF EXISTS tmp_data;
        DROP TABLE IF EXISTS tmp_sntcd;
        RESIGNAL;
    END;

    -- トランザクション開始
    START TRANSACTION;
    
	DELETE FROM pyt_w_201020 WHERE user_id = p_user_id;
	
	
        
	IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD = CONCAT('INSERT INTO tmp_sntcd(JGSCD,SNTCD) VALUES',p_sntcd);
        
        PREPARE stmt_SNTCD from @sql_SNTCD;
		EXECUTE stmt_SNTCD;
		DEALLOCATE PREPARE stmt_SNTCD;
	END IF;
    
    
	CREATE TEMPORARY TABLE tmp_data(
		NOHINYMD date
	,	JGSCD varchar(10)
    ,	JGSNM varchar(50)
    ,	NNSICD varchar(10)
    ,	NNSINM varchar(50)
    ,	KKTSR1 int NOT NULL DEFAULT 0
    ,	MOD_PL int NOT NULL DEFAULT 0    
    );
	

    
    SET @sql_ins = 'INSERT INTO tmp_data';
	SET @sql_ins = CONCAT(@sql_ins, ' SELECT');
    SET @sql_ins = CONCAT(@sql_ins, '  AH.arrival_date AS NOHINYMD');
	SET @sql_ins = CONCAT(@sql_ins, ', AH.source_sales_office_code AS JGSCD_SK');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.source_sales_office_name AS JGSNM_SK');     
    SET @sql_ins = CONCAT(@sql_ins, ', AH.shipper_code AS NNSICD');
    SET @sql_ins = CONCAT(@sql_ins, ', NN.NNSINM AS NNSINM');    
	SET @sql_ins = CONCAT(@sql_ins, ', pyt_ufn_get_KKTSR(AH.package_count, AH.total_fraction, AH.quantity_per_package) AS KKTSR1');	
	SET @sql_ins = CONCAT(@sql_ins, ', CASE WHEN AH.package_count_per_pallet >= pyt_ufn_get_KKTSR(AH.package_count, AH.total_fraction, AH.quantity_per_package) THEN 1 ELSE TRUNCATE((pyt_ufn_get_KKTSR(AH.package_count, AH.total_fraction, AH.quantity_per_package)/AH.package_count_per_pallet)+.9,0) END AS MOD_PL');  
    SET @sql_ins = CONCAT(@sql_ins, '  FROM t_arrival AS AH');
    SET @sql_ins = CONCAT(@sql_ins, '  INNER JOIN pyt_m_ninushi AS NN ON AH.shipper_code = NN.NNSICD');
     IF p_sntcd IS NOT NULL THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN tmp_sntcd AS ST');
        SET @sql_ins = CONCAT(@sql_ins,' ON AH.sales_office_code = ST.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND AH.warehouse_code = ST.SNTCD');        
	END IF;
    IF p_is_partner = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN pyt_m_sp_conditions AS SP');
		SET @sql_ins = CONCAT(@sql_ins,' ON NN.NNSICD = SP.NNSICD');
        IF p_sntcd IS NOT NULL THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND ST.JGSCD = SP.JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR ST.SNTCD = SP.SNTCD)');
        ELSE
			SET @sql_ins = CONCAT(@sql_ins,' AND AH.sales_office_code = SP.JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR AH.warehouse_code = SP.SNTCD)');
        END IF;		
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.UNSKSCD IS NULL OR AH.transporter_code = SP.UNSKSCD)');		
		SET @sql_ins = CONCAT(@sql_ins,' AND SP.NKTISFRG = 1');        
	END IF;
    
    
    SET @sql_where = null;
        
    IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL AND p_date_from = p_date_to THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		SET @sql_where = CONCAT(@sql_where,' AH.arrival_date = \'',p_date_from,'\'');
    ELSE    
		IF p_date_from IS NOT NULL THEN
			IF @sql_where IS NULL THEN
				SET @sql_where = ' WHERE';
			ELSE
				SET @sql_where = CONCAT(@sql_where,' AND');
			END IF;
			SET @sql_where = CONCAT(@sql_where,' AH.arrival_date >= \'',p_date_from,'\'');		
		END IF;
		
		IF p_date_to IS NOT NULL THEN
			IF @sql_where IS NULL THEN
				SET @sql_where = ' WHERE';
			ELSE
				SET @sql_where = CONCAT(@sql_where,' AND');
			END IF;
			SET @sql_where = CONCAT(@sql_where,' AH.arrival_date <= \'',p_date_to,'\'');		
		END IF;
	END IF;
    
    IF p_jgscd IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		SET @sql_where = CONCAT(@sql_where,' AH.sales_office_code IN(',p_jgscd,')');				
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
			pyt_ufn_get_date_format(NOHINYMD) AS NOHINYMD
		,	JGSCD
        ,	JGSNM
        ,	NNSICD
        ,	NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(MOD_PL) AS MOD_PL
        ,	1 AS DATA_DIVIDE
		FROM tmp_data
        GROUP BY
			NOHINYMD
		,	JGSCD
        ,	JGSNM
		,	NNSICD
        ,	NNSINM;
        
        CREATE TEMPORARY TABLE tmp_data_ymd_total
        SELECT
			CONCAT(pyt_ufn_get_date_format(NOHINYMD),' 集計') AS NOHINYMD
		,	'ZZZZZZZZZZ' AS JGSCD
        ,	'' AS JGSNM
        ,	'ZZZZZZZZZZ' AS NNSICD
        ,	'' AS NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(MOD_PL) AS MOD_PL
        ,	2 AS DATA_DIVIDE
		FROM tmp_data
        GROUP BY
			NOHINYMD
		;
        
        CREATE TEMPORARY TABLE tmp_data_total
        SELECT
			'ZZZZZZZZZZ' AS NOHINYMD
		,	'ZZZZZZZZZZ' AS JGSCD
        ,	'' AS JGSNM
		,	'ZZZZZZZZZZ' AS NNSICD
        ,	'' AS NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(MOD_PL) AS MOD_PL
        ,	3 AS DATA_DIVIDE
		FROM tmp_data
        ;
		
               
		SELECT IFNULL(MAX(work_id),0) INTO @work_id FROM pyt_w_201020 FOR UPDATE;
        
        INSERT INTO pyt_w_201020
        SELECT
			@work_id:=@work_id+1
		,	p_user_id
		,	DT.NOHINYMD
        ,	DT.JGSCD
        ,	DT.JGSNM
		,	DT.NNSICD
        ,	DT.NNSINM
        ,	DT.KKTSR1
        ,	DT.MOD_PL
        ,	DT.DATA_DIVIDE
        FROM
        (
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
			ORDER BY NOHINYMD,DATA_DIVIDE,JGSCD,NNSICD
        ) AS DT;
        
        SELECT
			NOHINYMD
		,	JGSNM
        ,	NNSINM
        ,	KKTSR1
        ,	MOD_PL
        ,	DATA_DIVIDE        
        FROM pyt_w_201020
        WHERE user_id = p_user_id;
        
        
	ELSE
		SELECT * FROM tmp_data;
    END IF;
    
    
    DROP TABLE IF EXISTS tmp_data_details;
	DROP TABLE IF EXISTS tmp_data_ymd_total;
	DROP TABLE IF EXISTS tmp_data_total;
	DROP TABLE IF EXISTS tmp_data;
    DROP TABLE IF EXISTS tmp_sntcd;
        
    COMMIT;
END//

delimiter ;