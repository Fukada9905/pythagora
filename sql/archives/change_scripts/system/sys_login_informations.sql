delimiter //
/** テーブル作成 **/
CREATE TABLE sys_login_informations(
	user_id						varchar(20)			NOT NULL							COMMENT 'ユーザーID'
,	function_id					varchar(10)			NOT NULL							COMMENT '使用中機能ID'
,	remote_ip					varchar(15)			DEFAULT NULL						COMMENT '接続IPアドレス'
,	user_agent					varchar(255)		DEFAULT NULL						COMMENT '接続ユーザーエージェント'
,	ticket						varchar(50)			DEFAULT NULL						COMMENT 'チケット'
,	login_datetime				datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'ログイン日時'
,	PRIMARY KEY (user_id)
,	KEY IX_sys_login_informations_function_id (function_id)
,	CONSTRAINT FK_sys_login_informations_mtb_users
		FOREIGN KEY (user_id) REFERENCES mtb_users (user_id)
		ON DELETE CASCADE ON UPDATE CASCADE
,	CONSTRAINT FK_sys_login_informations_sys_functions
		FOREIGN KEY (function_id) REFERENCES sys_functions (function_id)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ログイン情報 (ログイン中の情報を保持する)';//

delimiter ;
