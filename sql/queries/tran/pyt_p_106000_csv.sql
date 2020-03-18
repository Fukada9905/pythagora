DROP PROCEDURE IF EXISTS pyt_p_106000_csv;
delimiter //

CREATE PROCEDURE pyt_p_106000_csv(
	IN p_process_divide tinyint
,	IN p_ids text
,	IN p_user_id varchar(10)
)
BEGIN
	
    IF p_ids IS NOT NULL THEN
		SET @sql_where = CONCAT(' WHERE WD.work_id IN(',p_ids,')');
        SET @sql_where = CONCAT(@sql_where,' AND WD.user_id = \'',p_user_id,'\'');
		SET @sql_where = CONCAT(@sql_where,' AND WD.process_divide = ',p_process_divide);
	ELSE
		SET @sql_where = CONCAT(' WHERE WD.user_id = \'',p_user_id,'\'');
		SET @sql_where = CONCAT(@sql_where,' AND WD.process_divide = ',p_process_divide);
	END IF;


	SET @sql_sel = 'SELECT';
	SET @sql_sel = CONCAT(@sql_sel, ' \'\' AS \'SP業者CD\'');
	SET @sql_sel = CONCAT(@sql_sel, ', \'SK\' AS \'データ区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', 0 AS \'エントリー区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', \'\' AS \'シフト区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.shipper_code AS \'販売荷主\'');
	SET @sql_sel = CONCAT(@sql_sel, ', DATE_FORMAT(WD.shipper_accounting_date,\'%Y%m%d\') AS \'荷主会計日付\'');
	SET @sql_sel = CONCAT(@sql_sel, ', DATE_FORMAT(WD.warehouse_accounting_date,\'%Y%m%d\') AS \'倉庫会計日付\'');
	SET @sql_sel = CONCAT(@sql_sel, ', DATE_FORMAT(WD.delivery_date,\'%Y%m%d\') AS \'納品日\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.slip_number AS \'伝票番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ', \'\' AS \'伝票作成区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.shipper_trading_code AS \'荷主取引区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.shipper_trading_name AS \'荷主取引名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.shipper_trading_short_name AS \'倉庫取引区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.shipper_trading_name AS \'倉庫取引名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.sales_office_code AS \'倉庫営業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.sales_office_name AS \'倉庫営業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ', CONCAT(IFNULL(WD.sales_office_code,\'\'),IFNULL(WD.transporter_code,\'\')) AS \'業者コード１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.transporter_name AS \'業者名１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', \'\' AS \'共配ＣＤ\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.pken_code AS \'Ｐケンコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.detail_order_number AS \'発注ＮＯ．１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.slip_remarks1 AS \'備考１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.arrival_time AS \'着荷時間\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.branch_office_code AS \'支店コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.local_office_code AS \'出張所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ', \'\' AS \'打ち変えフラグ\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_code AS \'直送先CD\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.delivery_code AS \'納品先ＣＤ\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_name1 AS \'納品先名称１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_name2 AS \'納品先名称２\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_name3 AS \'納品先名称３\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_area_code AS \'地区コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_address1 AS \'納品先住所１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_address2 AS \'納品先住所２\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_address3 AS \'納品先住所３\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.receiver_tel AS \'納品先ＴＥＬ\'');
	SET @sql_sel = CONCAT(@sql_sel, ', \'\' AS \'コンビニフラグ\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.priority_flag AS \'優先フラグ１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.item_line AS \'明細行\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.item_line_column AS \'明細行列\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.logistics_code AS \'物流コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.outer_product_code AS \'荷主商品コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.denryaku AS \'電略\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.product_name AS \'商品名\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.capacity AS \'規格(ｶﾅ)\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.unit_type AS \'梱/端数区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', CASE WD.unit_type 	WHEN \'0\' THEN IFNULL(WD.order_package_count,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' WHEN \'1\' THEN IFNULL(WD.order_fraction,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' WHEN \'2\' THEN IFNULL(WD.order_carton_count,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' END AS \'数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ',CASE WD.unit_type 	WHEN \'0\' THEN IFNULL(WD.order_package_count,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' WHEN \'1\' THEN IFNULL(WD.order_fraction,0) DIV IFNULL(WD.quantity_per_package,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' WHEN \'2\' THEN (IFNULL(WD.order_carton_count,0) * IFNULL(WD.quantity_per_carton,0)) DIV IFNULL(WD.quantity_per_package,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' END AS \'梱数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.order_total_fraction AS \'端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.detail_order_number AS \'発注NO.１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.warehouse_code AS \'倉庫コード１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.warehouse_name AS \'倉庫名称１\'');
	SET @sql_sel = CONCAT(@sql_sel, ', CASE WD.unit_type 	WHEN \'0\' THEN IFNULL(WD.package_count,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' WHEN \'1\' THEN IFNULL(WD.total_fraction,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' WHEN \'2\' THEN IFNULL(WD.total_fraction,0) DIV IFNULL(WD.quantity_per_carton,0)');
	SET @sql_sel = CONCAT(@sql_sel, ' END AS \'ロット数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.lot AS \'ロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.sub_lot AS \'サブロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.line_lot AS \'ラインロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.campaign_flag AS \'キャンペーンフラグ\'');
	SET @sql_sel = CONCAT(@sql_sel, ', \'\' AS \'生産プラント\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.factory_type AS \'工場記号\'');
	SET @sql_sel = CONCAT(@sql_sel, ', \'\' AS \'工場略号\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.control_type AS \'管理区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.shipment_type AS \'出荷区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.quantity_per_package AS \'入目１(ケースの中のバラ数)\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.quantity_per_fraction AS \'入目２(バラ)\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.quantity_per_carton AS \'入目３(中間の中のバラ数)\'');
	SET @sql_sel = CONCAT(@sql_sel, ', 0 AS \'実入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.billing_type AS \'請求区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.cooling_type AS \'保冷区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.length AS \'縦\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.width AS \'横\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.height AS \'高さ\'');
	SET @sql_sel = CONCAT(@sql_sel, ', TRUNCATE(WD.package_weight,1) AS \'梱重量(ケース重量)\'');
	SET @sql_sel = CONCAT(@sql_sel, ', TRUNCATE(WD.shipping_weight,1) AS \'明細重量(ロット単位の明細重量)kg\'');
	SET @sql_sel = CONCAT(@sql_sel, ', 0 AS \'運賃重量(ケースあたり重量)g\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WD.shipping_location_code AS \'出荷場所コード1\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WG1.package_count AS \'伝票合計数量梱\'');
	SET @sql_sel = CONCAT(@sql_sel, ', TRUNCATE(WG1.shipping_weight,1) AS \'伝票合計重量\'');
	SET @sql_sel = CONCAT(@sql_sel, ', WG2.package_count AS \'納品合計梱数\'');
	SET @sql_sel = CONCAT(@sql_sel, ', TRUNCATE(WG2.shipping_weight,1) AS \'納品合計重量\'');	
    SET @sql_sel = CONCAT(@sql_sel, ', TRUNCATE(WG2.shipping_weight,1) AS \'納品合計重量\'');	
    SET @sql_sel = CONCAT(@sql_sel, ' FROM pyt_w_106000_details AS WD');
    SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN(');
    SET @sql_sel = CONCAT(@sql_sel, ' SELECT WD.delivery_date, WD.delivery_code, WD.slip_number, SUM(WD.package_count) AS package_count, SUM(TRUNCATE(WD.shipping_weight,1)) AS shipping_weight FROM pyt_w_106000_details AS WD');
    SET @sql_sel = CONCAT(@sql_sel, @sql_where);
    SET @sql_sel = CONCAT(@sql_sel, ' GROUP BY WD.delivery_date, WD.delivery_code, WD.slip_number');    
    SET @sql_sel = CONCAT(@sql_sel, ' ) AS WG1');
    SET @sql_sel = CONCAT(@sql_sel, ' ON WD.delivery_date = WG1.delivery_date');
    SET @sql_sel = CONCAT(@sql_sel, ' AND WD.delivery_code = WG1.delivery_code');
    SET @sql_sel = CONCAT(@sql_sel, ' AND WD.slip_number = WG1.slip_number');
    SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN(');
    SET @sql_sel = CONCAT(@sql_sel, ' SELECT WD.delivery_date, WD.delivery_code, SUM(WD.package_count) AS package_count, SUM(TRUNCATE(WD.shipping_weight,1)) AS shipping_weight FROM pyt_w_106000_details AS WD');
    SET @sql_sel = CONCAT(@sql_sel, @sql_where);
    SET @sql_sel = CONCAT(@sql_sel, ' GROUP BY WD.delivery_date, WD.delivery_code');
    SET @sql_sel = CONCAT(@sql_sel, ' ) AS WG2');
    SET @sql_sel = CONCAT(@sql_sel, ' ON WD.delivery_date = WG2.delivery_date');
    SET @sql_sel = CONCAT(@sql_sel, ' AND WD.delivery_code = WG2.delivery_code');    
	SET @sql_sel = CONCAT(@sql_sel, @sql_where);

	    
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;
    
    
END//

delimiter ;