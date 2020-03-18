DROP FUNCTION IF EXISTS pyt_ufn_get_PYTstocks;
delimiter //

CREATE FUNCTION pyt_ufn_get_PYTstocks(
	p_getDivide						tinyint
,	p_package_count					int
,	p_previous_accounting_stock		int
,	p_shipment_stock_quantity		int
,	p_received_stock_quantity		int
,	p_quantity_per_package			int
,	p_shipping_package_count		int
,	p_shipping_fraction				int
)
RETURNS int DETERMINISTIC
BEGIN  	
    RETURN	pyt_ufn_get_PYTexStocks(p_getDivide,p_package_count,p_previous_accounting_stock,p_shipment_stock_quantity,p_quantity_per_package) +  
			pyt_ufn_get_NUKSURU(p_getDivide,p_package_count,p_received_stock_quantity,p_quantity_per_package) - 
			pyt_ufn_get_PYTpicking(p_getDivide,p_package_count,p_shipping_package_count,p_shipping_fraction);    
END//
delimiter ;