DROP PROCEDURE IF EXISTS usp_203000_update;
delimiter //

CREATE PROCEDURE usp_203000_update(
	IN p_update_row	text
,	IN p_Reporter 	varchar(20)
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
    
    CREATE TEMPORARY TABLE tmp_insert(
		work_detail_id	int
	,	JitsuCase		int
    ,	JitsuBara		int
    ,	Comment			varchar(255)
    );
    
    SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',IFNULL(p_update_row,'(null,null,null,null)'));    
	PREPARE stmt from @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;    	
    
    
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
	INNER JOIN tmp_insert AS TP
		ON WK.work_detail_id = TP.work_detail_id
	SET AD.JitsuBara = TP.JitsuBara
    ,	AD.JitsuCase = TP.JitsuCase
    ,	AD.Comment = TP.Comment
    ,	AD.Reporter = p_Reporter
    ,	AD.ReportDatetime = current_timestamp()
    ,	AD.Status = 1;
    
        
    COMMIT;
        
    
END//

delimiter ;