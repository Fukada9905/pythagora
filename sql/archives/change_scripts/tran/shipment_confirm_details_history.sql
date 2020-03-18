delimiter //
/** テーブル作成 **/
CREATE TABLE shipment_confirm_details_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	ID							int						NOT NULL							COMMENT '出荷ID'
,	JGSCD						varchar(10)				NOT NULL							COMMENT '事業所コード'
,	JGSNM						varchar(50)				NOT NULL							COMMENT '事業所名称'
,	SNTCD						varchar(10)				NOT NULL							COMMENT 'センターコード'
,	SNTNM						varchar(50)				NOT NULL							COMMENT 'センター名称'
,	DENGNO						int						NOT NULL							COMMENT '伝票行番号'
,	SHCD						varchar(10)				NOT NULL							COMMENT '商品コード'
,	SHNM						varchar(50)				NOT NULL							COMMENT '製品名称'
,	DNRK						varchar(20)				DEFAULT NULL						COMMENT '電略'
,	SEKKBN						varchar(4)				NOT NULL							COMMENT '請求区分'
,	SHNKKKMEI_KS				varchar(20)				DEFAULT NULL						COMMENT '規格_ケース'
,	SHNKKKMEI_CU				varchar(20)				DEFAULT NULL						COMMENT '規格_中間'
,	SHNKKKMEI_BR				varchar(20)				DEFAULT NULL						COMMENT '規格_バラ'
,	RTNO						varchar(20)				NOT NULL							COMMENT 'ロット'
,	SR1RS						int						NOT NULL							COMMENT 'ケース入目'
,	SR2RS						int						NOT NULL							COMMENT 'バラ入目'
,	PL							int						NOT NULL DEFAULT 0					COMMENT 'パレット積付数'
,	KHKBN						tinyint					NOT NULL DEFAULT 0					COMMENT '梱端区分'
,	KKTSR1						int						NOT NULL DEFAULT 0					COMMENT 'ケース数量'
,	KKTSR2						int						NOT NULL DEFAULT 0					COMMENT '中間数量'
,	KKTSR3						int						NOT NULL DEFAULT 0					COMMENT 'バラ数量'
,	KKTSSR						int						NOT NULL DEFAULT 0					COMMENT '総バラ数量'
,	WGT							decimal(10,3)			NOT NULL DEFAULT 0					COMMENT '総重量'
,	LOTK						varchar(2)				NOT NULL							COMMENT '管理区分'
,	LOTS						varchar(2)				NOT NULL							COMMENT '出荷区分'
,	FCKBNKK						varchar(3)				NOT NULL							COMMENT '工場コード'
,	TRKMJ						datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'DB取込時間'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出荷確定BODYの履歴保持を行う)';//

delimiter ;
