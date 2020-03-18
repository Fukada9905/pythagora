delimiter //
/** テーブル作成 **/
CREATE TABLE mtb_users(
	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	user_password				varchar(20)			NOT NULL							COMMENT 'パスワード'
,	user_name					nvarchar(40)		DEFAULT NULL						COMMENT 'ユーザー名'
,	user_name_kana				nvarchar(40)		DEFAULT NULL						COMMENT 'ユーザー名カナ'
,	user_group_id				varchar(10)			NOT NULL							COMMENT 'ユーザーグループID'
,	management_cd				varchar(10)			NOT NULL							COMMENT '管理コード'
,	add_datetime				datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)			DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text				DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)			DEFAULT NULL						COMMENT '追加IP'
,	upd_datetime				datetime			DEFAULT NULL						COMMENT '更新日時'
,	upd_user_id					varchar(15)			DEFAULT NULL						COMMENT '更新ユーザーID'
,	upd_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '更新ユーザー名'
,	upd_user_agent				varchar(255)		DEFAULT NULL						COMMENT '更新ユーザーエージェント'
,	upd_ip						varchar(15)			DEFAULT NULL						COMMENT '更新IP'
,	del_flag					tinyint				NOT NULL DEFAULT 0					COMMENT '削除フラグ'
,	del_datetime				datetime			DEFAULT NULL						COMMENT '削除日時'
,	del_user_id					varchar(15)			DEFAULT NULL						COMMENT '削除ユーザーID'
,	del_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '削除ユーザー名'
,	del_user_agent				varchar(255)		DEFAULT NULL						COMMENT '削除ユーザーエージェント'
,	del_ip						varchar(15)			DEFAULT NULL						COMMENT '削除IP'
,	PRIMARY KEY (user_group_id)
,	KEY IX_mtb_users_user_group_id (user_group_id)
,	KEY IX_mtb_users_management_cd (management_cd)
,	KEY IX_mtb_users_del_flag (del_flag)
,	CONSTRAINT FK_mtb_users_mtb_user_groups
		FOREIGN KEY (user_group_id) REFERENCES mtb_user_groups (user_group_id)
		ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ユーザーマスタ (ユーザー管理を行う)';//

/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER mtb_users_BEFORE_INSERT BEFORE INSERT ON mtb_users FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = ufn_get_ip(NEW.add_user_id);
END;//


/** INSERT トリガー **/
CREATE TRIGGER mtb_users_AFTER_INSERT AFTER INSERT ON mtb_users FOR EACH ROW
BEGIN
	INSERT INTO mtb_users_history(
			history_record_divide
		,	user_id
		,	user_password
		,	user_name
		,	user_name_kana
		,	user_group_id
		,	management_cd
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
		,	del_flag
		,	del_datetime
		,	del_user_id
		,	del_user_name
		,	del_user_agent
		,	del_ip
	)
	VALUES(
			'I'
		,	NEW.user_id
		,	NEW.user_password
		,	NEW.user_name
		,	NEW.user_name_kana
		,	NEW.user_group_id
		,	NEW.management_cd
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
		,	NEW.del_flag
		,	NEW.del_datetime
		,	NEW.del_user_id
		,	NEW.del_user_name
		,	NEW.del_user_agent
		,	NEW.del_ip
	);
END;//


/** UPDATE(BEFORE) トリガー **/
CREATE TRIGGER mtb_users_BEFORE_UPDATE BEFORE UPDATE ON mtb_users FOR EACH ROW
BEGIN
	IF NEW.upd_user_id IS NULL THEN
		SET NEW.upd_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.upd_datetime = CURRENT_TIMESTAMP;
	SET NEW.upd_user_name = ufn_get_user_name(NEW.upd_user_id);
	SET NEW.upd_user_agent = ufn_get_user_agent(NEW.upd_user_id);
	SET NEW.upd_ip = ufn_get_ip(NEW.upd_user_id);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER mtb_users_AFTER_UPDATE AFTER UPDATE ON mtb_users FOR EACH ROW
BEGIN
	INSERT INTO mtb_users_history(
			history_record_divide
		,	user_id
		,	user_password
		,	user_name
		,	user_name_kana
		,	user_group_id
		,	management_cd
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
		,	del_flag
		,	del_datetime
		,	del_user_id
		,	del_user_name
		,	del_user_agent
		,	del_ip
	)
	VALUES(
			'U'
		,	NEW.user_id
		,	NEW.user_password
		,	NEW.user_name
		,	NEW.user_name_kana
		,	NEW.user_group_id
		,	NEW.management_cd
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
		,	NEW.del_flag
		,	NEW.del_datetime
		,	NEW.del_user_id
		,	NEW.del_user_name
		,	NEW.del_user_agent
		,	NEW.del_ip
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER mtb_users_AFTER_DELETE AFTER DELETE ON mtb_users FOR EACH ROW
BEGIN
	INSERT INTO mtb_users_history(
			history_record_divide
		,	user_id
		,	user_password
		,	user_name
		,	user_name_kana
		,	user_group_id
		,	management_cd
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
		,	del_flag
		,	del_datetime
		,	del_user_id
		,	del_user_name
		,	del_user_agent
		,	del_ip
	)
	VALUES(
			'D'
		,	OLD.user_id
		,	OLD.user_password
		,	OLD.user_name
		,	OLD.user_name_kana
		,	OLD.user_group_id
		,	OLD.management_cd
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
		,	OLD.del_flag
		,	OLD.del_datetime
		,	OLD.del_user_id
		,	OLD.del_user_name
		,	OLD.del_user_agent
		,	OLD.del_ip
	);
END;//


delimiter ;
