DROP FUNCTION IF EXISTS pyt_ufn_get_PYTpicking;
delimiter //

CREATE FUNCTION pyt_ufn_get_PYTpicking(
	p_getDivide						tinyint
,	p_package_count					int
,	p_shipping_package_count		int
,	p_shipping_fraction				int
)
RETURNS int DETERMINISTIC
BEGIN 
	IF p_getDivide = 1 THEN
		IF IFNULL(p_package_count,0) != 0 THEN
			RETURN IFNULL(p_shipping_package_count,0);
        ELSE
			RETURN 0;
        END IF;
	ELSE
		IF IFNULL(p_package_count,0) != 0 THEN
			RETURN 0;
		ELSE
			RETURN IFNULL(p_shipping_fraction,0);
        END IF;
	END IF;		
						
END//
delimiter ;