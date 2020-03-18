DROP PROCEDURE IF EXISTS usp_delete_login_information;
delimiter //

CREATE PROCEDURE usp_delete_login_information()
BEGIN
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;        
    END;    
    
    -- トランザクション開始
    START TRANSACTION;
    
    DELETE FROM sys_login_informations WHERE update_datetime < CURRENT_TIMESTAMP - INTERVAL 1 HOUR;       
    
    COMMIT;
END//

delimiter ;