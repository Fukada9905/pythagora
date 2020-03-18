DROP PROCEDURE IF EXISTS pyt_p_301000;
DELIMITER //

CREATE PROCEDURE pyt_p_301000(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_ptncd text
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(10)
)
BEGIN
	
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DELETE FROM pyt_w_301000_head WHERE user_id = p_user_id;
        DROP TABLE IF EXISTS tmp_details;
        DROP TABLE IF EXISTS tmp_sntcd_cone;
        DROP TABLE IF EXISTS tmp_sntcd_cone2;
        DROP TABLE IF EXISTS tmp_sntcd_ptgr;
        RESIGNAL;
    END;
    
        
    SELECT GROUP_CONCAT(CONCAT('\'',NNSICD,'\'')) INTO @nnsicd FROM pyt_m_ninushi;
    
       	
        
	IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd_cone(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
        CREATE TEMPORARY TABLE tmp_sntcd_cone2(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
        CREATE TEMPORARY TABLE tmp_sntcd_ptgr(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD_cone = CONCAT('INSERT INTO tmp_sntcd_cone(JGSCD,SNTCD) VALUES',p_sntcd);
        SET @sql_SNTCD_cone2 = CONCAT('INSERT INTO tmp_sntcd_cone2(JGSCD,SNTCD) VALUES',p_sntcd);
        SET @sql_SNTCD_ptgr = CONCAT('INSERT INTO tmp_sntcd_ptgr(JGSCD,SNTCD) VALUES',p_sntcd);
                
        PREPARE stmt_SNTCD_cone from @sql_SNTCD_cone;
		EXECUTE stmt_SNTCD_cone;
		DEALLOCATE PREPARE stmt_SNTCD_cone;
        
        PREPARE stmt_SNTCD_cone2 from @sql_SNTCD_cone2;
		EXECUTE stmt_SNTCD_cone2;
		DEALLOCATE PREPARE stmt_SNTCD_cone2;
        
        PREPARE stmt_SNTCD_ptgr from @sql_SNTCD_ptgr;
		EXECUTE stmt_SNTCD_ptgr;
		DEALLOCATE PREPARE stmt_SNTCD_ptgr;
	END IF;
    
    
    -- STEP.1 SELECT TARGET DATA
    DROP TABLE IF EXISTS tmp_details;
    
    
    -- Make WHERE for InnerQuery
    SET @sql_where_cone = '';    
    SET @sql_where_ptgr = '';    
    
    IF p_is_partner = 1 OR p_ptncd IS NOT NULL THEN
    
		SET @sql_where_cone = CONCAT(@sql_where_cone,' INNER JOIN pyt_m_sp_conditions AS SP');
		SET @sql_where_cone = CONCAT(@sql_where_cone,' ON TD.shipper_code = SP.NNSICD');
		SET @sql_where_cone = CONCAT(@sql_where_cone,' AND TD.sales_office_code = SP.JGSCD');
		SET @sql_where_cone = CONCAT(@sql_where_cone,' AND (SP.SNTCD IS NULL OR TD.warehouse_code = SP.SNTCD)');
		SET @sql_where_cone = CONCAT(@sql_where_cone,' AND SP.ZKTISFRG = 1');
        
        SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' INNER JOIN pyt_m_sp_conditions AS SP');
		SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' ON TD.NNSICD = SP.NNSICD');
		SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND TD.JGSCD = SP.JGSCD');
		SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND (SP.SNTCD IS NULL OR TD.SNTCD = SP.SNTCD)');
		SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND SP.ZKTISFRG = 1');        
        
        IF p_ptncd IS NOT NULL THEN
			SET @sql_where_cone = CONCAT(@sql_where_cone,' AND SP.PTNCD = \'',p_ptncd,'\'');
            SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND SP.PTNCD = \'',p_ptncd,'\'');		
        ELSE
			SET @sql_where_cone = CONCAT(@sql_where_cone,' AND SP.PTNCD = \'',p_management_cd,'\'');
            SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND SP.PTNCD = \'',p_management_cd,'\'');
        END IF;	        
	END IF;    
    
    SET @sql_where_cone2 = @sql_where_cone;
    
    IF p_sntcd IS NOT NULL THEN
		SET @sql_where_cone = CONCAT(@sql_where_cone,' INNER JOIN tmp_sntcd_cone AS ST');
        SET @sql_where_cone = CONCAT(@sql_where_cone,' ON TD.sales_office_code = ST.JGSCD');
		SET @sql_where_cone = CONCAT(@sql_where_cone,' AND TD.warehouse_code = ST.SNTCD');        		
   
		SET @sql_where_cone2 = CONCAT(@sql_where_cone2,' INNER JOIN tmp_sntcd_cone2 AS ST');
        SET @sql_where_cone2 = CONCAT(@sql_where_cone2,' ON TD.sales_office_code = ST.JGSCD');
		SET @sql_where_cone2 = CONCAT(@sql_where_cone2,' AND TD.warehouse_code = ST.SNTCD');        		
        
        SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' INNER JOIN tmp_sntcd_ptgr AS ST');
        SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' ON TD.JGSCD = ST.JGSCD');
		SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND TD.SNTCD = ST.SNTCD');        		
	END IF;
    
    SET @sql_where_cone = CONCAT(@sql_where_cone,' WHERE shipper_code IN(',@nnsicd,')');
    SET @sql_where_cone2 = CONCAT(@sql_where_cone2,' WHERE shipper_code IN(',@nnsicd,')');
    SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' WHERE AddFlag = 1');           
    
    
    IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL AND p_date_to = p_date_from THEN
		SET @sql_where_cone = CONCAT(@sql_where_cone,' AND TD.target_date = \'',p_date_to,'\'');
        SET @sql_where_cone2 = CONCAT(@sql_where_cone2,' AND TD.target_date = \'',p_date_to,'\'');
        SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND TD.PYTStocktakingDate = \'',p_date_from,'\'');        
    ELSE
		IF p_date_from IS NOT NULL THEN
			SET @sql_where_cone = CONCAT(@sql_where_cone,' AND TD.target_date >= \'',p_date_from,'\'');
            SET @sql_where_cone2 = CONCAT(@sql_where_cone2,' AND TD.target_date >= \'',p_date_from,'\'');
			SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND TD.PYTStocktakingDate >= \'',p_date_from,'\'');            
		END IF;
		
		IF p_date_to IS NOT NULL THEN
			SET @sql_where_cone = CONCAT(@sql_where_cone,' AND TD.target_date <= \'',p_date_to,'\'');
            SET @sql_where_cone2 = CONCAT(@sql_where_cone2,' AND TD.target_date <= \'',p_date_to,'\'');
			SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND TD.PYTStocktakingDate <= \'',p_date_to,'\'');            
		END IF;    
		
		
    END IF;	
    
    IF p_jgscd IS NOT NULL THEN
		SET @sql_where_cone = CONCAT(@sql_where_cone,' AND TD.sales_office_code IN(',p_jgscd,')');				
        SET @sql_where_cone2 = CONCAT(@sql_where_cone2,' AND TD.sales_office_code IN(',p_jgscd,')');				
		SET @sql_where_ptgr = CONCAT(@sql_where_ptgr,' AND TD.JGSCD IN(',p_jgscd,')');        
	END IF;
    
    
    -- Make TempTable
    DROP TABLE IF EXISTS tmp_inventory;
	CREATE TEMPORARY TABLE tmp_inventory(
		PYTStocktakingDate DATE
	,	NNSICD VARCHAR(10)
	,	NNSINM VARCHAR(50)
	,	JGSCD VARCHAR(10)
	,	JGSNM VARCHAR(50)
	,	SNTCD VARCHAR(10)
	,	SNTNM VARCHAR(50)
	,	SHCD VARCHAR(10)
	,	DNRK VARCHAR(20)
	,	SR1RS INT
	,	SHNKKKMEI_KS VARCHAR(20)
	,	SHNM VARCHAR(50)
	,	SRRNO VARCHAR(2)
	,	RTNO VARCHAR(20)
	,	KANRIK VARCHAR(10)
	,	SYUKAK VARCHAR(10)
	,	KOUJOK VARCHAR(3)
	,	PYTexStocks1 INT
	,	PYTexStocks3 INT
	,	NUKSURU1 INT
	,	NUKSURU3 INT
	,	PYTPicking1 INT
	,	PYTPicking3 INT
	,	PYTstock1 INT
	,	PYTstock3 INT
	,	PYTPLQ INT
	,	PYTPLP INT 
    ,	ReportComment VARCHAR(255)
    ,	Status TINYINT
	-- ,	KEY tmp_inventory_uq(NNSICD,JGSCD,SRRNO,RTNO,KANRIK,SYUKAK,KOUJOK,SNTCD,SHCD,PYTStocktakingDate)
	);
    
    SET @sql_ins = 'INSERT INTO tmp_inventory';
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' SELECT');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' PYTStocktakingDate');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NNSICD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NNSINM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,JGSCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,JGSNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SNTCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SNTNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SHCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,DNRK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SR1RS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SHNKKKMEI_KS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SHNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SRRNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,RTNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,KANRIK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SYUKAK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,KOUJOK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(PYTexStocks1) AS PYTexStocks1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(PYTexStocks3) AS PYTexStocks3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(NUKSURU1) AS NUKSURU1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(NUKSURU3) AS NUKSURU3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(PYTPicking1) AS PYTPicking1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(PYTPicking3) AS PYTPicking3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(PYTstock1) AS PYTstock1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(PYTstock3) AS PYTstock3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(PYTPLQ) AS PYTPLQ');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SUM(PYTPLP) AS PYTPLP');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,MAX(ReportComment) AS ReportComment');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,MAX(Status) AS Status');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' FROM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' (');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' SELECT');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' TD.target_date AS PYTStocktakingDate');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.shipper_code AS NNSICD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NN.NNSINM AS NNSINM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.sales_office_code AS JGSCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.sales_office_name AS JGSNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.warehouse_code AS SNTCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.warehouse_name AS SNTNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.product_code AS SHCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.denryaku AS DNRK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.quantity_per_package AS SR1RS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.package_capasity AS SHNKKKMEI_KS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.product_name AS SHNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(TD.pass_type,\'\') AS SRRNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.lot AS RTNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(TD.control_type,\'\') AS KANRIK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(TD.shipment_type,\'\') AS SYUKAK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(TD.factory_type,\'\') AS KOUJOK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTexStocks1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTexStocks3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS NUKSURU1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS NUKSURU3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTPicking1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTPicking3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTstock1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTstock3');		
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTPLQ');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTPLP');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(PL.ReportComment,\'\') AS ReportComment');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,PL.Status AS Status');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' FROM t_inventory AS TD');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' INNER JOIN pyt_m_ninushi AS NN');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ON TD.shipper_code = NN.NNSICD');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' INNER JOIN pyt_t_location_stocks AS PL');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ON TD.shipper_code = PL.NNSICD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND TD.sales_office_code = PL.JGSCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND IFNULL(TD.pass_type,\'\') = PL.SRRNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND TD.lot = PL.RTNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND IFNULL(TD.control_type,\'\') = PL.KANRIK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND IFNULL(TD.shipment_type,\'\') = PL.SYUKAK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND IFNULL(TD.factory_type,\'\') = PL.KOUJOK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND TD.warehouse_code = PL.SNTCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND TD.product_code = PL.SHCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND TD.target_date = PL.PYTStocktakingDate');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' AND PL.AddFlag = 0');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''), @sql_where_cone);
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' UNION ALL');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' SELECT');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' TD.target_date AS PYTStocktakingDate');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.shipper_code AS NNSICD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NN.NNSINM AS NNSINM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.sales_office_code AS JGSCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.sales_office_name AS JGSNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.warehouse_code AS SNTCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.warehouse_name AS SNTNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.product_code AS SHCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.denryaku AS DNRK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.quantity_per_package AS SR1RS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.package_capasity AS SHNKKKMEI_KS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.product_name AS SHNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(TD.pass_type,\'\') AS SRRNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.lot AS RTNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(TD.control_type,\'\') AS KANRIK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(TD.shipment_type,\'\') AS SYUKAK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,IFNULL(TD.factory_type,\'\') AS KOUJOK');
    /*
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTexStocks(1,TD.package_count,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.quantity_per_package) AS PYTexStocks1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTexStocks(3,TD.package_count,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.quantity_per_package) AS PYTexStocks3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_NUKSURU(1,TD.package_count,TD.received_stock_quantity,TD.quantity_per_package) AS NUKSURU1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_NUKSURU(3,TD.package_count,TD.received_stock_quantity,TD.quantity_per_package) AS NUKSURU3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTPicking(1,TD.package_count,TD.shipping_package_count,TD.shipping_fraction) AS PYTPicking1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTPicking(3,TD.package_count,TD.shipping_package_count,TD.shipping_fraction) AS PYTPicking3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTstocks(1,TD.package_count,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS PYTstock1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTstocks(3,TD.package_count,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS PYTstock3');		
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTstocks(1,TD.package_count,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) DIV IFNULL(package_count_per_pallet,0) AS PYTPLQ');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTstocks(1,TD.package_count,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) MOD IFNULL(package_count_per_pallet,0) AS PYTPLP');
    */
    
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTexStocks2(1,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS PYTexStocks1');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTexStocks2(3,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS PYTexStocks3');    
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_NUKSURU2(1,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS NUKSURU1');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_NUKSURU2(3,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS NUKSURU3');    
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTPicking2(1,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS PYTPicking1');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTPicking2(3,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS PYTPicking3');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTstocks2(1,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS PYTstock1');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTstocks2(3,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) AS PYTstock3');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTstocks2(1,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) DIV IFNULL(package_count_per_pallet,0) AS PYTPLQ');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,pyt_ufn_get_PYTstocks2(1,TD.package_count,TD.fraction,TD.previous_accounting_stock,TD.shipment_stock_quantity,TD.received_stock_quantity,TD.quantity_per_package,TD.shipping_package_count,TD.shipping_fraction) MOD IFNULL(package_count_per_pallet,0) AS PYTPLP');
    
    
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,\'\' AS ReportComment');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS Status');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' FROM t_inventory AS TD');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' INNER JOIN pyt_m_ninushi AS NN');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ON TD.shipper_code = NN.NNSICD');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''), @sql_where_cone2);
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),') AS SB');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' GROUP BY');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' PYTStocktakingDate');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NNSICD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NNSINM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,JGSCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,JGSNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SNTCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SNTNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SHCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,DNRK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SR1RS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SHNKKKMEI_KS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SHNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SRRNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,RTNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,KANRIK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,SYUKAK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,KOUJOK');	
    
    
    
    PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
    
    -- Make SelectQuery
    SET @sql_ins = 'CREATE TEMPORARY TABLE tmp_details SELECT PTGRS.* FROM(';
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),'SELECT');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' LSB.PYTStocktakingDate');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.NNSICD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.NNSINM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.JGSCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.JGSNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.SNTCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.SNTNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.SHCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.DNRK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.SR1RS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.SHNKKKMEI_KS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.SHNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.SRRNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.RTNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.KANRIK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.SYUKAK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.KOUJOK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTexStocks1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTexStocks3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.NUKSURU1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.NUKSURU3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTPicking1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTPicking3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTstock1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTstock3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTPLQ');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTPLP');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTstock1 AS JitsuCase');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.PYTstock3 AS JitsuBara');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.ReportComment AS Comment');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,LSB.Status');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS AddFlag');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' FROM tmp_inventory AS LSB');
	
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' UNION ALL');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' SELECT');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' TD.PYTStocktakingDate');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.NNSICD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NN.NNSINM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.JGSCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.JGSNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.SNTCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.SNTNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.SHCD');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,\'\' AS DNRK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NULL AS SR1RS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,NULL AS SHNKKKMEI_KS');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.SHNM');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,\'0\' AS SRRNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.RTNO');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.KANRIK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.SYUKAK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,TD.KOUJOK');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTexStocks1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTexStocks3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS NUKSURU1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS NUKSURU3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTPicking1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTPicking3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTstock1');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTstock3');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTPLQ');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ,0 AS PYTPLP');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''), ',TD.JitsuCase');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''), ',TD.JitsuBara');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''), ',IFNULL(TD.ReportComment,\'\') AS Comment');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''), ',TD.Status');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''), ',1 AS AddFlag');
	SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' FROM c_one.pyt_t_location_stocks AS TD');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' INNER JOIN pyt_m_ninushi AS NN');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),' ON TD.NNSICD = NN.NNSICD');
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),@sql_where_ptgr);
    SET @sql_ins = CONCAT(IFNULL(@sql_ins,''),') AS PTGRS');
    
    SET @sql_ins = CONCAT(@sql_ins, ' ORDER BY ');
    SET @sql_ins = CONCAT(@sql_ins, '  PTGRS.PYTStocktakingDate DESC');		
    SET @sql_ins = CONCAT(@sql_ins, ', PTGRS.JGSCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', PTGRS.SNTCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', PTGRS.NNSICD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', PTGRS.AddFlag ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', PTGRS.SHCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', PTGRS.KANRIK ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', PTGRS.SYUKAK ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', PTGRS.KOUJOK ASC');
        
        
	-- SELECT @sql_ins;
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
        
	IF EXISTS(SELECT * FROM tmp_details) THEN
    
		-- STEP.0 REFRESH WORK & SETUP PARAMS
        IF EXISTS(SELECT work_id FROM pyt_w_301000_head WHERE user_id = p_user_id) THEN
			DELETE FROM pyt_w_301000_head WHERE user_id = p_user_id;
        END IF;
        
		-- STEP.2 SET UP INSERT WORK TABLE
		
		SET @sql_prev_key = 'CONCAT_WS(\'_\'';
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(PYTStocktakingDate,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSNM,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTNM,\'\')');                
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSICD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSINM,\'\')');		        
		SET @sql_prev_key = CONCAT(@sql_prev_key, ')');
		
		
		-- STEP.3 INSERT WORK HEAD
        SET @prevkey:=null;
		SET @work_id = 1;
        
		SET @sql_head = 'INSERT INTO pyt_w_301000_head SELECT';
		SET @sql_head = CONCAT(@sql_head, '  CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_head = CONCAT(@sql_head, ', \'',p_user_id,'\' AS user_id');
		SET @sql_head = CONCAT(@sql_head, ', PYTStocktakingDate');
        SET @sql_head = CONCAT(@sql_head, ', JGSCD');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM');
        SET @sql_head = CONCAT(@sql_head, ', SNTCD');
		SET @sql_head = CONCAT(@sql_head, ', SNTNM');
        SET @sql_head = CONCAT(@sql_head, ', NNSICD');
		SET @sql_head = CONCAT(@sql_head, ', NNSINM');			
        SET @sql_head = CONCAT(@sql_head, ', MAX(Status) AS Status');        
		SET @sql_head = CONCAT(@sql_head, ', @prevkey:=',@sql_prev_key);	
		SET @sql_head = CONCAT(@sql_head, ' FROM tmp_details');
        SET @sql_head = CONCAT(@sql_head, ' GROUP BY');
        SET @sql_head = CONCAT(@sql_head, '  PYTStocktakingDate');
        SET @sql_head = CONCAT(@sql_head, ', JGSCD');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM');
        SET @sql_head = CONCAT(@sql_head, ', SNTCD');
		SET @sql_head = CONCAT(@sql_head, ', SNTNM');
        SET @sql_head = CONCAT(@sql_head, ', NNSICD');
		SET @sql_head = CONCAT(@sql_head, ', NNSINM');
		
        			
		
		PREPARE _stmt_head from @sql_head;
		EXECUTE _stmt_head;
		DEALLOCATE PREPARE _stmt_head;
		
		
        
        -- STEP.4 INSERT WORK DETAIL
		SET @prevkey:=null;
		SET @work_id = 1;
        SET @work_detail_id = 1;
			
		SET @sql_ins = 'INSERT INTO pyt_w_301000_details SELECT';
		SET @sql_ins = CONCAT(@sql_ins, '   @work_detail_id:=@work_detail_id+1 AS work_detail_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
        SET @sql_ins = CONCAT(@sql_ins, ', \'',p_user_id,'\' AS user_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHCD');
        SET @sql_ins = CONCAT(@sql_ins, ' , IFNULL(DNRK,\'\')');
        SET @sql_ins = CONCAT(@sql_ins, ' , SR1RS');
        SET @sql_ins = CONCAT(@sql_ins, ' , SHNKKKMEI_KS');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , IFNULL(SRRNO,\'\')');
        SET @sql_ins = CONCAT(@sql_ins, ' , RTNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , IFNULL(KANRIK,\'\')');
        SET @sql_ins = CONCAT(@sql_ins, ' , IFNULL(SYUKAK,\'\')');
        SET @sql_ins = CONCAT(@sql_ins, ' , IFNULL(KOUJOK,\'\')');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTexStocks1');
        SET @sql_ins = CONCAT(@sql_ins, ' , PYTexStocks3');
		SET @sql_ins = CONCAT(@sql_ins, ' , NUKSURU1');
        SET @sql_ins = CONCAT(@sql_ins, ' , NUKSURU3');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTPicking1');
        SET @sql_ins = CONCAT(@sql_ins, ' , PYTPicking3');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTstock1');
        SET @sql_ins = CONCAT(@sql_ins, ' , PYTstock3');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTPLQ');
        SET @sql_ins = CONCAT(@sql_ins, ' , PYTPLP');
		SET @sql_ins = CONCAT(@sql_ins, ' , JitsuCase');
		SET @sql_ins = CONCAT(@sql_ins, ' , JitsuBara');
		SET @sql_ins = CONCAT(@sql_ins, ' , Comment');
		SET @sql_ins = CONCAT(@sql_ins, ' , Status');
        SET @sql_ins = CONCAT(@sql_ins, ' , @prevkey:=',@sql_prev_key);        
		SET @sql_ins = CONCAT(@sql_ins, ' FROM tmp_details');
		
		PREPARE _stmt_detail from @sql_ins;
		EXECUTE _stmt_detail;
		DEALLOCATE PREPARE _stmt_detail;
		
        -- STEP.5 RETURN
		SELECT * FROM pyt_w_301000_head WHERE user_id = p_user_id
        ORDER BY PYTStocktakingDate DESC, JGSCD ASC, SNTCD ASC, NNSICD ASC;
    ELSE
		-- NOTHINGS TO RETURN
		SELECT * FROM tmp_details;
    END IF;          
    
    DROP TABLE IF EXISTS tmp_details;
    DROP TABLE IF EXISTS tmp_sntcd_cone;
    DROP TABLE IF EXISTS tmp_sntcd_cone2;
	DROP TABLE IF EXISTS tmp_sntcd_ptgr;
    
END//