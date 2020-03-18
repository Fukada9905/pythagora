delimiter //
/** テーブル作成 **/
CREATE TABLE wk_204000_details(
	work_detail_id				int UNSIGNED		NOT NULL							COMMENT 'ワーク明細ID'
,	work_id						int UNSIGNED		NOT NULL							COMMENT 'ワークID'
,	DENNO						varchar(20)			DEFAULT NULL						COMMENT '伝票番号'
,	SHCD						varchar(10)			DEFAULT NULL						COMMENT '商品コード'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	SHNM						varchar(50)			DEFAULT NULL						COMMENT '商品名'
,	RTNO						varchar(20)			DEFAULT NULL						COMMENT 'ロット'
,	KKTSR1						int					NOT NULL DEFAULT 0					COMMENT '入荷予定ケース数量'
,	KKTSR3						int					NOT NULL DEFAULT 0					COMMENT '入荷予定バラ数量'
,	JitsuCase					int					NOT NULL DEFAULT 0					COMMENT '実ケース'
,	JitsuBara					int					NOT NULL DEFAULT 0					COMMENT '実バラ'
,	Comment						varchar(255)		DEFAULT NULL						COMMENT 'コメント'
,	Reporter					varchar(20)			DEFAULT NULL						COMMENT '報告者'
,	Status						tinyint				NOT NULL DEFAULT 0					COMMENT 'ステータス'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前方参照用キー'
,	ID							int					DEFAULT NULL						COMMENT '入荷予定ID'
,	DENGNO						int					DEFAULT NULL						COMMENT '伝票行番号'
,	NIBKNRDENGNO				int					DEFAULT NULL						COMMENT '内部管理伝票行番号'
,	JGSCD_SK					varchar(10)			DEFAULT NULL						COMMENT '出荷元事業所コード'
,	SNTCD_SK					varchar(10)			DEFAULT NULL						COMMENT '出荷元センターコード'
,	LOTK						varchar(2)			DEFAULT NULL						COMMENT '管理区分'
,	LOTS						varchar(2)			DEFAULT NULL						COMMENT '出荷区分'
,	FCKBNKK						varchar(3)			DEFAULT NULL						COMMENT '工場コード'
,	PRIMARY KEY (work_detail_id)
,	KEY IX_wk_204000_details_work_id (work_id)
,	KEY IX_wk_204000_details_arrival_schedule_details (ID,DENGNO,NIBKNRDENGNO,SHCD,JGSCD_SK,SNTCD_SK,RTNO,LOTK,LOTS,FCKBNKK)
,	CONSTRAINT FK_wk_204000_details_wk_204000_head
		FOREIGN KEY (work_id) REFERENCES wk_204000_head (work_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入荷入力一時テーブル明細 (入荷入力一時テーブル(明細))';//

delimiter ;
