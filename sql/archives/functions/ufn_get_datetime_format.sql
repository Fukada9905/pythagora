DROP FUNCTION IF EXISTS ufn_get_datetime_format;
delimiter //

CREATE FUNCTION ufn_get_datetime_format(
	p_date		datetime
)
RETURNS varchar(19) DETERMINISTIC
BEGIN    

	IF p_date IS NULL THEN
		RETURN '';
	ELSE    
		RETURN DATE_FORMAT(p_date,'%Y/%m/%d %H:%i:%S');
	END IF;
						
END//
delimiter ;