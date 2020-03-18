delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_arrival_schedules_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	id							bigint					NOT NULL 							COMMENT '在庫管理ID'
,	JitsuCase 					int 					DEFAULT 0 NOT NULL 					COMMENT '実ケース'
,	JitsuBara 					int 					DEFAULT 0 NOT NULL 					COMMENT '実バラ'
,	Comment 					varchar(255) 			DEFAULT NULL 						COMMENT 'コメント'
,	Reporter 					varchar(20) 			DEFAULT NULL 						COMMENT '報告者'
,	ReportDatetime 				datetime 				DEFAULT NULL 						COMMENT '報告日時'
,	Status 						tinyint 				DEFAULT NULL 						COMMENT 'ステータス'
,	Registrant 					varchar(20) 			DEFAULT NULL 						COMMENT '入荷登録者'
,	Registdatetime 				datetime 				DEFAULT NULL 						COMMENT '入荷登録日時'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用入荷テーブルの履歴保持を行う';//

delimiter ;
