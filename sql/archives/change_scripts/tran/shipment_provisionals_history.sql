delimiter //
/** テーブル作成 **/
CREATE TABLE shipment_provisionals_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	ID							int						NOT NULL							COMMENT '仮出荷ID'
,	DKBN						varchar(2)				NOT NULL							COMMENT 'データ区分'
,	DKBNNM						varchar(10)				NOT NULL							COMMENT 'データ区分名称'
,	NNSICD						varchar(10)				NOT NULL							COMMENT '荷主コード'
,	NNSINM						varchar(50)				NOT NULL							COMMENT '荷主名'
,	DENPYOYMD					date					NOT NULL							COMMENT '伝票日付'
,	SYUKAYMD					date					DEFAULT NULL						COMMENT '出荷日'
,	NOHINYMD					date					NOT NULL							COMMENT '納品日'
,	SYORIYMD					datetime				DEFAULT NULL						COMMENT '処理日時'
,	SYUKAP						varchar(10)				DEFAULT NULL						COMMENT '出荷場所コード'
,	SYUKANM						varchar(50)				DEFAULT NULL						COMMENT '出荷場所名称'
,	HKATKK						tinyint					NOT NULL DEFAULT 0					COMMENT '引当エラーフラグ'
,	UNSKSCD						varchar(10)				NOT NULL							COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)				NOT NULL							COMMENT '運送会社名称'
,	SKHNYKBN1					varchar(10)				NOT NULL							COMMENT 'ＩＤ'
,	SKHNYKBN1NM					varchar(50)				NOT NULL							COMMENT 'ＩＤ名称'
,	DENNO						varchar(20)				NOT NULL							COMMENT '伝票番号'
,	JCDENNO						varchar(20)				DEFAULT NULL						COMMENT '受注伝票番号'
,	NHNSKCD						varchar(10)				NOT NULL							COMMENT '納品先コード'
,	NHNSKNM						varchar(50)				NOT NULL							COMMENT '納品先名称'
,	JISCD						varchar(5)				NOT NULL							COMMENT '地区コード'
,	JYUSYO						varchar(100)			NOT NULL							COMMENT '納品先住所'
,	TEL							varchar(15)				NOT NULL							COMMENT '納品先電話番号'
,	BIKO						varchar(200)			DEFAULT NULL						COMMENT '備考'
,	BIKO2						varchar(200)			DEFAULT NULL						COMMENT '備考２'
,	ENTKBN						varchar(10)				DEFAULT NULL						COMMENT 'エントリ区分'
,	ENTKBNNM					varchar(50)				DEFAULT NULL						COMMENT 'エントリ区分名称'
,	KOJYOFLG					varchar(10)				DEFAULT NULL						COMMENT '工場直送フラグ'
,	STN							varchar(10)				DEFAULT NULL						COMMENT '荷主支店コード'
,	SCUS						varchar(10)				DEFAULT NULL						COMMENT '荷主出張所コード'
,	K							varchar(10)				DEFAULT NULL						COMMENT '荷主課コード'
,	HN							varchar(10)				DEFAULT NULL						COMMENT '荷主班コード'
,	GENCD						varchar(10)				DEFAULT NULL						COMMENT '原価センタコード'
,	PJCD						varchar(10)				DEFAULT NULL						COMMENT 'プロジェクトコード'
,	TANTO						varchar(10)				DEFAULT NULL						COMMENT '担当者社員番号'
,	UTIKAEFLG					tinyint					NOT NULL DEFAULT 0					COMMENT '打変フラグ'
,	TRKMJ						datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'ＤＢ取込時間'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='仮出荷HEADの履歴保持を行う)';//

delimiter ;
