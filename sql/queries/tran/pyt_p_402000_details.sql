DROP PROCEDURE IF EXISTS pyt_p_402000_details;
delimiter //

CREATE PROCEDURE pyt_p_402000_details(
	IN p_target_id text
,	IN p_user_id varchar(10)
)
BEGIN

	CREATE TEMPORARY TABLE tmp_id(work_id int unsigned);				    
    SET @sql_sel = CONCAT('INSERT INTO tmp_id VALUES',p_target_id);
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;
    
    
    CREATE TEMPORARY TABLE tmp_data(
		shipper_name text
    ,	slip_number text
    ,	retrieval_date date
    ,	delivery_date date
    ,	warehouse text
    ,	delivery text
    ,	work_id int
    ,	target_divide tinyint
    ,	id int
    ,	detail_no int
    ,	transporter_name varchar(60)
    ,	shaban varchar(60)
    ,	kizai varchar(60)
    ,	jomuin varchar(60)
    ,	tel varchar(60)
    ,	remarks varchar(100)
    ,	departure_datetime text
    ,	arrival_datetime text
    );
    
    
    INSERT INTO tmp_data
    SELECT
		WK.shipper_name
	,	WK.slip_number
	,	WK.retrieval_date
	,	WK.delivery_date
	,	CONCAT(IFNULL(WK.warehouse_code,''),'　',IFNULL(WK.warehouse_name,'')) AS warehouse
	,	CONCAT(IFNULL(WK.delivery_code,''),'　',IFNULL(WK.delivery_name,''),'　',IFNULL(WK.delivery_address,'')) AS delivery
	,	WK.work_id
    ,	WK.target_divide
    ,	SD.id
    ,	SD.detail_no
	,	SD.transporter_name
    ,	SD.shaban
    ,	SD.kizai
    ,	SD.jomuin
    ,	SD.tel
    ,	SD.remarks
    ,	DATE_FORMAT(SD.departure_datetime,'%Y/%m/%d\r\n%H:%i') AS departure_datetime
    ,	DATE_FORMAT(SD.arrival_datetime,'%Y/%m/%d\r\n%H:%i') AS arrival_datetime
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
	,	CONCAT(IFNULL(WK.warehouse_code,''),'　',IFNULL(WK.warehouse_name,'')) AS warehouse
	,	CONCAT(IFNULL(WK.delivery_code,''),'　',IFNULL(WK.delivery_name,''),'　',IFNULL(WK.delivery_address,'')) AS delivery
	,	WK.work_id
    ,	WK.target_divide
    ,	SD.id
    ,	SD.detail_no
	,	SD.transporter_name
    ,	SD.shaban
    ,	SD.kizai
    ,	SD.jomuin
    ,	SD.tel
    ,	SD.remarks
    ,	DATE_FORMAT(SD.departure_datetime,'%Y/%m/%d\r\n%H:%i') AS departure_datetime
    ,	DATE_FORMAT(SD.arrival_datetime,'%Y/%m/%d\r\n%H:%i') AS arrival_datetime
    FROM pyt_w_402000 AS WK
	INNER JOIN tmp_id AS TP
		ON WK.work_id = TP.work_id
	INNER JOIN pyt_t_shaban_tc_details AS SD
		ON WK.shaban_id = SD.id
	WHERE WK.target_divide = 1
    AND WK.user_id = p_user_id;
    
    
    SELECT * FROM tmp_data ORDER BY work_id, detail_no;
	
    
END//

delimiter ;