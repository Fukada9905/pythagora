delimiter //
/** テーブル作成 **/
CREATE TABLE wk_101030_head(
	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	process_divide				tinyint				NOT NULL							COMMENT '処理区分'
,	DATEYMD						date				DEFAULT NULL						COMMENT '抽出対象日付'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '事業所名称'
,	PTNCD						varchar(10)			DEFAULT NULL						COMMENT 'PTコード'
,	PTNNM						varchar(50)			DEFAULT NULL						COMMENT 'PT名称'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (work_id)
,	KEY IX_wk_101030_head_user_id_process_divide (user_id,process_divide)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出荷ダウンロード一時テーブル (出荷ダウンロード一時テーブル(ヘッダー))';//

delimiter ;
