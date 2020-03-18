DROP TABLE IF EXISTS pyt_w_401000;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_401000(
	user_id				varchar(20)		NOT NULL			COMMENT 'ユーザーID'
,	work_id				int UNSIGNED	NOT NULL			COMMENT '一時ID'	
,	shipper_code 		varchar(10) 	NOT NULL 			COMMENT '荷主コード'
,	shipper_name 		varchar(50) 	DEFAULT NULL 		COMMENT '荷主名'
,	transporter_code 	varchar(10) 	DEFAULT NULL 		COMMENT '運送業者コード'
,	transporter_name 	varchar(30) 	DEFAULT NULL 		COMMENT '運送業者名'
,	slip_number 		varchar(20) 	NOT NULL 			COMMENT '伝票番号'
,	sales_office_code 	varchar(10) 	NOT NULL 			COMMENT '倉庫事業所コード'
,	warehouse_code 		varchar(10) 	NOT NULL 			COMMENT '出荷倉庫コード'
,	warehouse_name 		varchar(30) 	DEFAULT NULL 		COMMENT '出荷倉庫名'
,	delivery_code 		varchar(20)		DEFAULT NULL 		COMMENT '納品先コード'
,	delivery_name 		varchar(120)	DEFAULT NULL 		COMMENT '納品先名'
,	delivery_address 	varchar(120)	DEFAULT NULL 		COMMENT '納品先住所'
,	retrieval_date 		date 			NOT NULL 			COMMENT '出荷日'
,	delivery_date 		date 			DEFAULT NULL 		COMMENT '納品日'
,	package_count		int				NOT NULL DEFAULT 0	COMMENT 'ケース数'
,	fraction			int				NOT NULL DEFAULT 0	COMMENT 'バラ数'
,	shipping_weight		DECIMAL(12,1)	NOT NULL DEFAULT 0	COMMENT '重量'	
,	shaban_id			int				DEFAULT NULL		COMMENT '車番テーブルID'
,	root_id				int				DEFAULT NULL		COMMENT 'ルートマスタID'
,	PRIMARY KEY (user_id, work_id)
,	KEY IX_pyt_w_401000_head (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='車番入力一時テーブル';//

delimiter ;
