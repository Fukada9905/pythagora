DROP TABLE IF EXISTS pyt_w_101050_details;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_w_101050_details(
	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	process_divide				tinyint				NOT NULL							COMMENT '処理区分'
,	work_detail_id				int UNSIGNED		NOT NULL							COMMENT 'ワーク明細ID'
,	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '事業所名称'
,	SNTCD						varchar(10)			DEFAULT NULL						COMMENT 'センターコード'
,	SNTNM						varchar(50)			DEFAULT NULL						COMMENT 'センター名称'
,	UNSKSCD						varchar(10)			DEFAULT NULL						COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)			DEFAULT NULL						COMMENT '運送会社名称'
,	SYORIYMD					datetime			DEFAULT NULL						COMMENT '処理日時'
,	DATEYMD						date				DEFAULT NULL						COMMENT '処理対象日'
,	SYUKAYMD					date				DEFAULT NULL						COMMENT '出荷日'
,	NOHINYMD					date				DEFAULT NULL						COMMENT '納品日'
,	NHNSKCD 					varchar(10)			DEFAULT NULL						COMMENT '納品先コード'
,	NHNSKNM 					varchar(100)		DEFAULT NULL						COMMENT '納品先名'
,	JYUSYO 						varchar(100)		DEFAULT NULL						COMMENT '住所'
,	BIKO 						varchar(200)		DEFAULT NULL						COMMENT '備考'
,	SHCD 						varchar(20)			DEFAULT NULL						COMMENT '商品コード'
,	DNRK 						varchar(20)			DEFAULT NULL						COMMENT '伝略'
,	RTNO 						varchar(20)			DEFAULT NULL						COMMENT 'ロット'
,	LOTK 						varchar(10)			DEFAULT NULL						COMMENT '管理区分'
,	KKTSR1						int					NOT NULL DEFAULT 0					COMMENT 'ケース数量'
,	KKTSR2						int					NOT NULL DEFAULT 0					COMMENT '中間数量'
,	KKTSR3						int					NOT NULL DEFAULT 0					COMMENT 'バラ数量'
,	KKTSSR						int					NOT NULL DEFAULT 0					COMMENT '総バラ数量'
,	WGT							decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '総重量'
,	id							bigint				NOT NULL							COMMENT 'ID'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (user_id, process_divide, work_detail_id)
,	KEY IX_pyt_w_101050_details_fk_head (user_id,process_divide,work_id,NNSICD)
,	KEY IX_pyt_w_101050_details_id (id)
,	CONSTRAINT FK_pyt_w_101050_details_pyt_w_101050_head
		FOREIGN KEY (user_id,process_divide,work_id) REFERENCES pyt_w_101050_head (user_id,process_divide,work_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仮出荷物量把握一時テーブル明細';//

delimiter ;
