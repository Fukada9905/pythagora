DROP PROCEDURE IF EXISTS usp_999910_update;
delimiter //

CREATE PROCEDURE usp_999910_update(
	IN p_user_id	varchar(20)
)
BEGIN

	
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
        
    DELETE FROM sys_login_informations WHERE user_id = p_user_id;
    COMMIT;
        
    
END//

delimiter ;