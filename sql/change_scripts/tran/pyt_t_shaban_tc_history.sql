DROP TABLE IF EXISTS pyt_t_shaban_tc_history;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_shaban_tc_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	id							int 					NOT NULL 							COMMENT '車番管理ID'
,	root_id						int 					NOT NULL 							COMMENT 'ルートID'
,	target_date 				date 					NOT NULL 							COMMENT '対象日'
,	dispatch_user_name			varchar(20) 			DEFAULT NULL 						COMMENT '配車担当者'
,	dispatch_user_id			varchar(15) 			DEFAULT NULL 						COMMENT '配車担当ユーザーID'
,	dispatch_datetime			datetime 				DEFAULT NULL 						COMMENT '配車更新日時'
,	departure_status			tinyint					DEFAULT NULL 						COMMENT '出発確認フラグ'
,	arrival_status				tinyint					DEFAULT NULL						COMMENT '到着確認フラグ'
,	add_datetime 				datetime 				DEFAULT NULL					 	COMMENT '追加日時'
,	add_user_id 				varchar(15) 			DEFAULT NULL 						COMMENT '追加ユーザーID'
,	add_user_name 				varchar(40) 			DEFAULT NULL 						COMMENT '追加ユーザー名'
,	add_user_agent 				text 					DEFAULT NULL 						COMMENT '追加ユーザーエージェント'
,	add_ip 						varchar(15) 			DEFAULT NULL 						COMMENT '追加IP'
,	upd_datetime 				datetime 				DEFAULT NULL 						COMMENT '更新日時'
,	upd_user_id 				varchar(15) 			DEFAULT NULL 						COMMENT '更新ユーザーID'
,	upd_user_name 				varchar(40) 			DEFAULT NULL 						COMMENT '更新ユーザー名'
,	upd_user_agent 				text 					DEFAULT NULL 						COMMENT '更新ユーザーエージェント'
,	upd_ip 						varchar(15) 			DEFAULT NULL 						COMMENT '更新IP'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用車番ヘッダテーブル(TC幹線)の履歴保持を行う';//

delimiter ;
