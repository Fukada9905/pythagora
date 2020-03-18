DROP FUNCTION IF EXISTS pyt_ufn_get_NUKSURU;
delimiter //

CREATE FUNCTION pyt_ufn_get_NUKSURU(
	p_getDivide						tinyint
,	p_package_count					int
,	p_received_stock_quantity		int
,	p_quantity_per_package			int
)
RETURNS int DETERMINISTIC
BEGIN 


	IF p_getDivide = 1 THEN
		IF IFNULL(p_package_count,0) != 0 THEN
			IF IFNULL(p_quantity_per_package,0) = 0 THEN
				RETURN 0;
			END IF;
			RETURN TRUNCATE(IFNULL(p_received_stock_quantity,0) / IFNULL(p_quantity_per_package,0),0);
        ELSE
			RETURN 0;
        END IF;
	ELSE
		IF IFNULL(p_package_count,0) != 0 THEN
			RETURN 0;
		ELSE
			RETURN IFNULL(p_received_stock_quantity,0);
        END IF;
	END IF;
		
	
						
END//
delimiter ;