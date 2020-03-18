DROP FUNCTION IF EXISTS pyt_ufn_get_shipment_KHKBN;
delimiter //

CREATE FUNCTION pyt_ufn_get_shipment_KHKBN(
	p_package_count		int
,	p_carton_count		int
,	p_fraction			int    
)
RETURNS tinyint DETERMINISTIC
BEGIN   

	IF IFNULL(p_package_count,0)>0 THEN
		RETURN 0;
    END IF;
    
    IF IFNULL(p_carton_count,0)>0 THEN
		RETURN 2;
    END IF;
    
    IF IFNULL(p_fraction,0)>0 THEN
		RETURN 1;
    END IF;
    
    RETURN 0;
						
END//
delimiter ;