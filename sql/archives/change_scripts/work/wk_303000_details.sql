delimiter //
/** テーブル作成 **/
CREATE TABLE wk_303000_details(
	work_detail_id				int UNSIGNED		NOT NULL							COMMENT 'ワーク明細ID'
,	work_id						int UNSIGNED		NOT NULL							COMMENT 'ワークID'
,	SHCD						varchar(10)			DEFAULT NULL						COMMENT '商品コード'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	SHNM						varchar(50)			DEFAULT NULL						COMMENT '商品名'
,	RTNO						varchar(20)			DEFAULT NULL						COMMENT 'ロット'
,	KANRIK						varchar(2)			DEFAULT NULL						COMMENT '管理区分'
,	SYUKAK						varchar(2)			DEFAULT NULL						COMMENT '出荷区分'
,	PYTstock1					int					NOT NULL DEFAULT 0					COMMENT '在庫ケース'
,	PYTstock3					int					NOT NULL DEFAULT 0					COMMENT '在庫バラ'
,	JitsuCase					int					NOT NULL DEFAULT 0					COMMENT '実ケース'
,	JitsuBara					int					NOT NULL DEFAULT 0					COMMENT '実バラ'
,	ReportComment				varchar(255)		DEFAULT NULL						COMMENT '報告者コメント'
,	Reporter					varchar(20)			DEFAULT NULL						COMMENT '報告者'
,	ReportCorpName				varchar(60)			DEFAULT NULL						COMMENT '報告会社名'
,	ReportDatetime				datetime			DEFAULT NULL						COMMENT '報告日時'
,	ReviewComment				varchar(255)		DEFAULT NULL						COMMENT '確認者コメント'
,	ReviewerID					varchar(20)			DEFAULT NULL						COMMENT '確認者ID'
,	ReviewerName				varchar(40)			DEFAULT NULL						COMMENT '確認者名'
,	ReviewDatetime				datetime			DEFAULT NULL						COMMENT '確認日時'
,	AuthorizerComment			varchar(255)		DEFAULT NULL						COMMENT '承認者名コメント'
,	AuthorizerID				varchar(20)			DEFAULT NULL						COMMENT '承認者ID'
,	AuthorizerName				varchar(40)			DEFAULT NULL						COMMENT '承認者名'
,	AuthorizerDatetime			datetime			DEFAULT NULL						COMMENT '承認日時'
,	Status						tinyint				NOT NULL DEFAULT 0					COMMENT 'ステータス'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前方参照用キー'
,	DET_ID						int					DEFAULT NULL						COMMENT '在庫管理ID'
,	PRIMARY KEY (work_detail_id)
,	KEY IX_wk_303000_details_work_id (work_id)
,	KEY IX_wk_303000_details_location_stocks (DET_ID)
,	CONSTRAINT FK_wk_303000_details_wk_303000_head
		FOREIGN KEY (work_id) REFERENCES wk_303000_head (work_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='棚卸承認一時テーブル明細 (棚卸承認一時テーブル(明細))';//

delimiter ;
