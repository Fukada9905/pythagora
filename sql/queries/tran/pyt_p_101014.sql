DROP PROCEDURE IF EXISTS pyt_p_101014;
DELIMITER //
CREATE PROCEDURE pyt_p_101014(
	IN p_process_divide tinyint
,	IN p_is_partner tinyint
,	IN p_date_divide tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_management_cd varchar(10)
,	IN p_nnsicd text
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
	,	NNSICD varchar(10)
    ,	NNSINM varchar(50)    
    ,	KKTSR1 int NOT NULL DEFAULT 0
    ,	KKTSR3 int NOT NULL DEFAULT 0
    ,	WGT decimal(10,1) NOT NULL DEFAULT 0    
    );
    
    IF p_nnsicd IS NULL THEN
		SELECT GROUP_CONCAT(CONCAT('\'',NNSICD,'\'')) INTO @nnsicd FROM pyt_m_ninushi;
	ELSE
		SET @nnsicd = p_nnsicd;
    END IF;
	
    
    SET @sql_ins = 'INSERT INTO tmp_data';
	SET @sql_ins = CONCAT(@sql_ins, ' SELECT');
    IF p_date_divide = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins,' SH.retrieval_date AS DATEYMD');			
	ELSEIF p_date_divide = 2 THEN
		SET @sql_ins = CONCAT(@sql_ins,' SH.delivery_date AS DATEYMD');
	ELSEIF p_date_divide = 3 THEN
		SET @sql_ins = CONCAT(@sql_ins,' SH.warehouse_accounting_date AS DATEYMD');
	ELSEIF p_date_divide = 4 THEN
		SET @sql_ins = CONCAT(@sql_ins,' CAST(SH.created_at AS date) AS DATEYMD');
	END IF;
    SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_code AS NNSICD');
    SET @sql_ins = CONCAT(@sql_ins, ', MN.NNSINM AS NNSINM');
    SET @sql_ins = CONCAT(@sql_ins,', SH.total_fraction DIV SH.quantity_per_package');
	SET @sql_ins = CONCAT(@sql_ins,', SH.total_fraction MOD SH.quantity_per_package');
	SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SH.shipping_weight, 1)');
	
    
    -- 仮出荷
	IF p_process_divide = 1 THEN 
		SET @sql_ins = CONCAT(@sql_ins,' FROM t_provisional_shipment AS SH'); 		
	-- 本受注
	ELSE		
		SET @sql_ins = CONCAT(@sql_ins,' FROM t_shipment AS SH');             
	END IF;
	SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN pyt_m_ninushi AS MN ON SH.shipper_code = MN.NNSICD');   
    
    IF p_is_partner = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN pyt_m_sp_conditions AS SP');
		SET @sql_ins = CONCAT(@sql_ins,' ON MN.NNSICD = SP.NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,' AND SH.sales_office_code = SP.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR SH.warehouse_code = SP.SNTCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.UNSKSCD IS NULL OR SH.transporter_code = SP.UNSKSCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SYUKAP IS NULL OR SH.shipping_location_code = SP.SYUKAP)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SEKKBN IS NULL OR SH.billing_type = SP.SEKKBN)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.NHNSKCD IS NULL OR SH.delivery_code = SP.NHNSKCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND SP.SKTISFRG = 1');
        SET @sql_ins = CONCAT(@sql_ins,' AND SP.PTNCD = \'',p_management_cd,'\'');	
	END IF;
    
    
    SET @sql_where = CONCAT(' WHERE SH.shipper_code IN(',@nnsicd,')');
    
    IF p_process_divide != 1 THEN 
		SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_trading_short_name != \'A2\'');
	END IF;
    
    IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL AND p_date_from = p_date_to THEN
		IF p_date_divide = 1 THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.retrieval_date = \'',p_date_from,'\'');
		ELSEIF p_date_divide = 2 THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.delivery_date = \'',p_date_from,'\'');
		ELSEIF p_date_divide = 3 THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.warehouse_accounting_date = \'',p_date_from,'\'');
		ELSEIF p_date_divide = 4 THEN
			SET @sql_where = CONCAT(@sql_where,' AND CAST(SH.created_at AS date) = \'',p_date_from,'\'');
		END IF;							
	ELSE
		IF p_date_from IS NOT NULL THEN
			IF p_date_divide = 1 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.retrieval_date >= \'',p_date_from,'\'');
			ELSEIF p_date_divide = 2 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.delivery_date >= \'',p_date_from,'\'');
			ELSEIF p_date_divide = 3 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.warehouse_accounting_date >= \'',p_date_from,'\'');
			ELSEIF p_date_divide = 4 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.created_at >= \'',p_date_from,' 00:00:00\'');
			END IF;					
		END IF;
		
		IF p_date_to IS NOT NULL THEN
			IF p_date_divide = 1 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.retrieval_date <= \'',p_date_to,'\'');
			ELSEIF p_date_divide = 2 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.delivery_date <= \'',p_date_to,'\'');
			ELSEIF p_date_divide = 3 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.warehouse_accounting_date <= \'',p_date_to,'\'');
			ELSEIF p_date_divide = 4 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.created_at <= \'',p_date_to,' 23:59:59\'');
			END IF;					
		END IF;
	END IF;
	    
    IF p_jgscd IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND SH.sales_office_code IN(',p_jgscd,')');
	END IF;
	    

	SET @sql_ins = CONCAT(@sql_ins,IFNULL(@sql_where,''));

	
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
            
    IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
		CREATE TEMPORARY TABLE tmp_data_details
        SELECT
			pyt_ufn_get_date_format(DATEYMD) AS DATEYMD
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
			CONCAT(pyt_ufn_get_date_format(DATEYMD),' 集計') AS DATEYMD
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
	DROP TABLE IF EXISTS tmp_order_data_type;
    
END//
DELIMITER ;
