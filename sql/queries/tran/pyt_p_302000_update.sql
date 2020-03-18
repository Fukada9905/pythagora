DROP PROCEDURE IF EXISTS pyt_p_302000_update;
delimiter //

CREATE PROCEDURE pyt_p_302000_update(
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
		UPDATE pyt_t_location_stocks AS LS
        INNER JOIN(
			SELECT
				WH.NNSICD
            ,	WH.JGSCD
            ,	WD.SRRNO
            ,	WD.RTNO
            ,	WD.KANRIK
            ,	WD.SYUKAK
            ,	WD.KOUJOK
            ,	WH.SNTCD
            ,	WD.SHCD
            ,	WH.PYTStocktakingDate
            ,	WD.work_detail_id
			FROM pyt_w_302000_head AS WH
            INNER JOIN pyt_w_302000_details AS WD
				ON WH.work_id = WD.work_id
                AND WH.user_id = WD.user_id
			WHERE WH.work_id = p_work_id
            AND WH.user_id = p_user_id
        ) AS WK        
			ON LS.NNSICD = WK.NNSICD
            AND LS.JGSCD = WK.JGSCD
            AND LS.SRRNO = WK.SRRNO
            AND LS.RTNO = WK.RTNO
            AND LS.KANRIK = WK.KANRIK
            AND LS.SYUKAK = WK.SYUKAK
            AND LS.KOUJOK = WK.KOUJOK
            AND LS.SNTCD = WK.SNTCD
            AND LS.SHCD = WK.SHCD
            AND LS.PYTStocktakingDate = WK.PYTStocktakingDate
		INNER JOIN tmp_insert AS TP
			ON WK.work_detail_id = TP.work_detail_id
		SET LS.ReviewComment = TP.Comment;
    END IF;
    
    
    UPDATE pyt_t_location_stocks AS LS
    INNER JOIN pyt_w_302000_head AS WK
		ON LS.NNSICD = WK.NNSICD
		AND LS.JGSCD = WK.JGSCD
		AND LS.SNTCD = WK.SNTCD
		AND LS.PYTStocktakingDate = WK.PYTStocktakingDate
	SET LS.ReviewerID = p_user_id
    ,	LS.ReviewDatetime = current_timestamp()
    ,	LS.Status = 2
    WHERE WK.work_id = p_work_id
    AND WK.user_id = p_user_id;
    
	
    
        
    COMMIT;
        
    
END//

delimiter ;