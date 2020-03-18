DROP FUNCTION IF EXISTS ufn_get_ip;
delimiter //

CREATE FUNCTION ufn_get_ip(
	p_user_id		varchar(20)
)
RETURNS varchar(15) DETERMINISTIC
BEGIN    

	DECLARE _ip varchar(15);
    
    IF p_user_id IS NULL THEN    
		RETURN '127.0.0.1';
    END IF;
	       
	SELECT remote_ip INTO _ip FROM sys_login_informations
    WHERE user_id = p_user_id;
    
    IF _ip IS NULL
    THEN
		SET _ip = "127.0.0.1";
    END IF;
    
    RETURN _ip;
						
END//
delimiter ;