DROP PROCEDURE IF EXISTS usp_301000_update;
delimiter //

CREATE PROCEDURE usp_301000_update(
	IN p_update_row	text
,	IN p_Reporter 	varchar(20)
,	IN p_user_id	varchar(20)
)
BEGIN

	DECLARE _user_name VARCHAR(40);

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    SELECT IFNULL(US.user_name,'') INTO _user_name FROM mtb_users AS US 
    INNER JOIN mtb_user_groups AS UG
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
    
    
    UPDATE location_stocks AS LS
    INNER JOIN wk_301000_details AS WK
		ON LS.DET_ID = WK.DET_ID        
	INNER JOIN tmp_insert AS TP
		ON WK.work_detail_id = TP.work_detail_id
	SET LS.JitsuBara = TP.JitsuBara
    ,	LS.JitsuCase = TP.JitsuCase
    ,	LS.ReportComment = TP.Comment
    ,	LS.Reporter = p_Reporter
    ,	LS.ReportCorpName = IFNULL(_user_name,'')
    ,	LS.ReportDatetime = current_timestamp()
    ,	LS.Status = 1
    WHERE TP.IsAdd = 0;
    
    
    INSERT INTO location_stocks(
		NNSICD
	,	NNSINM
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
    ,	DNRK
    ,	SHNKKKMEI_KS
	,	PYTStocktakingDate
    ,	PYTexStocks1
    ,	PYTexStocks3
    ,	PYTPicking1
    ,	PYTPicking3
    ,	PYTstock1
    ,	PYTstock3
	,	PYTPLQ
    ,	PYTPLP
    ,	JitsuBara
    ,	JitsuCase
    ,	ReportComment
    ,	Reporter
    ,	ReportCorpName
    ,	ReportDatetime
    ,	Status
    ,	AddFlag
    )
    SELECT DISTINCT
		WK.NNSICD
	,	WK.NNSINM
	,	WK.JGSCD
	,	WK.JGSNM
    ,	'0' AS SRRNO
	,	TP.RTNO
	,	'' AS KANRIK
	,	'' AS SYUKAK
	,	'' AS KOUJOK
	,	WK.SNTCD
	,	WK.SNTNM
	,	'' AS SHCD
    ,	TP.SHNM
    ,	'' AS DNRK
    ,	'' AS SHNKKKMEI_KS
	,	WK.PYTStocktakingDate
    ,	0 AS PYTexStocks1
    ,	0 AS PYTexStocks3
    ,	0 AS PYTPicking1
    ,	0 AS PYTPicking3
    ,	0 AS PYTstock1
    ,	0 AS PYTstock3
	,	0 AS PYTPLQ
    ,	0 AS PYTPLP
    ,	TP.JitsuBara
    ,	TP.JitsuCase
    ,	TP.Comment
    ,	p_Reporter AS Reporter
    ,	IFNULL(_user_name,'') AS ReportCorpName
    ,	current_timestamp() AS ReportDatetime
    ,	1 AS Status
    ,	1 AS AddFlag
	FROM wk_301000_head AS WK
    INNER JOIN tmp_insert AS TP
		ON WK.work_id = TP.work_detail_id
	WHERE TP.IsAdd = 1
	;
    
	DROP TEMPORARY TABLE tmp_insert;
    COMMIT;
        
    
END//

delimiter ;