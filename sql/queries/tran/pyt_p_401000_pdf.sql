DROP PROCEDURE IF EXISTS pyt_p_401000_pdf;
delimiter //

CREATE PROCEDURE pyt_p_401000_pdf(
	IN p_get_divide tinyint
,	IN p_target_id text
,	IN p_user_id varchar(10)
)
BEGIN

	CREATE TEMPORARY TABLE tmp_id(work_id int unsigned);				    
    SET @sql_sel = CONCAT('INSERT INTO tmp_id VALUES',p_target_id);
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;
    
    IF p_get_divide = 3 THEN
		SELECT
			WK.shipper_name
		,	WK.slip_number
		,	WK.retrieval_date
		,	WK.delivery_date
		,	CONCAT(IFNULL(WK.warehouse_code,''),'　',IFNULL(WK.warehouse_name,'')) AS warehouse
		,	CONCAT(IFNULL(WK.delivery_code,''),'　',IFNULL(WK.delivery_name,''),'　',IFNULL(WK.delivery_address,'')) AS delivery
		,	WK.work_id
        ,	SH.dispatch_user_name
        ,	US.user_name
		,	SD.*
		FROM pyt_w_401000 AS WK
		INNER JOIN tmp_id AS TP
			ON WK.work_id = TP.work_id
		INNER JOIN pyt_t_shaban_tc AS SH
			ON WK.shaban_id = SH.id
		INNER JOIN pyt_t_shaban_tc_details AS SD
			ON SH.id = SD.id
		INNER JOIN pyt_m_users AS US
			ON SH.dispatch_user_id = US.user_id
		WHERE WK.user_id = p_user_id
		ORDER BY WK.work_id, SD.detail_no;
    ELSE    
		SELECT
			WK.shipper_name
		,	WK.slip_number
		,	WK.retrieval_date
		,	WK.delivery_date
		,	CONCAT(IFNULL(WK.warehouse_code,''),'　',IFNULL(WK.warehouse_name,'')) AS warehouse
		,	CONCAT(IFNULL(WK.delivery_code,''),'　',IFNULL(WK.delivery_name,''),'　',IFNULL(WK.delivery_address,'')) AS delivery
		,	WK.work_id
        ,	SH.dispatch_user_name
        ,	US.user_name
		,	SD.*
		FROM pyt_w_401000 AS WK
		INNER JOIN tmp_id AS TP
			ON WK.work_id = TP.work_id
		INNER JOIN pyt_t_shaban AS SH
			ON WK.shaban_id = SH.id
		INNER JOIN pyt_t_shaban_details AS SD
			ON SH.id = SD.id
		INNER JOIN pyt_m_users AS US
			ON SH.dispatch_user_id = US.user_id
		WHERE WK.user_id = p_user_id
		ORDER BY WK.work_id, SD.detail_no;
	END IF;
	
    
END//

delimiter ;