SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS pyt_w_103040_head;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_103040_head(
	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	process_divide				tinyint				NOT NULL							COMMENT '処理区分'
,	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	SYORIYMD					datetime			DEFAULT NULL						COMMENT '処理日付'
,	DATEYMD						date				DEFAULT NULL						COMMENT '抽出対象日付'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '事業所名称'
,	PTNCD						varchar(10)			DEFAULT NULL						COMMENT '運送会社コード'
,	PTNNM						varchar(100)		DEFAULT NULL						COMMENT '運送会社名'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (user_id,process_divide,work_id)
,	KEY IX_pyt_w_103040_head_user_id_process_divide (user_id,process_divide)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='補給物量把握一時テーブル';//

delimiter ;
SET FOREIGN_KEY_CHECKS = 1;
