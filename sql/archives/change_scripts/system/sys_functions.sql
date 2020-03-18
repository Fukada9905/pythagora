delimiter //
/** テーブル作成 **/
CREATE TABLE sys_functions(
	function_id					varchar(10)			NOT NULL							COMMENT '機能ID'
,	function_name				nvarchar(40)		NOT NULL							COMMENT 'メニュー名'
,	function_divide				tinyint				NOT NULL							COMMENT '機能区分'
,	icon_name					varchar(50)			DEFAULT NULL						COMMENT 'アイコン名'
,	add_datetime				datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)			DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text				DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)			DEFAULT NULL						COMMENT '追加IP'
,	PRIMARY KEY (function_id)
,	KEY IX_sys_functions_function_divide (function_divide)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='機能管理マスタ (機能一覧を保持する)';//

/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER sys_functions_BEFORE_INSERT BEFORE INSERT ON sys_functions FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = ufn_get_ip(NEW.add_user_id);
END;//


/** INSERT トリガー **/
CREATE TRIGGER sys_functions_AFTER_INSERT AFTER INSERT ON sys_functions FOR EACH ROW
BEGIN
	INSERT INTO sys_functions_history(
			history_record_divide
		,	function_id
		,	function_name
		,	function_divide
		,	icon_name
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'I'
		,	NEW.function_id
		,	NEW.function_name
		,	NEW.function_divide
		,	NEW.icon_name
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER sys_functions_AFTER_UPDATE AFTER UPDATE ON sys_functions FOR EACH ROW
BEGIN
	INSERT INTO sys_functions_history(
			history_record_divide
		,	function_id
		,	function_name
		,	function_divide
		,	icon_name
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'U'
		,	NEW.function_id
		,	NEW.function_name
		,	NEW.function_divide
		,	NEW.icon_name
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER sys_functions_AFTER_DELETE AFTER DELETE ON sys_functions FOR EACH ROW
BEGIN
	INSERT INTO sys_functions_history(
			history_record_divide
		,	function_id
		,	function_name
		,	function_divide
		,	icon_name
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'D'
		,	OLD.function_id
		,	OLD.function_name
		,	OLD.function_divide
		,	OLD.icon_name
		,	OLD.add_datetime
		,	OLD.add_user_id
		,	OLD.add_user_name
		,	OLD.add_user_agent
		,	OLD.add_ip
	);
END;//


delimiter ;
