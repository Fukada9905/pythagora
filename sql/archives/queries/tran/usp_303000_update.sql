DROP PROCEDURE IF EXISTS usp_303000_update;
delimiter //

CREATE PROCEDURE usp_303000_update(
	IN p_work_id	int
,	IN p_user_id	varchar(20)
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
    
    
    UPDATE location_stocks AS LS
    INNER JOIN wk_303000_details AS WK
		ON LS.DET_ID = WK.DET_ID        
	SET LS.AuthorizerID = p_user_id
    ,	LS.AuthorizerDatetime = current_timestamp()
    ,	LS.Status = 3
    WHERE WK.work_id = p_work_id;
    
	    
        
    COMMIT;
        
    
END//

delimiter ;