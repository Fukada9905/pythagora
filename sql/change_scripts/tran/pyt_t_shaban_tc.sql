DROP TABLE IF EXISTS pyt_t_shaban_tc;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_shaban_tc(
	id					int 			NOT NULL 							COMMENT '車番管理ID'
,	root_id				int 			NOT NULL 							COMMENT 'ルートID'
,	target_date 		date 			NOT NULL 							COMMENT '対象日'
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
,	CONSTRAINT FK_pyt_t_shaban_tc_details_pyt_m_root
		FOREIGN KEY (root_id) REFERENCES pyt_m_root (root_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用 車番ヘッダテーブル(TC幹線)';//


/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER pyt_t_shaban_tc_BEFORE_INSERT BEFORE INSERT ON pyt_t_shaban_tc FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = pyt_ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = pyt_ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = pyt_ufn_get_ip(NEW.add_user_id);
END;//

/** INSERT トリガー **/
CREATE TRIGGER pyt_t_shaban_tc_AFTER_INSERT AFTER INSERT ON pyt_t_shaban_tc FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_tc_history(
			history_record_divide
		,	id
        ,	root_id
		,	target_date
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
		,	NEW.root_id
		,	NEW.target_date
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
CREATE TRIGGER pyt_t_shaban_tc_BEFORE_UPDATE BEFORE UPDATE ON pyt_t_shaban_tc FOR EACH ROW
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
CREATE TRIGGER pyt_t_shaban_tc_AFTER_UPDATE AFTER UPDATE ON pyt_t_shaban_tc FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_tc_history(
			history_record_divide
		,	id
        ,	root_id
		,	target_date
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
        ,	NEW.root_id
		,	NEW.target_date
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
CREATE TRIGGER pyt_t_shaban_tc_AFTER_DELETE AFTER DELETE ON pyt_t_shaban_tc FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_shaban_tc_history(
			history_record_divide
		,	id
        ,	root_id
		,	target_date
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
		,	OLD.root_id
		,	OLD.target_date
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