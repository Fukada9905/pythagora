DROP PROCEDURE IF EXISTS pyt_p_401000_update;
delimiter //

CREATE PROCEDURE pyt_p_401000_update(
	IN p_get_divide tinyint
,	IN p_update_row	text
,	IN p_Dispatcher varchar(20)
,	IN p_user_id	varchar(20)
)
BEGIN


	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TEMPORARY TABLE tmp_insert;
        DROP TEMPORARY TABLE tmp_work_ids;
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    
    CREATE TEMPORARY TABLE tmp_insert(
		work_id				int
	,	detail_no			int
    ,	is_delete			tinyint
    ,	transporter_name	varchar(60)
    ,	shaban				varchar(60)
    ,	kizai				varchar(60)
    ,	jomuin				varchar(60)
    ,	tel					varchar(60)
    ,	remarks				varchar(100)
    );
    IF p_update_row IS NOT NULL THEN
		SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',p_update_row);    
		PREPARE stmt from @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;    
	END IF;
    
    CREATE TEMPORARY TABLE tmp_work_ids(
		work_id	int
    );
     
    INSERT INTO tmp_work_ids SELECT DISTINCT work_id FROM tmp_insert;
	
    
    IF p_get_divide = 3 THEN
		-- INSERT TO HEADERS
		SELECT IFNULL(MAX(id),0) INTO @id FROM pyt_t_shaban_tc FOR UPDATE;
    
		-- UPDATE WORKS
		UPDATE pyt_w_401000 AS WK
		INNER JOIN tmp_work_ids AS TP
			ON WK.work_id = TP.work_id
		SET WK.shaban_id = @id:=@id+1
		WHERE WK.user_id = p_user_id
		AND WK.shaban_id IS NULL;
        
        INSERT INTO pyt_t_shaban_tc(
			id
		,	root_id
		,	target_date
		,	dispatch_user_name
        ,	dispatch_user_id
        ,	dispatch_datetime
		)
		SELECT DISTINCT
			WK.shaban_id
		,	WK.root_id
		,	WK.retrieval_date
		,	p_Dispatcher
        ,	p_user_id
        ,	current_timestamp()
		FROM pyt_w_401000 AS WK
		INNER JOIN tmp_work_ids AS TP
			ON WK.work_id = TP.work_id
		WHERE WK.user_id = p_user_id
		ON DUPLICATE KEY UPDATE
			dispatch_user_name = p_Dispatcher
		,	dispatch_user_id = p_user_id
        ,	dispatch_datetime = current_timestamp()
		;
        
        INSERT INTO pyt_t_shaban_tc_details(
			id
		,	detail_no
		,	transporter_name
		,	shaban
		,	kizai
		,	jomuin
		,	tel
		,	remarks    
		)
		SELECT DISTINCT
			WK.shaban_id
		,	TP.detail_no
		,	TP.transporter_name
		,	TP.shaban
		,	TP.kizai
		,	TP.jomuin
		,	TP.tel
		,	TP.remarks    
		FROM pyt_w_401000 AS WK
		INNER JOIN tmp_insert AS TP
			ON WK.work_id = TP.work_id
		WHERE WK.user_id = p_user_id
		AND	TP.is_delete = 0
		ON DUPLICATE KEY UPDATE
			transporter_name = TP.transporter_name
		,	shaban = TP.shaban
		,	kizai = TP.kizai
		,	jomuin = TP.jomuin
		,	tel = TP.tel
		,	remarks = TP.remarks
		;
        
        
        DELETE SD FROM pyt_t_shaban_tc_details AS SD
		INNER JOIN pyt_w_401000 AS WK
			ON SD.id = WK.shaban_id
		INNER JOIN tmp_insert AS TP
			ON WK.work_id = TP.work_id
			AND SD.detail_no = TP.detail_no
		WHERE WK.user_id = p_user_id
		AND	TP.is_delete = 1;        
            
    ELSE    
		-- INSERT TO HEADERS
		SELECT IFNULL(MAX(id),0) INTO @id FROM pyt_t_shaban FOR UPDATE;
		
		-- UPDATE WORKS
		UPDATE pyt_w_401000 AS WK
		INNER JOIN tmp_work_ids AS TP
			ON WK.work_id = TP.work_id
		SET WK.shaban_id = @id:=@id+1
		WHERE WK.user_id = p_user_id
		AND WK.shaban_id IS NULL;
		
			
		

		INSERT INTO pyt_t_shaban(
			id
		,	shipper_code
		,	transporter_code
		,	transporter_name
		,	slip_number
		,	sales_office_code
		,	warehouse_code
		,	warehouse_name
		,	delivery_code
		,	retrieval_date
		,	delivery_date
		,	dispatch_user_name
        ,	dispatch_user_id
		,	dispatch_datetime
		)
		SELECT DISTINCT
			shaban_id
		,	shipper_code
		,	transporter_code
		,	transporter_name
		,	slip_number
		,	sales_office_code
		,	warehouse_code
		,	warehouse_name
		,	delivery_code
		,	retrieval_date
		,	delivery_date
		,	p_Dispatcher
        ,	p_user_id
        ,	current_timestamp()
		FROM pyt_w_401000 AS WK
		INNER JOIN tmp_work_ids AS TP
			ON WK.work_id = TP.work_id
		WHERE WK.user_id = p_user_id
		ON DUPLICATE KEY UPDATE
			dispatch_user_name = p_Dispatcher
		,	dispatch_user_id = p_user_id
        ,	dispatch_datetime = current_timestamp()
		;
		
		
		
		INSERT INTO pyt_t_shaban_details(
			id
		,	detail_no
		,	transporter_name
		,	shaban
		,	kizai
		,	jomuin
		,	tel
		,	remarks    
		)
		SELECT DISTINCT
			WK.shaban_id
		,	TP.detail_no
		,	TP.transporter_name
		,	TP.shaban
		,	TP.kizai
		,	TP.jomuin
		,	TP.tel
		,	TP.remarks    
		FROM pyt_w_401000 AS WK
		INNER JOIN tmp_insert AS TP
			ON WK.work_id = TP.work_id
		WHERE WK.user_id = p_user_id
		AND	TP.is_delete = 0
		ON DUPLICATE KEY UPDATE
			transporter_name = TP.transporter_name
		,	shaban = TP.shaban
		,	kizai = TP.kizai
		,	jomuin = TP.jomuin
		,	tel = TP.tel
		,	remarks = TP.remarks
		;
		
		DELETE SD FROM pyt_t_shaban_details AS SD
		INNER JOIN pyt_w_401000 AS WK
			ON SD.id = WK.shaban_id
		INNER JOIN tmp_insert AS TP
			ON WK.work_id = TP.work_id
			AND SD.detail_no = TP.detail_no
		WHERE WK.user_id = p_user_id
		AND	TP.is_delete = 1;
	END IF;
    
	DROP TEMPORARY TABLE tmp_insert;
    DROP TEMPORARY TABLE tmp_work_ids;
    COMMIT;
        
    
END//

delimiter ;