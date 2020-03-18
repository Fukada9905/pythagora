DROP PROCEDURE IF EXISTS pyt_p_106000;
DELIMITER //
CREATE PROCEDURE pyt_p_106000(
	IN p_process_divide tinyint
,	IN p_is_partner tinyint
,	IN p_date_divide tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_nnsicd text
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(10)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
		DELETE FROM pyt_w_106000_head WHERE user_id = p_user_id AND process_divide = p_process_divide;
        DROP TABLE IF EXISTS tmp_details;
        DROP TABLE IF EXISTS tmp_order_data_type;
        RESIGNAL;
    END;
    
    
       
       
	IF p_nnsicd IS NULL THEN
		SELECT GROUP_CONCAT(CONCAT('\'',NNSICD,'\'')) INTO @nnsicd FROM pyt_m_ninushi;
	ELSE
		SET @nnsicd = p_nnsicd;
    END IF;
       	
    -- STEP.0 REFRESH WORK
    DELETE FROM pyt_w_106000_head WHERE user_id = p_user_id AND process_divide = p_process_divide;
    
    -- STEP.1 SELECT TARGET DATA
    DROP TABLE IF EXISTS tmp_details;
	SET @sql_ins = ' CREATE TEMPORARY TABLE tmp_details SELECT';
	SET @sql_ins = CONCAT(@sql_ins, ' SH.shipper_code');
    SET @sql_ins = CONCAT(@sql_ins, ', NN.NNSINM AS shipper_name');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_accounting_date');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.warehouse_accounting_date');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.wms_processing_date');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.retrieval_date');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.delivery_date');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.slip_number');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_trading_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_trading_name');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_trading_short_name');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_name');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.transporter_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.transporter_name');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.pken_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.detail_order_number');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.slip_remarks1');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.arrival_time');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.branch_office_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.local_office_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.delivery_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_name1');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_name2');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_name3');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_area_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_address1');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_address2');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_address3');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.receiver_tel');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.priority_flag');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.item_line');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.item_line_column');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.logistics_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.outer_product_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.denryaku');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.product_name');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.capacity');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.unit_type');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.order_package_count');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.order_carton_count');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.order_fraction');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.quantity_per_carton');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.quantity_per_package');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.quantity_per_fraction');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.order_total_fraction');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.package_count');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.total_fraction');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.warehouse_code');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.warehouse_name');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.lot');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.sub_lot');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.line_lot');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.campaign_flag');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.factory_type');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.control_type');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.shipment_type');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.billing_type');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.cooling_type');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.width');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.length');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.height');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.package_weight');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.shipping_weight');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.shipping_location_code');
    
    SET @sql_from = ' FROM t_shipment AS SH';    
    SET @sql_from = CONCAT(@sql_from, ' INNER JOIN pyt_m_ninushi AS NN ON SH.shipper_code = NN.NNSICD');
    IF p_is_partner = 1 THEN
		SET @sql_from = CONCAT(@sql_from,' INNER JOIN pyt_m_sp_conditions AS SP');
		SET @sql_from = CONCAT(@sql_from,' ON SH.shipper_code = SP.NNSICD');
		SET @sql_from = CONCAT(@sql_from,' AND SH.sales_office_code = SP.JGSCD');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.SNTCD IS NULL OR SH.warehouse_code = SP.SNTCD)');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.UNSKSCD IS NULL OR SH.transporter_code = SP.UNSKSCD)');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.SYUKAP IS NULL OR SH.shipping_location_code = SP.SYUKAP)');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.SEKKBN IS NULL OR SH.billing_type = SP.SEKKBN)');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.NHNSKCD IS NULL OR SH.delivery_code = SP.NHNSKCD)');
		SET @sql_from = CONCAT(@sql_from,' AND SP.SKTISFRG = 1');
        SET @sql_from = CONCAT(@sql_from,' AND SP.PTNCD = \'',p_management_cd,'\'');
	END IF;
    
    SET @sql_where = CONCAT(' WHERE SH.shipper_code IN(',@nnsicd,')');
    IF p_process_divide = 1 THEN
		SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_trading_short_name != \'A2\'');	
    ELSE
		SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_trading_short_name = \'A2\'');	
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
	
	SET @sql_ins = CONCAT(@sql_ins,IFNULL(@sql_from,''),IFNULL(@sql_where,''));
    
    SET @sql_ins = CONCAT(@sql_ins, ' ORDER BY');
    SET @sql_ins = CONCAT(@sql_ins, ' SH.wms_processing_date DESC');    
    SET @sql_ins = CONCAT(@sql_ins, ', SH.delivery_date DESC');    
    SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_code ASC');    
    SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_name ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.slip_number ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.item_line  ASC');    
        
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
    
    
	
    IF EXISTS(SELECT * FROM tmp_details) THEN
        
		-- トランザクション開始
		START TRANSACTION;
        	
		
		SET @sql_prev_key = 'CONCAT_WS(\'_\'';
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(wms_processing_date,\'\')');		
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(delivery_date,\'\')');		
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(shipper_code,\'\')');        
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(sales_office_code,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(sales_office_name,\'\')');
        
		SET @sql_prev_key = CONCAT(@sql_prev_key, ')');
		
		
		-- STEP.3 INSERT WORK HEAD
        SET @prevkey:=null;
		SET @work_id = 1;
        
		SET @sql_head = 'INSERT INTO pyt_w_106000_head SELECT DISTINCT';
		SET @sql_head = CONCAT(@sql_head, ' \'',p_user_id,'\' AS user_id');
		SET @sql_head = CONCAT(@sql_head, ', ', p_process_divide,' AS process_divide');        
        SET @sql_head = CONCAT(@sql_head, ', CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
        SET @sql_head = CONCAT(@sql_head, ', wms_processing_date');
        SET @sql_head = CONCAT(@sql_head, ', delivery_date');
        SET @sql_head = CONCAT(@sql_head, ', shipper_code');
		SET @sql_head = CONCAT(@sql_head, ', shipper_name');
        SET @sql_head = CONCAT(@sql_head, ', sales_office_code');
		SET @sql_head = CONCAT(@sql_head, ', sales_office_name');
        SET @sql_head = CONCAT(@sql_head, ', @prevkey:=',@sql_prev_key);	
		SET @sql_head = CONCAT(@sql_head, ' FROM tmp_details');
        
        	
		
		PREPARE _stmt_head from @sql_head;
		EXECUTE _stmt_head;
		DEALLOCATE PREPARE _stmt_head;		
		
        
        -- STEP.4 INSERT WORK DETAIL
		SET @prevkey:=null;
		SET @work_id = 1;
        SET @work_detail_id = 1;
			
		SET @sql_ins = 'INSERT INTO pyt_w_106000_details SELECT';
		SET @sql_ins = CONCAT(@sql_ins, ' \'',p_user_id,'\' AS user_id');
		SET @sql_ins = CONCAT(@sql_ins, ', ', p_process_divide,' AS process_divide');        
        SET @sql_ins = CONCAT(@sql_ins, ', @work_detail_id:=@work_detail_id+1 AS work_detail_id');
        SET @sql_ins = CONCAT(@sql_ins, ', CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');		
		SET @sql_ins = CONCAT(@sql_ins, ', shipper_code');
		SET @sql_ins = CONCAT(@sql_ins, ', shipper_accounting_date');
		SET @sql_ins = CONCAT(@sql_ins, ', warehouse_accounting_date');        
		SET @sql_ins = CONCAT(@sql_ins, ', delivery_date');
		SET @sql_ins = CONCAT(@sql_ins, ', slip_number');
		SET @sql_ins = CONCAT(@sql_ins, ', shipper_trading_code');
		SET @sql_ins = CONCAT(@sql_ins, ', shipper_trading_name');
		SET @sql_ins = CONCAT(@sql_ins, ', shipper_trading_short_name');
		SET @sql_ins = CONCAT(@sql_ins, ', sales_office_code');
		SET @sql_ins = CONCAT(@sql_ins, ', sales_office_name');
		SET @sql_ins = CONCAT(@sql_ins, ', transporter_code');
		SET @sql_ins = CONCAT(@sql_ins, ', transporter_name');
		SET @sql_ins = CONCAT(@sql_ins, ', pken_code');
		SET @sql_ins = CONCAT(@sql_ins, ', detail_order_number');
		SET @sql_ins = CONCAT(@sql_ins, ', slip_remarks1');
		SET @sql_ins = CONCAT(@sql_ins, ', arrival_time');
		SET @sql_ins = CONCAT(@sql_ins, ', branch_office_code');
		SET @sql_ins = CONCAT(@sql_ins, ', local_office_code');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_code');
		SET @sql_ins = CONCAT(@sql_ins, ', delivery_code');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_name1');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_name2');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_name3');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_area_code');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_address1');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_address2');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_address3');
		SET @sql_ins = CONCAT(@sql_ins, ', receiver_tel');
		SET @sql_ins = CONCAT(@sql_ins, ', priority_flag');
		SET @sql_ins = CONCAT(@sql_ins, ', item_line');
		SET @sql_ins = CONCAT(@sql_ins, ', item_line_column');
		SET @sql_ins = CONCAT(@sql_ins, ', logistics_code');
		SET @sql_ins = CONCAT(@sql_ins, ', outer_product_code');
		SET @sql_ins = CONCAT(@sql_ins, ', denryaku');
		SET @sql_ins = CONCAT(@sql_ins, ', product_name');
		SET @sql_ins = CONCAT(@sql_ins, ', capacity');
		SET @sql_ins = CONCAT(@sql_ins, ', unit_type');
		SET @sql_ins = CONCAT(@sql_ins, ', order_package_count');
        SET @sql_ins = CONCAT(@sql_ins, ', order_carton_count');
		SET @sql_ins = CONCAT(@sql_ins, ', order_fraction');
		SET @sql_ins = CONCAT(@sql_ins, ', quantity_per_carton');
		SET @sql_ins = CONCAT(@sql_ins, ', quantity_per_package');
		SET @sql_ins = CONCAT(@sql_ins, ', quantity_per_fraction');
		SET @sql_ins = CONCAT(@sql_ins, ', order_total_fraction');
		SET @sql_ins = CONCAT(@sql_ins, ', package_count');
		SET @sql_ins = CONCAT(@sql_ins, ', total_fraction');
		SET @sql_ins = CONCAT(@sql_ins, ', warehouse_code');
		SET @sql_ins = CONCAT(@sql_ins, ', warehouse_name');
		SET @sql_ins = CONCAT(@sql_ins, ', lot');
		SET @sql_ins = CONCAT(@sql_ins, ', sub_lot');
		SET @sql_ins = CONCAT(@sql_ins, ', line_lot');
		SET @sql_ins = CONCAT(@sql_ins, ', campaign_flag');
		SET @sql_ins = CONCAT(@sql_ins, ', factory_type');
		SET @sql_ins = CONCAT(@sql_ins, ', control_type');
		SET @sql_ins = CONCAT(@sql_ins, ', shipment_type');
		SET @sql_ins = CONCAT(@sql_ins, ', billing_type');
		SET @sql_ins = CONCAT(@sql_ins, ', cooling_type');
		SET @sql_ins = CONCAT(@sql_ins, ', width');
		SET @sql_ins = CONCAT(@sql_ins, ', length');
		SET @sql_ins = CONCAT(@sql_ins, ', height');
		SET @sql_ins = CONCAT(@sql_ins, ', package_weight');
		SET @sql_ins = CONCAT(@sql_ins, ', shipping_weight');
		SET @sql_ins = CONCAT(@sql_ins, ', shipping_location_code');
		SET @sql_ins = CONCAT(@sql_ins, ' , @prevkey:=',@sql_prev_key);
		SET @sql_ins = CONCAT(@sql_ins, ' FROM tmp_details');
		
		PREPARE _stmt_detail from @sql_ins;
		EXECUTE _stmt_detail;
		DEALLOCATE PREPARE _stmt_detail;
        
        COMMIT;
		
        -- STEP.5 RETURN
		SELECT * FROM pyt_w_106000_head WHERE user_id = p_user_id AND process_divide = p_process_divide
        ORDER BY delivery_date DESC, shipper_code ASC, sales_office_code ASC;
    ELSE
		-- NOTHINGS TO RETURN
		SELECT * FROM pyt_w_106000_head WHERE user_id = p_user_id AND process_divide = p_process_divide;
    END IF;          
    
    
    DROP TABLE IF EXISTS tmp_details;    
    
    
    
END//
DELIMITER ;