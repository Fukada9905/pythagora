delimiter //
/** テーブル作成 **/
CREATE TABLE shipment_provisional_details(
	ID							int					NOT NULL							COMMENT '仮出荷ID'
,	JGSCD						varchar(10)			NOT NULL							COMMENT '事業所コード'
,	JGSNM						varchar(50)			NOT NULL							COMMENT '事業所名称'
,	SNTCD						varchar(10)			NOT NULL							COMMENT 'センターコード'
,	SNTNM						varchar(50)			NOT NULL							COMMENT 'センター名称'
,	DENGNO						int					NOT NULL							COMMENT '伝票行番号'
,	SHCD						varchar(10)			NOT NULL							COMMENT '商品コード'
,	SHNM						varchar(50)			DEFAULT NULL						COMMENT '製品名称'
,	BTRUCD						varchar(10)			DEFAULT NULL						COMMENT '物流コード'
,	TITSHNCD					varchar(10)			DEFAULT NULL						COMMENT '統一商品コード'
,	GS1CD						varchar(30)			DEFAULT NULL						COMMENT 'GS1コード'
,	JANCD						varchar(30)			DEFAULT NULL						COMMENT 'JANコード'
,	ITFCD						varchar(30)			DEFAULT NULL						COMMENT 'ITFコード'
,	SPDCD						varchar(30)			DEFAULT NULL						COMMENT 'SPDコード'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	SEKKBN						varchar(10)			DEFAULT NULL						COMMENT '請求区分'
,	GKYKGKBTKBN					tinyint				NOT NULL DEFAULT 0					COMMENT '劇薬劇物区分'
,	YNUHNFRG					tinyint				NOT NULL DEFAULT 0					COMMENT '輸入品フラグ'
,	YSTHNFRG					tinyint				NOT NULL DEFAULT 0					COMMENT '輸出品フラグ'
,	KTCD						varchar(10)			DEFAULT NULL						COMMENT '型コード'
,	BUNRUI						varchar(10)			DEFAULT NULL						COMMENT '商品分類'
,	SHNKKKMEI					varchar(20)			DEFAULT NULL						COMMENT '規格'
,	JR_KS						decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '重量_ケース'
,	JR_CU						decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '重量_中間'
,	JR_BR						decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '重量_バラ'
,	SHTT_KS						int					NOT NULL DEFAULT 0					COMMENT '商品縦_ケース'
,	SHYK_KS						int					NOT NULL DEFAULT 0					COMMENT '商品横_ケース'
,	SHTKS_KS					int					NOT NULL DEFAULT 0					COMMENT '商品高さ_ケース'
,	SHTT_CU						int					NOT NULL DEFAULT 0					COMMENT '商品縦_中間'
,	SHYK_CU						int					NOT NULL DEFAULT 0					COMMENT '商品横_中間'
,	SHTKS_CU					int					NOT NULL DEFAULT 0					COMMENT '商品高さ_中間'
,	SHTT_BR						int					NOT NULL DEFAULT 0					COMMENT '商品縦_バラ'
,	SHYK_BR						int					NOT NULL DEFAULT 0					COMMENT '商品横_バラ'
,	SHTKS_BR					int					NOT NULL DEFAULT 0					COMMENT '商品高さ_バラ'
,	RTNO						varchar(20)			NOT NULL							COMMENT 'ロット'
,	RTNOSTIFLG					varchar(2)			DEFAULT NULL						COMMENT 'ロット指定フラグ'
,	SR1RS						int					NOT NULL DEFAULT 0					COMMENT 'ケース入目'
,	SR2RS						int					NOT NULL DEFAULT 0					COMMENT '中間入目'
,	SR3RS						int					NOT NULL DEFAULT 0					COMMENT 'バラ入目'
,	JTIRM						int					NOT NULL DEFAULT 0					COMMENT '実入目'
,	PL							int					NOT NULL DEFAULT 0					COMMENT 'パレット積付数'
,	JCSR1						int					NOT NULL DEFAULT 0					COMMENT '受注数量ケース'
,	JCSR2						int					NOT NULL DEFAULT 0					COMMENT '受注数量中間'
,	JCSR3						int					NOT NULL DEFAULT 0					COMMENT '受注数量バラ'
,	JCSSR						int					NOT NULL DEFAULT 0					COMMENT '受注数量総バラ'
,	JCSJR						decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '受注総重量'
,	KHKBN						tinyint				NOT NULL DEFAULT 0					COMMENT '梱端区分'
,	KKTSR1						int					NOT NULL DEFAULT 0					COMMENT 'ケース数量'
,	KKTSR2						int					NOT NULL DEFAULT 0					COMMENT '中間数量'
,	KKTSR3						int					NOT NULL DEFAULT 0					COMMENT 'バラ数量'
,	KKTSSR						int					NOT NULL DEFAULT 0					COMMENT '総バラ数量'
,	WGT							decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '総重量'
,	LOTK						varchar(2)			NOT NULL							COMMENT '管理区分'
,	LOTS						varchar(2)			NOT NULL							COMMENT '出荷区分'
,	FCKBNKK						varchar(3)			NOT NULL							COMMENT '工場コード'
,	TRKMJ						datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'ＤＢ取込時間'
,	PRIMARY KEY (ID,JGSCD,SNTCD,DENGNO,SHCD,RTNO,LOTK,LOTS,FCKBNKK)
,	KEY IX_shipment_provisional_details_ID (ID)
,	KEY IX_shipment_provisional_details_JGSCD_SNTCD (ID,JGSCD,SNTCD)
,	KEY IX_shipment_provisional_details_DENGNO (DENGNO)
,	KEY IX_shipment_provisional_details_SHCD (SHCD)
,	KEY IX_shipment_provisional_details_RTNO (RTNO)
,	CONSTRAINT FK_shipment_provisional_details_shipment_provisionals
		FOREIGN KEY (ID) REFERENCES shipment_provisionals (ID)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仮出荷BODY (仮出荷明細テーブル)';//

/** INSERT トリガー **/
CREATE TRIGGER shipment_provisional_details_AFTER_INSERT AFTER INSERT ON shipment_provisional_details FOR EACH ROW
BEGIN
	INSERT INTO shipment_provisional_details_history(
			history_record_divide
		,	ID
		,	JGSCD
		,	JGSNM
		,	SNTCD
		,	SNTNM
		,	DENGNO
		,	SHCD
		,	SHNM
		,	BTRUCD
		,	TITSHNCD
		,	GS1CD
		,	JANCD
		,	ITFCD
		,	SPDCD
		,	DNRK
		,	SEKKBN
		,	GKYKGKBTKBN
		,	YNUHNFRG
		,	YSTHNFRG
		,	KTCD
		,	BUNRUI
		,	SHNKKKMEI
		,	JR_KS
		,	JR_CU
		,	JR_BR
		,	SHTT_KS
		,	SHYK_KS
		,	SHTKS_KS
		,	SHTT_CU
		,	SHYK_CU
		,	SHTKS_CU
		,	SHTT_BR
		,	SHYK_BR
		,	SHTKS_BR
		,	RTNO
		,	RTNOSTIFLG
		,	SR1RS
		,	SR2RS
		,	SR3RS
		,	JTIRM
		,	PL
		,	JCSR1
		,	JCSR2
		,	JCSR3
		,	JCSSR
		,	JCSJR
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
		,	NEW.BTRUCD
		,	NEW.TITSHNCD
		,	NEW.GS1CD
		,	NEW.JANCD
		,	NEW.ITFCD
		,	NEW.SPDCD
		,	NEW.DNRK
		,	NEW.SEKKBN
		,	NEW.GKYKGKBTKBN
		,	NEW.YNUHNFRG
		,	NEW.YSTHNFRG
		,	NEW.KTCD
		,	NEW.BUNRUI
		,	NEW.SHNKKKMEI
		,	NEW.JR_KS
		,	NEW.JR_CU
		,	NEW.JR_BR
		,	NEW.SHTT_KS
		,	NEW.SHYK_KS
		,	NEW.SHTKS_KS
		,	NEW.SHTT_CU
		,	NEW.SHYK_CU
		,	NEW.SHTKS_CU
		,	NEW.SHTT_BR
		,	NEW.SHYK_BR
		,	NEW.SHTKS_BR
		,	NEW.RTNO
		,	NEW.RTNOSTIFLG
		,	NEW.SR1RS
		,	NEW.SR2RS
		,	NEW.SR3RS
		,	NEW.JTIRM
		,	NEW.PL
		,	NEW.JCSR1
		,	NEW.JCSR2
		,	NEW.JCSR3
		,	NEW.JCSSR
		,	NEW.JCSJR
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
CREATE TRIGGER shipment_provisional_details_AFTER_UPDATE AFTER UPDATE ON shipment_provisional_details FOR EACH ROW
BEGIN
	INSERT INTO shipment_provisional_details_history(
			history_record_divide
		,	ID
		,	JGSCD
		,	JGSNM
		,	SNTCD
		,	SNTNM
		,	DENGNO
		,	SHCD
		,	SHNM
		,	BTRUCD
		,	TITSHNCD
		,	GS1CD
		,	JANCD
		,	ITFCD
		,	SPDCD
		,	DNRK
		,	SEKKBN
		,	GKYKGKBTKBN
		,	YNUHNFRG
		,	YSTHNFRG
		,	KTCD
		,	BUNRUI
		,	SHNKKKMEI
		,	JR_KS
		,	JR_CU
		,	JR_BR
		,	SHTT_KS
		,	SHYK_KS
		,	SHTKS_KS
		,	SHTT_CU
		,	SHYK_CU
		,	SHTKS_CU
		,	SHTT_BR
		,	SHYK_BR
		,	SHTKS_BR
		,	RTNO
		,	RTNOSTIFLG
		,	SR1RS
		,	SR2RS
		,	SR3RS
		,	JTIRM
		,	PL
		,	JCSR1
		,	JCSR2
		,	JCSR3
		,	JCSSR
		,	JCSJR
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
		,	NEW.BTRUCD
		,	NEW.TITSHNCD
		,	NEW.GS1CD
		,	NEW.JANCD
		,	NEW.ITFCD
		,	NEW.SPDCD
		,	NEW.DNRK
		,	NEW.SEKKBN
		,	NEW.GKYKGKBTKBN
		,	NEW.YNUHNFRG
		,	NEW.YSTHNFRG
		,	NEW.KTCD
		,	NEW.BUNRUI
		,	NEW.SHNKKKMEI
		,	NEW.JR_KS
		,	NEW.JR_CU
		,	NEW.JR_BR
		,	NEW.SHTT_KS
		,	NEW.SHYK_KS
		,	NEW.SHTKS_KS
		,	NEW.SHTT_CU
		,	NEW.SHYK_CU
		,	NEW.SHTKS_CU
		,	NEW.SHTT_BR
		,	NEW.SHYK_BR
		,	NEW.SHTKS_BR
		,	NEW.RTNO
		,	NEW.RTNOSTIFLG
		,	NEW.SR1RS
		,	NEW.SR2RS
		,	NEW.SR3RS
		,	NEW.JTIRM
		,	NEW.PL
		,	NEW.JCSR1
		,	NEW.JCSR2
		,	NEW.JCSR3
		,	NEW.JCSSR
		,	NEW.JCSJR
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
CREATE TRIGGER shipment_provisional_details_AFTER_DELETE AFTER DELETE ON shipment_provisional_details FOR EACH ROW
BEGIN
	INSERT INTO shipment_provisional_details_history(
			history_record_divide
		,	ID
		,	JGSCD
		,	JGSNM
		,	SNTCD
		,	SNTNM
		,	DENGNO
		,	SHCD
		,	SHNM
		,	BTRUCD
		,	TITSHNCD
		,	GS1CD
		,	JANCD
		,	ITFCD
		,	SPDCD
		,	DNRK
		,	SEKKBN
		,	GKYKGKBTKBN
		,	YNUHNFRG
		,	YSTHNFRG
		,	KTCD
		,	BUNRUI
		,	SHNKKKMEI
		,	JR_KS
		,	JR_CU
		,	JR_BR
		,	SHTT_KS
		,	SHYK_KS
		,	SHTKS_KS
		,	SHTT_CU
		,	SHYK_CU
		,	SHTKS_CU
		,	SHTT_BR
		,	SHYK_BR
		,	SHTKS_BR
		,	RTNO
		,	RTNOSTIFLG
		,	SR1RS
		,	SR2RS
		,	SR3RS
		,	JTIRM
		,	PL
		,	JCSR1
		,	JCSR2
		,	JCSR3
		,	JCSSR
		,	JCSJR
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
		,	OLD.BTRUCD
		,	OLD.TITSHNCD
		,	OLD.GS1CD
		,	OLD.JANCD
		,	OLD.ITFCD
		,	OLD.SPDCD
		,	OLD.DNRK
		,	OLD.SEKKBN
		,	OLD.GKYKGKBTKBN
		,	OLD.YNUHNFRG
		,	OLD.YSTHNFRG
		,	OLD.KTCD
		,	OLD.BUNRUI
		,	OLD.SHNKKKMEI
		,	OLD.JR_KS
		,	OLD.JR_CU
		,	OLD.JR_BR
		,	OLD.SHTT_KS
		,	OLD.SHYK_KS
		,	OLD.SHTKS_KS
		,	OLD.SHTT_CU
		,	OLD.SHYK_CU
		,	OLD.SHTKS_CU
		,	OLD.SHTT_BR
		,	OLD.SHYK_BR
		,	OLD.SHTKS_BR
		,	OLD.RTNO
		,	OLD.RTNOSTIFLG
		,	OLD.SR1RS
		,	OLD.SR2RS
		,	OLD.SR3RS
		,	OLD.JTIRM
		,	OLD.PL
		,	OLD.JCSR1
		,	OLD.JCSR2
		,	OLD.JCSR3
		,	OLD.JCSSR
		,	OLD.JCSJR
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
