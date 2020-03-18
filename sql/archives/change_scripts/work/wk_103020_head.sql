delimiter //
/** テーブル作成 **/
CREATE TABLE wk_103020_head(
	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	DENPYOYMD					date				DEFAULT NULL						COMMENT '伝票日付'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	SNTCD						varchar(10)			DEFAULT NULL						COMMENT 'センターコード'
,	SNTNM						varchar(50)			DEFAULT NULL						COMMENT 'センター名称'
,	UNSKSCD						varchar(10)			DEFAULT NULL						COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)			DEFAULT NULL						COMMENT '運送会社名称'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (work_id)
,	KEY IX_wk_103020_head_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='補給ダウンロード一時テーブル (補給ダウンロード一時テーブル(ヘッダー))';//

delimiter ;
