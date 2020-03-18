delimiter //
/** テーブル作成 **/
CREATE TABLE shipment_confirm_details(
	ID							int					NOT NULL							COMMENT '出荷ID'
,	JGSCD						varchar(10)			NOT NULL							COMMENT '事業所コード'
,	JGSNM						varchar(50)			NOT NULL							COMMENT '事業所名称'
,	SNTCD						varchar(10)			NOT NULL							COMMENT 'センターコード'
,	SNTNM						varchar(50)			NOT NULL							COMMENT 'センター名称'
,	DENGNO						int					NOT NULL							COMMENT '伝票行番号'
,	SHCD						varchar(10)			NOT NULL							COMMENT '商品コード'
,	SHNM						varchar(50)			NOT NULL							COMMENT '製品名称'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	SEKKBN						varchar(4)			NOT NULL							COMMENT '請求区分'
,	SHNKKKMEI_KS				varchar(20)			DEFAULT NULL						COMMENT '規格_ケース'
,	SHNKKKMEI_CU				varchar(20)			DEFAULT NULL						COMMENT '規格_中間'
,	SHNKKKMEI_BR				varchar(20)			DEFAULT NULL						COMMENT '規格_バラ'
,	RTNO						varchar(20)			NOT NULL							COMMENT 'ロット'
,	SR1RS						int					NOT NULL							COMMENT 'ケース入目'
,	SR2RS						int					NOT NULL							COMMENT 'バラ入目'
,	PL							int					NOT NULL DEFAULT 0					COMMENT 'パレット積付数'
,	KHKBN						tinyint				NOT NULL DEFAULT 0					COMMENT '梱端区分'
,	KKTSR1						int					NOT NULL DEFAULT 0					COMMENT 'ケース数量'
,	KKTSR2						int					NOT NULL DEFAULT 0					COMMENT '中間数量'
,	KKTSR3						int					NOT NULL DEFAULT 0					COMMENT 'バラ数量'
,	KKTSSR						int					NOT NULL DEFAULT 0					COMMENT '総バラ数量'
,	WGT							decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '総重量'
,	LOTK						varchar(2)			NOT NULL							COMMENT '管理区分'
,	LOTS						varchar(2)			NOT NULL							COMMENT '出荷区分'
,	FCKBNKK						varchar(3)			NOT NULL							COMMENT '工場コード'
,	TRKMJ						datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'DB取込時間'
,	PRIMARY KEY (ID,JGSCD,SNTCD,DENGNO,SHCD,RTNO,LOTK,LOTS,FCKBNKK)
,	KEY IX_shipment_confirm_details_ID (ID)
,	KEY IX_shipment_confirm_details_JGSCD_SNTCD (ID,JGSCD,SNTCD)
,	KEY IX_shipment_confirm_details_DENGNO (DENGNO)
,	KEY IX_shipment_confirm_details_SHCD (SHCD)
,	KEY IX_shipment_confirm_details_RTNO (RTNO)
,	CONSTRAINT FK_shipment_confirm_details_shipment_confirms
		FOREIGN KEY (ID) REFERENCES shipment_confirms (ID)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出荷確定BODY (出荷確定明細テーブル)';//

/** INSERT トリガー **/
CREATE TRIGGER shipment_confirm_details_AFTER_INSERT AFTER INSERT ON shipment_confirm_details FOR EACH ROW
BEGIN
	INSERT INTO shipment_confirm_details_history(
			history_record_divide
		,	ID
		,	JGSCD
		,	JGSNM
		,	SNTCD
		,	SNTNM
		,	DENGNO
		,	SHCD
		,	SHNM
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
		,	KKTSSR
		,	WGT
		,	LOTK
		,	LOTS
		,	FCKBNKK
		,	TRKMJ
	)
	VALUES(
			'I'
		,	NEW.ID
		,	NEW.JGSCD
		,	NEW.JGSNM
		,	NEW.SNTCD
		,	NEW.SNTNM
		,	NEW.DENGNO
		,	NEW.SHCD
		,	NEW.SHNM
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
		,	NEW.KKTSSR
		,	NEW.WGT
		,	NEW.LOTK
		,	NEW.LOTS
		,	NEW.FCKBNKK
		,	NEW.TRKMJ
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER shipment_confirm_details_AFTER_UPDATE AFTER UPDATE ON shipment_confirm_details FOR EACH ROW
BEGIN
	INSERT INTO shipment_confirm_details_history(
			history_record_divide
		,	ID
		,	JGSCD
		,	JGSNM
		,	SNTCD
		,	SNTNM
		,	DENGNO
		,	SHCD
		,	SHNM
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
		,	KKTSSR
		,	WGT
		,	LOTK
		,	LOTS
		,	FCKBNKK
		,	TRKMJ
	)
	VALUES(
			'U'
		,	NEW.ID
		,	NEW.JGSCD
		,	NEW.JGSNM
		,	NEW.SNTCD
		,	NEW.SNTNM
		,	NEW.DENGNO
		,	NEW.SHCD
		,	NEW.SHNM
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
		,	NEW.KKTSSR
		,	NEW.WGT
		,	NEW.LOTK
		,	NEW.LOTS
		,	NEW.FCKBNKK
		,	NEW.TRKMJ
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER shipment_confirm_details_AFTER_DELETE AFTER DELETE ON shipment_confirm_details FOR EACH ROW
BEGIN
	INSERT INTO shipment_confirm_details_history(
			history_record_divide
		,	ID
		,	JGSCD
		,	JGSNM
		,	SNTCD
		,	SNTNM
		,	DENGNO
		,	SHCD
		,	SHNM
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
		,	KKTSSR
		,	WGT
		,	LOTK
		,	LOTS
		,	FCKBNKK
		,	TRKMJ
	)
	VALUES(
			'D'
		,	OLD.ID
		,	OLD.JGSCD
		,	OLD.JGSNM
		,	OLD.SNTCD
		,	OLD.SNTNM
		,	OLD.DENGNO
		,	OLD.SHCD
		,	OLD.SHNM
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
		,	OLD.KKTSSR
		,	OLD.WGT
		,	OLD.LOTK
		,	OLD.LOTS
		,	OLD.FCKBNKK
		,	OLD.TRKMJ
	);
END;//


delimiter ;
