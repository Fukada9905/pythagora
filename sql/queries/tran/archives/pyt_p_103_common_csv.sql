DROP PROCEDURE IF EXISTS pyt_p_103_common_csv;
DELIMITER //
CREATE PROCEDURE pyt_p_103_common_csv(
	IN p_is_partner tinyint
,	IN p_target_date date
,	IN p_jgscd text
,	IN p_management_cd varchar(10)
)
BEGIN
    
    SELECT GROUP_CONCAT(CONCAT('\'',NNSICD,'\'')) INTO @nnsicd FROM pyt_m_ninushi;
    
    SET @sql_sel = 'SELECT';
    SET @sql_sel = CONCAT(@sql_sel, ' NULL AS \'データ区分名称\'');		
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.shipper_code AS \'荷主コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , NN.NNSINM AS \'荷主名\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.sales_office_code AS \'事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.sales_office_name AS \'事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.shipper_order_number AS \'受注伝票番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.slip_number AS \'伝票番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.item_line AS \'伝票行番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.shipping_location_code AS \'出荷場所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.control_type AS \'管理区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.shipment_type AS \'出荷区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.factory_type AS \'工場コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.warehouse_code AS \'センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.warehouse_name AS \'センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , CASE WHEN PN.PTNCD IS NULL THEN \'なし\' ELSE CONCAT(IFNULL(PN.PTNCDNM1,\'\'),IFNULL(PN.PTNCDNM2,\'\')) END AS \'PT名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.transporter_code AS \'運送会社コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.transporter_name AS \'運送会社名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.shipper_trading_code AS \'ＩＤ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.shipper_trading_name AS \'ＩＤ名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.wms_processing_date AS \'処理日時\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.retrieval_date AS \'出荷日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.delivery_date AS \'納品日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.warehouse_accounting_date AS \'伝票日付\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.delivery_code AS \'納品先コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , CONCAT(IFNULL(SH.receiver_name1,\'\'), IFNULL(SH.receiver_name2,\'\'), IFNULL(SH.receiver_name3,\'\')) AS \'納品先名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , CONCAT(IFNULL(SH.receiver_address1,\'\'), IFNULL(SH.receiver_address2,\'\'), IFNULL(SH.receiver_address3,\'\')) AS \'納品先住所\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.receiver_tel AS \'納品先電話番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.receiver_area_code AS \'地区コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.product_code AS \'商品コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.denryaku AS \'電略\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.product_name AS \'製品名称\'');    
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.package_capasity AS \'規格\'');	
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.billing_type AS \'請求区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.lot AS \'ロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.quantity_per_package AS \'ケース入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.quantity_per_carton AS \'中間入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.unit_type AS \'梱端区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.package_count_per_pallet AS \'パレット積付数\'');
    SET @sql_sel = CONCAT(@sql_sel, ' , SH.package_count AS \'ケース数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (SH.package_count DIV SH.package_count_per_pallet) AS \'パレット枚数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (SH.package_count MOD SH.package_count_per_pallet) AS \'パレット端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.carton_count AS \'中間数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.fraction AS \'バラ数量\'');    
    /*
	SET @sql_sel = CONCAT(@sql_sel, ' , pyt_ufn_get_KKTSR(SH.order_package_count,SH.total_fraction,SH.quantity_per_package) AS \'ケース数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (pyt_ufn_get_KKTSR(SH.order_package_count,SH.total_fraction,SH.quantity_per_package) DIV SH.package_count_per_pallet) AS \'パレット枚数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (pyt_ufn_get_KKTSR(SH.order_package_count,SH.total_fraction,SH.quantity_per_package) MOD SH.package_count_per_pallet) AS \'パレット端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , pyt_ufn_get_KKTSR(SH.order_carton_count,SH.total_fraction,SH.quantity_per_carton) AS \'中間数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , CASE WHEN (SH.order_fraction <> 0) THEN SH.total_fraction ELSE 0 END AS \'バラ数量\'');
	*/
    SET @sql_sel = CONCAT(@sql_sel, ' , SH.total_fraction AS \'総バラ数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , TRUNCATE(SH.shipping_weight+0.9, 0) AS \'総重量\'');
    SET @sql_sel = CONCAT(@sql_sel, ' , SH.factory_direct AS \'工場直送フラグ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.delivery_remark AS \'備考\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SH.created_at,\'%Y%m%d\') AS \'ＤＢ取込時間（yyyymmdd）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SH.created_at,\'%Y\') AS \'ＤＢ取込時間（yyyy）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SH.created_at,\'%m\') AS \'ＤＢ取込時間（mm）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SH.created_at,\'%d\') AS \'ＤＢ取込時間（dd）\'');
    SET @sql_sel = CONCAT(@sql_sel, ' FROM t_shipment AS SH');
    SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN pyt_m_ninushi AS NN ON SH.shipper_code = NN.NNSICD');
    SET @sql_sel = CONCAT(@sql_sel,' LEFT JOIN pyt_m_sp_conditions AS SP');
	SET @sql_sel = CONCAT(@sql_sel,' ON SH.shipper_code = SP.NNSICD');
	SET @sql_sel = CONCAT(@sql_sel,' AND SH.sales_office_code = SP.JGSCD');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SNTCD IS NULL OR SH.warehouse_code = SP.SNTCD)');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.UNSKSCD IS NULL OR SH.transporter_code = SP.UNSKSCD)');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SYUKAP IS NULL OR SH.shipping_location_code = SP.SYUKAP)');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SEKKBN IS NULL OR SH.billing_type = SP.SEKKBN)');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.NHNSKCD IS NULL OR SH.delivery_code = SP.NHNSKCD)');
	SET @sql_sel = CONCAT(@sql_sel,' AND SP.SKTISFRG = 1');		
    SET @sql_sel = CONCAT(@sql_sel,' LEFT JOIN pyt_m_partners AS PN');
	SET @sql_sel = CONCAT(@sql_sel,' ON SP.PTNCD = PN.PTNCD');
    
    
    SET @sql_where = CONCAT(' WHERE SH.shipper_code IN(',@nnsicd,') AND SH.shipper_trading_short_name = \'A2\'');    
    
    IF p_target_date IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND SH.warehouse_accounting_date = \'',p_target_date,'\'');		
	END IF;
	
    
    IF p_jgscd IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND SH.sales_office_code IN(',p_jgscd,')');				
	END IF;
    
	IF p_is_partner = 1 THEN
		SET @sql_where = CONCAT(@sql_where,' AND PN.PTNCD = \'',p_management_cd,'\'');		
	END IF;
            
	SET @sql_sel = CONCAT(@sql_sel,@sql_where,' ORDER BY SH.warehouse_accounting_date, SH.sales_office_code, SH.warehouse_code, SH.slip_number, SH.item_line');
    
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
END//
DELIMITER ;
