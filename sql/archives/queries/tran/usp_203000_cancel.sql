DROP PROCEDURE IF EXISTS usp_203000_cancel;
delimiter //

CREATE PROCEDURE usp_203000_cancel(
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
    
    UPDATE arrival_schedule_details AS AD
    INNER JOIN wk_203000_details AS WK
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
	SET AD.JitsuBara = null
    ,	AD.JitsuCase = null
    ,	AD.Comment = null
    ,	AD.Reporter = null
    ,	AD.ReportDatetime = null
    ,	AD.Status = null
    WHERE WK.work_id = p_work_id;
    
        
    COMMIT;
        
    
END//

delimiter ;