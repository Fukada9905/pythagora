DROP PROCEDURE IF EXISTS pyt_p_301000_cancel;
delimiter //

CREATE PROCEDURE pyt_p_301000_cancel(
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
    
    DELETE LS FROM pyt_t_location_stocks AS LS
    INNER JOIN pyt_w_301000_head AS WK
		ON LS.NNSICD = WK.NNSICD
        AND LS.JGSCD = WK.JGSCD
        AND LS.SNTCD = WK.SNTCD
        AND LS.PYTStocktakingDate = WK.PYTStocktakingDate
	WHERE WK.work_id = p_work_id
    AND WK.user_id = p_user_id;
    
        
    COMMIT;
        
    
END//

delimiter ;