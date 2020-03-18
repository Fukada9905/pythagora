DROP PROCEDURE IF EXISTS pyt_p_203000_cancel;
delimiter //

CREATE PROCEDURE pyt_p_203000_cancel(
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
    
    UPDATE pyt_t_arrival_schedules AS PA
    INNER JOIN pyt_w_203000_details AS WK
		ON PA.id = WK.work_detail_id
	SET PA.JitsuBara = null
    ,	PA.JitsuCase = null
    ,	PA.Comment = null
    ,	PA.Reporter = null
    ,	PA.ReportDatetime = null
    ,	PA.Status = null
    WHERE WK.work_id = p_work_id;
    
        
    COMMIT;
        
    
END//

delimiter ;