delimiter //
/** テーブル作成 **/
CREATE TABLE mtb_menus_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	menu_id						int UNSIGNED			NOT NULL							COMMENT 'メニュー管理ID'
,	user_group_id				varchar(10)				NOT NULL							COMMENT 'ユーザーグループ名'
,	function_id					varchar(10)				NOT NULL							COMMENT '機能ID'
,	menu_name					nvarchar(40)			DEFAULT NULL						COMMENT 'メニュー名'
,	position_order				tinyint UNSIGNED		NOT NULL DEFAULT 0					COMMENT '表示順'
,	params						varchar(100)			DEFAULT NULL						COMMENT 'パラメータ'
,	parent_function_id			varchar(10)				DEFAULT NULL						COMMENT '親機能ID'
,	add_datetime				datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)				DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)			DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text					DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)				DEFAULT NULL						COMMENT '追加IP'
,	del_flag					tinyint					NOT NULL DEFAULT 0					COMMENT '削除フラグ'
,	del_datetime				datetime				DEFAULT NULL						COMMENT '削除日時'
,	del_user_id					varchar(15)				DEFAULT NULL						COMMENT '削除ユーザーID'
,	del_user_name				nvarchar(40)			DEFAULT NULL						COMMENT '削除ユーザー名'
,	del_user_agent				varchar(255)			DEFAULT NULL						COMMENT '削除ユーザーエージェント'
,	del_ip						varchar(15)				DEFAULT NULL						COMMENT '削除IP'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='メニュー管理マスタの履歴保持を行う)';//

delimiter ;
