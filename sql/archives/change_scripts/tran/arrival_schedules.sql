delimiter //
/** テーブル作成 **/
CREATE TABLE arrival_schedules(
	ID							int					NOT NULL							COMMENT '入荷予定ID'
,	NNSICD						varchar(10)			NOT NULL							COMMENT '荷主コード'
,	NNSINM						varchar(50)			NOT NULL							COMMENT '荷主名'
,	DENPYOYMD					date				NOT NULL							COMMENT '伝票日付'
,	SYUKAYMD					date				DEFAULT NULL						COMMENT '出荷日'
,	NOHINYMD					date				NOT NULL							COMMENT '入荷予定日'
,	SYORIYMD					datetime			DEFAULT NULL						COMMENT '処理日時'
,	UNSKSCD						varchar(10)			NOT NULL							COMMENT '運送会社コード'
,	UNSKSNM						varchar(50)			NOT NULL							COMMENT '運送会社名称'
,	KZIMI						varchar(20)			DEFAULT NULL						COMMENT '機材名称'
,	SKHNYKBN1					varchar(10)			NOT NULL							COMMENT 'ID'
,	SKHNYKBN1NM					varchar(50)			NOT NULL							COMMENT 'ID名称'
,	DENNO						varchar(20)			NOT NULL							COMMENT '伝票番号'
,	JGSCD_NK					varchar(10)			NOT NULL							COMMENT '入荷事業所コード'
,	JGSNM_NK					varchar(50)			NOT NULL							COMMENT '入荷事業所名称'
,	SNTCD_NK					varchar(10)			NOT NULL							COMMENT '入荷センターコード'
,	SNTNM_NK					varchar(50)			NOT NULL							COMMENT '入荷センター名称'
,	BIKO						varchar(200)		DEFAULT NULL						COMMENT '備考'
,	TRKMJ						datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'DB取込時間'
,	PRIMARY KEY (ID)
,	UNIQUE KEY UQ_arrival_schedules_NNSICD_DENPYOYMD_DENNO(NNSICD,DENPYOYMD,DENNO)
,	KEY IX_arrival_schedules_NNSICD (NNSICD)
,	KEY IX_arrival_schedules_JGSCD_NK_SNTCD_NK (TRKMJ,JGSCD_NK,SNTCD_NK)
,	KEY IX_arrival_schedules_DENPYOYMD (TRKMJ,DENPYOYMD)
,	KEY IX_arrival_schedules_SYUKAYMD (TRKMJ,SYUKAYMD)
,	KEY IX_arrival_schedules_NOHINYMD (TRKMJ,NOHINYMD)
,	KEY IX_arrival_schedules_SYORIYMD (SYORIYMD)
,	KEY IX_arrival_schedules_UNSKSCD (UNSKSCD)
,	KEY IX_arrival_schedules_SKHNYKBN1 (SKHNYKBN1)
,	KEY IX_arrival_schedules_DENNO (TRKMJ,DENNO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='入荷予定HEAD (入荷予定ヘッダテーブル)';//

/** INSERT トリガー **/
CREATE TRIGGER arrival_schedules_AFTER_INSERT AFTER INSERT ON arrival_schedules FOR EACH ROW
BEGIN
	INSERT INTO arrival_schedules_history(
			history_record_divide
		,	ID
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	UNSKSCD
		,	UNSKSNM
		,	KZIMI
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JGSCD_NK
		,	JGSNM_NK
		,	SNTCD_NK
		,	SNTNM_NK
		,	BIKO
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
		,	NEW.UNSKSCD
		,	NEW.UNSKSNM
		,	NEW.KZIMI
		,	NEW.SKHNYKBN1
		,	NEW.SKHNYKBN1NM
		,	NEW.DENNO
		,	NEW.JGSCD_NK
		,	NEW.JGSNM_NK
		,	NEW.SNTCD_NK
		,	NEW.SNTNM_NK
		,	NEW.BIKO
		,	NEW.TRKMJ
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER arrival_schedules_AFTER_UPDATE AFTER UPDATE ON arrival_schedules FOR EACH ROW
BEGIN
	INSERT INTO arrival_schedules_history(
			history_record_divide
		,	ID
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	UNSKSCD
		,	UNSKSNM
		,	KZIMI
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JGSCD_NK
		,	JGSNM_NK
		,	SNTCD_NK
		,	SNTNM_NK
		,	BIKO
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
		,	NEW.UNSKSCD
		,	NEW.UNSKSNM
		,	NEW.KZIMI
		,	NEW.SKHNYKBN1
		,	NEW.SKHNYKBN1NM
		,	NEW.DENNO
		,	NEW.JGSCD_NK
		,	NEW.JGSNM_NK
		,	NEW.SNTCD_NK
		,	NEW.SNTNM_NK
		,	NEW.BIKO
		,	NEW.TRKMJ
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER arrival_schedules_AFTER_DELETE AFTER DELETE ON arrival_schedules FOR EACH ROW
BEGIN
	INSERT INTO arrival_schedules_history(
			history_record_divide
		,	ID
		,	NNSICD
		,	NNSINM
		,	DENPYOYMD
		,	SYUKAYMD
		,	NOHINYMD
		,	SYORIYMD
		,	UNSKSCD
		,	UNSKSNM
		,	KZIMI
		,	SKHNYKBN1
		,	SKHNYKBN1NM
		,	DENNO
		,	JGSCD_NK
		,	JGSNM_NK
		,	SNTCD_NK
		,	SNTNM_NK
		,	BIKO
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
		,	OLD.UNSKSCD
		,	OLD.UNSKSNM
		,	OLD.KZIMI
		,	OLD.SKHNYKBN1
		,	OLD.SKHNYKBN1NM
		,	OLD.DENNO
		,	OLD.JGSCD_NK
		,	OLD.JGSNM_NK
		,	OLD.SNTCD_NK
		,	OLD.SNTNM_NK
		,	OLD.BIKO
		,	OLD.TRKMJ
	);
END;//


delimiter ;
