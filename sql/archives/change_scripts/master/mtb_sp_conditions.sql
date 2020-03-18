delimiter //
/** テーブル作成 **/
CREATE TABLE mtb_sp_conditions(
	sp_conditions_id			int UNSIGNED		NOT NULL AUTO_INCREMENT				COMMENT '送信条件ID'
,	PTNCD						varchar(10)			NOT NULL							COMMENT 'パートナーコード'
,	NNSICD						varchar(10)			NOT NULL							COMMENT '荷主コード'
,	JGSCD						varchar(10)			DEFAULT NULL						COMMENT '事業所コード'
,	SNTCD						varchar(10)			DEFAULT NULL						COMMENT 'センターコード'
,	UNSKSCD						varchar(10)			DEFAULT NULL						COMMENT '運送会社コード'
,	SYUKAP						varchar(10)			DEFAULT NULL						COMMENT '出荷場所コード'
,	SEKKBN						varchar(10)			DEFAULT NULL						COMMENT '請求区分'
,	NHNSKCD						varchar(10)			DEFAULT NULL						COMMENT '納品先コード'
,	NKTISFRG					tinyint				NOT NULL DEFAULT 0					COMMENT '入荷対象フラグ'
,	SKTISFRG					tinyint				NOT NULL DEFAULT 0					COMMENT '出荷対象フラグ'
,	ZKTISFRG					tinyint				NOT NULL DEFAULT 0					COMMENT '在庫対象フラグ'
,	add_datetime				datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)			DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)		DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text				DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)			DEFAULT NULL						COMMENT '追加IP'
,	PRIMARY KEY (sp_conditions_id)
,	KEY IX_mtb_sp_conditions_PTNCD (PTNCD)
,	KEY IX_mtb_sp_conditions_NKTISFRG (NKTISFRG,NNSICD,JGSCD,SNTCD,UNSDSCD,SYUKAP,SEKKBN,NHNSKCD,PTNCD)
,	KEY IX_mtb_sp_conditions_SKTISFRG (SKTISFRG,NNSICD,JGSCD,SNTCD,UNSDSCD,SYUKAP,SEKKBN,NHNSKCD,PTNCD)
,	KEY IX_mtb_sp_conditions_ZKTISFRG (ZKTISFRG,NNSICD,JGSCD,SNTCD,UNSDSCD,SYUKAP,SEKKBN,NHNSKCD,PTNCD)
,	CONSTRAINT FK_mtb_sp_conditions_mtb_partners
		FOREIGN KEY (PTNCD) REFERENCES mtb_partners (PTNCD)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='SP送信条件マスタ (パートナー送信条件の管理を行う)';//

/** INSERT(BEFORE) トリガー **/
CREATE TRIGGER mtb_sp_conditions_BEFORE_INSERT BEFORE INSERT ON mtb_sp_conditions FOR EACH ROW
BEGIN
	IF NEW.add_user_id IS NULL THEN
		SET NEW.add_user_id = SUBSTRING_INDEX(USER(),'@',1);
	END IF;

	SET NEW.add_user_name = ufn_get_user_name(NEW.add_user_id);
	SET NEW.add_user_agent = ufn_get_user_agent(NEW.add_user_id);
	SET NEW.add_ip = ufn_get_ip(NEW.add_user_id);
END;//


/** INSERT トリガー **/
CREATE TRIGGER mtb_sp_conditions_AFTER_INSERT AFTER INSERT ON mtb_sp_conditions FOR EACH ROW
BEGIN
	INSERT INTO mtb_sp_conditions_history(
			history_record_divide
		,	sp_conditions_id
		,	PTNCD
		,	NNSICD
		,	JGSCD
		,	SNTCD
		,	UNSKSCD
		,	SYUKAP
		,	SEKKBN
		,	NHNSKCD
		,	NKTISFRG
		,	SKTISFRG
		,	ZKTISFRG
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'I'
		,	NEW.sp_conditions_id
		,	NEW.PTNCD
		,	NEW.NNSICD
		,	NEW.JGSCD
		,	NEW.SNTCD
		,	NEW.UNSKSCD
		,	NEW.SYUKAP
		,	NEW.SEKKBN
		,	NEW.NHNSKCD
		,	NEW.NKTISFRG
		,	NEW.SKTISFRG
		,	NEW.ZKTISFRG
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
	);
END;//


/** UPDATE トリガー **/
CREATE TRIGGER mtb_sp_conditions_AFTER_UPDATE AFTER UPDATE ON mtb_sp_conditions FOR EACH ROW
BEGIN
	INSERT INTO mtb_sp_conditions_history(
			history_record_divide
		,	sp_conditions_id
		,	PTNCD
		,	NNSICD
		,	JGSCD
		,	SNTCD
		,	UNSKSCD
		,	SYUKAP
		,	SEKKBN
		,	NHNSKCD
		,	NKTISFRG
		,	SKTISFRG
		,	ZKTISFRG
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'U'
		,	NEW.sp_conditions_id
		,	NEW.PTNCD
		,	NEW.NNSICD
		,	NEW.JGSCD
		,	NEW.SNTCD
		,	NEW.UNSKSCD
		,	NEW.SYUKAP
		,	NEW.SEKKBN
		,	NEW.NHNSKCD
		,	NEW.NKTISFRG
		,	NEW.SKTISFRG
		,	NEW.ZKTISFRG
		,	NEW.add_datetime
		,	NEW.add_user_id
		,	NEW.add_user_name
		,	NEW.add_user_agent
		,	NEW.add_ip
	);
END;//


/** DELETE トリガー **/
CREATE TRIGGER mtb_sp_conditions_AFTER_DELETE AFTER DELETE ON mtb_sp_conditions FOR EACH ROW
BEGIN
	INSERT INTO mtb_sp_conditions_history(
			history_record_divide
		,	sp_conditions_id
		,	PTNCD
		,	NNSICD
		,	JGSCD
		,	SNTCD
		,	UNSKSCD
		,	SYUKAP
		,	SEKKBN
		,	NHNSKCD
		,	NKTISFRG
		,	SKTISFRG
		,	ZKTISFRG
		,	add_datetime
		,	add_user_id
		,	add_user_name
		,	add_user_agent
		,	add_ip
	)
	VALUES(
			'D'
		,	OLD.sp_conditions_id
		,	OLD.PTNCD
		,	OLD.NNSICD
		,	OLD.JGSCD
		,	OLD.SNTCD
		,	OLD.UNSKSCD
		,	OLD.SYUKAP
		,	OLD.SEKKBN
		,	OLD.NHNSKCD
		,	OLD.NKTISFRG
		,	OLD.SKTISFRG
		,	OLD.ZKTISFRG
		,	OLD.add_datetime
		,	OLD.add_user_id
		,	OLD.add_user_name
		,	OLD.add_user_agent
		,	OLD.add_ip
	);
END;//


delimiter ;
