delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_t_location_stocks_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	NNSICD						varchar(10)				NOT NULL							COMMENT '荷主コード'
,	JGSCD						varchar(10)				NOT NULL							COMMENT '事業所コード'
,	JGSNM						varchar(50)				NOT NULL							COMMENT '事業所名称'
,	SRRNO						varchar(2)				DEFAULT NULL						COMMENT '未合区分'
,	RTNO						varchar(20)				NOT NULL							COMMENT 'ロット'
,	KANRIK						varchar(10)				NOT NULL							COMMENT '管理区分'
,	SYUKAK						varchar(10)				NOT NULL							COMMENT '出荷区分'
,	KOUJOK						varchar(3)				NOT NULL							COMMENT '工場区分'
,	SNTCD						varchar(10)				NOT NULL							COMMENT 'センターコード'
,	SNTNM						varchar(50)				NOT NULL							COMMENT 'センター名称'
,	SHCD						varchar(10)				NOT NULL							COMMENT '商品コード'
,	SHNM						varchar(50)				DEFAULT NULL						COMMENT '製品名称'
,	PYTStocktakingDate			date					NOT NULL							COMMENT '棚卸日YYYYMMDD'
,	JitsuCase					int						NOT NULL DEFAULT 0					COMMENT '実ケース'
,	JitsuBara 					int						NOT NULL DEFAULT 0					COMMENT '実バラ'
,	ReportComment				varchar(255)			DEFAULT NULL						COMMENT '報告者コメント'
,	Reporter					varchar(20)				DEFAULT NULL						COMMENT '報告者'
,	ReportCorpName				varchar(60)				DEFAULT NULL						COMMENT '報告会社名'
,	ReportDatetime				datetime				DEFAULT NULL						COMMENT '報告日時'
,	ReviewComment				varchar(255)			DEFAULT NULL						COMMENT '確認者コメント'
,	ReviewerID					varchar(20)				DEFAULT NULL						COMMENT '確認者'
,	ReviewDatetime				datetime				DEFAULT NULL						COMMENT '確認日時'
,	AuthorizerComment			varchar(255)			DEFAULT NULL						COMMENT '承認者名コメント'
,	AuthorizerID				varchar(20)				DEFAULT NULL						COMMENT '承認者'
,	AuthorizerDatetime			datetime				DEFAULT NULL						COMMENT '承認日時'
,	Status						tinyint					NOT NULL DEFAULT 0					COMMENT 'ステータス'
,	AddFlag						tinyint					NOT NULL DEFAULT 0					COMMENT '追加判定フラグ\n追加レコードかどうかの判定フラグ 0:通常 1:追加'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='pythagora用棚卸テーブルの履歴保持を行う';//

delimiter ;
