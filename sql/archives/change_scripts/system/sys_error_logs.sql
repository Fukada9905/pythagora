delimiter //
/** テーブル作成 **/
CREATE TABLE sys_error_logs(
	log_id						int UNSIGNED		NOT NULL AUTO_INCREMENT				COMMENT 'ログID'
,	queries						text				DEFAULT NULL						COMMENT '発行クエリ'
,	params						text				DEFAULT NULL						COMMENT 'パラメータ'
,	detail						text				DEFAULT NULL						COMMENT '詳細'
,	user_id						varchar(20)			DEFAULT NULL						COMMENT 'ユーザーID'
,	remote_ip					varchar(15)			DEFAULT NULL						COMMENT '接続IPアドレス'
,	user_agent					text				DEFAULT NULL						COMMENT '接続ユーザーエージェント'
,	ins_date					datetime			NOT NULL DEFAULT CURRENT_TIMESTAMP	COMMENT 'ログ日時'
,	PRIMARY KEY (log_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='エラーログ情報 (エラーログ情報を保持する)';//

delimiter ;
