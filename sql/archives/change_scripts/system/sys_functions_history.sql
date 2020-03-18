delimiter //
/** テーブル作成 **/
CREATE TABLE sys_functions_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	function_id					varchar(10)				NOT NULL							COMMENT '機能ID'
,	function_name				nvarchar(40)			NOT NULL							COMMENT 'メニュー名'
,	function_divide				tinyint					NOT NULL							COMMENT '機能区分'
,	icon_name					varchar(50)				DEFAULT NULL						COMMENT 'アイコン名'
,	add_datetime				datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)				DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)			DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text					DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)				DEFAULT NULL						COMMENT '追加IP'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='機能管理マスタの履歴保持を行う)';//

delimiter ;
