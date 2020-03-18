delimiter //
/** テーブル作成 **/
CREATE TABLE mtb_sp_conditions_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	sp_conditions_id			int UNSIGNED			NOT NULL							COMMENT '送信条件ID'
,	PTNCD						varchar(10)				NOT NULL							COMMENT 'パートナーコード'
,	NNSICD						varchar(10)				NOT NULL							COMMENT '荷主コード'
,	JGSCD						varchar(10)				DEFAULT NULL						COMMENT '事業所コード'
,	SNTCD						varchar(10)				DEFAULT NULL						COMMENT 'センターコード'
,	UNSKSCD						varchar(10)				DEFAULT NULL						COMMENT '運送会社コード'
,	SYUKAP						varchar(10)				DEFAULT NULL						COMMENT '出荷場所コード'
,	SEKKBN						varchar(10)				DEFAULT NULL						COMMENT '請求区分'
,	NHNSKCD						varchar(10)				DEFAULT NULL						COMMENT '納品先コード'
,	NKTISFRG					tinyint					NOT NULL DEFAULT 0					COMMENT '入荷対象フラグ'
,	SKTISFRG					tinyint					NOT NULL DEFAULT 0					COMMENT '出荷対象フラグ'
,	ZKTISFRG					tinyint					NOT NULL DEFAULT 0					COMMENT '在庫対象フラグ'
,	add_datetime				datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)				DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)			DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text					DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)				DEFAULT NULL						COMMENT '追加IP'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='SP送信条件マスタの履歴保持を行う)';//

delimiter ;
