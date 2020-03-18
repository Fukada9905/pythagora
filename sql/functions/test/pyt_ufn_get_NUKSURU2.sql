DROP FUNCTION IF EXISTS pyt_ufn_get_NUKSURU2;
delimiter //

CREATE FUNCTION pyt_ufn_get_NUKSURU2(
	p_getDivide						tinyint
,	p_package_count					int
,	p_flaction						int
,	p_previous_accounting_stock		int
,	p_shipment_stock_quantity		int
,	p_received_stock_quantity		int
,	p_quantity_per_package			int
,	p_shipping_package_count		int
,	p_shipping_fraction				int
)
RETURNS int DETERMINISTIC
BEGIN 

	SET @CaseDivide = pyt_ufn_get_is_case_stocks(p_package_count,p_flaction,p_previous_accounting_stock,p_shipment_stock_quantity,p_received_stock_quantity,p_quantity_per_package,p_shipping_package_count,p_shipping_fraction);
    IF @CaseDivide IS NULL THEN 
		RETURN 0; 
	END IF;

	IF p_getDivide = 1 THEN
		IF @CaseDivide= 1 THEN
			IF IFNULL(p_quantity_per_package,0) = 0 THEN
				RETURN 0;
			END IF;
			RETURN TRUNCATE(IFNULL(p_received_stock_quantity,0) / IFNULL(p_quantity_per_package,0),0);
        ELSE
			RETURN 0;
        END IF;
	ELSE
		IF @CaseDivide= 1 THEN
			RETURN 0;
		ELSE
			RETURN IFNULL(p_received_stock_quantity,0);
        END IF;
	END IF;
		
	
						
END//
delimiter ;