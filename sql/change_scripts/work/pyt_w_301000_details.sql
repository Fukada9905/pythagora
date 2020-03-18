DROP TABLE IF EXISTS pyt_w_301000_details;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_301000_details(
	work_detail_id				int UNSIGNED		NOT NULL							COMMENT 'ワーク明細ID'
,	work_id						int UNSIGNED		NOT NULL							COMMENT 'ワークID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	SHCD						varchar(10)			DEFAULT NULL						COMMENT '商品コード'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	SR1RS						int					NOT NULL DEFAULT 0					COMMENT '入目１'
,	SHNKKKMEI_KS				varchar(20)			DEFAULT NULL						COMMENT '規格ケース'
,	SHNM						varchar(50)			DEFAULT NULL						COMMENT '商品名'
,	SRRNO						varchar(2)			DEFAULT NULL						COMMENT '未合区分'
,	RTNO						varchar(20)			DEFAULT NULL						COMMENT 'ロット'
,	KANRIK						varchar(10)			DEFAULT NULL						COMMENT '管理区分'
,	SYUKAK						varchar(10)			DEFAULT NULL						COMMENT '出荷区分'
,	KOUJOK						varchar(3)			DEFAULT NULL						COMMENT '工場区分'
,	PYTexStocks1				int					NOT NULL DEFAULT 0					COMMENT '前日在庫ケース'
,	PYTexStocks3				int					NOT NULL DEFAULT 0					COMMENT '前日在庫バラ'
,	NUKSURU1					int					NOT NULL DEFAULT 0					COMMENT '入庫ケース'
,	NUKSURU3					int					NOT NULL DEFAULT 0					COMMENT '入庫バラ'
,	PYTPicking1					int					NOT NULL DEFAULT 0					COMMENT '出庫ケース'
,	PYTPicking3					int					NOT NULL DEFAULT 0					COMMENT '出庫バラ'
,	PYTstock1					int					NOT NULL DEFAULT 0					COMMENT '在庫ケース'
,	PYTstock3					int					NOT NULL DEFAULT 0					COMMENT '在庫バラ'
,	PYTPLQ						int					NOT NULL DEFAULT 0					COMMENT 'PL枚数'
,	PYTPLP						int					NOT NULL DEFAULT 0					COMMENT 'PL端数'
,	JitsuCase					int					NOT NULL DEFAULT 0					COMMENT '実ケース'
,	JitsuBara					int					NOT NULL DEFAULT 0					COMMENT '実バラ'
,	Comment						varchar(255)		DEFAULT NULL						COMMENT 'コメント'
,	Status						tinyint				NOT NULL DEFAULT 0					COMMENT 'ステータス'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前方参照用キー'
,	PRIMARY KEY (work_detail_id, work_id, user_id)
,	KEY IX_pyt_w_301000_details_work_id (work_id, user_id)
,	CONSTRAINT FK_pyt_w_301000_details_pyt_w_301000_head
		FOREIGN KEY (work_id, user_id) REFERENCES pyt_w_301000_head (work_id, user_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='棚卸業務一時テーブル明細 (棚卸業務一時テーブル(明細))';//
delimiter ;
