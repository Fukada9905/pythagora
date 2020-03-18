DROP TABLE IF EXISTS pyt_t_shaban_tc_details_history;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_shaban_tc_details_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	id							int 					NOT NULL 							COMMENT '車番管理ID'
,	detail_no					int						NOT NULL							COMMENT '明細番号' 
,	transporter_name			varchar(60)				DEFAULT NULL						COMMENT '運送会社'
,	shaban						varchar(60)				DEFAULT NULL						COMMENT '車番'
,	kizai						varchar(60)				DEFAULT NULL						COMMENT '機材'
,	jomuin						varchar(60)				DEFAULT NULL						COMMENT '乗務員'
,	tel							varchar(60)				DEFAULT NULL						COMMENT '携帯番号'
,	remarks						varchar(100)			DEFAULT NULL						COMMENT '備考'
,	status						tinyint					DEFAULT NULL						COMMENT 'ステータス'
,	departure_datetime			datetime				DEFAULT NULL						COMMENT '出発時間'
,	departure_upduser			varchar(10)				DEFAULT NULL						COMMENT '出発時間更新ユーザー'
,	arrival_datetime			datetime				DEFAULT NULL						COMMENT '到着時間'
,	arrival_upduser				varchar(10)				DEFAULT NULL						COMMENT '到着時間更新ユーザー'
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用車番明細テーブル(TC幹線)の履歴保持を行う';//

delimiter ;
