delimiter //
/** テーブル作成 **/
CREATE TABLE location_stocks(
	DET_ID						int UNSIGNED		NOT NULL AUTO_INCREMENT				COMMENT '在庫管理ID'
,	NNSICD						varchar(10)			NOT NULL							COMMENT '荷主コード'
,	NNSINM						varchar(50)			NOT NULL							COMMENT '荷主名称'
,	JGSCD						varchar(10)			NOT NULL							COMMENT '事業所コード'
,	JGSNM						varchar(50)			NOT NULL							COMMENT '事業所名称'
,	SRRNO						varchar(2)			DEFAULT NULL						COMMENT '未合区分'
,	RTNO						varchar(20)			NOT NULL							COMMENT 'ロット'
,	KANRIK						varchar(2)			NOT NULL							COMMENT '管理区分'
,	SYUKAK						varchar(2)			NOT NULL							COMMENT '出荷区分'
,	KOUJOK						varchar(3)			NOT NULL							COMMENT '工場区分'
,	SNTCD						varchar(10)			NOT NULL							COMMENT 'センターコード'
,	SNTNM						varchar(50)			NOT NULL							COMMENT 'センター名称'
,	SHCD						varchar(10)			NOT NULL							COMMENT '商品コード'
,	SHNM						varchar(50)			DEFAULT NULL						COMMENT '製品名称'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	SHNKKKMEI_KS				varchar(20)			DEFAULT NULL						COMMENT '規格ケース'
,	SR1RS						int					NOT NULL DEFAULT 0					COMMENT '入目１'
,	PL							int					NOT NULL DEFAULT 0					COMMENT 'パレット積数'
,	KSNJ						datetime			DEFAULT NULL						COMMENT '更新日'
,	ZNJTZIKSURU1				int					NOT NULL DEFAULT 0					COMMENT '会計前日在庫ケース'
,	ZNJTZIKSURU3				int					NOT NULL DEFAULT 0					COMMENT '会計前日在庫バラ'
,	NUKSURU1					int					NOT NULL DEFAULT 0					COMMENT '会計入庫ケース'
,	NUKSURU3					int					NOT NULL DEFAULT 0					COMMENT '会計入庫バラ'
,	SKSURU1						int					NOT NULL DEFAULT 0					COMMENT '会計出庫ケース'
,	SKSURU3						int					NOT NULL DEFAULT 0					COMMENT '会計出庫バラ'
,	TUJTZIKSURU1				int					NOT NULL DEFAULT 0					COMMENT '会計当日在庫ケース'
,	TUJTZIKSURU3				int					NOT NULL DEFAULT 0					COMMENT '会計当日在庫バラ'
,	SKYTI1SURU1					int					NOT NULL DEFAULT 0					COMMENT '会計出庫予定１ケース'
,	SKYTI1SURU3					int					NOT NULL DEFAULT 0					COMMENT '会計出庫予定１バラ'
,	TRNJ						datetime			DEFAULT NULL						COMMENT 'DB取込時間'
,	PYTStocktakingDate			date				NOT NULL							COMMENT '棚卸日YYYYMMDD'
,	PYTexStocks1				int					DEFAULT NULL						COMMENT '前日在庫ケース'
,	PYTexStocks3				int					DEFAULT NULL						COMMENT '前日在庫バラ'
,	PYTPicking1					int					DEFAULT NULL						COMMENT '出庫ケース'
,	PYTPicking3					int					DEFAULT NULL						COMMENT '出庫バラ'
,	PYTstock1					int					DEFAULT NULL						COMMENT '在庫ケース'
,	PYTstock3					int					DEFAULT NULL						COMMENT '在庫バラ'
,	PYTPLQ						int					DEFAULT NULL						COMMENT 'PL枚数'
,	PYTPLP						int					DEFAULT NULL						COMMENT 'PL端数'
,	JitsuCase					int					NOT NULL DEFAULT 0					COMMENT '実ケース'
,	JitsuBara					int					NOT NULL DEFAULT 0					COMMENT '実バラ'
,	ReportComment				varchar(255)		DEFAULT NULL						COMMENT '報告者コメント'
,	Reporter					varchar(20)			DEFAULT NULL						COMMENT '報告者'
,	ReportCorpName				varchar(60)			DEFAULT NULL						COMMENT '報告会社名'
,	ReportDatetime				datetime			DEFAULT NULL						COMMENT '報告日時'
,	ReviewComment				varchar(255)		DEFAULT NULL						COMMENT '確認者コメント'
,	ReviewerID					varchar(20)			DEFAULT NULL						COMMENT '確認者'
,	ReviewDatetime				datetime			DEFAULT NULL						COMMENT '確認日時'
,	AuthorizerComment			varchar(255)		DEFAULT NULL						COMMENT '承認者名コメント'
,	AuthorizerID				varchar(20)			DEFAULT NULL						COMMENT '承認者'
,	AuthorizerDatetime			datetime			DEFAULT NULL						COMMENT '承認日時'
,	Status						tinyint				NOT NULL DEFAULT 0					COMMENT 'ステータス'
,	AddFlag						tinyint				NOT NULL DEFAULT 0					COMMENT '追加判定フラグ'
,	PRIMARY KEY (DET_ID)
,	UNIQUE KEY UQ_location_stocks(NNSICD,JGSCD,SRRNO,RTNO,KANRIK,SYUKAK,KOUJOK,SNTCD,SHCD,PYTStocktakingDate)
,	KEY IX_location_stocks_NNSICD (PYTStocktakingDate,NNSICD)
,	KEY IX_location_stocks_JGSCD_SNTCD_NNSICD (PYTStocktakingDate,JGSCD,SNTCD,NNSICD)
,	KEY IX_location_stocks_SHCD (SHCD)
,	KEY IX_location_stocks_Status_JGSCD_SNTCD_NNSICD (PYTStocktakingDate,Status,JGSCD,SNTCD,NNSICD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在庫 (在庫テーブル)';//

/** INSERT トリガー **/
CREATE TRIGGER location_stocks_AFTER_INSERT AFTER INSERT ON location_stocks FOR EACH ROW
BEGIN
	INSERT INTO location_stocks_history(
			history_record_divide
		,	DET_ID
		,	NNSICD
		,	NNSINM
		,	JGSCD
		,	JGSNM
		,	SRRNO
		,	RTNO
		,	KANRIK
		,	SYUKAK
		,	KOUJOK
		,	SNTCD
		,	SNTNM
		,	SHCD
		,	SHNM
		,	DNRK
		,	SHNKKKMEI_KS
		,	SR1RS
		,	PL
		,	KSNJ
		,	ZNJTZIKSURU1
		,	ZNJTZIKSURU3
		,	NUKSURU1
		,	NUKSURU3
		,	SKSURU1
		,	SKSURU3
		,	TUJTZIKSURU1
		,	TUJTZIKSURU3
		,	SKYTI1SURU1
		,	SKYTI1SURU3
		,	TRNJ
		,	PYTStocktakingDate
		,	PYTexStocks1
		,	PYTexStocks3
		,	PYTPicking1
		,	PYTPicking3
		,	PYTstock1
		,	PYTstock3
		,	PYTPLQ
		,	PYTPLP
		,	JitsuCase
		,	JitsuBara
		,	ReportComment
		,	Reporter
		,	ReportCorpName
		,	ReportDatetime
		,	ReviewComment
		,	ReviewerID
		,	ReviewDatetime
		,	AuthorizerComment
		,	AuthorizerID
		,	AuthorizerDatetime
		,	Status
		,	AddFlag
	)
	VALUES(
			'I'
		,	NEW.DET_ID
		,	NEW.NNSICD
		,	NEW.NNSINM
		,	NEW.JGSCD
		,	NEW.JGSNM
		,	NEW.SRRNO
		,	NEW.RTNO
		,	NEW.KANRIK
		,	NEW.SYUKAK
		,	NEW.KOUJOK
		,	NEW.SNTCD
		,	NEW.SNTNM
		,	NEW.SHCD
		,	NEW.SHNM
		,	NEW.DNRK
		,	NEW.SHNKKKMEI_KS
		,	NEW.SR1RS
		,	NEW.PL
		,	NEW.KSNJ
		,	NEW.ZNJTZIKSURU1
		,	NEW.ZNJTZIKSURU3
		,	NEW.NUKSURU1
		,	NEW.NUKSURU3
		,	NEW.SKSURU1
		,	NEW.SKSURU3
		,	NEW.TUJTZIKSURU1
		,	NEW.TUJTZIKSURU3
		,	NEW.SKYTI1SURU1
		,	NEW.SKYTI1SURU3
		,	NEW.TRNJ
		,	NEW.PYTStocktakingDate
		,	NEW.PYTexStocks1
		,	NEW.PYTexStocks3
		,	NEW.PYTPicking1
		,	NEW.PYTPicking3
		,	NEW.PYTstock1
		,	NEW.PYTstock3
		,	NEW.PYTPLQ
		,	NEW.PYTPLP
		,	NEW.JitsuCase
		,	NEW.JitsuBara
		,	NEW.ReportComment
		,	NEW.Reporter
		,	NEW.ReportCorpName
		,	NEW.ReportDatetime
		,	NEW.ReviewComment
		,	NEW.ReviewerID
		,	NEW.ReviewDatetime
		,	NEW.AuthorizerComment
		,	NEW.AuthorizerID
		,	NEW.AuthorizerDatetime
		,	NEW.Status
		,	NEW.AddFlag
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER location_stocks_AFTER_UPDATE AFTER UPDATE ON location_stocks FOR EACH ROW
BEGIN
	INSERT INTO location_stocks_history(
			history_record_divide
		,	DET_ID
		,	NNSICD
		,	NNSINM
		,	JGSCD
		,	JGSNM
		,	SRRNO
		,	RTNO
		,	KANRIK
		,	SYUKAK
		,	KOUJOK
		,	SNTCD
		,	SNTNM
		,	SHCD
		,	SHNM
		,	DNRK
		,	SHNKKKMEI_KS
		,	SR1RS
		,	PL
		,	KSNJ
		,	ZNJTZIKSURU1
		,	ZNJTZIKSURU3
		,	NUKSURU1
		,	NUKSURU3
		,	SKSURU1
		,	SKSURU3
		,	TUJTZIKSURU1
		,	TUJTZIKSURU3
		,	SKYTI1SURU1
		,	SKYTI1SURU3
		,	TRNJ
		,	PYTStocktakingDate
		,	PYTexStocks1
		,	PYTexStocks3
		,	PYTPicking1
		,	PYTPicking3
		,	PYTstock1
		,	PYTstock3
		,	PYTPLQ
		,	PYTPLP
		,	JitsuCase
		,	JitsuBara
		,	ReportComment
		,	Reporter
		,	ReportCorpName
		,	ReportDatetime
		,	ReviewComment
		,	ReviewerID
		,	ReviewDatetime
		,	AuthorizerComment
		,	AuthorizerID
		,	AuthorizerDatetime
		,	Status
		,	AddFlag
	)
	VALUES(
			'U'
		,	NEW.DET_ID
		,	NEW.NNSICD
		,	NEW.NNSINM
		,	NEW.JGSCD
		,	NEW.JGSNM
		,	NEW.SRRNO
		,	NEW.RTNO
		,	NEW.KANRIK
		,	NEW.SYUKAK
		,	NEW.KOUJOK
		,	NEW.SNTCD
		,	NEW.SNTNM
		,	NEW.SHCD
		,	NEW.SHNM
		,	NEW.DNRK
		,	NEW.SHNKKKMEI_KS
		,	NEW.SR1RS
		,	NEW.PL
		,	NEW.KSNJ
		,	NEW.ZNJTZIKSURU1
		,	NEW.ZNJTZIKSURU3
		,	NEW.NUKSURU1
		,	NEW.NUKSURU3
		,	NEW.SKSURU1
		,	NEW.SKSURU3
		,	NEW.TUJTZIKSURU1
		,	NEW.TUJTZIKSURU3
		,	NEW.SKYTI1SURU1
		,	NEW.SKYTI1SURU3
		,	NEW.TRNJ
		,	NEW.PYTStocktakingDate
		,	NEW.PYTexStocks1
		,	NEW.PYTexStocks3
		,	NEW.PYTPicking1
		,	NEW.PYTPicking3
		,	NEW.PYTstock1
		,	NEW.PYTstock3
		,	NEW.PYTPLQ
		,	NEW.PYTPLP
		,	NEW.JitsuCase
		,	NEW.JitsuBara
		,	NEW.ReportComment
		,	NEW.Reporter
		,	NEW.ReportCorpName
		,	NEW.ReportDatetime
		,	NEW.ReviewComment
		,	NEW.ReviewerID
		,	NEW.ReviewDatetime
		,	NEW.AuthorizerComment
		,	NEW.AuthorizerID
		,	NEW.AuthorizerDatetime
		,	NEW.Status
		,	NEW.AddFlag
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER location_stocks_AFTER_DELETE AFTER DELETE ON location_stocks FOR EACH ROW
BEGIN
	INSERT INTO location_stocks_history(
			history_record_divide
		,	DET_ID
		,	NNSICD
		,	NNSINM
		,	JGSCD
		,	JGSNM
		,	SRRNO
		,	RTNO
		,	KANRIK
		,	SYUKAK
		,	KOUJOK
		,	SNTCD
		,	SNTNM
		,	SHCD
		,	SHNM
		,	DNRK
		,	SHNKKKMEI_KS
		,	SR1RS
		,	PL
		,	KSNJ
		,	ZNJTZIKSURU1
		,	ZNJTZIKSURU3
		,	NUKSURU1
		,	NUKSURU3
		,	SKSURU1
		,	SKSURU3
		,	TUJTZIKSURU1
		,	TUJTZIKSURU3
		,	SKYTI1SURU1
		,	SKYTI1SURU3
		,	TRNJ
		,	PYTStocktakingDate
		,	PYTexStocks1
		,	PYTexStocks3
		,	PYTPicking1
		,	PYTPicking3
		,	PYTstock1
		,	PYTstock3
		,	PYTPLQ
		,	PYTPLP
		,	JitsuCase
		,	JitsuBara
		,	ReportComment
		,	Reporter
		,	ReportCorpName
		,	ReportDatetime
		,	ReviewComment
		,	ReviewerID
		,	ReviewDatetime
		,	AuthorizerComment
		,	AuthorizerID
		,	AuthorizerDatetime
		,	Status
		,	AddFlag
	)
	VALUES(
			'D'
		,	OLD.DET_ID
		,	OLD.NNSICD
		,	OLD.NNSINM
		,	OLD.JGSCD
		,	OLD.JGSNM
		,	OLD.SRRNO
		,	OLD.RTNO
		,	OLD.KANRIK
		,	OLD.SYUKAK
		,	OLD.KOUJOK
		,	OLD.SNTCD
		,	OLD.SNTNM
		,	OLD.SHCD
		,	OLD.SHNM
		,	OLD.DNRK
		,	OLD.SHNKKKMEI_KS
		,	OLD.SR1RS
		,	OLD.PL
		,	OLD.KSNJ
		,	OLD.ZNJTZIKSURU1
		,	OLD.ZNJTZIKSURU3
		,	OLD.NUKSURU1
		,	OLD.NUKSURU3
		,	OLD.SKSURU1
		,	OLD.SKSURU3
		,	OLD.TUJTZIKSURU1
		,	OLD.TUJTZIKSURU3
		,	OLD.SKYTI1SURU1
		,	OLD.SKYTI1SURU3
		,	OLD.TRNJ
		,	OLD.PYTStocktakingDate
		,	OLD.PYTexStocks1
		,	OLD.PYTexStocks3
		,	OLD.PYTPicking1
		,	OLD.PYTPicking3
		,	OLD.PYTstock1
		,	OLD.PYTstock3
		,	OLD.PYTPLQ
		,	OLD.PYTPLP
		,	OLD.JitsuCase
		,	OLD.JitsuBara
		,	OLD.ReportComment
		,	OLD.Reporter
		,	OLD.ReportCorpName
		,	OLD.ReportDatetime
		,	OLD.ReviewComment
		,	OLD.ReviewerID
		,	OLD.ReviewDatetime
		,	OLD.AuthorizerComment
		,	OLD.AuthorizerID
		,	OLD.AuthorizerDatetime
		,	OLD.Status
		,	OLD.AddFlag
	);
END;//


delimiter ;
