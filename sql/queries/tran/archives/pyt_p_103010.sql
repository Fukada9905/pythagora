DROP PROCEDURE IF EXISTS pyt_p_103010;
DELIMITER //
CREATE PROCEDURE pyt_p_103010(
	IN p_target_divide tinyint
,   IN p_target_date date
,	IN p_jgscd text
)
BEGIN
	    
	DECLARE _nnsicd varchar(10);
    DECLARE _nnsinm varchar(50);
    DECLARE _cur CURSOR FOR SELECT NNSICD, NNSINM FROM pyt_m_ninushi;
    
    
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TABLE IF EXISTS tmp_data;
        DROP TABLE IF EXISTS tmp_data_details;
        DROP TABLE IF EXISTS tmp_data_total;
        RESIGNAL;
    END;
    
    SET @sql_sum = '';  
	SELECT COUNT(*) INTO @total FROM pyt_m_ninushi;    
    SET @pos = 0;
    
    
    IF p_target_divide = 1 THEN
		-- 方面別補給物量
        CREATE TEMPORARY TABLE tmp_data(
			JGSCD varchar(10)
		,	JGSNM varchar(50)
        ,	NHNSKCD varchar(10)
		,	NHNSKNM varchar(50)
		,	NNSICD varchar(10)
		,	NNSINM varchar(50)    
		,	TOTAL_KKTSR1 int NOT NULL DEFAULT 0
		,	TOTAL_WGT int NOT NULL DEFAULT 0		
		);
        
        OPEN _cur;
    
		WHILE @total > @pos DO
			FETCH _cur INTO _nnsicd, _nnsinm;
			SET @sql_cr = 'ALTER TABLE tmp_data';
			SET @sql_cr = CONCAT(@sql_cr , ' ADD COLUMN ',_nnsicd,'_KKTSR1 int NOT NULL DEFAULT 0');
			SET @sql_cr = CONCAT(@sql_cr , ',ADD COLUMN ',_nnsicd,'_WGT int NOT NULL DEFAULT 0');
			
			PREPARE _stmt_cr from @sql_cr;
			EXECUTE _stmt_cr;
			DEALLOCATE PREPARE _stmt_cr;
			SET @pos = @pos +1;
		END WHILE;
		
		CLOSE _cur;
		
		OPEN _cur;
		SET @pos = 0;
        
        WHILE @total > @pos DO
			FETCH _cur INTO _nnsicd, _nnsinm;
			
			SET @sql_ins = 'INSERT INTO tmp_data(';
			SET @sql_ins = CONCAT(@sql_ins,'  JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,', JGSNM');
			SET @sql_ins = CONCAT(@sql_ins,', NHNSKCD');
            SET @sql_ins = CONCAT(@sql_ins,', NHNSKNM');
			SET @sql_ins = CONCAT(@sql_ins,', NNSICD');
			SET @sql_ins = CONCAT(@sql_ins,', NNSINM');
			SET @sql_ins = CONCAT(@sql_ins,', TOTAL_KKTSR1');
			SET @sql_ins = CONCAT(@sql_ins,', TOTAL_WGT');
			SET @sql_ins = CONCAT(@sql_ins,', ',_nnsicd,'_KKTSR1');
			SET @sql_ins = CONCAT(@sql_ins,', ',_nnsicd,'_WGT');
			SET @sql_ins = CONCAT(@sql_ins,')');
			SET @sql_ins = CONCAT(@sql_ins,' SELECT');
            
            
            SET @sql_ins = CONCAT(@sql_ins, ' SH.sales_office_code AS JGSCD');
			SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_name AS JGSNM');
			SET @sql_ins = CONCAT(@sql_ins, ', SH.delivery_code AS NHNSKCD');
			SET @sql_ins = CONCAT(@sql_ins, ', CONCAT(IFNULL(SH.receiver_name1,\'\'), IFNULL(SH.receiver_name2,\'\'), IFNULL(SH.receiver_name3,\'\')) AS NHNSKNM');
			SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_code AS NNSICD');
			SET @sql_ins = CONCAT(@sql_ins, ', NN.NNSINM AS NNSINM');
            SET @sql_ins = CONCAT(@sql_ins, ', SH.package_count AS KKTSR1');
			-- SET @sql_ins = CONCAT(@sql_ins,', pyt_ufn_get_KKTSR(SH.order_package_count,SH.total_fraction,SH.quantity_per_package) AS KKTSR1');
            SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SH.shipping_weight+0.9, 0) AS WGT');
            SET @sql_ins = CONCAT(@sql_ins, ', SH.package_count');
            -- SET @sql_ins = CONCAT(@sql_ins,', pyt_ufn_get_KKTSR(SH.order_package_count,SH.total_fraction,SH.quantity_per_package)');
            SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SH.shipping_weight+0.9, 0)');
    
            SET @sql_ins = CONCAT(@sql_ins,' FROM t_shipment AS SH');
            SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN pyt_m_ninushi AS NN ON SH.shipper_code = NN.NNSICD');
			
            SET @sql_ins = CONCAT(@sql_ins,' WHERE SH.shipper_code = \'',_nnsicd,'\'');
            SET @sql_ins = CONCAT(@sql_ins,' AND SH.shipper_trading_short_name = \'A2\'');
            SET @sql_ins = CONCAT(@sql_ins,' AND SH.warehouse_accounting_date = \'',p_target_date,'\'');
			IF p_jgscd IS NOT NULL THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.sales_office_code IN(',p_jgscd,')');				
			END IF;
			
			PREPARE _stmt_ins from @sql_ins;
			EXECUTE _stmt_ins;
			DEALLOCATE PREPARE _stmt_ins;
			
			SET @sql_sum = CONCAT(@sql_sum, ', SUM(',_nnsicd,'_KKTSR1) AS ',_nnsicd,'_KKTSR1');
			SET @sql_sum = CONCAT(@sql_sum, ', SUM(',_nnsicd,'_WGT) AS ',_nnsicd,'_WGT');
					
										  
			SET @pos = @pos +1;
		END WHILE;
		
		CLOSE _cur;
        
        
        SET @sql_ret = 'CREATE TEMPORARY TABLE tmp_data_details';
		SET @sql_ret = CONCAT(@sql_ret,' SELECT');
		SET @sql_ret = CONCAT(@sql_ret,'  JGSCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,JGSNM');
        SET @sql_ret = CONCAT(@sql_ret,' ,NHNSKCD');
        SET @sql_ret = CONCAT(@sql_ret,' ,NHNSKNM');        
        SET @sql_ret = CONCAT(@sql_ret,@sql_sum);
        SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR1) AS TOTAL_KKTSR1');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_WGT) AS TOTAL_WGT');        
        SET @sql_ret = CONCAT(@sql_ret,' ,1 AS DATA_DIVIDE');
        SET @sql_ret = CONCAT(@sql_ret,' FROM tmp_data AS DD');
        SET @sql_ret = CONCAT(@sql_ret,' GROUP BY');
		SET @sql_ret = CONCAT(@sql_ret,'  JGSCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,JGSNM');
		SET @sql_ret = CONCAT(@sql_ret,' ,NHNSKCD');
        SET @sql_ret = CONCAT(@sql_ret,' ,NHNSKNM');
        SET @sql_ret = CONCAT(@sql_ret,' ORDER BY');
        SET @sql_ret = CONCAT(@sql_ret,'   JGSCD');
        SET @sql_ret = CONCAT(@sql_ret,' , NHNSKCD');
        
            
		PREPARE _stmt_ret from @sql_ret;
		EXECUTE _stmt_ret;
		DEALLOCATE PREPARE _stmt_ret;
        
        
        SET @sql_ret = 'CREATE TEMPORARY TABLE tmp_data_total';
		SET @sql_ret = CONCAT(@sql_ret,' SELECT');
		SET @sql_ret = CONCAT(@sql_ret,'  \'ZZZZZZZZZZ\' AS JGSCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,\'\' AS JGSNM');
		SET @sql_ret = CONCAT(@sql_ret,' ,\'ZZZZZZZZZZ\' AS NHNSKCD');
        SET @sql_ret = CONCAT(@sql_ret,' ,\'\' AS NHNSKNM');
		SET @sql_ret = CONCAT(@sql_ret,@sql_sum);
        SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR1) AS TOTAL_KKTSR1');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_WGT) AS TOTAL_WGT');  
        SET @sql_ret = CONCAT(@sql_ret,' ,2 AS DATA_DIVIDE');
        SET @sql_ret = CONCAT(@sql_ret,' FROM tmp_data');
        
        PREPARE _stmt_ret2 from @sql_ret;
		EXECUTE _stmt_ret2;
		DEALLOCATE PREPARE _stmt_ret2;
        
        IF EXISTS(SELECT * FROM tmp_data) THEN
			SELECT * FROM tmp_data_details
			UNION ALL
			SELECT * FROM tmp_data_total
			ORDER BY DATA_DIVIDE,JGSCD,NHNSKCD;
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
		,	TOTAL_KKTSR1 int NOT NULL DEFAULT 0
		,	TOTAL_WGT int NOT NULL DEFAULT 0		
		);
        
        
        OPEN _cur;
    
		WHILE @total > @pos DO
			FETCH _cur INTO _nnsicd, _nnsinm;
			SET @sql_cr = 'ALTER TABLE tmp_data';
			SET @sql_cr = CONCAT(@sql_cr , ' ADD COLUMN ',_nnsicd,'_KKTSR1 int NOT NULL DEFAULT 0');
			SET @sql_cr = CONCAT(@sql_cr , ',ADD COLUMN ',_nnsicd,'_WGT int NOT NULL DEFAULT 0');
			
			PREPARE _stmt_cr from @sql_cr;
			EXECUTE _stmt_cr;
			DEALLOCATE PREPARE _stmt_cr;
			SET @pos = @pos +1;
		END WHILE;
		
		CLOSE _cur;
		
		OPEN _cur;
		SET @pos = 0;
        
        WHILE @total > @pos DO
			FETCH _cur INTO _nnsicd, _nnsinm;
			
			SET @sql_ins = 'INSERT INTO tmp_data(';
			SET @sql_ins = CONCAT(@sql_ins,'  JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,', JGSNM');
			SET @sql_ins = CONCAT(@sql_ins,', SNTCD');
            SET @sql_ins = CONCAT(@sql_ins,', SNTNM');
			SET @sql_ins = CONCAT(@sql_ins,', NNSICD');
			SET @sql_ins = CONCAT(@sql_ins,', NNSINM');
			SET @sql_ins = CONCAT(@sql_ins,', TOTAL_KKTSR1');
			SET @sql_ins = CONCAT(@sql_ins,', TOTAL_WGT');
			SET @sql_ins = CONCAT(@sql_ins,', ',_nnsicd,'_KKTSR1');
			SET @sql_ins = CONCAT(@sql_ins,', ',_nnsicd,'_WGT');
			SET @sql_ins = CONCAT(@sql_ins,')');
			SET @sql_ins = CONCAT(@sql_ins,' SELECT');
            
            
            SET @sql_ins = CONCAT(@sql_ins, ' SH.sales_office_code AS JGSCD');
			SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_name AS JGSNM');
			SET @sql_ins = CONCAT(@sql_ins, ', SH.warehouse_code AS SNTCD');
			SET @sql_ins = CONCAT(@sql_ins, ', SH.warehouse_name AS SNTNM');
			SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_code AS NNSICD');
			SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_name AS NNSINM');
			SET @sql_ins = CONCAT(@sql_ins,', pyt_ufn_get_KKTSR(SH.order_package_count,SH.total_fraction,SH.quantity_per_package) AS KKTSR1');
            SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SH.shipping_weight+0.9, 0) AS WGT');
            SET @sql_ins = CONCAT(@sql_ins,', pyt_ufn_get_KKTSR(SH.order_package_count,SH.total_fraction,SH.quantity_per_package)');
            SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SH.shipping_weight+0.9, 0)');
            
            
            SET @sql_ins = CONCAT(@sql_ins,' FROM t_shipment AS SH');
			
            SET @sql_ins = CONCAT(@sql_ins,' WHERE SH.shipper_code = \'',_nnsicd,'\'');
            SET @sql_ins = CONCAT(@sql_ins,' AND SH.shipper_trading_code = \'A2\'');
            SET @sql_ins = CONCAT(@sql_ins,' AND SH.warehouse_accounting_date = \'',p_target_date,'\'');
			IF p_jgscd IS NOT NULL THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.sales_office_code IN(',p_jgscd,')');				
			END IF;            
			
			PREPARE _stmt_ins from @sql_ins;
			EXECUTE _stmt_ins;
			DEALLOCATE PREPARE _stmt_ins;
			
			SET @sql_sum = CONCAT(@sql_sum, ', SUM(',_nnsicd,'_KKTSR1) AS ',_nnsicd,'_KKTSR1');
			SET @sql_sum = CONCAT(@sql_sum, ', SUM(',_nnsicd,'_WGT) AS ',_nnsicd,'_WGT');
					
										  
			SET @pos = @pos +1;
		END WHILE;
		
		CLOSE _cur;
        
        
        SET @sql_ret = 'CREATE TEMPORARY TABLE tmp_data_details';
		SET @sql_ret = CONCAT(@sql_ret,' SELECT');
		SET @sql_ret = CONCAT(@sql_ret,'  JGSCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,JGSNM');
        SET @sql_ret = CONCAT(@sql_ret,' ,SNTCD');
        SET @sql_ret = CONCAT(@sql_ret,' ,SNTNM');        
        SET @sql_ret = CONCAT(@sql_ret,@sql_sum);
        SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR1) AS TOTAL_KKTSR1');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_WGT) AS TOTAL_WGT');        
        SET @sql_ret = CONCAT(@sql_ret,' ,1 AS DATA_DIVIDE');
        SET @sql_ret = CONCAT(@sql_ret,' FROM tmp_data AS DD');
        SET @sql_ret = CONCAT(@sql_ret,' GROUP BY');
		SET @sql_ret = CONCAT(@sql_ret,'  JGSCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,JGSNM');
		SET @sql_ret = CONCAT(@sql_ret,' ,SNTCD');
        SET @sql_ret = CONCAT(@sql_ret,' ,SNTNM');
        SET @sql_ret = CONCAT(@sql_ret,' ORDER BY');
        SET @sql_ret = CONCAT(@sql_ret,'   JGSCD');
        SET @sql_ret = CONCAT(@sql_ret,' , SNTCD');
        
            
		PREPARE _stmt_ret from @sql_ret;
		EXECUTE _stmt_ret;
		DEALLOCATE PREPARE _stmt_ret;
        
        
        SET @sql_ret = 'CREATE TEMPORARY TABLE tmp_data_total';
		SET @sql_ret = CONCAT(@sql_ret,' SELECT');
		SET @sql_ret = CONCAT(@sql_ret,'  \'ZZZZZZZZZZ\' AS JGSCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,\'\' AS JGSNM');
		SET @sql_ret = CONCAT(@sql_ret,' ,\'ZZZZZZZZZZ\' AS SNTCD');
        SET @sql_ret = CONCAT(@sql_ret,' ,\'\' AS SNTNM');
		SET @sql_ret = CONCAT(@sql_ret,@sql_sum);
        SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR1) AS TOTAL_KKTSR1');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_WGT) AS TOTAL_WGT');  
        SET @sql_ret = CONCAT(@sql_ret,' ,2 AS DATA_DIVIDE');
        SET @sql_ret = CONCAT(@sql_ret,' FROM tmp_data');
        
        PREPARE _stmt_ret2 from @sql_ret;
		EXECUTE _stmt_ret2;
		DEALLOCATE PREPARE _stmt_ret2;
        
        
        
        
        
        IF EXISTS(SELECT * FROM tmp_data) THEN
			SELECT * FROM tmp_data_details
			UNION ALL
			SELECT * FROM tmp_data_total
			ORDER BY DATA_DIVIDE,JGSCD,SNTCD;
        ELSE
			SELECT * FROM tmp_data;
        END IF;
        
        
    END IF;
    
 
    DROP TABLE IF EXISTS tmp_data;
    DROP TABLE IF EXISTS tmp_data_details;
    DROP TABLE IF EXISTS tmp_data_total;
        
    
END//
DELIMITER ;
