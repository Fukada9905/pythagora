DROP PROCEDURE IF EXISTS pyt_p_203000_update;
delimiter //

CREATE PROCEDURE pyt_p_203000_update(
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
		work_detail_id	bigint
	,	JitsuCase		int
    ,	JitsuBara		int
    ,	Comment			varchar(255)
    );
    
    SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',IFNULL(p_update_row,'(null,null,null,null)'));    
	PREPARE stmt from @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;    	
    
    
    INSERT INTO pyt_t_arrival_schedules(
		id
    ,	JitsuCase
    ,	JitsuBara
    ,	Comment
    ,	Reporter
    ,	ReportDatetime
    ,	Status
    )
    SELECT
		WK.work_detail_id
	,	TP.JitsuCase
    ,	TP.JitsuBara    
    ,	TP.Comment
    ,	p_Reporter
    ,	current_timestamp()
    ,	1
    FROM pyt_w_203000_details AS WK
    INNER JOIN tmp_insert AS TP
		ON WK.work_detail_id = TP.work_detail_id
	ON DUPLICATE KEY UPDATE
		JitsuCase = VALUES(JitsuCase)
    ,	JitsuBara = VALUES(JitsuBara)
    ,	Comment = VALUES(Comment)
    ,	Reporter = VALUES(Reporter)
    ,	ReportDatetime = VALUES(ReportDatetime)
    ,	Status = VALUES(Status);
	
        
    COMMIT;
        
    
END//

delimiter ;