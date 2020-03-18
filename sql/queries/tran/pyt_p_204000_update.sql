DROP PROCEDURE IF EXISTS pyt_p_204000_update;
delimiter //

CREATE PROCEDURE pyt_p_204000_update(
	IN p_work_id	int
,	IN p_user_id	varchar(20)
)
BEGIN

	DECLARE _user_name varchar(20);
    
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    SELECT user_name INTO _user_name FROM pyt_m_users WHERE user_id = p_user_id;
    
    
    UPDATE pyt_t_arrival_schedules AS AP
    INNER JOIN pyt_w_204000_details AS WK
		ON AP.id = WK.work_detail_id        
	LEFT JOIN pyt_m_users AS US
		ON p_user_id
	SET AP.Status = 2
	,	AP.Registrant = _user_name
    ,	AP.Registdatetime = CURRENT_TIMESTAMP()
    WHERE WK.work_id = p_work_id;
    
        
    COMMIT;
        
    
END//

delimiter ;