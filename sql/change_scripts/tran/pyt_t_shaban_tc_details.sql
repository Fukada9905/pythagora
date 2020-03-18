DROP TABLE IF EXISTS pyt_t_shaban_tc_details;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_shaban_tc_details(
	id					int 			NOT NULL 							COMMENT '車番管理ID'
,	detail_no			int				NOT NULL							COMMENT '明細番号' 
,	transporter_name	varchar(60)		DEFAULT NULL						COMMENT '運送会社'
,	shaban				varchar(60)		DEFAULT NULL						COMMENT '車番'
,	kizai				varchar(60)		DEFAULT NULL						COMMENT '機材'
,	jomuin				varchar(60)		DEFAULT NULL						COMMENT '乗務員'
,	tel					varchar(60)		DEFAULT NULL						COMMENT '携帯番号'
,	remarks				varchar(100)	DEFAULT NULL						COMMENT '備考'
,	status				tinyint			DEFAULT 0 NOT NULL					COMMENT 'ステータス'
,	departure_datetime	datetime		DEFAULT NULL						COMMENT '出発時間'
,	departure_upduser	varchar(10)		DEFAULT NULL						COMMENT '出発時間更新ユーザー'
,	arrival_datetime	datetime		DEFAULT NULL						COMMENT '到着時間'
,	arrival_upduser		varchar(10)		DEFAULT NULL						COMMENT '到着時間更新ユーザー'
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
,	PRIMARY KEY (id,detail_no)
,	CONSTRAINT FK_pyt_t_shaban_tc_details_pyt_t_shaban_tc
		FOREIGN KEY (id) REFERENCES pyt_t_shaban_tc (id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用 車番明細テーブル(TC幹線)';//


/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER pyt_t_shaban_tc_details_BEFORE_INSERT BEFORE INSERT ON pyt_t_shaban_tc_details FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = pyt_ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = pyt_ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = pyt_ufn_get_ip(NEW.add_user_id);
END;//

/** INSERT トリガー **/
CREATE TRIGGER pyt_t_shaban_tc_details_AFTER_INSERT AFTER INSERT ON pyt_t_shaban_tc_details FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_tc_details_history(
			history_record_divide
		,	id
		,	detail_no
		,	transporter_name
		,	shaban
		,	kizai
		,	jomuin
		,	tel
		,	remarks
		,	status
		,	departure_datetime
		,	departure_upduser
		,	arrival_datetime
		,	arrival_upduser
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
		,	NEW.detail_no
		,	NEW.transporter_name
		,	NEW.shaban
		,	NEW.kizai
		,	NEW.jomuin
		,	NEW.tel
		,	NEW.remarks
		,	NEW.status
		,	NEW.departure_datetime
		,	NEW.departure_upduser
		,	NEW.arrival_datetime
		,	NEW.arrival_upduser
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
CREATE TRIGGER pyt_t_shaban_tc_details_BEFORE_UPDATE BEFORE UPDATE ON pyt_t_shaban_tc_details FOR EACH ROW
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
CREATE TRIGGER pyt_t_shaban_tc_details_AFTER_UPDATE AFTER UPDATE ON pyt_t_shaban_tc_details FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_tc_details_history(
			history_record_divide
		,	id
		,	detail_no
		,	transporter_name
		,	shaban
		,	kizai
		,	jomuin
		,	tel
		,	remarks
		,	status
		,	departure_datetime
		,	departure_upduser
		,	arrival_datetime
		,	arrival_upduser
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
		,	NEW.detail_no
		,	NEW.transporter_name
		,	NEW.shaban
		,	NEW.kizai
		,	NEW.jomuin
		,	NEW.tel
		,	NEW.remarks
		,	NEW.status
		,	NEW.departure_datetime
		,	NEW.departure_upduser
		,	NEW.arrival_datetime
		,	NEW.arrival_upduser
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
CREATE TRIGGER pyt_t_shaban_tc_details_AFTER_DELETE AFTER DELETE ON pyt_t_shaban_tc_details FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_tc_details_history(
			history_record_divide
		,	id
		,	detail_no
		,	transporter_name
		,	shaban
		,	kizai
		,	jomuin
		,	tel
		,	remarks
		,	status
		,	departure_datetime
		,	departure_upduser
		,	arrival_datetime
		,	arrival_upduser
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
		,	OLD.detail_no
		,	OLD.transporter_name
		,	OLD.shaban
		,	OLD.kizai
		,	OLD.jomuin
		,	OLD.tel
		,	OLD.remarks
		,	OLD.status
		,	OLD.departure_datetime
		,	OLD.departure_upduser
		,	OLD.arrival_datetime
		,	OLD.arrival_upduser
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
