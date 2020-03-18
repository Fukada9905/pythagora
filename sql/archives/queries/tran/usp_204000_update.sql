DROP PROCEDURE IF EXISTS usp_204000_update;
delimiter //

CREATE PROCEDURE usp_204000_update(
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
    
    SELECT user_name INTO _user_name FROM mtb_users WHERE user_id = p_user_id;
    
    
    UPDATE arrival_schedule_details AS AD
    INNER JOIN wk_204000_details AS WK
		ON AD.ID = WK.ID
        AND AD.DENGNO = WK.DENGNO
        AND AD.NIBKNRDENGNO = WK.NIBKNRDENGNO
        AND AD.SHCD = WK.SHCD
        AND AD.JGSCD_SK = WK.JGSCD_SK
        AND AD.SNTCD_SK = WK.SNTCD_SK
        AND AD.RTNO = WK.RTNO
        AND AD.LOTK = WK.LOTK
        AND AD.LOTS = WK.LOTS
        AND AD.FCKBNKK = WK.FCKBNKK
	LEFT JOIN mtb_users AS US
		ON p_user_id
	SET AD.Status = 2
	,	AD.Registrant = _user_name
    ,	AD.Registdatetime = CURRENT_TIMESTAMP()
    WHERE WK.work_id = p_work_id;
    
        
    COMMIT;
        
    
END//

delimiter ;