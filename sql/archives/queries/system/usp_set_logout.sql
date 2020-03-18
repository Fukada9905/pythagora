DROP PROCEDURE IF EXISTS usp_set_logout;
delimiter //

CREATE PROCEDURE usp_set_logout(
	IN p_user_id		varchar(20)
)
BEGIN
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        -- RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
	DELETE FROM sys_login_informations WHERE user_id = p_user_id;
	
    COMMIT;
END//

delimiter ;