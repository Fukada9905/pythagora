DROP TABLE IF EXISTS pyt_t_shaban;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_shaban(
	id					int 			NOT NULL 							COMMENT '車番管理ID'
,	shipper_code 		varchar(10) 	NOT NULL 							COMMENT '荷主コード'
,	transporter_code 	varchar(10) 	DEFAULT NULL 						COMMENT '運送業者コード'
,	transporter_name 	varchar(30) 	DEFAULT NULL 						COMMENT '運送業者名'
,	slip_number 		varchar(20) 	NOT NULL 							COMMENT '伝票番号'
,	sales_office_code 	varchar(10) 	NOT NULL 							COMMENT '倉庫事業所コード'
,	warehouse_code 		varchar(10) 	NOT NULL 							COMMENT '出荷倉庫コード'
,	warehouse_name 		varchar(30) 	DEFAULT NULL 						COMMENT '出荷倉庫名'
,	delivery_code 		varchar(20)		DEFAULT NULL 						COMMENT '納品先コード'
,	retrieval_date 		date 			NOT NULL 							COMMENT '出荷日'
,	delivery_date 		date 			DEFAULT NULL 						COMMENT '納品日'
,	dispatch_user_name	varchar(20) 	DEFAULT NULL 						COMMENT '配車担当者'
,	dispatch_user_id	varchar(15) 	DEFAULT NULL 						COMMENT '配車担当ユーザーID'
,	dispatch_datetime	datetime 		DEFAULT NULL 						COMMENT '配車更新日時'
,	departure_status	tinyint			DEFAULT 0 NOT NULL 					COMMENT '出発確認フラグ'
,	arrival_status		tinyint			DEFAULT 0 NOT NULL					COMMENT '到着確認フラグ'
,	add_datetime 		datetime 		NOT NULL DEFAULT CURRENT_TIMESTAMP 	COMMENT '追加日時'
,	add_user_id 		varchar(15) 	DEFAULT NULL 						COMMENT '追加ユーザーID'
,	add_user_name 		varchar(40) 	DEFAULT NULL 						COMMENT '追加ユーザー名'
,	add_user_agent 		text 			DEFAULT NULL 						COMMENT '追加ユーザーエージェント'
,	add_ip 				varchar(15) 	DEFAULT NULL 						COMMENT '追加IP'
,	upd_datetime 		datetime 		DEFAULT NULL 						COMMENT '更新日時'
,	upd_user_id 		varchar(15) 	DEFAULT NULL 						COMMENT '更新ユーザーID'
,	upd_user_name 		varchar(40) 	DEFAULT NULL 						COMMENT '更新ユーザー名'
,	upd_user_agent 		text 			DEFAULT NULL 						COMMENT '更新ユーザーエージェント'
,	upd_ip 				varchar(15) 	DEFAULT NULL 						COMMENT '更新IP'
,	PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用 車番ヘッダテーブル';//


/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER pyt_t_shaban_BEFORE_INSERT BEFORE INSERT ON pyt_t_shaban FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = pyt_ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = pyt_ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = pyt_ufn_get_ip(NEW.add_user_id);
END;//

/** INSERT トリガー **/
CREATE TRIGGER pyt_t_shaban_AFTER_INSERT AFTER INSERT ON pyt_t_shaban FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_history(
			history_record_divide
		,	id
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
        ,	departure_status
        ,	arrival_status
        ,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
		,	upd_datetime
		,	upd_user_id
		,	upd_user_name
		,	upd_user_agent
		,	upd_ip
	)
	VALUES(
			'I'
		,	NEW.id
		,	NEW.shipper_code
		,	NEW.transporter_code
		,	NEW.transporter_name
		,	NEW.slip_number
        ,	NEW.sales_office_code
		,	NEW.warehouse_code
		,	NEW.warehouse_name
		,	NEW.delivery_code
		,	NEW.retrieval_date
		,	NEW.delivery_date
        ,	NEW.dispatch_user_name
        ,	NEW.dispatch_user_id
        ,	NEW.dispatch_datetime
        ,	NEW.departure_status
        ,	NEW.arrival_status
        ,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
		,	NEW.upd_datetime
		,	NEW.upd_user_id
		,	NEW.upd_user_name
		,	NEW.upd_user_agent
		,	NEW.upd_ip
	);
END;//

/** UPDATE(BEFORE) トリガー **/
CREATE TRIGGER pyt_t_shaban_BEFORE_UPDATE BEFORE UPDATE ON pyt_t_shaban FOR EACH ROW
BEGIN
	IF NEW.upd_user_id IS NULL THEN
		SET NEW.upd_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.upd_datetime = CURRENT_TIMESTAMP;
	SET NEW.upd_user_name = pyt_ufn_get_user_name(NEW.upd_user_id);
	SET NEW.upd_user_agent = pyt_ufn_get_user_agent(NEW.upd_user_id);
	SET NEW.upd_ip = pyt_ufn_get_ip(NEW.upd_user_id);
END;//

/** UPDATE トリガー **/
CREATE TRIGGER pyt_t_shaban_AFTER_UPDATE AFTER UPDATE ON pyt_t_shaban FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_history(
			history_record_divide
		,	id
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
        ,	departure_status
        ,	arrival_status
        ,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
		,	upd_datetime
		,	upd_user_id
		,	upd_user_name
		,	upd_user_agent
		,	upd_ip
	)
	VALUES(
			'U'
		,	NEW.id
		,	NEW.shipper_code
		,	NEW.transporter_code
		,	NEW.transporter_name
		,	NEW.slip_number
        ,	NEW.sales_office_code
		,	NEW.warehouse_code
		,	NEW.warehouse_name
		,	NEW.delivery_code
		,	NEW.retrieval_date
		,	NEW.delivery_date
        ,	NEW.dispatch_user_name
        ,	NEW.dispatch_user_id
        ,	NEW.dispatch_datetime
        ,	NEW.departure_status
        ,	NEW.arrival_status
        ,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
		,	NEW.upd_datetime
		,	NEW.upd_user_id
		,	NEW.upd_user_name
		,	NEW.upd_user_agent
		,	NEW.upd_ip
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER pyt_t_shaban_AFTER_DELETE AFTER DELETE ON pyt_t_shaban FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_history(
			history_record_divide
		,	id
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
        ,	departure_status
        ,	arrival_status
        ,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
		,	upd_datetime
		,	upd_user_id
		,	upd_user_name
		,	upd_user_agent
		,	upd_ip
	)
	VALUES(
			'D'
		,	OLD.id
		,	OLD.shipper_code
		,	OLD.transporter_code
		,	OLD.transporter_name
		,	OLD.slip_number
        ,	OLD.sales_office_code
		,	OLD.warehouse_code
		,	OLD.warehouse_name
		,	OLD.delivery_code
		,	OLD.retrieval_date
		,	OLD.delivery_date
        ,	OLD.dispatch_user_name
        ,	OLD.dispatch_user_id
        ,	OLD.dispatch_datetime
        ,	OLD.departure_status
        ,	OLD.arrival_status
        ,	OLD.add_datetime
		,	OLD.add_user_id
		,	OLD.add_user_name
		,	OLD.add_user_agent
		,	OLD.add_ip
		,	OLD.upd_datetime
		,	OLD.upd_user_id
		,	OLD.upd_user_name
		,	OLD.upd_user_agent
		,	OLD.upd_ip
	);
END;//


delimiter ;
