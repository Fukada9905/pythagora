DROP FUNCTION IF EXISTS pyt_ufn_get_ZNJTZIKSURU;
delimiter //

CREATE FUNCTION pyt_ufn_get_ZNJTZIKSURU(
	p_getDivide						tinyint
,	p_package_count					int
,	p_previous_accounting_stock		int
,	p_quantity_per_package			int
)
RETURNS int DETERMINISTIC
BEGIN   
	IF p_getDivide = 1 THEN
		IF IFNULL(p_package_count,0) != 0 THEN
			IF IFNULL(p_quantity_per_package,0) = 0 THEN
				return 0;
			END IF;
			RETURN IFNULL(p_previous_accounting_stock,0) DIV p_quantity_per_package;    
		ELSE
			RETURN 0;
		END IF;
    ELSE
		IF IFNULL(p_package_count,0) != 0 THEN
			RETURN 0;
		ELSE
			RETURN IFNULL(p_previous_accounting_stock,0);
		END IF;
    END IF;
	

END//
delimiter ;