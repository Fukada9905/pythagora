delimiter //
/** テーブル作成 **/
CREATE TABLE arrival_schedule_details(
	ID							int					NOT NULL							COMMENT '入荷予定ID'
,	DENGNO						int					NOT NULL							COMMENT '伝票行番号'
,	NIBKNRDENGNO				int					NOT NULL							COMMENT '内部管理伝票行番号'
,	SHCD						varchar(10)			NOT NULL							COMMENT '商品コード'
,	SHNM						varchar(50)			DEFAULT NULL						COMMENT '製品名称'
,	JGSCD_SK					varchar(10)			NOT NULL							COMMENT '出荷元事業所コード'
,	JGSNM_SK					varchar(50)			NOT NULL							COMMENT '出荷元事業所名称'
,	SNTCD_SK					varchar(10)			NOT NULL							COMMENT '出荷元センターコード'
,	SNTNM_SK					varchar(50)			NOT NULL							COMMENT '出荷元センター名称'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	SEKKBN						varchar(4)			NOT NULL							COMMENT '請求区分'
,	SHNKKKMEI_KS				varchar(20)			DEFAULT NULL						COMMENT '規格_ケース'
,	SHNKKKMEI_CU				varchar(20)			DEFAULT NULL						COMMENT '規格_中間'
,	SHNKKKMEI_BR				varchar(20)			DEFAULT NULL						COMMENT '規格_バラ'
,	RTNO						varchar(20)			NOT NULL							COMMENT 'ロット'
,	SR1RS						int					NOT NULL DEFAULT 0					COMMENT 'ケース入目'
,	SR2RS						int					NOT NULL DEFAULT 0					COMMENT 'バラ入目'
,	PL							int					NOT NULL DEFAULT 0					COMMENT 'パレット積付数'
,	KHKBN						tinyint				NOT NULL DEFAULT 0					COMMENT '梱端区分'
,	KKTSR1						int					NOT NULL DEFAULT 0					COMMENT '入荷予定ケース数量'
,	KKTSR2						int					NOT NULL DEFAULT 0					COMMENT '中間数量'
,	KKTSR3						int					NOT NULL DEFAULT 0					COMMENT '入荷予定バラ数量'
,	WGT							decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '入荷予定総重量'
,	LOTK						varchar(2)			NOT NULL							COMMENT '管理区分'
,	LOTS						varchar(2)			NOT NULL							COMMENT '出荷区分'
,	FCKBNKK						varchar(3)			NOT NULL							COMMENT '工場コード'
,	TRKMJ						datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'DB取込時間'
,	JitsuCase					int					DEFAULT NULL						COMMENT '実ケース'
,	JitsuBara					int					DEFAULT NULL						COMMENT '実バラ'
,	Comment						varchar(255)		DEFAULT NULL						COMMENT 'コメント'
,	Reporter					varchar(20)			DEFAULT NULL						COMMENT '報告者'
,	ReportDatetime				datetime			DEFAULT NULL						COMMENT '報告日時'
,	Status						tinyint				DEFAULT NULL						COMMENT 'ステータス'
,	PRIMARY KEY (ID,DENGNO,NIBKNRDENGNO,SHCD,JGSCD_SK,SNTCD_SK,RTNO,LOTK,LOTS,FCKBNKK)
,	KEY IX_arrival_schedule_details_ID (ID)
,	KEY IX_arrival_schedule_details_DENGNO (DENGNO)
,	KEY IX_arrival_schedule_details_NIBKNRDENGNO (NIBKNRDENGNO)
,	KEY IX_arrival_schedule_details_SHCD (SHCD)
,	KEY IX_arrival_schedule_details_JGSCD_SK_SNTCD_SK (JGSCD_SK,SNTCD_SK)
,	KEY IX_arrival_schedule_details_RTNO (RTNO)
,	KEY IX_arrival_schedule_details_TRKMJ (TRKMJ)
,	CONSTRAINT FK_arrival_schedule_details_arrival_schedules
		FOREIGN KEY (ID) REFERENCES arrival_schedules (ID)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入荷予定BODY (入荷予定明細テーブル)';//

/** INSERT トリガー **/
CREATE TRIGGER arrival_schedule_details_AFTER_INSERT AFTER INSERT ON arrival_schedule_details FOR EACH ROW
BEGIN
	INSERT INTO arrival_schedule_details_history(
			history_record_divide
		,	ID
		,	DENGNO
		,	NIBKNRDENGNO
		,	SHCD
		,	SHNM
		,	JGSCD_SK
		,	JGSNM_SK
		,	SNTCD_SK
		,	SNTNM_SK
		,	DNRK
		,	SEKKBN
		,	SHNKKKMEI_KS
		,	SHNKKKMEI_CU
		,	SHNKKKMEI_BR
		,	RTNO
		,	SR1RS
		,	SR2RS
		,	PL
		,	KHKBN
		,	KKTSR1
		,	KKTSR2
		,	KKTSR3
		,	WGT
		,	LOTK
		,	LOTS
		,	FCKBNKK
		,	TRKMJ
		,	JitsuCase
		,	JitsuBara
		,	Comment
		,	Reporter
		,	ReportDatetime
		,	Status
	)
	VALUES(
			'I'
		,	NEW.ID
		,	NEW.DENGNO
		,	NEW.NIBKNRDENGNO
		,	NEW.SHCD
		,	NEW.SHNM
		,	NEW.JGSCD_SK
		,	NEW.JGSNM_SK
		,	NEW.SNTCD_SK
		,	NEW.SNTNM_SK
		,	NEW.DNRK
		,	NEW.SEKKBN
		,	NEW.SHNKKKMEI_KS
		,	NEW.SHNKKKMEI_CU
		,	NEW.SHNKKKMEI_BR
		,	NEW.RTNO
		,	NEW.SR1RS
		,	NEW.SR2RS
		,	NEW.PL
		,	NEW.KHKBN
		,	NEW.KKTSR1
		,	NEW.KKTSR2
		,	NEW.KKTSR3
		,	NEW.WGT
		,	NEW.LOTK
		,	NEW.LOTS
		,	NEW.FCKBNKK
		,	NEW.TRKMJ
		,	NEW.JitsuCase
		,	NEW.JitsuBara
		,	NEW.Comment
		,	NEW.Reporter
		,	NEW.ReportDatetime
		,	NEW.Status
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER arrival_schedule_details_AFTER_UPDATE AFTER UPDATE ON arrival_schedule_details FOR EACH ROW
BEGIN
	INSERT INTO arrival_schedule_details_history(
			history_record_divide
		,	ID
		,	DENGNO
		,	NIBKNRDENGNO
		,	SHCD
		,	SHNM
		,	JGSCD_SK
		,	JGSNM_SK
		,	SNTCD_SK
		,	SNTNM_SK
		,	DNRK
		,	SEKKBN
		,	SHNKKKMEI_KS
		,	SHNKKKMEI_CU
		,	SHNKKKMEI_BR
		,	RTNO
		,	SR1RS
		,	SR2RS
		,	PL
		,	KHKBN
		,	KKTSR1
		,	KKTSR2
		,	KKTSR3
		,	WGT
		,	LOTK
		,	LOTS
		,	FCKBNKK
		,	TRKMJ
		,	JitsuCase
		,	JitsuBara
		,	Comment
		,	Reporter
		,	ReportDatetime
		,	Status
	)
	VALUES(
			'U'
		,	NEW.ID
		,	NEW.DENGNO
		,	NEW.NIBKNRDENGNO
		,	NEW.SHCD
		,	NEW.SHNM
		,	NEW.JGSCD_SK
		,	NEW.JGSNM_SK
		,	NEW.SNTCD_SK
		,	NEW.SNTNM_SK
		,	NEW.DNRK
		,	NEW.SEKKBN
		,	NEW.SHNKKKMEI_KS
		,	NEW.SHNKKKMEI_CU
		,	NEW.SHNKKKMEI_BR
		,	NEW.RTNO
		,	NEW.SR1RS
		,	NEW.SR2RS
		,	NEW.PL
		,	NEW.KHKBN
		,	NEW.KKTSR1
		,	NEW.KKTSR2
		,	NEW.KKTSR3
		,	NEW.WGT
		,	NEW.LOTK
		,	NEW.LOTS
		,	NEW.FCKBNKK
		,	NEW.TRKMJ
		,	NEW.JitsuCase
		,	NEW.JitsuBara
		,	NEW.Comment
		,	NEW.Reporter
		,	NEW.ReportDatetime
		,	NEW.Status
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER arrival_schedule_details_AFTER_DELETE AFTER DELETE ON arrival_schedule_details FOR EACH ROW
BEGIN
	INSERT INTO arrival_schedule_details_history(
			history_record_divide
		,	ID
		,	DENGNO
		,	NIBKNRDENGNO
		,	SHCD
		,	SHNM
		,	JGSCD_SK
		,	JGSNM_SK
		,	SNTCD_SK
		,	SNTNM_SK
		,	DNRK
		,	SEKKBN
		,	SHNKKKMEI_KS
		,	SHNKKKMEI_CU
		,	SHNKKKMEI_BR
		,	RTNO
		,	SR1RS
		,	SR2RS
		,	PL
		,	KHKBN
		,	KKTSR1
		,	KKTSR2
		,	KKTSR3
		,	WGT
		,	LOTK
		,	LOTS
		,	FCKBNKK
		,	TRKMJ
		,	JitsuCase
		,	JitsuBara
		,	Comment
		,	Reporter
		,	ReportDatetime
		,	Status
	)
	VALUES(
			'D'
		,	OLD.ID
		,	OLD.DENGNO
		,	OLD.NIBKNRDENGNO
		,	OLD.SHCD
		,	OLD.SHNM
		,	OLD.JGSCD_SK
		,	OLD.JGSNM_SK
		,	OLD.SNTCD_SK
		,	OLD.SNTNM_SK
		,	OLD.DNRK
		,	OLD.SEKKBN
		,	OLD.SHNKKKMEI_KS
		,	OLD.SHNKKKMEI_CU
		,	OLD.SHNKKKMEI_BR
		,	OLD.RTNO
		,	OLD.SR1RS
		,	OLD.SR2RS
		,	OLD.PL
		,	OLD.KHKBN
		,	OLD.KKTSR1
		,	OLD.KKTSR2
		,	OLD.KKTSR3
		,	OLD.WGT
		,	OLD.LOTK
		,	OLD.LOTS
		,	OLD.FCKBNKK
		,	OLD.TRKMJ
		,	OLD.JitsuCase
		,	OLD.JitsuBara
		,	OLD.Comment
		,	OLD.Reporter
		,	OLD.ReportDatetime
		,	OLD.Status
	);
END;//


delimiter ;
