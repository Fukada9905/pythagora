delimiter //
/** テーブル作成 **/
CREATE TABLE shipment_provisionals(
	ID							int					NOT NULL							COMMENT '仮出荷ID'
,	DKBN						varchar(2)			NOT NULL							COMMENT 'データ区分'
,	DKBNNM						varchar(10)			NOT NULL							COMMENT 'データ区分名称'
,	NNSICD						varchar(10)			NOT NULL							COMMENT '荷主コード'
,	NNSINM						varchar(50)			NOT NULL							COMMENT '荷主名'
,	DENPYOYMD					date				NOT NULL							COMMENT '伝票日付'
,	SYUKAYMD					date				DEFAULT NULL						COMMENT '出荷日'
,	NOHINYMD					date				NOT NULL							COMMENT '納品日'
,	SYORIYMD					datetime			DEFAULT NULL						COMMENT '処理日時'
,	SYUKAP						varchar(10)			DEFAULT NULL						COMMENT '出荷場所コード'
,	SYUKANM						varchar(50)			DEFAULT NULL						COMMENT '出荷場所名称'
,	HKATKK						tinyint				NOT NULL DEFAULT 0					COMMENT '引当エラーフラグ'
,	UNSKSCD						varchar(10)			NOT NULL							COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)			NOT NULL							COMMENT '運送会社名称'
,	SKHNYKBN1					varchar(10)			NOT NULL							COMMENT 'ＩＤ'
,	SKHNYKBN1NM					varchar(50)			NOT NULL							COMMENT 'ＩＤ名称'
,	DENNO						varchar(20)			NOT NULL							COMMENT '伝票番号'
,	JCDENNO						varchar(20)			DEFAULT NULL						COMMENT '受注伝票番号'
,	NHNSKCD						varchar(10)			NOT NULL							COMMENT '納品先コード'
,	NHNSKNM						varchar(50)			NOT NULL							COMMENT '納品先名称'
,	JISCD						varchar(5)			NOT NULL							COMMENT '地区コード'
,	JYUSYO						varchar(100)		NOT NULL							COMMENT '納品先住所'
,	TEL							varchar(15)			NOT NULL							COMMENT '納品先電話番号'
,	BIKO						varchar(200)		DEFAULT NULL						COMMENT '備考'
,	BIKO2						varchar(200)		DEFAULT NULL						COMMENT '備考２'
,	ENTKBN						varchar(10)			DEFAULT NULL						COMMENT 'エントリ区分'
,	ENTKBNNM					varchar(50)			DEFAULT NULL						COMMENT 'エントリ区分名称'
,	KOJYOFLG					varchar(10)			DEFAULT NULL						COMMENT '工場直送フラグ'
,	STN							varchar(10)			DEFAULT NULL						COMMENT '荷主支店コード'
,	SCUS						varchar(10)			DEFAULT NULL						COMMENT '荷主出張所コード'
,	K							varchar(10)			DEFAULT NULL						COMMENT '荷主課コード'
,	HN							varchar(10)			DEFAULT NULL						COMMENT '荷主班コード'
,	GENCD						varchar(10)			DEFAULT NULL						COMMENT '原価センタコード'
,	PJCD						varchar(10)			DEFAULT NULL						COMMENT 'プロジェクトコード'
,	TANTO						varchar(10)			DEFAULT NULL						COMMENT '担当者社員番号'
,	UTIKAEFLG					tinyint				NOT NULL DEFAULT 0					COMMENT '打変フラグ'
,	TRKMJ						datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'ＤＢ取込時間'
,	PRIMARY KEY (ID)
,	UNIQUE KEY UQ_shipment_provisionals_NNSICD_DENPYOYMD_DENNO(NNSICD,DENPYOYMD,DENNO)
,	KEY IX_shipment_provisionals_NNSICD_SYUKAYMD (DKBN,NNSICD,SYUKAYMD)
,	KEY IX_shipment_provisionals_NNSICD_NOHINYMD (DKBN,NNSICD,NOHINYMD)
,	KEY IX_shipment_provisionals_DENPYOYMD (DKBN,DENPYOYMD,SKHNYKBN1)
,	KEY IX_shipment_provisionals_SYUKAYMD (DKBN,SYUKAYMD,SKHNYKBN1)
,	KEY IX_shipment_provisionals_NOHINYMD (DKBN,NOHINYMD,SKHNYKBN1)
,	KEY IX_shipment_provisionals_SYORIYMD (SYORIYMD)
,	KEY IX_shipment_provisionals_UNSKSCD (UNSKSCD)
,	KEY IX_shipment_provisionals_SKHNYKBN1 (SKHNYKBN1)
,	KEY IX_shipment_provisionals_DENNO (DENNO)
,	KEY IX_shipment_provisionals_TRKMJ (TRKMJ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仮出荷HEAD (仮出荷ヘッダテーブル)';//

/** INSERT トリガー **/
CREATE TRIGGER shipment_provisionals_AFTER_INSERT AFTER INSERT ON shipment_provisionals FOR EACH ROW
BEGIN
	INSERT INTO shipment_provisionals_history(
			history_record_divide
		,	ID
		,	DKBN
		,	DKBNNM
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	SYUKAP
		,	SYUKANM
		,	HKATKK
		,	UNSKSCD
		,	UNSKSNM
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JCDENNO
		,	NHNSKCD
		,	NHNSKNM
		,	JISCD
		,	JYUSYO
		,	TEL
		,	BIKO
		,	BIKO2
		,	ENTKBN
		,	ENTKBNNM
		,	KOJYOFLG
		,	STN
		,	SCUS
		,	K
		,	HN
		,	GENCD
		,	PJCD
		,	TANTO
		,	UTIKAEFLG
		,	TRKMJ
	)
	VALUES(
			'I'
		,	NEW.ID
		,	NEW.DKBN
		,	NEW.DKBNNM
		,	NEW.NNSICD
		,	NEW.NNSINM
		,	NEW.DENPYOYMD
		,	NEW.SYUKAYMD
		,	NEW.NOHINYMD
		,	NEW.SYORIYMD
		,	NEW.SYUKAP
		,	NEW.SYUKANM
		,	NEW.HKATKK
		,	NEW.UNSKSCD
		,	NEW.UNSKSNM
		,	NEW.SKHNYKBN1
		,	NEW.SKHNYKBN1NM
		,	NEW.DENNO
		,	NEW.JCDENNO
		,	NEW.NHNSKCD
		,	NEW.NHNSKNM
		,	NEW.JISCD
		,	NEW.JYUSYO
		,	NEW.TEL
		,	NEW.BIKO
		,	NEW.BIKO2
		,	NEW.ENTKBN
		,	NEW.ENTKBNNM
		,	NEW.KOJYOFLG
		,	NEW.STN
		,	NEW.SCUS
		,	NEW.K
		,	NEW.HN
		,	NEW.GENCD
		,	NEW.PJCD
		,	NEW.TANTO
		,	NEW.UTIKAEFLG
		,	NEW.TRKMJ
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER shipment_provisionals_AFTER_UPDATE AFTER UPDATE ON shipment_provisionals FOR EACH ROW
BEGIN
	INSERT INTO shipment_provisionals_history(
			history_record_divide
		,	ID
		,	DKBN
		,	DKBNNM
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	SYUKAP
		,	SYUKANM
		,	HKATKK
		,	UNSKSCD
		,	UNSKSNM
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JCDENNO
		,	NHNSKCD
		,	NHNSKNM
		,	JISCD
		,	JYUSYO
		,	TEL
		,	BIKO
		,	BIKO2
		,	ENTKBN
		,	ENTKBNNM
		,	KOJYOFLG
		,	STN
		,	SCUS
		,	K
		,	HN
		,	GENCD
		,	PJCD
		,	TANTO
		,	UTIKAEFLG
		,	TRKMJ
	)
	VALUES(
			'U'
		,	NEW.ID
		,	NEW.DKBN
		,	NEW.DKBNNM
		,	NEW.NNSICD
		,	NEW.NNSINM
		,	NEW.DENPYOYMD
		,	NEW.SYUKAYMD
		,	NEW.NOHINYMD
		,	NEW.SYORIYMD
		,	NEW.SYUKAP
		,	NEW.SYUKANM
		,	NEW.HKATKK
		,	NEW.UNSKSCD
		,	NEW.UNSKSNM
		,	NEW.SKHNYKBN1
		,	NEW.SKHNYKBN1NM
		,	NEW.DENNO
		,	NEW.JCDENNO
		,	NEW.NHNSKCD
		,	NEW.NHNSKNM
		,	NEW.JISCD
		,	NEW.JYUSYO
		,	NEW.TEL
		,	NEW.BIKO
		,	NEW.BIKO2
		,	NEW.ENTKBN
		,	NEW.ENTKBNNM
		,	NEW.KOJYOFLG
		,	NEW.STN
		,	NEW.SCUS
		,	NEW.K
		,	NEW.HN
		,	NEW.GENCD
		,	NEW.PJCD
		,	NEW.TANTO
		,	NEW.UTIKAEFLG
		,	NEW.TRKMJ
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER shipment_provisionals_AFTER_DELETE AFTER DELETE ON shipment_provisionals FOR EACH ROW
BEGIN
	INSERT INTO shipment_provisionals_history(
			history_record_divide
		,	ID
		,	DKBN
		,	DKBNNM
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	SYUKAP
		,	SYUKANM
		,	HKATKK
		,	UNSKSCD
		,	UNSKSNM
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JCDENNO
		,	NHNSKCD
		,	NHNSKNM
		,	JISCD
		,	JYUSYO
		,	TEL
		,	BIKO
		,	BIKO2
		,	ENTKBN
		,	ENTKBNNM
		,	KOJYOFLG
		,	STN
		,	SCUS
		,	K
		,	HN
		,	GENCD
		,	PJCD
		,	TANTO
		,	UTIKAEFLG
		,	TRKMJ
	)
	VALUES(
			'D'
		,	OLD.ID
		,	OLD.DKBN
		,	OLD.DKBNNM
		,	OLD.NNSICD
		,	OLD.NNSINM
		,	OLD.DENPYOYMD
		,	OLD.SYUKAYMD
		,	OLD.NOHINYMD
		,	OLD.SYORIYMD
		,	OLD.SYUKAP
		,	OLD.SYUKANM
		,	OLD.HKATKK
		,	OLD.UNSKSCD
		,	OLD.UNSKSNM
		,	OLD.SKHNYKBN1
		,	OLD.SKHNYKBN1NM
		,	OLD.DENNO
		,	OLD.JCDENNO
		,	OLD.NHNSKCD
		,	OLD.NHNSKNM
		,	OLD.JISCD
		,	OLD.JYUSYO
		,	OLD.TEL
		,	OLD.BIKO
		,	OLD.BIKO2
		,	OLD.ENTKBN
		,	OLD.ENTKBNNM
		,	OLD.KOJYOFLG
		,	OLD.STN
		,	OLD.SCUS
		,	OLD.K
		,	OLD.HN
		,	OLD.GENCD
		,	OLD.PJCD
		,	OLD.TANTO
		,	OLD.UTIKAEFLG
		,	OLD.TRKMJ
	);
END;//


delimiter ;
