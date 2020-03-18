DROP TABLE IF EXISTS pyt_w_305000_details;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_305000_details(
	work_detail_id				int UNSIGNED		NOT NULL							COMMENT 'ワーク明細ID'
,	work_id						int UNSIGNED		NOT NULL							COMMENT 'ワークID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	TRNJ						datetime			DEFAULT NULL						COMMENT 'DB取込時間'
,	PYTStocktakingDate			date				NOT NULL							COMMENT '棚卸日YYYYMMDD'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '事業所名称'
,	SNTCD						varchar(10)			DEFAULT NULL						COMMENT 'センターコード'
,	SNTNM						varchar(50)			DEFAULT NULL						COMMENT 'センター名称'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	SRRNO						varchar(2)			DEFAULT NULL						COMMENT '未合区分'
,	SHCD						varchar(10)			DEFAULT NULL						COMMENT '商品コード'
,	SHNM						varchar(50)			DEFAULT NULL						COMMENT '製品名称'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	RTNO						varchar(20)			DEFAULT NULL						COMMENT 'ロット'
,	KANRIK						varchar(10)			DEFAULT NULL						COMMENT '管理区分'
,	SYUKAK						varchar(10)			DEFAULT NULL						COMMENT '出荷区分'
,	KOUJOK						varchar(3)			DEFAULT NULL						COMMENT '工場区分'
,	SHNKKKMEI_KS				varchar(20)			DEFAULT NULL						COMMENT '規格ケース'
,	SR1RS						int					NOT NULL DEFAULT 0					COMMENT '入目１'
,	PYTexStocks1				int					DEFAULT NULL						COMMENT '前日在庫ケース'
,	PYTexStocks3				int					DEFAULT NULL						COMMENT '前日在庫バラ'
,	PYTRecieving1				int					NOT NULL DEFAULT 0					COMMENT '入庫ケース'
,	PYTRecieving3				int					NOT NULL DEFAULT 0					COMMENT '入庫バラ'
,	PYTPicking1					int					DEFAULT NULL						COMMENT '出庫ケース'
,	PYTPicking3					int					DEFAULT NULL						COMMENT '出庫バラ'
,	PYTstock1					int					DEFAULT NULL						COMMENT '在庫ケース'
,	PYTstock3					int					DEFAULT NULL						COMMENT '在庫バラ'
,	PL							int					NOT NULL DEFAULT 0					COMMENT 'パレット積数'
,	PYTPLQ						int					DEFAULT NULL						COMMENT 'PL枚数'
,	PYTPLP						int					DEFAULT NULL						COMMENT 'PL端数'
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
,	PTStocktakingDate_YYYY		varchar(4)			DEFAULT NULL						COMMENT '棚卸日（yyyy）'
,	PTStocktakingDate_MM		varchar(2)			DEFAULT NULL						COMMENT '棚卸日（mm）'
,	PTStocktakingDate_DD		varchar(2)			DEFAULT NULL						COMMENT '棚卸日（dd）'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (work_detail_id, work_id, user_id)
,	KEY IX_pyt_w_305000_details_work_id (work_id, user_id)
,	CONSTRAINT FK_pyt_w_305000_details_pyt_w_305000_head
		FOREIGN KEY (work_id, user_id) REFERENCES pyt_w_305000_head (work_id, user_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='棚卸ダウンロード一時テーブル明細 (棚卸ダウンロード一時テーブル(明細))';//

delimiter ;
