DROP TABLE IF EXISTS pyt_w_302000_head;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_302000_head(
	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	PYTStocktakingDate			date				DEFAULT NULL						COMMENT '棚卸日'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '事業所名'
,	SNTCD						varchar(10)			DEFAULT NULL						COMMENT 'センターコード'
,	SNTNM						varchar(50)			DEFAULT NULL						COMMENT 'センター名'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	Status						tinyint				DEFAULT NULL						COMMENT 'ステータス'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (work_id, user_id)
,	KEY IX_pyt_w_302000_head_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='棚卸確認一時テーブル (棚卸確認一時テーブル(ヘッダー))';//

delimiter ;
