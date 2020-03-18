DROP PROCEDURE IF EXISTS pyt_p_103_common_csv;
DELIMITER //

CREATE PROCEDURE pyt_p_103_common_csv(
	IN p_process_divide tinyint
,	IN p_selections text
,	IN p_user_id varchar(20)
,	IN p_target_date date
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		RESIGNAL;
    END;
    
    
    SET @sql_sel = 'SELECT';
    SET @sql_sel = CONCAT(@sql_sel, ' NULL AS \'データ区分名称\'');		
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.shipper_code AS \'荷主コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WK.NNSINM AS \'荷主名\'');
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
	SET @sql_sel = CONCAT(@sql_sel, ' , WK.PTNNM AS \'PT名称\'');
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
    -- SET @sql_sel = CONCAT(@sql_sel, ' , SH.package_count AS \'ケース数量\'');
    SET @sql_sel = CONCAT(@sql_sel, ' , (SH.total_fraction DIV SH.quantity_per_package) AS \'ケース数量\'');
    
	SET @sql_sel = CONCAT(@sql_sel, ' , (SH.package_count DIV SH.package_count_per_pallet) AS \'パレット枚数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (SH.package_count MOD SH.package_count_per_pallet) AS \'パレット端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.carton_count AS \'中間数量\'');
	-- SET @sql_sel = CONCAT(@sql_sel, ' , SH.fraction AS \'バラ数量\'');
    SET @sql_sel = CONCAT(@sql_sel, ' , (SH.total_fraction MOD SH.quantity_per_package) AS \'バラ数量\'');
    
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.total_fraction AS \'総バラ数量\'');
	-- SET @sql_sel = CONCAT(@sql_sel, ' , TRUNCATE(SH.shipping_weight+0.9, 0) AS \'総重量\'');
    SET @sql_sel = CONCAT(@sql_sel, ' , TRUNCATE(SH.shipping_weight, 1) AS \'総重量\'');
    
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.factory_direct AS \'工場直送フラグ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.delivery_remark AS \'備考\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SH.created_at,\'%Y%m%d\') AS \'ＤＢ取込時間（yyyymmdd）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SH.created_at,\'%Y\') AS \'ＤＢ取込時間（yyyy）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SH.created_at,\'%m\') AS \'ＤＢ取込時間（mm）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SH.created_at,\'%d\') AS \'ＤＢ取込時間（dd）\'');
    SET @sql_sel = CONCAT(@sql_sel, ' FROM pyt_w_103040_details AS WK');        
    SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN t_shipment AS SH');
    SET @sql_sel = CONCAT(@sql_sel, ' ON WK.id = SH.id');
    SET @sql_sel = CONCAT(@sql_sel,' WHERE WK.user_id = \'',p_user_id,'\'');
	SET @sql_sel = CONCAT(@sql_sel,' AND WK.process_divide = ',p_process_divide);
    IF p_target_date IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' AND WK.DENPYOYMD = \'',p_target_date,'\'');
    END IF;    
    IF p_selections IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' AND WK.work_id IN(',p_selections,')');
	END IF;
            
	SET @sql_sel = CONCAT(@sql_sel,' ORDER BY SH.shipper_code,SH.sales_office_code,SH.warehouse_code,SH.retrieval_date, SH.slip_number, SH.item_line');
        
	
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
    
END//
DELIMITER ;
