DROP PROCEDURE IF EXISTS pyt_p_402000_csv;
delimiter //

CREATE PROCEDURE pyt_p_402000_csv(
	IN p_target_id text
,	IN p_user_id varchar(10)
)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_id;
	CREATE TEMPORARY TABLE tmp_id(work_id int unsigned);				    
        
    IF p_target_id IS NOT NULL THEN
		SET @sql_sel = CONCAT('INSERT INTO tmp_id VALUES',p_target_id);    
		PREPARE _stmt_sel from @sql_sel;
		EXECUTE _stmt_sel;
		DEALLOCATE PREPARE _stmt_sel;
	ELSE
		INSERT INTO tmp_id
        SELECT DISTINCT work_id FROM pyt_w_402000 WHERE user_id = p_user_id;
    END IF;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_data;
    CREATE TEMPORARY TABLE tmp_data(
		shipper_name text
    ,	slip_number text
    ,	retrieval_date date
    ,	delivery_date date    
    ,	warehouse_accounting_date date
    ,	warehouse_code text    
    ,	warehouse_name text    
    ,	delivery_code text
    ,	delivery_name text
    ,	delivery_address text
    ,	transporter_code text
    ,	transporter_name text
    ,	work_id int
    ,	target_divide tinyint
    ,	id int
    ,	detail_no int
    ,	transporter varchar(60)
    ,	shaban varchar(60)
    ,	kizai varchar(60)
    ,	jomuin varchar(60)
    ,	tel varchar(60)
    ,	remarks varchar(100)
    
    );
    
    
    INSERT INTO tmp_data
    SELECT
		WK.shipper_name
	,	WK.slip_number
	,	WK.retrieval_date
	,	WK.delivery_date
    ,	WK.warehouse_accounting_date
	,	WK.warehouse_code
    ,	WK.warehouse_name
	,	WK.delivery_code
    ,	WK.delivery_name
    ,	WK.delivery_address
    ,	WK.transporter_code
    ,	WK.transporter_name
	,	WK.work_id
    ,	WK.target_divide
    ,	SD.id
    ,	SD.detail_no
	,	SD.transporter_name AS transporter
    ,	SD.shaban
    ,	SD.kizai
    ,	SD.jomuin
    ,	SD.tel
    ,	SD.remarks
    FROM pyt_w_402000 AS WK
	INNER JOIN tmp_id AS TP
		ON WK.work_id = TP.work_id
	INNER JOIN pyt_t_shaban_details AS SD
		ON WK.shaban_id = SD.id
	WHERE WK.target_divide = 0
    AND WK.user_id = p_user_id;
    
    INSERT INTO tmp_data
    SELECT
		WK.shipper_name
	,	WK.slip_number
	,	WK.retrieval_date
	,	WK.delivery_date
    ,	WK.warehouse_accounting_date
	,	WK.warehouse_code
    ,	WK.warehouse_name
	,	WK.delivery_code
    ,	WK.delivery_name
    ,	WK.delivery_address
    ,	WK.transporter_code
    ,	WK.transporter_name
	,	WK.work_id
    ,	WK.target_divide
    ,	SD.id
    ,	SD.detail_no
	,	SD.transporter_name AS transporter
    ,	SD.shaban
    ,	SD.kizai
    ,	SD.jomuin
    ,	SD.tel
    ,	SD.remarks
    FROM pyt_w_402000 AS WK
	INNER JOIN tmp_id AS TP
		ON WK.work_id = TP.work_id
	INNER JOIN pyt_t_shaban_tc_details AS SD
		ON WK.shaban_id = SD.id
	WHERE WK.target_divide = 1
    AND WK.user_id = p_user_id;
    

    SELECT
		warehouse_accounting_date AS '伝票日付'
    ,	shipper_name AS '荷主'
    ,	transporter_code AS '運送会社コード'
    ,	transporter_name AS '運送会社名称'
    ,	slip_number AS '伝票番号'
    ,	warehouse_code AS '積地センターコード'
    ,	warehouse_name AS '積地センター名称'
    ,	delivery_code AS '納品先コード'
    ,	delivery_name AS '納品先名称'    
    ,	delivery_address AS '納品先住所'    
    ,	transporter AS '運送会社名'
    ,	shaban AS '車番'
    ,	kizai AS '機材'
    ,	jomuin AS '乗務員'
    ,	tel AS '携帯番号'
    ,	remarks AS '備考'    
    FROM tmp_data 
    ORDER BY warehouse_accounting_date, work_id, detail_no;
	
    
END//

delimiter ;