DROP FUNCTION IF EXISTS pyt_ufn_get_is_case_stocks;
delimiter //

CREATE FUNCTION pyt_ufn_get_is_case_stocks(
	p_package_count					int
,	p_flaction						int
,	p_previous_accounting_stock		int
,	p_shipment_stock_quantity		int
,	p_received_stock_quantity		int
,	p_quantity_per_package			int
,	p_shipping_package_count		int
,	p_shipping_fraction				int
)
RETURNS tinyint DETERMINISTIC
BEGIN   

	-- ケース数量が0でない場合
	IF p_package_count <> 0 THEN
		RETURN 1;	-- ケース
    END IF;
    
    -- バラ数量が0でない場合
    IF p_flaction <> 0 THEN
		RETURN 0;	-- バラ
	END IF;
    
    -- 前日在庫数(総バラ)が0でない場合
    IF IFNULL(p_previous_accounting_stock,0) - IFNULL(p_shipment_stock_quantity,0) <> 0 THEN
		-- 前日在庫(総バラ)が入数で割り切れる場合
		IF (IFNULL(p_previous_accounting_stock,0) - IFNULL(p_shipment_stock_quantity,0)) MOD IFNULL(p_quantity_per_package,0) = 0 THEN
			RETURN 1;	-- ケース
		ELSE
			RETURN 0;	-- バラ
		END IF;
	END IF;
    
    -- 入庫数(総バラ)が0でない場合
    IF IFNULL(p_received_stock_quantity,0) <> 0 THEN
		-- 入庫数(総バラ)が入数で割り切れる場合
		IF IFNULL(p_received_stock_quantity,0) MOD IFNULL(p_quantity_per_package,0) = 0 THEN
			RETURN 1;	-- ケース
        ELSE
			RETURN 0;	-- バラ
        END IF;
    END IF;
    
    -- 出庫ケース数が0でない場合
    IF IFNULL(p_shipping_package_count,0) <> 0 THEN
		RETURN 1;	-- ケース
    END IF;
    
    -- 出庫バラ数が0でない場合
    IF IFNULL(p_shipping_fraction,0) <> 0 THEN
		RETURN 0;	-- バラ
    END IF;
    
    RETURN NULL;	-- 数量0扱い

END//
delimiter ;