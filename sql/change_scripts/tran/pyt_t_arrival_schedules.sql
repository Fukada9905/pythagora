delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_arrival_schedules(
	id					bigint 			NOT NULL 			COMMENT '在庫管理ID'
,	JitsuCase 			int 			DEFAULT 0 NOT NULL 	COMMENT '実ケース'
,	JitsuBara 			int 			DEFAULT 0 NOT NULL 	COMMENT '実バラ'
,	Comment 			varchar(255) 	DEFAULT NULL 		COMMENT 'コメント'
,	Reporter 			varchar(20) 	DEFAULT NULL 		COMMENT '報告者'
,	ReportDatetime 		datetime 		DEFAULT NULL 		COMMENT '報告日時'
,	Status 				tinyint 		DEFAULT NULL 		COMMENT 'ステータス'
,	Registrant 			varchar(20) 	DEFAULT NULL 		COMMENT '入荷登録者'
,	Registdatetime 		datetime 		DEFAULT NULL 		COMMENT '入荷登録日時'
,	PRIMARY KEY (id)
,	CONSTRAINT FK_pyt_t_arrival_schedules_t_arrival
		FOREIGN KEY (id) REFERENCES t_arrival (id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用 入荷テーブル';//

/** INSERT トリガー **/
CREATE TRIGGER pyt_t_arrival_schedules_AFTER_INSERT AFTER INSERT ON pyt_t_arrival_schedules FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_arrival_schedules_history(
			history_record_divide
		,	id
		,	JitsuCase
		,	JitsuBara
		,	Comment
		,	Reporter
		,	ReportDatetime
		,	Status
		,	Registrant
		,	Registdatetime		
	)
	VALUES(
			'I'
		,	NEW.id
		,	NEW.JitsuCase
		,	NEW.JitsuBara
		,	NEW.Comment
		,	NEW.Reporter
		,	NEW.ReportDatetime
		,	NEW.Status
		,	NEW.Registrant
		,	NEW.Registdatetime		
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER pyt_t_arrival_schedules_AFTER_UPDATE AFTER UPDATE ON pyt_t_arrival_schedules FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_arrival_schedules_history(
			history_record_divide
		,	id
		,	JitsuCase
		,	JitsuBara
		,	Comment
		,	Reporter
		,	ReportDatetime
		,	Status
		,	Registrant
		,	Registdatetime	
	)
	VALUES(
			'U'
		,	NEW.id
		,	NEW.JitsuCase
		,	NEW.JitsuBara
		,	NEW.Comment
		,	NEW.Reporter
		,	NEW.ReportDatetime
		,	NEW.Status
		,	NEW.Registrant
		,	NEW.Registdatetime	
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER pyt_t_arrival_schedules_AFTER_DELETE AFTER DELETE ON pyt_t_arrival_schedules FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_arrival_schedules_history(
			history_record_divide
		,	id
		,	JitsuCase
		,	JitsuBara
		,	Comment
		,	Reporter
		,	ReportDatetime
		,	Status
		,	Registrant
		,	Registdatetime	
	)
	VALUES(
			'D'
		,	OLD.id
		,	OLD.JitsuCase
		,	OLD.JitsuBara
		,	OLD.Comment
		,	OLD.Reporter
		,	OLD.ReportDatetime
		,	OLD.Status
		,	OLD.Registrant
		,	OLD.Registdatetime	
	);
END;//


delimiter ;
