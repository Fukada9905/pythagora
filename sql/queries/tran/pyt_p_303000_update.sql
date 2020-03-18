DROP PROCEDURE IF EXISTS pyt_p_303000_update;
delimiter //

CREATE PROCEDURE pyt_p_303000_update(
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
    
    
    UPDATE pyt_t_location_stocks AS LS
    INNER JOIN pyt_w_303000_head AS WK
		ON LS.NNSICD = WK.NNSICD
		AND LS.JGSCD = WK.JGSCD
		AND LS.SNTCD = WK.SNTCD
		AND LS.PYTStocktakingDate = WK.PYTStocktakingDate   
	SET LS.AuthorizerID = p_user_id
    ,	LS.AuthorizerDatetime = current_timestamp()
    ,	LS.Status = 3
    WHERE WK.work_id = p_work_id
    AND WK.user_id = p_user_id;
    
	    
        
    COMMIT;
        
    
END//

delimiter ;