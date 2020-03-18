delimiter //
/** テーブル作成 **/
CREATE TABLE shipment_confirms_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	ID							int						NOT NULL							COMMENT '出荷ID'
,	NNSICD						varchar(10)				NOT NULL							COMMENT '荷主コード'
,	NNSINM						varchar(50)				NOT NULL							COMMENT '荷主名'
,	DENPYOYMD					date					NOT NULL							COMMENT '伝票日付'
,	SYUKAYMD					date					DEFAULT NULL						COMMENT '出荷日'
,	NOHINYMD					date					NOT NULL							COMMENT '納品日'
,	SYORIYMD					datetime				DEFAULT NULL						COMMENT '処理日時'
,	SYUKAP						varchar(10)				DEFAULT NULL						COMMENT '出荷場所コード'
,	UNSKSCD						varchar(10)				NOT NULL							COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)				NOT NULL							COMMENT '運送会社名称'
,	KZIMI						varchar(20)				DEFAULT NULL						COMMENT '機材名称'
,	SKHNYKBN1					varchar(10)				NOT NULL							COMMENT 'ID'
,	SKHNYKBN1NM					varchar(50)				NOT NULL							COMMENT 'ID名称'
,	DENNO						varchar(20)				NOT NULL							COMMENT '伝票番号'
,	JCDENNO						varchar(20)				DEFAULT NULL						COMMENT '受注伝票番号'
,	KRMBN						varchar(8)				DEFAULT NULL						COMMENT '車番'
,	NHNSKCD						varchar(10)				NOT NULL							COMMENT '納品先コード'
,	NHNSKNM						varchar(50)				NOT NULL							COMMENT '納品先名称'
,	JISCD						varchar(5)				NOT NULL							COMMENT '地区コード'
,	JYUSYO						varchar(100)			NOT NULL							COMMENT '納品先住所'
,	TEL							varchar(15)				NOT NULL							COMMENT '納品先電話番号'
,	BIKO						varchar(200)			DEFAULT NULL						COMMENT '備考'
,	KOJYOFLG					varchar(10)				DEFAULT NULL						COMMENT '工場直送フラグ'
,	TRKMJ						datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'DB取込時間'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出荷確定HEADの履歴保持を行う)';//

delimiter ;
