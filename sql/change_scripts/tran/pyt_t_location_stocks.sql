delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_location_stocks(
	NNSICD				varchar(10)		NOT NULL			COMMENT '荷主コード'
,	JGSCD				varchar(10)		NOT NULL			COMMENT '事業所コード'
,	JGSNM				varchar(50)		NOT NULL			COMMENT '事業所名称'
,	SRRNO				varchar(2)		NOT NULL			COMMENT '未合区分'
,	RTNO				varchar(20)		NOT NULL			COMMENT 'ロット'
,	KANRIK				varchar(10)		NOT NULL			COMMENT '管理区分'
,	SYUKAK				varchar(10)		NOT NULL			COMMENT '出荷区分'
,	KOUJOK				varchar(3)		NOT NULL			COMMENT '工場区分'
,	SNTCD				varchar(10)		NOT NULL			COMMENT 'センターコード'
,	SNTNM				varchar(50)		NOT NULL			COMMENT 'センター名称'
,	SHCD				varchar(10)		NOT NULL			COMMENT '商品コード'
,	SHNM				varchar(50)		DEFAULT NULL		COMMENT '製品名称'
,	PYTStocktakingDate	date			NOT NULL			COMMENT '棚卸日YYYYMMDD'
,	JitsuCase			int				NOT NULL DEFAULT 0	COMMENT '実ケース'
,	JitsuBara 			int				NOT NULL DEFAULT 0	COMMENT '実バラ'
,	ReportComment		varchar(255)	DEFAULT NULL		COMMENT '報告者コメント'
,	Reporter			varchar(20)		DEFAULT NULL		COMMENT '報告者'
,	ReportCorpName		varchar(60)		DEFAULT NULL		COMMENT '報告会社名'
,	ReportDatetime		datetime		DEFAULT NULL		COMMENT '報告日時'
,	ReviewComment		varchar(255)	DEFAULT NULL		COMMENT '確認者コメント'
,	ReviewerID			varchar(20)		DEFAULT NULL		COMMENT '確認者'
,	ReviewDatetime		datetime		DEFAULT NULL		COMMENT '確認日時'
,	AuthorizerComment	varchar(255)	DEFAULT NULL		COMMENT '承認者名コメント'
,	AuthorizerID		varchar(20)		DEFAULT NULL		COMMENT '承認者'
,	AuthorizerDatetime	datetime		DEFAULT NULL		COMMENT '承認日時'
,	Status				tinyint			NOT NULL DEFAULT 0	COMMENT 'ステータス'
,	AddFlag				tinyint			NOT NULL DEFAULT 0	COMMENT '追加判定フラグ\n追加レコードかどうかの判定フラグ 0:通常 1:追加'
,	PRIMARY KEY (NNSICD,JGSCD,SRRNO,RTNO,KANRIK,SYUKAK,KOUJOK,SNTCD,SHCD,PYTStocktakingDate)
,	KEY ix_pyt_t_location_stocks1(NNSICD,JGSCD,SRRNO,RTNO,KANRIK,SYUKAK,KOUJOK,SNTCD,SHCD,PYTStocktakingDate,AddFlag,Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用 棚卸テーブル';//

/** INSERT トリガー **/
CREATE TRIGGER pyt_t_location_stocks_AFTER_INSERT AFTER INSERT ON pyt_t_location_stocks FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_location_stocks_history(
			history_record_divide
		,	NNSICD
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
		,	PYTStocktakingDate
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
		,	NEW.NNSICD
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
		,	NEW.PYTStocktakingDate
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
CREATE TRIGGER pyt_t_location_stocks_AFTER_UPDATE AFTER UPDATE ON pyt_t_location_stocks FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_location_stocks_history(
			history_record_divide
		,	NNSICD
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
		,	PYTStocktakingDate
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
		,	NEW.NNSICD
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
		,	NEW.PYTStocktakingDate
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
CREATE TRIGGER pyt_t_location_stocks_AFTER_DELETE AFTER DELETE ON pyt_t_location_stocks FOR EACH ROW
BEGIN
	INSERT INTO pyt_t_location_stocks_history(
			history_record_divide
		,	NNSICD
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
		,	PYTStocktakingDate
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
		,	OLD.NNSICD
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
		,	OLD.PYTStocktakingDate
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
