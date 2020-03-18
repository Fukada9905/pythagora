DROP PROCEDURE IF EXISTS usp_batch_set_masters;
delimiter //

CREATE PROCEDURE usp_batch_set_masters(
	IN p_process_date DATE
)
BEGIN

	DECLARE _count_insert int;
    DECLARE _count_update int;
    DECLARE _process_date date;
    
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TABLE IF EXISTS tmp_jigyosho;
		DROP TABLE IF EXISTS tmp_center;
		DROP TABLE IF EXISTS tmp_return;
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    IF p_process_date IS NULL THEN
		SET _process_date = CURDATE();
    ELSE
		SET _process_date = p_process_date;
    END IF;
    
    SET @date_from = DATE_FORMAT(_process_date,'%Y-%m-%d');
    SET @date_to = DATE_FORMAT(DATE_ADD(_process_date,INTERVAL 1 DAY),'%Y-%m-%d');
    
    CREATE TEMPORARY TABLE tmp_return(
		PROCESS_TYPE			tinyint
	,	TABLE_NAMES				text
	,	PROCESS_COUNT_INSERT 	int
    ,	PROCESS_COUNT_UPDATE 	int
    );
    
    INSERT INTO tmp_return VALUES
		(1,'仮出荷情報から事業所マスタ',0,0)
	,	(2,'仮出荷情報からセンターマスタ',0,0)
    ,	(3,'出荷確定情報から事業所マスタ',0,0)
    ,	(4,'出荷確定情報からセンターマスタ',0,0)
    ,	(5,'入荷荷情報出荷元から事業所マスタ',0,0)
    ,	(6,'入荷荷情報出荷元からセンターマスタ',0,0)
    ,	(7,'入荷荷情報入荷先から事業所マスタ',0,0)
    ,	(8,'入荷荷情報入荷先からセンターマスタ',0,0)
    ,	(9,'倉庫情報から事業所マスタ',0,0)
    ,	(10,'倉庫情報からセンターマスタ',0,0);
    
        
    CREATE TEMPORARY TABLE tmp_jigyosho(
		JGSCD	varchar(10)
	,	JGSNM	varchar(20)
    ,	update_divide tinyint
    ,	KEY IX_tmp_jigyosho_JGSCD (JGSCD)    
    ,	KEY IX_tmp_jigyosho_update_divide (update_divide)    
    );
    
    
    CREATE TEMPORARY TABLE tmp_center(
		JGSCD	varchar(10)
	,	SNTCD	varchar(10)
	,	SNTNM	varchar(20)
    ,	update_divide tinyint
    ,	KEY IX_tmp_center_JGSCD (JGSCD)
    ,	KEY IX_tmp_center_SNTCD (SNTCD)
    ,	KEY IX_tmp_center_update_divide (update_divide)    
    );
    
    
    -- 仮出荷情報
    INSERT INTO tmp_jigyosho
    SELECT
		TA.JGSCD
	,	TA.JGSNM
    ,	CASE WHEN JG.JGSCD IS NULL THEN 1
			 WHEN TA.JGSNM != JG.JGSNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			SD.JGSCD AS JGSCD
		,	SD.JGSNM AS JGSNM
		FROM shipment_provisional_details AS SD
		INNER JOIN shipment_provisionals AS SC
			ON SD.ID = SC.ID
		WHERE SC.TRKMJ BETWEEN @date_from AND @date_to
    ) AS TA
    LEFT JOIN mtb_jigyosho AS JG
		ON TA.JGSCD = JG.JGSCD
	;
    
    INSERT INTO tmp_center
    SELECT
		TA.JGSCD
	,	TA.SNTCD
    ,	TA.SNTNM
    ,	CASE WHEN ST.JGSCD IS NULL THEN 1
			 WHEN TA.SNTNM != ST.SNTNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			SD.JGSCD AS JGSCD
		,	SD.SNTCD AS SNTCD
        ,	SD.SNTNM AS SNTNM
		FROM shipment_provisional_details AS SD
		INNER JOIN shipment_provisionals AS SC
			ON SD.ID = SC.ID
		WHERE SC.TRKMJ BETWEEN @date_from AND @date_to
    ) AS TA
    LEFT JOIN mtb_center AS ST
		ON TA.JGSCD = ST.JGSCD
        AND TA.SNTCD = ST.SNTCD
	;
    
    
    
    INSERT INTO mtb_jigyosho(
		JGSCD
	,	JGSNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	JGSNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_jigyosho
    WHERE update_divide = 1;
    
        
    UPDATE mtb_jigyosho AS JG
    INNER JOIN tmp_jigyosho AS TP
		ON JG.JGSCD = TP.JGSCD
	SET JG.JGSNM = TP.JGSNM
    ,	JG.upd_user_id = 'BATCH'
    ,	JG.upd_user_name = 'バッチ処理'
    ,	JG.upd_ip = '127.0.0.1'
    ,	JG.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_jigyosho WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_jigyosho WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 1;
    
    
    INSERT INTO mtb_center(
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_center
    WHERE update_divide = 1;
    
        
    UPDATE mtb_center AS ST
    INNER JOIN tmp_center AS TP
		ON ST.JGSCD = TP.JGSCD
        AND ST.SNTCD = TP.SNTCD
	SET ST.SNTNM = TP.SNTNM
    ,	ST.upd_user_id = 'BATCH'
    ,	ST.upd_user_name = 'バッチ処理'
    ,	ST.upd_ip = '127.0.0.1'
    ,	ST.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_center WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_center WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 2;
    
    
    TRUNCATE TABLE tmp_jigyosho;
    TRUNCATE TABLE tmp_center;
    
    
    
    
    
    -- 出荷確定情報
    INSERT INTO tmp_jigyosho
    SELECT
		TA.JGSCD
	,	TA.JGSNM
    ,	CASE WHEN JG.JGSCD IS NULL THEN 1
			 WHEN TA.JGSNM != JG.JGSNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			SD.JGSCD AS JGSCD
		,	SD.JGSNM AS JGSNM
		FROM shipment_confirm_details AS SD
		INNER JOIN shipment_confirms AS SC
			ON SD.ID = SC.ID
		WHERE SC.TRKMJ BETWEEN @date_from AND @date_to		
    ) AS TA
    LEFT JOIN mtb_jigyosho AS JG
		ON TA.JGSCD = JG.JGSCD
	;
    
    
    INSERT INTO tmp_center
    SELECT
		TA.JGSCD
	,	TA.SNTCD
    ,	TA.SNTNM
    ,	CASE WHEN ST.JGSCD IS NULL THEN 1
			 WHEN TA.SNTNM != ST.SNTNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			SD.JGSCD AS JGSCD
		,	SD.SNTCD AS SNTCD
        ,	SD.SNTNM AS SNTNM
		FROM shipment_confirm_details AS SD
		INNER JOIN shipment_confirms AS SC
			ON SD.ID = SC.ID
		WHERE SC.TRKMJ BETWEEN @date_from AND @date_to
    ) AS TA
    LEFT JOIN mtb_center AS ST
		ON TA.JGSCD = ST.JGSCD
        AND TA.SNTCD = ST.SNTCD
	;
    
    
	INSERT INTO mtb_jigyosho(
		JGSCD
	,	JGSNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	JGSNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_jigyosho
    WHERE update_divide = 1;
    
        
    UPDATE mtb_jigyosho AS JG
    INNER JOIN tmp_jigyosho AS TP
		ON JG.JGSCD = TP.JGSCD
	SET JG.JGSNM = TP.JGSNM
    ,	JG.upd_user_id = 'BATCH'
    ,	JG.upd_user_name = 'バッチ処理'
    ,	JG.upd_ip = '127.0.0.1'
    ,	JG.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_jigyosho WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_jigyosho WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 3;
    
    
    INSERT INTO mtb_center(
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_center
    WHERE update_divide = 1;
    
        
    UPDATE mtb_center AS ST
    INNER JOIN tmp_center AS TP
		ON ST.JGSCD = TP.JGSCD
        AND ST.SNTCD = TP.SNTCD
	SET ST.SNTNM = TP.SNTNM
    ,	ST.upd_user_id = 'BATCH'
    ,	ST.upd_user_name = 'バッチ処理'
    ,	ST.upd_ip = '127.0.0.1'
    ,	ST.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_center WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_center WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 4;
    
    
    TRUNCATE TABLE tmp_jigyosho;
    TRUNCATE TABLE tmp_center;
    
    
    
    
    
    -- 入荷情報(入荷先)
    INSERT INTO tmp_jigyosho
    SELECT
		TA.JGSCD
	,	TA.JGSNM
    ,	CASE WHEN JG.JGSCD IS NULL THEN 1
			 WHEN TA.JGSNM != JG.JGSNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			JGSCD_NK AS JGSCD
		,	JGSNM_NK AS JGSNM
		FROM arrival_schedules
        WHERE TRKMJ BETWEEN @date_from AND @date_to		
    ) AS TA
    LEFT JOIN mtb_jigyosho AS JG
		ON TA.JGSCD = JG.JGSCD
	;
    
    
    INSERT INTO tmp_center
    SELECT
		TA.JGSCD
	,	TA.SNTCD
    ,	TA.SNTNM
    ,	CASE WHEN ST.JGSCD IS NULL THEN 1
			 WHEN TA.SNTNM != ST.SNTNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			JGSCD_NK AS JGSCD
		,	SNTCD_NK AS SNTCD
        ,	SNTNM_NK AS SNTNM
		FROM arrival_schedules
		WHERE TRKMJ BETWEEN @date_from AND @date_to
    ) AS TA
    LEFT JOIN mtb_center AS ST
		ON TA.JGSCD = ST.JGSCD
        AND TA.SNTCD = ST.SNTCD
	;
    
    
    INSERT INTO mtb_jigyosho(
		JGSCD
	,	JGSNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	JGSNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_jigyosho
    WHERE update_divide = 1;
    
        
    UPDATE mtb_jigyosho AS JG
    INNER JOIN tmp_jigyosho AS TP
		ON JG.JGSCD = TP.JGSCD
	SET JG.JGSNM = TP.JGSNM
    ,	JG.upd_user_id = 'BATCH'
    ,	JG.upd_user_name = 'バッチ処理'
    ,	JG.upd_ip = '127.0.0.1'
    ,	JG.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_jigyosho WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_jigyosho WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 5;
    
    
    INSERT INTO mtb_center(
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_center
    WHERE update_divide = 1;
    
        
    UPDATE mtb_center AS ST
    INNER JOIN tmp_center AS TP
		ON ST.JGSCD = TP.JGSCD
        AND ST.SNTCD = TP.SNTCD
	SET ST.SNTNM = TP.SNTNM
    ,	ST.upd_user_id = 'BATCH'
    ,	ST.upd_user_name = 'バッチ処理'
    ,	ST.upd_ip = '127.0.0.1'
    ,	ST.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_center WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_center WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 6;
    
    
    
    
    -- 入荷情報(出荷元)
    INSERT INTO tmp_jigyosho
    SELECT
		TA.JGSCD
	,	TA.JGSNM
    ,	CASE WHEN JG.JGSCD IS NULL THEN 1
			 WHEN TA.JGSNM != JG.JGSNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			AD.JGSCD_SK AS JGSCD
		,	AD.JGSNM_SK AS JGSNM
		FROM arrival_schedule_details AS AD
        INNER JOIN arrival_schedules AS AH
			ON AD.ID = AH.ID
		WHERE AH.TRKMJ BETWEEN @date_from AND @date_to
    ) AS TA
    LEFT JOIN mtb_jigyosho AS JG
		ON TA.JGSCD = JG.JGSCD
	;
    
    
    INSERT INTO tmp_center
    SELECT
		TA.JGSCD
	,	TA.SNTCD
    ,	TA.SNTNM
    ,	CASE WHEN ST.JGSCD IS NULL THEN 1
			 WHEN TA.SNTNM != ST.SNTNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			AD.JGSCD_SK AS JGSCD
		,	AD.SNTCD_SK AS SNTCD
        ,	AD.SNTNM_SK AS SNTNM
		FROM arrival_schedule_details AS AD
        INNER JOIN arrival_schedules AS AH
			ON AD.ID = AH.ID
		WHERE AH.TRKMJ BETWEEN @date_from AND @date_to
    ) AS TA
    LEFT JOIN mtb_center AS ST
		ON TA.JGSCD = ST.JGSCD
        AND TA.SNTCD = ST.SNTCD
	;
    
    
	INSERT INTO mtb_jigyosho(
		JGSCD
	,	JGSNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	JGSNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_jigyosho
    WHERE update_divide = 1;
    
        
    UPDATE mtb_jigyosho AS JG
    INNER JOIN tmp_jigyosho AS TP
		ON JG.JGSCD = TP.JGSCD
	SET JG.JGSNM = TP.JGSNM
    ,	JG.upd_user_id = 'BATCH'
    ,	JG.upd_user_name = 'バッチ処理'
    ,	JG.upd_ip = '127.0.0.1'
    ,	JG.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_jigyosho WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_jigyosho WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 7;
    
    
    INSERT INTO mtb_center(
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_center
    WHERE update_divide = 1;
    
        
    UPDATE mtb_center AS ST
    INNER JOIN tmp_center AS TP
		ON ST.JGSCD = TP.JGSCD
        AND ST.SNTCD = TP.SNTCD
	SET ST.SNTNM = TP.SNTNM
    ,	ST.upd_user_id = 'BATCH'
    ,	ST.upd_user_name = 'バッチ処理'
    ,	ST.upd_ip = '127.0.0.1'
    ,	ST.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_center WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_center WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 8;
    
    
    TRUNCATE TABLE tmp_jigyosho;
    TRUNCATE TABLE tmp_center;
    
    
    
    
    
    -- 在庫情報
    INSERT INTO tmp_jigyosho
    SELECT
		TA.JGSCD
	,	TA.JGSNM
    ,	CASE WHEN JG.JGSCD IS NULL THEN 1
			 WHEN TA.JGSNM != JG.JGSNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			JGSCD AS JGSCD
		,	JGSNM AS JGSNM
		FROM location_stocks	
		WHERE TRKJ BETWEEN @date_from AND @date_to
    ) AS TA
    LEFT JOIN mtb_jigyosho AS JG
		ON TA.JGSCD = JG.JGSCD
	;
    
    
    INSERT INTO tmp_center
    SELECT
		TA.JGSCD
	,	TA.SNTCD
    ,	TA.SNTNM
    
    ,	CASE WHEN ST.JGSCD IS NULL THEN 1
			 WHEN TA.SNTNM != ST.SNTNM THEN 2
             ELSE 0
		END AS update_divide
    FROM
    (
		SELECT DISTINCT
			JGSCD AS JGSCD
		,	SNTCD AS SNTCD
        ,	SNTNM AS SNTNM
		FROM location_stocks			
		WHERE TRKJ BETWEEN @date_from AND @date_to
    ) AS TA
    LEFT JOIN mtb_center AS ST
		ON TA.JGSCD = ST.JGSCD
        AND TA.SNTCD = ST.SNTCD
	;
    
    
    INSERT INTO mtb_jigyosho(
		JGSCD
	,	JGSNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	JGSNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_jigyosho
    WHERE update_divide = 1;
    
        
    UPDATE mtb_jigyosho AS JG
    INNER JOIN tmp_jigyosho AS TP
		ON JG.JGSCD = TP.JGSCD
	SET JG.JGSNM = TP.JGSNM
    ,	JG.upd_user_id = 'BATCH'
    ,	JG.upd_user_name = 'バッチ処理'
    ,	JG.upd_ip = '127.0.0.1'
    ,	JG.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_jigyosho WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_jigyosho WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 9;
    
    
    INSERT INTO mtb_center(
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	add_user_id
    ,	add_user_name
    ,	add_ip
    )
    SELECT
		JGSCD
	,	SNTCD
	,	SNTNM
    ,	'BATCH'
    ,	'バッチ処理'
    ,	'127.0.0.1'
	FROM tmp_center
    WHERE update_divide = 1;
    
        
    UPDATE mtb_center AS ST
    INNER JOIN tmp_center AS TP
		ON ST.JGSCD = TP.JGSCD
        AND ST.SNTCD = TP.SNTCD
	SET ST.SNTNM = TP.SNTNM
    ,	ST.upd_user_id = 'BATCH'
    ,	ST.upd_user_name = 'バッチ処理'
    ,	ST.upd_ip = '127.0.0.1'
    ,	ST.upd_datetime = CURRENT_TIMESTAMP
	WHERE TP.update_divide = 2;
	
    SELECT COUNT(*) INTO _count_insert FROM tmp_center WHERE update_divide = 1;
    SELECT COUNT(*) INTO _count_update FROM tmp_center WHERE update_divide = 2;
    
    
    UPDATE tmp_return SET
		PROCESS_COUNT_INSERT = _count_insert
	,	PROCESS_COUNT_UPDATE = _count_update
	WHERE PROCESS_TYPE = 10;
    
    
    COMMIT;
    
    
    SELECT * FROM tmp_return;
    
    
    DROP TABLE IF EXISTS tmp_jigyosho;
    DROP TABLE IF EXISTS tmp_center;
    DROP TABLE IF EXISTS tmp_return;
    
    ALTER TABLE mtb_jigyosho ENGINE = InnoDB;
	ALTER TABLE mtb_center ENGINE = InnoDB;
	
	
        
    
END//

delimiter ;