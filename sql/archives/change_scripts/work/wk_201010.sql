delimiter //
/** テーブル作成 **/
CREATE TABLE wk_201010(
	work_id						int UNSIGNED		NOT NULL							COMMENT '一時ID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	NOHINYMD					varchar(50)			DEFAULT NULL						COMMENT '入荷予定日'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名称'
,	KKTSR1						int					NOT NULL DEFAULT 0					COMMENT 'ケース数量'
,	KKTSR3						int					NOT NULL DEFAULT 0					COMMENT 'バラ数量'
,	MOD_PL						int					NOT NULL DEFAULT 0					COMMENT '概算PL数'
,	DATA_DIVIDE					tinyint				NOT NULL DEFAULT 1					COMMENT 'データ区分'
,	PRIMARY KEY (work_id)
,	KEY IX_wk_201010_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入荷メーカー別物量一時テーブル (入荷メーカー別物量一時テーブル)';//

delimiter ;
