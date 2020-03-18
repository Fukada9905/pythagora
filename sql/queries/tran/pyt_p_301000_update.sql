DROP PROCEDURE IF EXISTS pyt_p_301000_update;
delimiter //

CREATE PROCEDURE pyt_p_301000_update(
	IN p_update_row	text
,	IN p_Reporter 	varchar(20)
,	IN p_user_id	varchar(20)
)
BEGIN

	DECLARE _user_name VARCHAR(40);
    DECLARE _work_id INT;

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    SELECT IFNULL(US.user_name,'') INTO _user_name FROM pyt_m_users AS US 
    INNER JOIN pyt_m_user_groups AS UG
		ON US.user_group_id = UG.user_group_id
    WHERE US.user_id = p_user_id
    AND UG.user_divide = 30;
    
    CREATE TEMPORARY TABLE tmp_insert(
		work_detail_id	int
	,	JitsuCase		int
    ,	JitsuBara		int
    ,	Comment			varchar(255)
    ,	IsAdd			tinyint
    ,	SHNM			varchar(50)
    ,	RTNO			varchar(20)
    );
    
    SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',IFNULL(p_update_row,'(null,null,null,null,null,null,null)'));    
	PREPARE stmt from @s;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;    
	
    SELECT DISTINCT work_id INTO _work_id FROM pyt_w_301000_details AS WK
    INNER JOIN tmp_insert AS TP ON WK.work_detail_id = TP.work_detail_id AND WK.user_id = p_user_id;
  
	INSERT INTO pyt_t_location_stocks(
    	NNSICD
    ,	JGSCD
    ,	JGSNM
    ,	SRRNO
    ,	RTNO
    ,	KANRIK
    ,	SYUKAK
    ,	KOUJOK
    ,	SNTCD
    ,	SNTNM
    ,	SHCD
    ,	SHNM
    ,	PYTStocktakingDate
    ,	JitsuCase
    ,	JitsuBara
    ,	ReportComment
    ,	Reporter
    ,	ReportCorpName
    ,	ReportDatetime
    ,	Status
    ,	AddFlag
    )
    SELECT
		WH.NNSICD
    ,	WH.JGSCD
    ,	WH.JGSNM
    ,	CASE WHEN TP.IsAdd = 0 THEN WK.SRRNO ELSE '0' END
    ,	CASE WHEN TP.IsAdd = 0 THEN WK.RTNO ELSE TP.RTNO END
    ,	CASE WHEN TP.IsAdd = 0 THEN WK.KANRIK ELSE '' END
    ,	CASE WHEN TP.IsAdd = 0 THEN WK.SYUKAK ELSE '' END
    ,	CASE WHEN TP.IsAdd = 0 THEN WK.KOUJOK ELSE '' END
    ,	WH.SNTCD
    ,	WH.SNTNM
    ,	CASE WHEN TP.IsAdd = 0 THEN WK.SHCD ELSE '' END
    ,	CASE WHEN TP.IsAdd = 0 THEN WK.SHNM ELSE TP.SHNM END
    ,	WH.PYTStocktakingDate
    ,	TP.JitsuCase
    ,	TP.JitsuBara
    ,	TP.Comment
    ,	p_Reporter
    ,	IFNULL(_user_name,'')
    ,	current_timestamp()
    ,	1
    ,	TP.IsAdd
    FROM tmp_insert AS TP    
    INNER JOIN pyt_w_301000_head AS WH
		ON WH.work_id = _work_id
        AND WH.user_id = p_user_id
	LEFT JOIN pyt_w_301000_details AS WK
		ON WH.work_id = WK.work_id
        AND WH.user_id = WK.user_id
        AND TP.work_detail_id = WK.work_detail_id
	ON DUPLICATE KEY UPDATE
		JitsuCase = VALUES(JitsuCase)
    ,	JitsuBara = VALUES(JitsuBara)
    ,	ReportComment = VALUES(ReportComment)
    ,	Reporter = VALUES(Reporter)
    ,	ReportDatetime = VALUES(ReportDatetime)
    ,	Status = VALUES(Status);
  

    
	DROP TEMPORARY TABLE tmp_insert;
    COMMIT;
        
    
END//

delimiter ;