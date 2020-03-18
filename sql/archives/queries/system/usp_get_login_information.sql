DROP PROCEDURE IF EXISTS usp_get_login_information;
delimiter //

CREATE PROCEDURE usp_get_login_information(
	IN p_user_id	varchar(20)
,   IN p_ticket		varchar(50)
	
)
BEGIN
	SELECT
		*
	FROM sys_login_informations
	WHERE user_id = p_user_id
    AND ticket != p_ticket;
	
END//

delimiter ;