DROP PROCEDURE IF EXISTS pyt_p_103020;
DELIMITER //

CREATE PROCEDURE pyt_p_103020(
	IN p_is_partner tinyint
,	IN p_date_divide tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_management_cd varchar(10)
,	IN p_pt_name_divide tinyint
,	IN p_nnsicd text
,	IN p_user_id varchar(10)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
		DELETE FROM pyt_w_103020_head WHERE user_id = p_user_id;
        DROP TABLE IF EXISTS tmp_details;
        RESIGNAL;
    END;

    -- トランザクション開始
    START TRANSACTION;
    
    IF p_nnsicd IS NULL THEN
		SELECT GROUP_CONCAT(CONCAT('\'',NNSICD,'\'')) INTO @nnsicd FROM pyt_m_ninushi;
	ELSE
		SET @nnsicd = p_nnsicd;
    END IF;
    
    -- STEP.0 REFRESH WORK
    DELETE FROM pyt_w_103020_head WHERE user_id = p_user_id;
    
    -- STEP.1 SELECT TARGET DATA
    DROP TABLE IF EXISTS tmp_details;
	SET @sql_ins = ' CREATE TEMPORARY TABLE tmp_details SELECT';    
    SET @sql_ins = CONCAT(@sql_ins, ' NULL AS DKBNNM');		
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.shipper_code AS NNSICD');
	SET @sql_ins = CONCAT(@sql_ins, ' , NN.NNSINM AS NNSINM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.sales_office_code AS JGSCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.sales_office_name AS JGSNM');
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.shipper_order_number AS JCDENNO');
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.slip_number AS DENNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.item_line AS DENGNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.shipping_location_code AS SYUKAP');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.control_type AS LOTK');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.shipment_type AS LOTS');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.factory_type AS FCKBNKK');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.warehouse_code AS SNTCD');
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.warehouse_name AS SNTNM');
    IF p_pt_name_divide = 1 OR p_is_partner = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins, ' , PN.PTNCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , CASE WHEN PN.PTNCD IS NULL THEN \'なし\' ELSE CONCAT(IFNULL(PN.PTNCDNM1,\'\'),IFNULL(PN.PTNCDNM2,\'\')) END AS PTNNM');
    END IF;
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.transporter_code AS UNSKSCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.transporter_name AS UNSKSNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.shipper_trading_code AS SKHNYKBN1');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.shipper_trading_name AS SKHNYKBN1NM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.wms_processing_date AS SYORIYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.retrieval_date AS SYUKAYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.delivery_date AS NOHINYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.warehouse_accounting_date AS DENPYOYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.delivery_code AS NHNSKCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , CONCAT(IFNULL(SH.receiver_name1,\'\'), IFNULL(SH.receiver_name2,\'\'), IFNULL(SH.receiver_name3,\'\')) AS NHNSKNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , CONCAT(IFNULL(SH.receiver_address1,\'\'), IFNULL(SH.receiver_address2,\'\'), IFNULL(SH.receiver_address3,\'\')) AS JYUSYO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.receiver_tel AS TEL');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.receiver_area_code AS JISCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.wms_car_number AS KRMBN');
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.product_code AS SHCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.denryaku AS DNRK');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.product_name AS SHNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.package_capasity AS SHNKKKMEI');	
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.billing_type AS SEKKBN');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.lot AS RTNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.quantity_per_package AS SR1RS');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.quantity_per_carton AS SR2RS');
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.unit_type AS KHKBN');
	-- SET @sql_ins = CONCAT(@sql_ins, ' , pyt_ufn_get_shipment_KHKBN(SH.package_count, SH.carton_count, SH.fraction) AS KHKBN');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.package_count_per_pallet AS PL');
    
    SET @sql_ins = CONCAT(@sql_ins,', SH.total_fraction DIV SH.quantity_per_package AS KKTSR1');		
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.package_count DIV SH.package_count_per_pallet AS PL_DIV');
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.package_count MOD SH.package_count_per_pallet AS PL_MOD');    
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.carton_count AS KKTSR2');
    SET @sql_ins = CONCAT(@sql_ins,', SH.total_fraction MOD SH.quantity_per_package AS KKTSR3');
    SET @sql_ins = CONCAT(@sql_ins,', SH.total_fraction AS KKTSSR');
	
    SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SH.shipping_weight, 1) AS WGT');	
    
    
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.factory_direct AS KOJYOFLG');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.delivery_remark AS BIKO');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(SH.created_at,\'%Y%m%d\') AS TRKMJ');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(SH.created_at,\'%Y\') AS TRKMJ_YYYY');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(SH.created_at,\'%m\') AS TRKMJ_MM');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(SH.created_at,\'%d\') AS TRKMJ_DD');
    SET @sql_ins = CONCAT(@sql_ins, ' , CAST(SH.created_at AS date) AS TRKMYMD');
    
	    
    SET @sql_from = '';
    SET @sql_from = CONCAT(@sql_from, ' FROM t_shipment AS SH');
    SET @sql_from = CONCAT(@sql_from, ' INNER JOIN pyt_m_ninushi AS NN ON SH.shipper_code = NN.NNSICD');
    
    IF p_pt_name_divide = 1 OR p_is_partner = 1 THEN
		SET @sql_from = CONCAT(@sql_from,' LEFT JOIN pyt_m_sp_conditions AS SP');
        SET @sql_from = CONCAT(@sql_from,' ON NN.NNSICD = SP.NNSICD');
		SET @sql_from = CONCAT(@sql_from,' AND SH.sales_office_code = SP.JGSCD');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.SNTCD IS NULL OR SH.warehouse_code = SP.SNTCD)');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.UNSKSCD IS NULL OR SH.transporter_code = SP.UNSKSCD)');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.SYUKAP IS NULL OR SH.shipping_location_code = SP.SYUKAP)');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.SEKKBN IS NULL OR SH.billing_type = SP.SEKKBN)');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.NHNSKCD IS NULL OR SH.delivery_code = SP.NHNSKCD)');
		SET @sql_from = CONCAT(@sql_from,' AND SP.SKTISFRG = 1');
        SET @sql_from = CONCAT(@sql_from,' LEFT JOIN pyt_m_partners AS PN');
		SET @sql_from = CONCAT(@sql_from,' ON SP.PTNCD = PN.PTNCD');
    END IF;
    
    SET @sql_where = ' WHERE SH.shipper_trading_short_name = \'A2\'';
	SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_code IN(',@nnsicd,')');
    
    
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
    
    IF p_is_partner = 1 THEN
		SET @sql_where = CONCAT(@sql_where,' AND SP.PTNCD = \'',p_management_cd,'\'');
	END IF;

	SET @sql_ins = CONCAT(@sql_ins,IFNULL(@sql_from,''),IFNULL(@sql_where,''));
    
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
    SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.sales_office_name ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.warehouse_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.warehouse_name ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.transporter_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.transporter_name ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.shipper_code ASC');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.slip_number ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.item_line ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.lot ASC');
    
    
        
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
    
    IF EXISTS(SELECT * FROM tmp_details) THEN
        
		-- STEP.2 SET UP INSERT WORK TABLE
		SELECT IFNULL(MAX(work_id),0) + 1 INTO @def_work_id FROM pyt_w_103020_head FOR UPDATE;
		SELECT IFNULL(MAX(work_detail_id),0) + 1 INTO @work_detail_id FROM pyt_w_103020_details FOR UPDATE;
				
		
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
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSNM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTNM,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(UNSKSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(UNSKSNM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSICD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSINM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ')');
		
		
		-- STEP.3 INSERT WORK HEAD
        SET @prevkey:=null;
		SET @work_id = @def_work_id;
        
		SET @sql_head = 'INSERT INTO pyt_w_103020_head SELECT DISTINCT';
        SET @sql_head = CONCAT(@sql_head, '  CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_head = CONCAT(@sql_head, ', \'',p_user_id,'\' AS user_id');
        SET @sql_head = CONCAT(@sql_head, ', SYORIYMD');
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
        SET @sql_head = CONCAT(@sql_head, ', SNTCD');
		SET @sql_head = CONCAT(@sql_head, ', SNTNM');
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
		SET @work_id = @def_work_id;
			
		SET @sql_ins = 'INSERT INTO pyt_w_103020_details SELECT';
		SET @sql_ins = CONCAT(@sql_ins, '   @work_detail_id:=@work_detail_id+1 AS work_detail_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , DKBNNM');		
		SET @sql_ins = CONCAT(@sql_ins, ' , NNSICD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NNSINM');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , JCDENNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENGNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYUKAP');
		SET @sql_ins = CONCAT(@sql_ins, ' , LOTK');
		SET @sql_ins = CONCAT(@sql_ins, ' , LOTS');
		SET @sql_ins = CONCAT(@sql_ins, ' , FCKBNKK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTNM');
        IF p_pt_name_divide = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins, ' , PTNNM');
        ELSE
        SET @sql_ins = CONCAT(@sql_ins, ' , NULL AS PTNNM');
        END IF;
		SET @sql_ins = CONCAT(@sql_ins, ' , UNSKSCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , UNSKSNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKHNYKBN1');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKHNYKBN1NM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYORIYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYUKAYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NOHINYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENPYOYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NHNSKCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NHNSKNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , JYUSYO');
		SET @sql_ins = CONCAT(@sql_ins, ' , TEL');
		SET @sql_ins = CONCAT(@sql_ins, ' , JISCD');
        SET @sql_ins = CONCAT(@sql_ins, ' , KRMBN');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , DNRK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNKKKMEI');	
		SET @sql_ins = CONCAT(@sql_ins, ' , SEKKBN');
		SET @sql_ins = CONCAT(@sql_ins, ' , RTNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , SR1RS');
		SET @sql_ins = CONCAT(@sql_ins, ' , SR2RS');
		SET @sql_ins = CONCAT(@sql_ins, ' , KHKBN');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL_DIV');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL_MOD');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR2');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSSR');
		SET @sql_ins = CONCAT(@sql_ins, ' , WGT');
		SET @sql_ins = CONCAT(@sql_ins, ' , KOJYOFLG');
		SET @sql_ins = CONCAT(@sql_ins, ' , BIKO');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRKMJ');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRKMJ_YYYY');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRKMJ_MM');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRKMJ_DD');
		SET @sql_ins = CONCAT(@sql_ins, ' , @prevkey:=',@sql_prev_key);
		SET @sql_ins = CONCAT(@sql_ins, ' FROM tmp_details');
		
		PREPARE _stmt_detail from @sql_ins;
		EXECUTE _stmt_detail;
		DEALLOCATE PREPARE _stmt_detail;
		
        -- STEP.5 RETURN
		SELECT * FROM pyt_w_103020_head WHERE user_id = p_user_id
        ORDER BY SYORIYMD DESC, DATEYMD DESC, JGSCD ASC, SNTCD ASC, UNSKSCD ASC, NNSICD ASC;
    ELSE
		-- NOTHINGS TO RETURN
		SELECT * FROM pyt_w_103020_head WHERE user_id = p_user_id;
    END IF;          
    
    
    DROP TABLE IF EXISTS tmp_details;

    COMMIT;

END//
DELIMITER ;
