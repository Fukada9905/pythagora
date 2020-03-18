DROP PROCEDURE IF EXISTS usp_303000_cancel;
delimiter //

CREATE PROCEDURE usp_303000_cancel(
	IN p_work_id	int
,	IN p_Comment	varchar(255)    
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
    ,	LS.AuthorizerDatetime = null
    ,	LS.ReviewDatetime = null
    ,	LS.ReviewerID = null
    ,	LS.AuthorizerComment = p_Comment
    ,	LS.Status = 1
    WHERE WK.work_id = p_work_id;
    
	    
        
    COMMIT;
        
    
END//

delimiter ;