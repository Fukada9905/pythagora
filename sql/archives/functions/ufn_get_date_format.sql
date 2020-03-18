DROP FUNCTION IF EXISTS ufn_get_date_format;
delimiter //

CREATE FUNCTION ufn_get_date_format(
	p_date		date
)
RETURNS varchar(10) DETERMINISTIC
BEGIN    
	IF p_date IS NULL THEN
		RETURN '';
	ELSE    
		RETURN DATE_FORMAT(p_date,'%Y/%m/%d');
	END IF;
						
END//
delimiter ;