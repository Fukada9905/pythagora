DROP TABLE IF EXISTS pyt_t_shaban_history;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_shaban_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	id							int 					NOT NULL 							COMMENT '在庫管理ID'
,	shipper_code 				varchar(10) 			NOT NULL 							COMMENT '荷主コード'
,	transporter_code 			varchar(10) 			DEFAULT NULL 						COMMENT '運送業者コード'
,	transporter_name 			varchar(30) 			DEFAULT NULL 						COMMENT '運送業者名'
,	slip_number 				varchar(20) 			NOT NULL 							COMMENT '伝票番号'
,	sales_office_code 			varchar(10) 			NOT NULL 							COMMENT '倉庫事業所コード'
,	warehouse_code 				varchar(10) 			NOT NULL 							COMMENT '出荷倉庫コード'
,	warehouse_name 				varchar(30) 			DEFAULT NULL 						COMMENT '出荷倉庫名'
,	delivery_code 				varchar(20)				DEFAULT NULL 						COMMENT '納品先コード'
,	retrieval_date 				date 					NOT NULL 							COMMENT '出荷日'
,	delivery_date 				date 					DEFAULT NULL 						COMMENT '納品日'
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用車番ヘッダテーブルの履歴保持を行う';//

delimiter ;
