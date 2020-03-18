delimiter //
/** テーブル作成 **/
CREATE TABLE sys_login_records(
	login_record_id				int UNSIGNED		NOT NULL AUTO_INCREMENT				COMMENT 'ログイン履歴ID'
,	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	remote_ip					varchar(15)			DEFAULT NULL						COMMENT '接続IPアドレス'
,	user_agent					varchar(255)		DEFAULT NULL						COMMENT '接続ユーザーエージェント'
,	ticket						varchar(50)			DEFAULT NULL						COMMENT 'チケット'
,	login_datetime				datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'ログイン日時'
,	PRIMARY KEY (login_record_id)
,	KEY IX_sys_login_records_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ログイン履歴 (ログイン履歴を保持する)';//

delimiter ;
