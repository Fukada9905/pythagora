DROP FUNCTION IF EXISTS ufn_get_user_name;
delimiter //

CREATE FUNCTION ufn_get_user_name(
	p_user_id		varchar(20)
)
RETURNS nvarchar(40) DETERMINISTIC
BEGIN    

	DECLARE _user_name nvarchar(40);
	   
	IF p_user_id IS NULL THEN    
		RETURN USER();
    END IF;
    
	SELECT user_name INTO _user_name FROM mtb_users
    WHERE user_id = p_user_id;
    
    IF _user_name IS NULL
    THEN
		SET _user_name = USER();
    END IF;
    
    RETURN _user_name;
						
END//
delimiter ;