DROP FUNCTION IF EXISTS ufn_get_user_agent;
delimiter //

CREATE FUNCTION ufn_get_user_agent(
	p_user_id		varchar(20)
)
RETURNS text DETERMINISTIC
BEGIN    

	DECLARE _user_agent text;
	   
	IF p_user_id IS NULL THEN    
		RETURN 'unknown';
    END IF;
    
	SELECT user_agent INTO _user_agent FROM sys_login_informations
    WHERE user_id = p_user_id;
    
    IF _user_agent IS NULL
    THEN
		SET _user_agent = "unknown";
    END IF;
    
    RETURN _user_agent;
						
END//
delimiter ;