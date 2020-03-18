SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS pyt_w_106000_head;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_106000_head(
	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	process_divide				tinyint				NOT NULL							COMMENT '処理区分'
,	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	wms_processing_date			datetime			DEFAULT NULL						COMMENT '処理日'
,	delivery_date				date				DEFAULT NULL						COMMENT '納品日'
,	shipper_code				varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	shipper_name				varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	sales_office_code			varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	sales_office_name			varchar(30)			DEFAULT NULL						COMMENT '事業所名称'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (user_id,process_divide,work_id)
,	KEY IX_pyt_w_106000_head_user_id_process_divide (user_id,process_divide)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='営業倉庫システムCSV一時テーブル';//

delimiter ;
SET FOREIGN_KEY_CHECKS = 1;