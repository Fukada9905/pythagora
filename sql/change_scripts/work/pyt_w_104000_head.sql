SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS pyt_w_104000_head;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_104000_head(
	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	process_divide				tinyint				NOT NULL							COMMENT '処理区分'
,	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	SYORIYMD					datetime			DEFAULT NULL						COMMENT '処理日'
,	NOHINYMD					date				DEFAULT NULL						COMMENT '納品日'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '事業所名称'
,	SYUKAP						varchar(10)			DEFAULT NULL						COMMENT '出荷場所コード'
,	UNSKSCD						varchar(10)			DEFAULT NULL						COMMENT '運送会社コード'
,	UNSKSNM						varchar(30)			DEFAULT NULL						COMMENT '運送会社名'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (user_id,process_divide,work_id)
,	KEY IX_pyt_w_104000_head_user_id_process_divide (user_id,process_divide)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='納品書一覧一時テーブル';//

delimiter ;
SET FOREIGN_KEY_CHECKS = 1;
