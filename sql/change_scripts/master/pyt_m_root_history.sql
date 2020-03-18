DROP TABLE IF EXISTS pyt_m_root_history;
delimiter //
/** テーブル作成 **/
CREATE TABLE pyt_m_root_history(
	history_record_id			int						NOT NULL AUTO_INCREMENT				COMMENT '履歴ID'
,	history_record_date			datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '履歴追加日'
,	history_record_divide		ENUM('I','U','D')		NOT NULL							COMMENT '履歴区分 I:登録 U:更新 D:削除'
,	root_id						int						NOT NULL 							COMMENT 'ルートID'		
,	JGSCD						varchar(10)				NOT NULL							COMMENT '事業所コード'
,	TMCPTNCD					varchar(10)				NOT	NULL							COMMENT '積地パートナーコード'
,	CKCPTNCD					varchar(10)				NOT	NULL							COMMENT '着地パートナーコード'
,	UNSKSPTNCD					varchar(10)				NOT	NULL							COMMENT '運送会社パートナーコード'
,	add_datetime				datetime				NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT '追加日時'
,	add_user_id					varchar(15)				DEFAULT NULL						COMMENT '追加ユーザーID'
,	add_user_name				nvarchar(40)			DEFAULT NULL						COMMENT '追加ユーザー名'
,	add_user_agent				text					DEFAULT NULL						COMMENT '追加ユーザーエージェント'
,	add_ip						varchar(15)				DEFAULT NULL						COMMENT '追加IP'
,	upd_datetime				datetime				DEFAULT NULL						COMMENT '更新日時'
,	upd_user_id					varchar(15)				DEFAULT NULL						COMMENT '更新ユーザーID'
,	upd_user_name				nvarchar(40)			DEFAULT NULL						COMMENT '更新ユーザー名'
,	upd_user_agent				text					DEFAULT NULL						COMMENT '更新ユーザーエージェント'
,	upd_ip						varchar(15)				DEFAULT NULL						COMMENT '更新IP'
,	del_flag					tinyint					NOT NULL DEFAULT 0					COMMENT '削除フラグ'
,	del_datetime				datetime				DEFAULT NULL						COMMENT '削除日時'
,	del_user_id					varchar(15)				DEFAULT NULL						COMMENT '削除ユーザーID'
,	del_user_name				nvarchar(40)			DEFAULT NULL						COMMENT '削除ユーザー名'
,	del_user_agent				text					DEFAULT NULL						COMMENT '削除ユーザーエージェント'
,	del_ip						varchar(15)				DEFAULT NULL						COMMENT '削除IP'
,	PRIMARY KEY (history_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ルートマスタの履歴保持を行う)';//

delimiter ;
