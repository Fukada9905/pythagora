DROP PROCEDURE IF EXISTS pyt_p_201_common_csv;
delimiter //

CREATE PROCEDURE pyt_p_201_common_csv(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_management_cd varchar(10)
)
BEGIN
    
    DECLARE cur_date DATE;
    
    SET cur_date = CURRENT_DATE();
        
    SET @date_from = DATE_FORMAT(cur_date,'%Y-%m-%d');
    SET @date_to = DATE_FORMAT(DATE_ADD(cur_date,INTERVAL 1 DAY),'%Y-%m-%d');
    
    IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD = CONCAT('INSERT INTO tmp_sntcd(JGSCD,SNTCD) VALUES',p_sntcd);
        
        PREPARE stmt_SNTCD from @sql_SNTCD;
		EXECUTE stmt_SNTCD;
		DEALLOCATE PREPARE stmt_SNTCD;
	END IF;
    
    
    SET @sql_sel = 'SELECT';
	SET @sql_sel = CONCAT(@sql_sel, ' AH.wms_processing_date AS \'処理日時\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.retrieval_date AS \'出荷日\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.arrival_date AS \'納品日\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.warehouse_accounting_date AS \'伝票日付\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.shipper_code	AS \'荷主コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ',NN.NNSINM AS \'荷主名\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.source_sales_office_code AS \'出荷元事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.source_sales_office_name AS \'出荷元事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.source_warehouse_code AS \'出荷元センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.source_warehouse_name AS \'出荷元センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.transporter_code AS \'運送会社コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.transporter_name AS \'運送会社名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.sales_office_code AS \'入荷事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.sales_office_name AS \'入荷事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.warehouse_code AS \'入荷センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.warehouse_name AS \'入荷センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.shipper_trading_code AS \'ＩＤ\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.shipper_trading_name AS \'ＩＤ名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.slip_number AS \'伝票番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.item_line AS \'伝票行番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.slip_remarks AS \'備考\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.product_code AS \'商品コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.denryaku AS \'電略\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.product_name AS \'製品名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.package_capasity	AS \'規格\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.billing_type AS \'請求区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.quantity_per_package AS \'ケース入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.quantity_per_carton AS \'中間入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ',pyt_ufn_get_arrival_KHKBN(AH.package_count,AH.carton_count) AS \'梱端区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.lot AS \'ロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.control_type AS \'管理区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.shipment_type AS \'出荷区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.factory_type AS \'工場コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ',AH.package_count_per_pallet AS \'パレット積付数\'');
	SET @sql_sel = CONCAT(@sql_sel, ',pyt_ufn_get_KKTSR(AH.package_count, AH.total_fraction, AH.quantity_per_package) AS \'入荷予定ケース数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ',pyt_ufn_get_KKTSR(AH.package_count, AH.total_fraction, AH.quantity_per_package) DIV AH.package_count_per_pallet AS \'パレット枚数\'');
	SET @sql_sel = CONCAT(@sql_sel, ',pyt_ufn_get_KKTSR(AH.package_count, AH.total_fraction, AH.quantity_per_package) MOD AH.package_count_per_pallet AS \'パレット端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ',pyt_ufn_get_KKTSR(AH.carton_count, AH.total_fraction, AH.quantity_per_carton) AS \'入荷予定中間数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ',CASE WHEN (AH.fraction <> 0) THEN AH.total_fraction ELSE 0 END AS \'入荷予定バラ数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ',TRUNCATE(AH.total_fraction_weight+0.9, 0) AS \'入荷予定総重量\'');
	SET @sql_sel = CONCAT(@sql_sel, ',DATE_FORMAT(AH.created_at,\'%Y%m%d\') AS \'ＤＢ取込時間（yyyymmdd）\'');
	SET @sql_sel = CONCAT(@sql_sel, ',DATE_FORMAT(AH.created_at,\'%Y\') AS \'ＤＢ取込時間（yyyy）\'');
	SET @sql_sel = CONCAT(@sql_sel, ',DATE_FORMAT(AH.created_at,\'%m\') AS \'ＤＢ取込時間（mm）\'');
	SET @sql_sel = CONCAT(@sql_sel, ',DATE_FORMAT(AH.created_at,\'%d\') AS \'ＤＢ取込時間（dd）\'');
    
    SET @sql_sel = CONCAT(@sql_sel, ' FROM t_arrival AS AH');
    SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN pyt_m_ninushi AS NN ON AH.shipper_code = NN.NNSICD');
	SET @sql_sel = CONCAT(@sql_sel, ' LEFT JOIN pyt_t_arrival_schedules AS AP');
	SET @sql_sel = CONCAT(@sql_sel, ' ON AH.id = AP.id');   
    
    IF p_sntcd IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN tmp_sntcd AS ST');
        SET @sql_sel = CONCAT(@sql_sel,' ON AH.sales_office_code = ST.JGSCD');
		SET @sql_sel = CONCAT(@sql_sel,' AND AH.warehouse_code = ST.SNTCD');        
	END IF;
    IF p_is_partner = 1 THEN
		SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN pyt_m_sp_conditions AS SP');
		SET @sql_sel = CONCAT(@sql_sel,' ON NN.NNSICD = SP.NNSICD');
		IF p_sntcd IS NOT NULL THEN
			SET @sql_sel = CONCAT(@sql_sel,' AND ST.JGSCD = SP.JGSCD');
			SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SNTCD IS NULL OR ST.SNTCD = SP.SNTCD)');
        ELSE
			SET @sql_sel = CONCAT(@sql_sel,' AND AH.sales_office_code = SP.JGSCD');
			SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SNTCD IS NULL OR AH.warehouse_code = SP.SNTCD)');
        END IF;
		SET @sql_sel = CONCAT(@sql_sel,' AND (SP.UNSKSCD IS NULL OR AH.transporter_code = SP.UNSKSCD)');		
		SET @sql_sel = CONCAT(@sql_sel,' AND SP.NKTISFRG = 1');        
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
    
    SET @sql_sel = CONCAT(@sql_sel,IFNULL(@sql_where,''));
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
END//

delimiter ;