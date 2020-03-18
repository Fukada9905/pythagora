DROP FUNCTION IF EXISTS pyt_ufn_get_DKBN;
delimiter //

CREATE FUNCTION pyt_ufn_get_DKBN(
	p_order_data_type		varchar(10)
)
RETURNS varchar(2) DETERMINISTIC
BEGIN   

	IF p_order_data_type IS NULL OR p_order_data_type = '' THEN
		RETURN '';
    END IF;

	RETURN CASE WHEN p_order_data_type IN('126','252','253','254','255') THEN 'AM' ELSE 'PM' END;
						
END//
delimiter ;