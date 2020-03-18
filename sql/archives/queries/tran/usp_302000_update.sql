DROP PROCEDURE IF EXISTS usp_302000_update;
delimiter //

CREATE PROCEDURE usp_302000_update(
	IN p_work_id	int
,	IN p_update_row	text    
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
    
    CREATE TEMPORARY TABLE tmp_insert(
		work_detail_id	int
	,	Comment			varchar(255)    
    );
    IF p_update_row IS NOT NULL THEN
		SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',IFNULL(p_update_row,'(null,null)'));    
		PREPARE stmt from @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
    END IF;
    
	
	IF EXISTS(SELECT * FROM tmp_insert) THEN
		UPDATE location_stocks AS LS
        INNER JOIN wk_302000_details AS WK
			ON LS.DET_ID = WK.DET_ID        
		INNER JOIN tmp_insert AS TP
			ON WK.work_detail_id = TP.work_detail_id
		SET LS.ReviewComment = TP.Comment;
    END IF;
    
    
    UPDATE location_stocks AS LS
    INNER JOIN wk_302000_details AS WK
		ON LS.DET_ID = WK.DET_ID        
	SET LS.ReviewerID = p_user_id
    ,	LS.ReviewDatetime = current_timestamp()
    ,	LS.Status = 2
    WHERE WK.work_id = p_work_id;
    
	
    
        
    COMMIT;
        
    
END//

delimiter ;