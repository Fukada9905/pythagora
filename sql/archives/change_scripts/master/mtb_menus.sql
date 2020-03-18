delimiter //
/** テーブル作成 **/
CREATE TABLE mtb_menus(
	menu_id						int UNSIGNED		NOT NULL AUTO_INCREMENT				COMMENT 'メニュー管理ID'
,	user_group_id				varchar(10)			NOT NULL							COMMENT 'ユーザーグループ名'
,	function_id					varchar(10)			NOT NULL							COMMENT '機能ID'
,	menu_name					nvarchar(40)		DEFAULT NULL						COMMENT 'メニュー名'
,	position_order				tinyint UNSIGNED	NOT NULL DEFAULT 0					COMMENT '表示順'
,	params						varchar(100)		DEFAULT NULL						COMMENT 'パラメータ'
,	parent_function_id			varchar(10)			DEFAULT NULL						COMMENT '親機能ID'
,	add_datetime				datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)			DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text				DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)			DEFAULT NULL						COMMENT '追加IP'
,	del_flag					tinyint				NOT NULL DEFAULT 0					COMMENT '削除フラグ'
,	del_datetime				datetime			DEFAULT NULL						COMMENT '削除日時'
,	del_user_id					varchar(15)			DEFAULT NULL						COMMENT '削除ユーザーID'
,	del_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '削除ユーザー名'
,	del_user_agent				varchar(255)		DEFAULT NULL						COMMENT '削除ユーザーエージェント'
,	del_ip						varchar(15)			DEFAULT NULL						COMMENT '削除IP'
,	PRIMARY KEY (menu_id)
,	KEY IX_mtb_menus_user_group_id (user_group_id)
,	KEY IX_mtb_menus_function_id (function_id)
,	KEY IX_mtb_menus_position_order (position_order)
,	KEY IX_mtb_menus_parent_function_id (parent_function_id)
,	KEY IX_mtb_menus_del_flag (del_flag)
,	CONSTRAINT FK_mtb_menus_mtb_user_groups
		FOREIGN KEY (user_group_id) REFERENCES mtb_user_groups (user_group_id)
		ON DELETE CASCADE ON UPDATE CASCADE
,	CONSTRAINT FK_mtb_menus_sys_functions
		FOREIGN KEY (function_id) REFERENCES sys_functions (function_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='メニュー管理マスタ (ユーザーグループ毎に表示メニューの管理を行う)';//

/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER mtb_menus_BEFORE_INSERT BEFORE INSERT ON mtb_menus FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = ufn_get_ip(NEW.add_user_id);
END;//


/** INSERT トリガー **/
CREATE TRIGGER mtb_menus_AFTER_INSERT AFTER INSERT ON mtb_menus FOR EACH ROW
BEGIN
	INSERT INTO mtb_menus_history(
			history_record_divide
		,	menu_id
		,	user_group_id
		,	function_id
		,	menu_name
		,	position_order
		,	params
		,	parent_function_id
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
		,	del_flag
		,	del_datetime
		,	del_user_id
		,	del_user_name
		,	del_user_agent
		,	del_ip
	)
	VALUES(
			'I'
		,	NEW.menu_id
		,	NEW.user_group_id
		,	NEW.function_id
		,	NEW.menu_name
		,	NEW.position_order
		,	NEW.params
		,	NEW.parent_function_id
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
		,	NEW.del_flag
		,	NEW.del_datetime
		,	NEW.del_user_id
		,	NEW.del_user_name
		,	NEW.del_user_agent
		,	NEW.del_ip
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER mtb_menus_AFTER_UPDATE AFTER UPDATE ON mtb_menus FOR EACH ROW
BEGIN
	INSERT INTO mtb_menus_history(
			history_record_divide
		,	menu_id
		,	user_group_id
		,	function_id
		,	menu_name
		,	position_order
		,	params
		,	parent_function_id
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
		,	del_flag
		,	del_datetime
		,	del_user_id
		,	del_user_name
		,	del_user_agent
		,	del_ip
	)
	VALUES(
			'U'
		,	NEW.menu_id
		,	NEW.user_group_id
		,	NEW.function_id
		,	NEW.menu_name
		,	NEW.position_order
		,	NEW.params
		,	NEW.parent_function_id
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
		,	NEW.del_flag
		,	NEW.del_datetime
		,	NEW.del_user_id
		,	NEW.del_user_name
		,	NEW.del_user_agent
		,	NEW.del_ip
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER mtb_menus_AFTER_DELETE AFTER DELETE ON mtb_menus FOR EACH ROW
BEGIN
	INSERT INTO mtb_menus_history(
			history_record_divide
		,	menu_id
		,	user_group_id
		,	function_id
		,	menu_name
		,	position_order
		,	params
		,	parent_function_id
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
		,	del_flag
		,	del_datetime
		,	del_user_id
		,	del_user_name
		,	del_user_agent
		,	del_ip
	)
	VALUES(
			'D'
		,	OLD.menu_id
		,	OLD.user_group_id
		,	OLD.function_id
		,	OLD.menu_name
		,	OLD.position_order
		,	OLD.params
		,	OLD.parent_function_id
		,	OLD.add_datetime
		,	OLD.add_user_id
		,	OLD.add_user_name
		,	OLD.add_user_agent
		,	OLD.add_ip
		,	OLD.del_flag
		,	OLD.del_datetime
		,	OLD.del_user_id
		,	OLD.del_user_name
		,	OLD.del_user_agent
		,	OLD.del_ip
	);
END;//


delimiter ;
