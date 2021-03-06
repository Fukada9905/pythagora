delimiter //
/** テーブル作成 **/
CREATE TABLE wk_103020_details(
	work_detail_id				int UNSIGNED		NOT NULL							COMMENT 'ワーク明細ID'
,	work_id						int UNSIGNED		NOT NULL							COMMENT 'ワークID'
,	DKBNNM						varchar(10)			DEFAULT NULL						COMMENT 'データ区分名称'
,	NNSICD						varchar(10)			DEFAULT NULL						COMMENT '荷主コード'
,	NNSINM						varchar(50)			DEFAULT NULL						COMMENT '荷主名'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	JGSNM						varchar(50)			DEFAULT NULL						COMMENT '事業所名称'
,	JCDENNO						varchar(20)			DEFAULT NULL						COMMENT '受注伝票番号'
,	DENNO						varchar(20)			DEFAULT NULL						COMMENT '伝票番号'
,	DENGNO						int					NOT NULL DEFAULT 0					COMMENT '伝票行番号'
,	SYUKAP						varchar(10)			DEFAULT NULL						COMMENT '出荷場所コード'
,	LOTK						varchar(2)			DEFAULT NULL						COMMENT '管理区分'
,	LOTS						varchar(2)			DEFAULT NULL						COMMENT '出荷区分'
,	FCKBNKK						varchar(3)			DEFAULT NULL						COMMENT '工場コード'
,	SNTCD						varchar(10)			DEFAULT NULL						COMMENT 'センターコード'
,	SNTNM						varchar(50)			DEFAULT NULL						COMMENT 'センター名称'
,	PTNNM						varchar(50)			DEFAULT NULL						COMMENT 'PT名称'
,	UNSKSCD						varchar(10)			DEFAULT NULL						COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)			DEFAULT NULL						COMMENT '運送会社名称'
,	SKHNYKBN1					varchar(10)			DEFAULT NULL						COMMENT 'ＩＤ'
,	SKHNYKBN1NM					varchar(50)			DEFAULT NULL						COMMENT 'ＩＤ名称'
,	SYORIYMD					datetime			DEFAULT NULL						COMMENT '処理日時'
,	SYUKAYMD					date				DEFAULT NULL						COMMENT '出荷日'
,	NOHINYMD					date				DEFAULT NULL						COMMENT '納品日'
,	DENPYOYMD					date				DEFAULT NULL						COMMENT '伝票日付'
,	NHNSKCD						varchar(10)			DEFAULT NULL						COMMENT '納品先コード'
,	NHNSKNM						varchar(50)			DEFAULT NULL						COMMENT '納品先名称'
,	JYUSYO						varchar(100)		DEFAULT NULL						COMMENT '納品先住所'
,	TEL							varchar(15)			DEFAULT NULL						COMMENT '納品先電話番号'
,	JISCD						varchar(5)			DEFAULT NULL						COMMENT '地区コード'
,	KRMBN						varchar(8)			DEFAULT NULL						COMMENT '車番'
,	SHCD						varchar(10)			DEFAULT NULL						COMMENT '商品コード'
,	DNRK						varchar(20)			DEFAULT NULL						COMMENT '電略'
,	SHNM						varchar(50)			DEFAULT NULL						COMMENT '製品名称'
,	SHNKKKMEI					varchar(20)			DEFAULT NULL						COMMENT '規格'
,	SEKKBN						varchar(10)			DEFAULT NULL						COMMENT '請求区分'
,	RTNO						varchar(20)			DEFAULT NULL						COMMENT 'ロット'
,	SR1RS						int					NOT NULL DEFAULT 0					COMMENT 'ケース入目'
,	SR2RS						int					NOT NULL DEFAULT 0					COMMENT '中間入目'
,	KHKBN						tinyint				NOT NULL DEFAULT 0					COMMENT '梱端区分'
,	PL							int					NOT NULL DEFAULT 0					COMMENT 'パレット積付数'
,	KKTSR1						int					NOT NULL DEFAULT 0					COMMENT 'ケース数量'
,	PL_DIV						int					NOT NULL DEFAULT 0					COMMENT 'パレット枚数'
,	PL_MOD						int					NOT NULL DEFAULT 0					COMMENT 'パレット端数'
,	KKTSR2						int					NOT NULL DEFAULT 0					COMMENT '中間数量'
,	KKTSR3						int					NOT NULL DEFAULT 0					COMMENT 'バラ数量'
,	KKTSSR						int					NOT NULL DEFAULT 0					COMMENT '総バラ数量'
,	WGT							decimal(10,3)		NOT NULL DEFAULT 0					COMMENT '総重量'
,	KOJYOFLG					varchar(10)			DEFAULT NULL						COMMENT '工場直送フラグ'
,	BIKO						varchar(200)		DEFAULT NULL						COMMENT '備考'
,	TRKMJ						varchar(8)			DEFAULT NULL						COMMENT 'ＤＢ取込時間（yyyymmdd）'
,	TRKMJ_YYYY					varchar(4)			DEFAULT NULL						COMMENT 'ＤＢ取込時間（yyyy）'
,	TRKMJ_MM					varchar(2)			DEFAULT NULL						COMMENT 'ＤＢ取込時間（mm）'
,	TRKMJ_DD					varchar(2)			DEFAULT NULL						COMMENT 'ＤＢ取込時間（dd）'
,	prev_key					varchar(255)		DEFAULT NULL						COMMENT '前列参照用キー'
,	PRIMARY KEY (work_detail_id)
,	KEY IX_wk_103020_details_work_id (work_id)
,	CONSTRAINT FK_wk_103020_details_wk_103020_head
		FOREIGN KEY (work_id) REFERENCES wk_103020_head (work_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='補給ダウンロード一時テーブル明細 (補給ダウンロード一時テーブル(明細))';//

delimiter ;
