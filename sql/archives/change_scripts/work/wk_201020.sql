delimiter //
/** テーブル作成 **/
CREATE TABLE wk_201020(
	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	NOHINYMD					varchar(50)			DEFAULT NULL						COMMENT '入荷予定日'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '出荷元事業コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '出荷元事業所名'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	KKTSR1						int					NOT NULL DEFAULT 0					COMMENT 'ケース数量'
,	MOD_PL						int					NOT NULL DEFAULT 0					COMMENT '概算PL数'
,	DATA_DIVIDE					tinyint				NOT NULL DEFAULT 1					COMMENT 'データ区分'
,	PRIMARY KEY (work_id)
,	KEY IX_wk_201020_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入荷荷倉庫別物量一時テーブル (入荷出荷倉庫別物量一時テーブル)';//

delimiter ;
