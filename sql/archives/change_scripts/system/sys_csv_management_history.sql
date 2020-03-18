delimiter //
/** テーブル作成 **/
CREATE TABLE sys_csv_management_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	function_id					varchar(10)				NOT NULL							COMMENT '機能ID'
,	process_divide				tinyint					NOT NULL DEFAULT 1					COMMENT '処理区分'
,	file_name					nvarchar(20)			NOT NULL							COMMENT '出力ファイル名'
,	is_output_header			tinyint					NOT NULL DEFAULT 1					COMMENT 'ヘッダーを出力するか'
,	is_output_number			tinyint					NOT NULL DEFAULT 1					COMMENT '行番号を出力するか'
,	add_datetime				datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)				DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)			DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text					DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)				DEFAULT NULL						COMMENT '追加IP'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='CSV出力ファイル管理マスタの履歴保持を行う)';//

delimiter ;
