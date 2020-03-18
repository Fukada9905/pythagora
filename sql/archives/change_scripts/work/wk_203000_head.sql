delimiter //
/** テーブル作成 **/
CREATE TABLE wk_203000_head(
	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	NOHINYMD					date				DEFAULT NULL						COMMENT '入荷予定日'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	JGSCD_SK					varchar(10)			DEFAULT NULL						COMMENT '出荷元事業所コード'
,	JGSNM_SK					varchar(50)			DEFAULT NULL						COMMENT '出荷元事業所名'
,	JGSCD_NK					varchar(10)			DEFAULT NULL						COMMENT '入荷事業所コード'
,	JGSNM_NK					varchar(50)			DEFAULT NULL						COMMENT '入荷事業所名'
,	SNTCD_NK					varchar(10)			DEFAULT NULL						COMMENT '入荷センターコード'
,	SNTNM_NK					varchar(50)			DEFAULT NULL						COMMENT '入荷センター名'
,	DENNO						varchar(20)			DEFAULT NULL						COMMENT '伝票番号'
,	Status						tinyint				DEFAULT NULL						COMMENT 'ステータス'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (work_id)
,	KEY IX_wk_203000_head_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='検品報告一時テーブル (検品報告一時テーブル(ヘッダー))';//

delimiter ;
