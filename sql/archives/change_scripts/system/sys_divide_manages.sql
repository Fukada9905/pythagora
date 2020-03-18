delimiter //
/** テーブル作成 **/
CREATE TABLE sys_divide_manages(
	divide_id					smallint UNSIGNED	NOT NULL							COMMENT '区分ID'
,	divide_cd					smallint			NOT NULL							COMMENT '区分コード'
,	divide_name					nvarchar(40)		DEFAULT NULL						COMMENT '区分名'
,	add_datetime				datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)			DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text				DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)			DEFAULT NULL						COMMENT '追加IP'
,	PRIMARY KEY (divide_id)
,	KEY IX_sys_divide_manages_divide_cd (divide_cd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='区分マスタ (区分管理を行う)';//

/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER sys_divide_manages_BEFORE_INSERT BEFORE INSERT ON sys_divide_manages FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = ufn_get_ip(NEW.add_user_id);
END;//


/** INSERT トリガー **/
CREATE TRIGGER sys_divide_manages_AFTER_INSERT AFTER INSERT ON sys_divide_manages FOR EACH ROW
BEGIN
	INSERT INTO sys_divide_manages_history(
			history_record_divide
		,	divide_id
		,	divide_cd
		,	divide_name
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'I'
		,	NEW.divide_id
		,	NEW.divide_cd
		,	NEW.divide_name
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER sys_divide_manages_AFTER_UPDATE AFTER UPDATE ON sys_divide_manages FOR EACH ROW
BEGIN
	INSERT INTO sys_divide_manages_history(
			history_record_divide
		,	divide_id
		,	divide_cd
		,	divide_name
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'U'
		,	NEW.divide_id
		,	NEW.divide_cd
		,	NEW.divide_name
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER sys_divide_manages_AFTER_DELETE AFTER DELETE ON sys_divide_manages FOR EACH ROW
BEGIN
	INSERT INTO sys_divide_manages_history(
			history_record_divide
		,	divide_id
		,	divide_cd
		,	divide_name
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'D'
		,	OLD.divide_id
		,	OLD.divide_cd
		,	OLD.divide_name
		,	OLD.add_datetime
		,	OLD.add_user_id
		,	OLD.add_user_name
		,	OLD.add_user_agent
		,	OLD.add_ip
	);
END;//


delimiter ;
