delimiter //
/** テーブル作成 **/
CREATE TABLE sys_csv_management(
	function_id					varchar(10)			NOT NULL							COMMENT '機能ID'
,	process_divide				tinyint				NOT NULL DEFAULT 1					COMMENT '処理区分'
,	file_name					nvarchar(20)		NOT NULL							COMMENT '出力ファイル名'
,	is_output_header			tinyint				NOT NULL DEFAULT 1					COMMENT 'ヘッダーを出力するか'
,	is_output_number			tinyint				NOT NULL DEFAULT 1					COMMENT '行番号を出力するか'
,	add_datetime				datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)			DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text				DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)			DEFAULT NULL						COMMENT '追加IP'
,	PRIMARY KEY (function_id,process_divide)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CSV出力ファイル管理マスタ (CSV出力ファイル情報を管理する)';//

/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER sys_csv_management_BEFORE_INSERT BEFORE INSERT ON sys_csv_management FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = ufn_get_ip(NEW.add_user_id);
END;//


/** INSERT トリガー **/
CREATE TRIGGER sys_csv_management_AFTER_INSERT AFTER INSERT ON sys_csv_management FOR EACH ROW
BEGIN
	INSERT INTO sys_csv_management_history(
			history_record_divide
		,	function_id
		,	process_divide
		,	file_name
		,	is_output_header
		,	is_output_number
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'I'
		,	NEW.function_id
		,	NEW.process_divide
		,	NEW.file_name
		,	NEW.is_output_header
		,	NEW.is_output_number
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER sys_csv_management_AFTER_UPDATE AFTER UPDATE ON sys_csv_management FOR EACH ROW
BEGIN
	INSERT INTO sys_csv_management_history(
			history_record_divide
		,	function_id
		,	process_divide
		,	file_name
		,	is_output_header
		,	is_output_number
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'U'
		,	NEW.function_id
		,	NEW.process_divide
		,	NEW.file_name
		,	NEW.is_output_header
		,	NEW.is_output_number
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER sys_csv_management_AFTER_DELETE AFTER DELETE ON sys_csv_management FOR EACH ROW
BEGIN
	INSERT INTO sys_csv_management_history(
			history_record_divide
		,	function_id
		,	process_divide
		,	file_name
		,	is_output_header
		,	is_output_number
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'D'
		,	OLD.function_id
		,	OLD.process_divide
		,	OLD.file_name
		,	OLD.is_output_header
		,	OLD.is_output_number
		,	OLD.add_datetime
		,	OLD.add_user_id
		,	OLD.add_user_name
		,	OLD.add_user_agent
		,	OLD.add_ip
	);
END;//


delimiter ;
