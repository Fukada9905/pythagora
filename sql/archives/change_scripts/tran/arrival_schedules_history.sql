delimiter //
/** テーブル作成 **/
CREATE TABLE arrival_schedules_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	ID							int						NOT NULL							COMMENT '入荷予定ID'
,	NNSICD						varchar(10)				NOT NULL							COMMENT '荷主コード'
,	NNSINM						varchar(50)				NOT NULL							COMMENT '荷主名'
,	DENPYOYMD					date					NOT NULL							COMMENT '伝票日付'
,	SYUKAYMD					date					DEFAULT NULL						COMMENT '出荷日'
,	NOHINYMD					date					NOT NULL							COMMENT '入荷予定日'
,	SYORIYMD					datetime				DEFAULT NULL						COMMENT '処理日時'
,	UNSKSCD						varchar(10)				NOT NULL							COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)				NOT NULL							COMMENT '運送会社名称'
,	KZIMI						varchar(20)				DEFAULT NULL						COMMENT '機材名称'
,	SKHNYKBN1					varchar(10)				NOT NULL							COMMENT 'ID'
,	SKHNYKBN1NM					varchar(50)				NOT NULL							COMMENT 'ID名称'
,	DENNO						varchar(20)				NOT NULL							COMMENT '伝票番号'
,	JGSCD_NK					varchar(10)				NOT NULL							COMMENT '入荷事業所コード'
,	JGSNM_NK					varchar(50)				NOT NULL							COMMENT '入荷事業所名称'
,	SNTCD_NK					varchar(10)				NOT NULL							COMMENT '入荷センターコード'
,	SNTNM_NK					varchar(50)				NOT NULL							COMMENT '入荷センター名称'
,	BIKO						varchar(200)			DEFAULT NULL						COMMENT '備考'
,	TRKMJ						datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'DB取込時間'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入荷予定HEADの履歴保持を行う)';//

delimiter ;
