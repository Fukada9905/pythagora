DROP PROCEDURE IF EXISTS pyt_p_101050;
delimiter //

CREATE PROCEDURE pyt_p_101050(
	IN p_process_divide tinyint
,	IN p_is_partner tinyint
,	IN p_date_divide tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(20)
,	IN p_nnsicd text
,	IN p_sntcd text
)
BEGIN
	
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
		DELETE FROM pyt_w_101050_head WHERE user_id = p_user_id AND process_divide = p_process_divide;
        DROP TABLE IF EXISTS tmp_details;
        RESIGNAL;
    END;
    
     IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD = CONCAT('INSERT INTO tmp_sntcd(JGSCD,SNTCD) VALUES',p_sntcd);
                
        PREPARE stmt_SNTCD from @sql_SNTCD;
		EXECUTE stmt_SNTCD;
		DEALLOCATE PREPARE stmt_SNTCD;
	END IF;
    
    IF p_nnsicd IS NULL THEN
		SELECT GROUP_CONCAT(CONCAT('\'',NNSICD,'\'')) INTO @nnsicd FROM pyt_m_ninushi;
	ELSE
		SET @nnsicd = p_nnsicd;
    END IF;
       
	
    -- STEP.0 REFRESH WORK
    DELETE FROM pyt_w_101050_head WHERE user_id = p_user_id AND process_divide = p_process_divide;
    
    -- STEP.1 SELECT TARGET DATA
    DROP TABLE IF EXISTS tmp_details;
    SET @sql_ins = ' CREATE TEMPORARY TABLE tmp_details SELECT';
    SET @sql_ins = CONCAT(@sql_ins,' SH.shipper_code AS NNSICD');
	SET @sql_ins = CONCAT(@sql_ins,', MN.NNSINM AS NNSINM');
	SET @sql_ins = CONCAT(@sql_ins,', SH.sales_office_code AS JGSCD');
	SET @sql_ins = CONCAT(@sql_ins,', SH.sales_office_name AS JGSNM');
    SET @sql_ins = CONCAT(@sql_ins,', SH.warehouse_code AS SNTCD');
    SET @sql_ins = CONCAT(@sql_ins,', SH.warehouse_name AS SNTNM');
    SET @sql_ins = CONCAT(@sql_ins,', SH.transporter_code AS UNSKSCD');
    SET @sql_ins = CONCAT(@sql_ins,', SH.transporter_name AS UNSKSNM');
    SET @sql_ins = CONCAT(@sql_ins,', SH.wms_processing_date AS SYORIYMD');
	SET @sql_ins = CONCAT(@sql_ins,', SH.retrieval_date AS SYUKAYMD');
	SET @sql_ins = CONCAT(@sql_ins,', SH.delivery_date AS NOHINYMD');
	SET @sql_ins = CONCAT(@sql_ins,', SH.warehouse_accounting_date AS DENPYOYMD');
    SET @sql_ins = CONCAT(@sql_ins,', CAST(SH.created_at AS date) AS TRKMYMD');    
    SET @sql_ins = CONCAT(@sql_ins,', SH.delivery_code AS NHNSKCD');
    SET @sql_ins = CONCAT(@sql_ins,', CONCAT(IFNULL(SH.receiver_name1,\'\'), IFNULL(SH.receiver_name2,\'\'), IFNULL(SH.delivery_name3,\'\')) AS NHNSKNM');
    SET @sql_ins = CONCAT(@sql_ins,', CONCAT(IFNULL(SH.receiver_address1,\'\'), IFNULL(SH.receiver_address2,\'\'), IFNULL(SH.receiver_address3,\'\')) AS JYUSYO');
    SET @sql_ins = CONCAT(@sql_ins,', IFNULL(SH.delivery_remark,\'\') AS BIKO');    
    
    SET @sql_ins = CONCAT(@sql_ins,', SH.product_code AS SHCD');
	SET @sql_ins = CONCAT(@sql_ins,', SH.denryaku AS DNRK');
	SET @sql_ins = CONCAT(@sql_ins,', SH.lot AS RTNO');
	SET @sql_ins = CONCAT(@sql_ins,', SH.control_type AS LOTK');
    
    SET @sql_ins = CONCAT(@sql_ins,', SH.total_fraction DIV SH.quantity_per_package AS KKTSR1');		
    SET @sql_ins = CONCAT(@sql_ins,', SH.carton_count AS KKTSR2');
	SET @sql_ins = CONCAT(@sql_ins,', SH.total_fraction MOD SH.quantity_per_package AS KKTSR3');
	SET @sql_ins = CONCAT(@sql_ins,', SH.total_fraction AS KKTSSR');	
    SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SH.shipping_weight, 1) AS WGT');
    SET @sql_ins = CONCAT(@sql_ins,', SH.id AS id');
    IF p_process_divide = 1 THEN 
		SET @sql_ins = CONCAT(@sql_ins, ' FROM t_provisional_shipment AS SH');        
    ELSE
		SET @sql_ins = CONCAT(@sql_ins, ' FROM t_shipment AS SH'); 
    END IF;
    SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN pyt_m_ninushi AS MN ON SH.shipper_code = MN.NNSICD');   
    
    IF p_sntcd IS NOT NULL THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN tmp_sntcd AS ST');
        SET @sql_ins = CONCAT(@sql_ins,' ON SH.sales_office_code = ST.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND SH.warehouse_code = ST.SNTCD');  		
	END IF;
    
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
        SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN pyt_m_partners AS PN');
		SET @sql_ins = CONCAT(@sql_ins,' ON SP.PTNCD = PN.PTNCD');											    
    END IF;
	
    SET @sql_ins = CONCAT(@sql_ins,' WHERE SH.shipper_code IN(',@nnsicd,')');
        
	IF p_process_divide != 1 THEN 
		SET @sql_ins = CONCAT(@sql_ins,' AND SH.shipper_trading_short_name != \'A2\'');            
	END IF;
    
    IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL AND p_date_from = p_date_to THEN		
		IF p_date_divide = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SH.retrieval_date = \'',p_date_from,'\'');
		ELSEIF p_date_divide = 2 THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SH.delivery_date = \'',p_date_from,'\'');
		ELSEIF p_date_divide = 3 THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SH.warehouse_accounting_date = \'',p_date_from,'\'');
		ELSEIF p_date_divide = 4 THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND CAST(SH.created_at AS date) = \'',p_date_from,'\'');
		END IF;							
	ELSE
		IF p_date_from IS NOT NULL THEN
			IF p_date_divide = 1 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.retrieval_date >= \'',p_date_from,'\'');
			ELSEIF p_date_divide = 2 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.delivery_date >= \'',p_date_from,'\'');
			ELSEIF p_date_divide = 3 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.warehouse_accounting_date >= \'',p_date_from,'\'');
			ELSEIF p_date_divide = 4 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.created_at >= \'',p_date_from,' 00:00:00\'');
			END IF;					
		END IF;
		
		IF p_date_to IS NOT NULL THEN
			IF p_date_divide = 1 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.retrieval_date <= \'',p_date_to,'\'');
			ELSEIF p_date_divide = 2 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.delivery_date <= \'',p_date_to,'\'');
			ELSEIF p_date_divide = 3 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.warehouse_accounting_date <= \'',p_date_to,'\'');
			ELSEIF p_date_divide = 4 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.created_at <= \'',p_date_to,' 23:59:59\'');
			END IF;					
		END IF;
	END IF;
	
    IF p_jgscd IS NOT NULL THEN
		SET @sql_ins = CONCAT(@sql_ins,' AND SH.sales_office_code IN(',p_jgscd,')');				
	END IF;
	
    
    SET @sql_ins = CONCAT(@sql_ins, ' ORDER BY ');
    SET @sql_ins = CONCAT(@sql_ins, ' SH.wms_processing_date DESC');
    IF p_date_divide = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins, ', SH.retrieval_date DESC');		
    ELSEIF p_date_divide = 2 THEN
		SET @sql_ins = CONCAT(@sql_ins, ', SH.delivery_date DESC');
	ELSEIF p_date_divide = 3 THEN
		SET @sql_ins = CONCAT(@sql_ins, ', SH.warehouse_accounting_date DESC');		
	ELSEIF p_date_divide = 4 THEN
		SET @sql_ins = CONCAT(@sql_ins, ', SH.created_at DESC');		
    END IF;
    SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_name ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.transporter_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.transporter_name ASC');
        
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
    
    
    IF EXISTS(SELECT * FROM tmp_details LIMIT 1) THEN    
    
		-- トランザクション開始
		START TRANSACTION;
    		
        SET @sql_prev_key = 'CONCAT_WS(\'_\'';
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SYORIYMD,\'\')');
		IF p_date_divide = 1 THEN
			SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SYUKAYMD,\'\')');
		ELSEIF p_date_divide = 2 THEN
			SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NOHINYMD,\'\')');
		ELSEIF p_date_divide = 3 THEN
			SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(DENPYOYMD,\'\')');
		ELSEIF p_date_divide = 4 THEN
			SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(TRKMYMD,\'\')');
		END IF;
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSICD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSNM,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(UNSKSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(UNSKSNM,\'\')');        
		SET @sql_prev_key = CONCAT(@sql_prev_key, ')');
        
        
        -- STEP.3 INSERT WORK HEAD
        SET @prevkey:=null;
		SET @work_id = 1;
        
		SET @sql_head = 'INSERT INTO pyt_w_101050_head SELECT DISTINCT';
        SET @sql_head = CONCAT(@sql_head, ' \'',p_user_id,'\' AS user_id');
        SET @sql_head = CONCAT(@sql_head, ', ', p_process_divide,' AS process_divide');
		SET @sql_head = CONCAT(@sql_head, ', CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_head = CONCAT(@sql_head, ', SYORIYMD AS SYORIYMD');
        IF p_date_divide = 1 THEN
			SET @sql_head = CONCAT(@sql_head, ', SYUKAYMD AS DATEYMD');
		ELSEIF p_date_divide = 2 THEN
			SET @sql_head = CONCAT(@sql_head, ', NOHINYMD AS DATEYMD');
		ELSEIF p_date_divide = 3 THEN
			SET @sql_head = CONCAT(@sql_head, ', DENPYOYMD AS DATEYMD');
		ELSEIF p_date_divide = 4 THEN
			SET @sql_head = CONCAT(@sql_head, ', TRKMYMD AS DATEYMD');
		END IF;
		SET @sql_head = CONCAT(@sql_head, ', JGSCD');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM');
        SET @sql_head = CONCAT(@sql_head, ', UNSKSCD');
		SET @sql_head = CONCAT(@sql_head, ', UNSKSNM');
        SET @sql_head = CONCAT(@sql_head, ', NNSICD');
		SET @sql_head = CONCAT(@sql_head, ', NNSINM');
		SET @sql_head = CONCAT(@sql_head, ', @prevkey:=',@sql_prev_key);	
		SET @sql_head = CONCAT(@sql_head, ' FROM tmp_details');
        
        PREPARE _stmt_head from @sql_head;
		EXECUTE _stmt_head;
		DEALLOCATE PREPARE _stmt_head;
		
        -- STEP.4 INSERT WORK DETAIL
		SET @prevkey:=null;
		SET @work_id = 1;
        SET @work_detail_id = 1;
			
		SET @sql_ins = 'INSERT INTO pyt_w_101050_details SELECT';
        SET @sql_ins = CONCAT(@sql_ins, ' \'',p_user_id,'\' AS user_id');
        SET @sql_ins = CONCAT(@sql_ins, ', ', p_process_divide,' AS process_divide');
		SET @sql_ins = CONCAT(@sql_ins, ', @work_detail_id:=@work_detail_id+1 AS work_detail_id');
		SET @sql_ins = CONCAT(@sql_ins, ', CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_ins = CONCAT(@sql_ins,', NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,', NNSINM');
		SET @sql_ins = CONCAT(@sql_ins,', JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,', JGSNM');
		SET @sql_ins = CONCAT(@sql_ins,', SNTCD');
		SET @sql_ins = CONCAT(@sql_ins,', SNTNM');
		SET @sql_ins = CONCAT(@sql_ins,', UNSKSCD');
		SET @sql_ins = CONCAT(@sql_ins,', UNSKSNM');
		SET @sql_ins = CONCAT(@sql_ins,', SYORIYMD');
        IF p_date_divide = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins, ', SYUKAYMD AS DATEYMD');
		ELSEIF p_date_divide = 2 THEN
			SET @sql_ins = CONCAT(@sql_ins, ', NOHINYMD AS DATEYMD');
		ELSEIF p_date_divide = 3 THEN
			SET @sql_ins = CONCAT(@sql_ins, ', DENPYOYMD AS DATEYMD');
		ELSEIF p_date_divide = 4 THEN
			SET @sql_ins = CONCAT(@sql_ins, ', TRKMYMD AS DATEYMD');
		END IF;
        SET @sql_ins = CONCAT(@sql_ins,', SYUKAYMD');
        SET @sql_ins = CONCAT(@sql_ins,', NOHINYMD');
        SET @sql_ins = CONCAT(@sql_ins,', NHNSKCD');
		SET @sql_ins = CONCAT(@sql_ins,', NHNSKNM');
		SET @sql_ins = CONCAT(@sql_ins,', JYUSYO');
		SET @sql_ins = CONCAT(@sql_ins,', BIKO'); 
        SET @sql_ins = CONCAT(@sql_ins,', SHCD');
        SET @sql_ins = CONCAT(@sql_ins,', DNRK');
        SET @sql_ins = CONCAT(@sql_ins,', RTNO');
        SET @sql_ins = CONCAT(@sql_ins,', LOTK');
        SET @sql_ins = CONCAT(@sql_ins,', KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins,', KKTSR2');
		SET @sql_ins = CONCAT(@sql_ins,', KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins,', KKTSSR');
		SET @sql_ins = CONCAT(@sql_ins,', WGT');
        SET @sql_ins = CONCAT(@sql_ins,', id');
        SET @sql_ins = CONCAT(@sql_ins,', @prevkey:=',@sql_prev_key);
		SET @sql_ins = CONCAT(@sql_ins,' FROM tmp_details');
		
        PREPARE _stmt_detail from @sql_ins;
		EXECUTE _stmt_detail;
		DEALLOCATE PREPARE _stmt_detail;
		
        
        COMMIT;
        
        -- STEP.5 RETURN
		SELECT
			*,
            1 AS checked
        FROM pyt_w_101050_head 
        WHERE user_id = p_user_id AND process_divide = p_process_divide
        ORDER BY SYORIYMD DESC, DATEYMD DESC, JGSCD ASC, UNSKSCD ASC, NNSICD ASC;
        
    ELSE
		SELECT * FROM pyt_w_101050_head WHERE user_id = p_user_id AND process_divide = p_process_divide;
    END IF;
    
    DROP TABLE IF EXISTS tmp_details;
    DROP TABLE IF EXISTS tmp_order_data_type;
    
    
END//

delimiter ;