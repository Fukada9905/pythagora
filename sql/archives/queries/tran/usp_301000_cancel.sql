DROP PROCEDURE IF EXISTS usp_301000_cancel;
delimiter //

CREATE PROCEDURE usp_301000_cancel(
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
    
    DELETE LS FROM location_stocks AS LS
    INNER JOIN wk_301000_details AS WK
		ON LS.DET_ID = WK.DET_ID        
	WHERE WK.work_id = p_work_id
    AND LS.TRNJ IS NULL;
    
    
    UPDATE location_stocks AS LS
    INNER JOIN wk_301000_details AS WK
		ON LS.DET_ID = WK.DET_ID        
	SET LS.JitsuBara = null
    ,	LS.JitsuCase = null
    ,	LS.ReportComment = null
    ,	LS.Reporter = null
    ,	LS.ReportCorpName = null
    ,	LS.ReportDatetime = null
    ,	LS.Status = null
    WHERE WK.work_id = p_work_id;
    
        
    COMMIT;
        
    
END//

delimiter ;