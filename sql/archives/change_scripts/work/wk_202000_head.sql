delimiter //
/** テーブル作成 **/
CREATE TABLE wk_202000_head(
	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	NOHINYMD					date				DEFAULT NULL						COMMENT '入荷予定日'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '入荷事業所コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '入荷事業所名'
,	SNTCD						varchar(10)			DEFAULT NULL						COMMENT '入荷センターコード'
,	SNTNM						varchar(50)			DEFAULT NULL						COMMENT '入荷センター名'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	STATUS						varchar(10)			DEFAULT NULL						COMMENT 'ステータス'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (work_id)
,	KEY IX_wk_202000_head_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入荷ダウンロード一時テーブル (入荷ダウンロード一時テーブル(ヘッダー))';//

delimiter ;
