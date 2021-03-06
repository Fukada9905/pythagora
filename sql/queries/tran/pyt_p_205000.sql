DROP PROCEDURE IF EXISTS pyt_p_205000;
delimiter //

CREATE PROCEDURE pyt_p_205000(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_denno text
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_nnsicd text
,	IN p_shcd text
,	IN p_has_comment tinyint
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(10)
)
BEGIN

	DECLARE cur_date DATE;

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
		DELETE FROM pyt_w_205000_head WHERE user_id = p_user_id;
        DROP TABLE IF EXISTS tmp_details;
        RESIGNAL;
    END;

    -- トランザクション開始
    START TRANSACTION;
    
    -- STEP.0 REFRESH WORK & SETUP PARAMS
    DELETE FROM pyt_w_205000_head WHERE user_id = p_user_id;
    
	SET @date_to = DATE_FORMAT(DATE_ADD(p_date_to,INTERVAL 1 DAY),'%Y-%m-%d');
    
        
	IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD = CONCAT('INSERT INTO tmp_sntcd(JGSCD,SNTCD) VALUES',p_sntcd);
                
        PREPARE stmt_SNTCD from @sql_SNTCD;
		EXECUTE stmt_SNTCD;
		DEALLOCATE PREPARE stmt_SNTCD;
	END IF;
    
    
    -- STEP.1 SELECT TARGET DATA
    DROP TABLE IF EXISTS tmp_details;
	SET @sql_ins = ' CREATE TEMPORARY TABLE tmp_details SELECT';    
 	SET @sql_ins = CONCAT(@sql_ins, '   AP.ReportDatetime');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.warehouse_accounting_date AS DENPYOYMD');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.retrieval_date AS SYUKAYMD');
    SET @sql_ins = CONCAT(@sql_ins, ' , CAST(AH.wms_processing_date AS date) AS SYORIYMD');    
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.arrival_date AS NOHINYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.shipper_code AS NNSICD');
	SET @sql_ins = CONCAT(@sql_ins, ' , NN.NNSINM AS NNSINM');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.source_sales_office_code AS JGSCD_SK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.source_sales_office_name AS JGSNM_SK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.sales_office_code AS JGSCD_NK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.sales_office_name AS JGSNM_NK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.warehouse_code AS SNTCD_NK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.warehouse_name AS SNTNM_NK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.slip_number AS DENNO');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.transporter_code AS UNSKSCD');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.transporter_name AS UNSKSNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.product_code AS SHCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.denryaku AS DNRK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.product_name AS SHNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.lot AS RTNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , pyt_ufn_get_KKTSR(AH.package_count, AH.total_fraction, AH.quantity_per_package) AS KKTSR1');
	SET @sql_ins = CONCAT(@sql_ins, ' , CASE WHEN (AH.fraction <> 0) THEN AH.total_fraction ELSE 0 END AS KKTSR3');
	SET @sql_ins = CONCAT(@sql_ins, ' , IFNULL(AP.JitsuCase,pyt_ufn_get_KKTSR(AH.package_count, AH.total_fraction, AH.quantity_per_package)) AS JitsuCase');
    SET @sql_ins = CONCAT(@sql_ins, ' , IFNULL(AP.JitsuBara,CASE WHEN (AH.fraction <> 0) THEN AH.total_fraction ELSE 0 END) AS JitsuBara');
    SET @sql_ins = CONCAT(@sql_ins, ' , IFNULL(AP.Comment,\'\') AS Comment');
    SET @sql_ins = CONCAT(@sql_ins, ' , AP.Reporter');    
    SET @sql_ins = CONCAT(@sql_ins, ' , AP.Status');
    SET @sql_ins = CONCAT(@sql_ins, ' , AP.Registrant');    
    SET @sql_ins = CONCAT(@sql_ins, ' , AP.Registdatetime');    
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.id AS ID');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.item_line AS DENGNO');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.internal_slip_number AS NIBKNRDENGNO');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.source_warehouse_code AS SNTCD_SK');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.control_type AS LOTK');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.shipment_type AS LOTS');
    SET @sql_ins = CONCAT(@sql_ins, ' , AH.factory_type AS FCKBNKK');
    

    SET @sql_ins = CONCAT(@sql_ins, '  FROM t_arrival AS AH');
    SET @sql_ins = CONCAT(@sql_ins, '  INNER JOIN pyt_m_ninushi AS NN ON AH.shipper_code = NN.NNSICD');
	SET @sql_ins = CONCAT(@sql_ins, '  LEFT JOIN pyt_t_arrival_schedules AS AP');
	SET @sql_ins = CONCAT(@sql_ins, '  ON AH.id = AP.id');   
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
    
    
    SET @sql_where = ' WHERE AP.Status = 2';
    
    IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL AND p_date_from = p_date_to THEN
		SET @sql_where = CONCAT(@sql_where,' AND AH.wms_processing_date = \'',p_date_from,'\'');
    ELSE    
		IF p_date_from IS NOT NULL THEN
			SET @sql_where = CONCAT(@sql_where,' AND AH.wms_processing_date >= \'',p_date_from,'\'');		
		END IF;
		
		IF p_date_to IS NOT NULL THEN
			SET @sql_where = CONCAT(@sql_where,' AND AH.wms_processing_date < \'',@date_to,'\'');		
		END IF;
	END IF;
    
    IF p_denno IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND AH.slip_number IN(',p_denno,')');		
	END IF;
    
    IF p_jgscd IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND AH.sales_office_code IN(',p_jgscd,')');				
	END IF;
    
    IF p_nnsicd IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND AH.shipper_code IN(',p_nnsicd,')');				
	END IF;
        
	IF p_is_partner = 1 THEN
		SET @sql_where = CONCAT(@sql_where,' AND SP.PTNCD = \'',p_management_cd,'\'');		
	END IF;
        

	SET @sql_ins = CONCAT(@sql_ins,IFNULL(@sql_where,''));
    
    SET @sql_ins = CONCAT(@sql_ins, ' ORDER BY ');
    SET @sql_ins = CONCAT(@sql_ins, '  AH.wms_processing_date DESC');		
    SET @sql_ins = CONCAT(@sql_ins, ', AH.slip_number ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.shipper_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.source_sales_office_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.sales_office_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.warehouse_code ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.item_line ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.lot ASC');
    
    
            
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
    
	
    IF EXISTS(SELECT * FROM tmp_details) THEN
        
		-- STEP.2 SET UP INSERT WORK TABLE
		SELECT IFNULL(MAX(work_id),0) + 1 INTO @def_work_id FROM pyt_w_205000_head FOR UPDATE;
		SELECT IFNULL(MAX(work_detail_id),0) + 1 INTO @work_detail_id FROM pyt_w_205000_details FOR UPDATE;
				
		
		SET @sql_prev_key = 'CONCAT_WS(\'_\'';
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(ReportDatetime,\'\')');        
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSICD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSINM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSCD_SK,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSNM_SK,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSCD_NK,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSNM_NK,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTCD_NK,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTNM_NK,\'\')');                
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(DENNO,\'\')');		
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(DENPYOYMD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SYUKAYMD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NOHINYMD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SYORIYMD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(UNSKSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(UNSKSNM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ')');
		
		
		-- STEP.3 INSERT WORK HEAD
        SET @prevkey:=null;
		SET @work_id = @def_work_id;
        
		SET @sql_head = 'INSERT INTO pyt_w_205000_head SELECT';
		SET @sql_head = CONCAT(@sql_head, '  CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_head = CONCAT(@sql_head, ', \'',p_user_id,'\' AS user_id');
		SET @sql_head = CONCAT(@sql_head, ', ReportDatetime');        
        SET @sql_head = CONCAT(@sql_head, ', NNSICD');
		SET @sql_head = CONCAT(@sql_head, ', NNSINM');
        SET @sql_head = CONCAT(@sql_head, ', JGSCD_SK');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM_SK');
		SET @sql_head = CONCAT(@sql_head, ', JGSCD_NK');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM_NK');
        SET @sql_head = CONCAT(@sql_head, ', SNTCD_NK');
		SET @sql_head = CONCAT(@sql_head, ', SNTNM_NK');
        SET @sql_head = CONCAT(@sql_head, ', DENNO');
        SET @sql_head = CONCAT(@sql_head, ', DENPYOYMD');
        SET @sql_head = CONCAT(@sql_head, ', SYUKAYMD');
        SET @sql_head = CONCAT(@sql_head, ', NOHINYMD');
        SET @sql_head = CONCAT(@sql_head, ', SYORIYMD');
        SET @sql_head = CONCAT(@sql_head, ', UNSKSCD');
        SET @sql_head = CONCAT(@sql_head, ', UNSKSNM');
        SET @sql_head = CONCAT(@sql_head, ', MAX(IFNULL(Status,0)) AS Status');        
		SET @sql_head = CONCAT(@sql_head, ', @prevkey:=',@sql_prev_key);	
		SET @sql_head = CONCAT(@sql_head, ' FROM tmp_details');
        SET @sql_head = CONCAT(@sql_head, ' GROUP BY');
        SET @sql_head = CONCAT(@sql_head, '  ReportDatetime');
        SET @sql_head = CONCAT(@sql_head, ', NNSICD');
		SET @sql_head = CONCAT(@sql_head, ', NNSINM');
		SET @sql_head = CONCAT(@sql_head, ', JGSCD_SK');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM_SK');
		SET @sql_head = CONCAT(@sql_head, ', JGSCD_NK');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM_NK');
        SET @sql_head = CONCAT(@sql_head, ', SNTCD_NK');
		SET @sql_head = CONCAT(@sql_head, ', SNTNM_NK');
		SET @sql_head = CONCAT(@sql_head, ', DENPYOYMD');
        SET @sql_head = CONCAT(@sql_head, ', SYUKAYMD');
        SET @sql_head = CONCAT(@sql_head, ', NOHINYMD');
        SET @sql_head = CONCAT(@sql_head, ', UNSKSCD');
        SET @sql_head = CONCAT(@sql_head, ', UNSKSNM');
        SET @sql_head = CONCAT(@sql_head, ', DENNO');
			
		
		PREPARE _stmt_head from @sql_head;
		EXECUTE _stmt_head;
		DEALLOCATE PREPARE _stmt_head;
		
		
        
        -- STEP.4 INSERT WORK DETAIL
		SET @prevkey:=null;
		SET @work_id = @def_work_id;
			
		SET @sql_ins = 'INSERT INTO pyt_w_205000_details SELECT';
		SET @sql_ins = CONCAT(@sql_ins, '   @work_detail_id:=@work_detail_id+1 AS work_detail_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENNO');
        SET @sql_ins = CONCAT(@sql_ins, ' , SHCD');
        SET @sql_ins = CONCAT(@sql_ins, ' , DNRK');
        SET @sql_ins = CONCAT(@sql_ins, ' , SHNM');
        SET @sql_ins = CONCAT(@sql_ins, ' , RTNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins, ' , JitsuCase');
		SET @sql_ins = CONCAT(@sql_ins, ' , JitsuBara');
		SET @sql_ins = CONCAT(@sql_ins, ' , Comment');
		SET @sql_ins = CONCAT(@sql_ins, ' , Reporter');
        SET @sql_ins = CONCAT(@sql_ins, ' , Status');
		SET @sql_ins = CONCAT(@sql_ins, ' , Registrant');    
		SET @sql_ins = CONCAT(@sql_ins, ' , Registdatetime');   
        SET @sql_ins = CONCAT(@sql_ins, ' , @prevkey:=',@sql_prev_key);
        SET @sql_ins = CONCAT(@sql_ins, ' , ID');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENGNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , NIBKNRDENGNO');
		-- SET @sql_ins = CONCAT(@sql_ins, ' , SHCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSCD_SK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTCD_SK');
		-- SET @sql_ins = CONCAT(@sql_ins, ' , AH._RTNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , LOTK');
		SET @sql_ins = CONCAT(@sql_ins, ' , LOTS');
		SET @sql_ins = CONCAT(@sql_ins, ' , FCKBNKK');
		SET @sql_ins = CONCAT(@sql_ins, ' FROM tmp_details');
		
		PREPARE _stmt_detail from @sql_ins;
		EXECUTE _stmt_detail;
		DEALLOCATE PREPARE _stmt_detail;
		
        -- STEP.5 RETURN
        SET @sql_sel = 'SELECT';
        SET @sql_sel = CONCAT(@sql_sel, '  	WK.work_id');
        SET @sql_sel = CONCAT(@sql_sel, ',	pyt_ufn_get_datetime_format(WK.SYORIYMD) AS SYORIYMD');
        SET @sql_sel = CONCAT(@sql_sel, ',	pyt_ufn_get_date_format(WK.NOHINYMD) AS NOHINYMD');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.DENNO');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.NNSICD');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.NNSINM');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.JGSCD_SK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.JGSNM_SK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.JGSCD_NK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.JGSNM_NK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.SNTCD_NK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.SNTNM_NK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.prev_key');
        SET @sql_sel = CONCAT(@sql_sel, ',	CASE WHEN MAX(WD.Comment) != \'\' THEN \'有\' ELSE \'\' END AS HasComment');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.Status');        
        SET @sql_sel = CONCAT(@sql_sel, ' FROM pyt_w_205000_head AS WK');
        SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN pyt_w_205000_details AS WD');
        SET @sql_sel = CONCAT(@sql_sel, ' ON WK.work_id = WD.work_id');
        SET @sql_sel = CONCAT(@sql_sel, ' WHERE user_id = \'',p_user_id,'\'');
        IF p_shcd IS NOT NULL THEN
			SET @sql_sel = CONCAT(@sql_sel,' AND WD.SHCD IN(',p_shcd,')');		
		END IF;  
        IF p_has_comment = 1 THEN
			SET @sql_sel = CONCAT(@sql_sel,' AND WD.Comment != \'\'');		
        END IF;
        SET @sql_sel = CONCAT(@sql_sel, ' GROUP BY');
        SET @sql_sel = CONCAT(@sql_sel, '  	WK.work_id');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.SYORIYMD');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.NOHINYMD');        
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.DENNO');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.NNSICD');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.NNSINM');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.JGSCD_SK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.JGSNM_SK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.JGSCD_NK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.JGSNM_NK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.SNTCD_NK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.SNTNM_NK');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.prev_key');
        SET @sql_sel = CONCAT(@sql_sel, ',	WK.Status');
        
        SET @sql_sel = CONCAT(@sql_sel, ' ORDER BY SYORIYMD DESC, NOHINYMD DESC, DENNO ASC, NNSICD ASC, JGSCD_SK ASC, JGSCD_NK ASC, SNTCD_NK ASC');
                
		PREPARE _stmt_sel from @sql_sel;
		EXECUTE _stmt_sel;
		DEALLOCATE PREPARE _stmt_sel;
        
    ELSE
		-- NOTHINGS TO RETURN
		SELECT * FROM pyt_w_205000_head WHERE user_id = p_user_id;
    END IF;          
    
    
    DROP TABLE IF EXISTS tmp_details;

    COMMIT;

END//

delimiter ;