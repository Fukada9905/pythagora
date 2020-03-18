SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS pyt_w_106000_details;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_106000_details(
	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	process_divide				tinyint				NOT NULL							COMMENT '処理区分'
,	work_detail_id				int UNSIGNED		NOT NULL							COMMENT 'ワーク明細ID'
,	work_id						int UNSIGNED		NOT NULL							COMMENT 'ワークID'
,	shipper_code				varchar(10)			NOT	NULL
,	shipper_accounting_date		date				DEFAULT	NULL
,	warehouse_accounting_date	date				DEFAULT	NULL
,	delivery_date				date				DEFAULT	NULL
,	slip_number					varchar(20)			DEFAULT	NULL
,	shipper_trading_code		varchar(10)			DEFAULT	NULL
,	shipper_trading_name		varchar(30)			DEFAULT	NULL
,	shipper_trading_short_name	varchar(20)			DEFAULT	NULL
,	sales_office_code			varchar(10)			DEFAULT	NULL
,	sales_office_name			varchar(30)			DEFAULT	NULL
,	transporter_code			varchar(10)			DEFAULT	NULL
,	transporter_name			varchar(30)			DEFAULT	NULL
,	pken_code					varchar(10)			DEFAULT	NULL
,	detail_order_number			varchar(15)			DEFAULT	NULL
,	slip_remarks1				varchar(40)			DEFAULT	NULL
,	arrival_time				varchar(15)			DEFAULT	NULL
,	branch_office_code			varchar(10)			DEFAULT	NULL
,	local_office_code			varchar(10)			DEFAULT	NULL
,	receiver_code				varchar(15)			DEFAULT	NULL
,	delivery_code				varchar(20)			DEFAULT	NULL
,	receiver_name1				varchar(40)			DEFAULT	NULL
,	receiver_name2				varchar(40)			DEFAULT	NULL
,	receiver_name3				varchar(40)			DEFAULT	NULL
,	receiver_area_code			varchar(5)			DEFAULT	NULL
,	receiver_address1			varchar(40)			DEFAULT	NULL
,	receiver_address2			varchar(40)			DEFAULT	NULL
,	receiver_address3			varchar(40)			DEFAULT	NULL
,	receiver_tel				varchar(15)			DEFAULT	NULL
,	priority_flag				varchar(2)			DEFAULT	NULL
,	item_line					int					DEFAULT	NULL
,	item_line_column			int					DEFAULT	NULL
,	logistics_code				varchar(20)			DEFAULT	NULL
,	outer_product_code			varchar(20)			DEFAULT	NULL
,	denryaku					varchar(20)			DEFAULT	NULL
,	product_name				varchar(80)			DEFAULT	NULL
,	capacity					varchar(40)			DEFAULT	NULL
,	unit_type					varchar(1)			DEFAULT	NULL
,	order_package_count			int					DEFAULT	NULL
,	order_carton_count			int					DEFAULT	NULL
,	order_fraction				int					DEFAULT	NULL
,	quantity_per_carton			int					DEFAULT	NULL
,	quantity_per_package		int					DEFAULT	NULL
,	quantity_per_fraction		int					DEFAULT	NULL
,	order_total_fraction		int					DEFAULT	NULL
,	package_count				int					DEFAULT	NULL
,	total_fraction				int					DEFAULT	NULL
,	warehouse_code				varchar(10)			DEFAULT	NULL
,	warehouse_name				varchar(30)			DEFAULT	NULL
,	lot							varchar(20)			DEFAULT	NULL
,	sub_lot						varchar(1)			DEFAULT	NULL
,	line_lot					varchar(2)			DEFAULT	NULL
,	campaign_flag				varchar(2)			DEFAULT	NULL
,	factory_type				varchar(3)			DEFAULT	NULL
,	control_type				varchar(10)			DEFAULT	NULL
,	shipment_type				varchar(10)			DEFAULT	NULL
,	billing_type				varchar(2)			DEFAULT	NULL
,	cooling_type				varchar(1)			DEFAULT	NULL
,	width						decimal(7,1)		DEFAULT	NULL
,	length						decimal(7,1)		DEFAULT	NULL
,	height						decimal(7,1)		DEFAULT	NULL
,	package_weight				decimal(10,3)		DEFAULT	NULL
,	shipping_weight				decimal(12,3)		DEFAULT	NULL
,	shipping_location_code		varchar(10)			DEFAULT	NULL
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (user_id,process_divide,work_detail_id)
,	KEY IX_pyt_w_106000_details_work_id (user_id,process_divide,work_id)
,	CONSTRAINT FK_pyt_w_106000_details_pyt_w_106000_head
		FOREIGN KEY (user_id,process_divide,work_id) REFERENCES pyt_w_106000_head (user_id,process_divide,work_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='営業倉庫システムCSV一時テーブル明細';//

delimiter ;
SET FOREIGN_KEY_CHECKS = 1;