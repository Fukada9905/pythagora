delimiter //
/** テーブル作成 **/
CREATE TABLE shipment_confirms(
	ID							int					NOT NULL							COMMENT '出荷ID'
,	NNSICD						varchar(10)			NOT NULL							COMMENT '荷主コード'
,	NNSINM						varchar(50)			NOT NULL							COMMENT '荷主名'
,	DENPYOYMD					date				NOT NULL							COMMENT '伝票日付'
,	SYUKAYMD					date				DEFAULT NULL						COMMENT '出荷日'
,	NOHINYMD					date				NOT NULL							COMMENT '納品日'
,	SYORIYMD					datetime			DEFAULT NULL						COMMENT '処理日時'
,	SYUKAP						varchar(10)			DEFAULT NULL						COMMENT '出荷場所コード'
,	UNSKSCD						varchar(10)			NOT NULL							COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)			NOT NULL							COMMENT '運送会社名称'
,	KZIMI						varchar(20)			DEFAULT NULL						COMMENT '機材名称'
,	SKHNYKBN1					varchar(10)			NOT NULL							COMMENT 'ID'
,	SKHNYKBN1NM					varchar(50)			NOT NULL							COMMENT 'ID名称'
,	DENNO						varchar(20)			NOT NULL							COMMENT '伝票番号'
,	JCDENNO						varchar(20)			DEFAULT NULL						COMMENT '受注伝票番号'
,	KRMBN						varchar(8)			DEFAULT NULL						COMMENT '車番'
,	NHNSKCD						varchar(10)			NOT NULL							COMMENT '納品先コード'
,	NHNSKNM						varchar(50)			NOT NULL							COMMENT '納品先名称'
,	JISCD						varchar(5)			NOT NULL							COMMENT '地区コード'
,	JYUSYO						varchar(100)		NOT NULL							COMMENT '納品先住所'
,	TEL							varchar(15)			NOT NULL							COMMENT '納品先電話番号'
,	BIKO						varchar(200)		DEFAULT NULL						COMMENT '備考'
,	KOJYOFLG					varchar(10)			DEFAULT NULL						COMMENT '工場直送フラグ'
,	TRKMJ						datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'DB取込時間'
,	PRIMARY KEY (ID,NNSICD)
,	UNIQUE KEY UQ_shipment_confirms_NNSICD_DENPYOYMD_DENNO(NNSICD,DENPYOYMD,DENNO)
,	KEY IX_shipment_confirms_NNSICD_DENPYOYMD (NNSICD,DENPYOYMD)
,	KEY IX_shipment_confirms_NNSICD_SYUKAYMD (NNSICD,SYUKAYMD)
,	KEY IX_shipment_confirms_NNSICD_NOHINYMD (NNSICD,NOHINYMD)
,	KEY IX_shipment_confirms_DENPYOYMD (DENPYOYMD,SKHNYKBN1)
,	KEY IX_shipment_confirms_SYUKAYMD (SYUKAYMD,SKHNYKBN1)
,	KEY IX_shipment_confirms_NOHINYMD (NOHINYMD,SKHNYKBN1)
,	KEY IX_shipment_confirms_SYORIYMD (SYORIYMD)
,	KEY IX_shipment_confirms_UNSKSCD (UNSKSCD)
,	KEY IX_shipment_confirms_DENNO (DENNO)
,	KEY IX_shipment_confirms_TRKMJ (TRKMJ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='出荷確定HEAD (出荷確定ヘッダテーブル)';//

/** INSERT トリガー **/
CREATE TRIGGER shipment_confirms_AFTER_INSERT AFTER INSERT ON shipment_confirms FOR EACH ROW
BEGIN
	INSERT INTO shipment_confirms_history(
			history_record_divide
		,	ID
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	SYUKAP
		,	UNSKSCD
		,	UNSKSNM
		,	KZIMI
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JCDENNO
		,	KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	JISCD
		,	JYUSYO
		,	TEL
		,	BIKO
		,	KOJYOFLG
		,	TRKMJ
	)
	VALUES(
			'I'
		,	NEW.ID
		,	NEW.NNSICD
		,	NEW.NNSINM
		,	NEW.DENPYOYMD
		,	NEW.SYUKAYMD
		,	NEW.NOHINYMD
		,	NEW.SYORIYMD
		,	NEW.SYUKAP
		,	NEW.UNSKSCD
		,	NEW.UNSKSNM
		,	NEW.KZIMI
		,	NEW.SKHNYKBN1
		,	NEW.SKHNYKBN1NM
		,	NEW.DENNO
		,	NEW.JCDENNO
		,	NEW.KRMBN
		,	NEW.NHNSKCD
		,	NEW.NHNSKNM
		,	NEW.JISCD
		,	NEW.JYUSYO
		,	NEW.TEL
		,	NEW.BIKO
		,	NEW.KOJYOFLG
		,	NEW.TRKMJ
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER shipment_confirms_AFTER_UPDATE AFTER UPDATE ON shipment_confirms FOR EACH ROW
BEGIN
	INSERT INTO shipment_confirms_history(
			history_record_divide
		,	ID
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	SYUKAP
		,	UNSKSCD
		,	UNSKSNM
		,	KZIMI
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JCDENNO
		,	KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	JISCD
		,	JYUSYO
		,	TEL
		,	BIKO
		,	KOJYOFLG
		,	TRKMJ
	)
	VALUES(
			'U'
		,	NEW.ID
		,	NEW.NNSICD
		,	NEW.NNSINM
		,	NEW.DENPYOYMD
		,	NEW.SYUKAYMD
		,	NEW.NOHINYMD
		,	NEW.SYORIYMD
		,	NEW.SYUKAP
		,	NEW.UNSKSCD
		,	NEW.UNSKSNM
		,	NEW.KZIMI
		,	NEW.SKHNYKBN1
		,	NEW.SKHNYKBN1NM
		,	NEW.DENNO
		,	NEW.JCDENNO
		,	NEW.KRMBN
		,	NEW.NHNSKCD
		,	NEW.NHNSKNM
		,	NEW.JISCD
		,	NEW.JYUSYO
		,	NEW.TEL
		,	NEW.BIKO
		,	NEW.KOJYOFLG
		,	NEW.TRKMJ
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER shipment_confirms_AFTER_DELETE AFTER DELETE ON shipment_confirms FOR EACH ROW
BEGIN
	INSERT INTO shipment_confirms_history(
			history_record_divide
		,	ID
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	SYUKAP
		,	UNSKSCD
		,	UNSKSNM
		,	KZIMI
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JCDENNO
		,	KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	JISCD
		,	JYUSYO
		,	TEL
		,	BIKO
		,	KOJYOFLG
		,	TRKMJ
	)
	VALUES(
			'D'
		,	OLD.ID
		,	OLD.NNSICD
		,	OLD.NNSINM
		,	OLD.DENPYOYMD
		,	OLD.SYUKAYMD
		,	OLD.NOHINYMD
		,	OLD.SYORIYMD
		,	OLD.SYUKAP
		,	OLD.UNSKSCD
		,	OLD.UNSKSNM
		,	OLD.KZIMI
		,	OLD.SKHNYKBN1
		,	OLD.SKHNYKBN1NM
		,	OLD.DENNO
		,	OLD.JCDENNO
		,	OLD.KRMBN
		,	OLD.NHNSKCD
		,	OLD.NHNSKNM
		,	OLD.JISCD
		,	OLD.JYUSYO
		,	OLD.TEL
		,	OLD.BIKO
		,	OLD.KOJYOFLG
		,	OLD.TRKMJ
	);
END;//


delimiter ;
