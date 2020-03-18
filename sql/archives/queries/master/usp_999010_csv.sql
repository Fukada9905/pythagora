DROP PROCEDURE IF EXISTS usp_999010_csv;
delimiter //

CREATE PROCEDURE usp_999010_csv(
	IN p_user_group_id VARCHAR(10)
)
BEGIN
    
    
    SELECT
		US.user_id AS 'ユーザーID'
	,	US.user_password AS 'パスワード'
	,	US.user_name AS '名称'
	,	US.user_name_kana AS '名称(カナ)'
	,	US.user_group_id AS 'ユーザーグループID'
    ,	UG.user_group_name AS 'ユーザーグループ名'
	,	US.management_cd AS '管理コード'
	,	US.add_datetime AS '追加日時'
	,	US.add_user_id AS '追加ユーザーID'
	,	US.add_user_name AS '追加ユーザー名'
	,	US.add_user_agent AS '追加ユーザーエージェント'
	,	US.add_ip AS '追加IP'
	,	US.upd_datetime AS '更新日時'
	,	US.upd_user_id AS '更新ユーザーID'
	,	US.upd_user_name AS '更新ユーザー名'
	,	US.upd_user_agent AS '更新ユーザーエージェント'
	,	US.upd_ip AS '更新IP'
	,	US.del_flag AS '削除フラグ'
	,	US.del_datetime AS '削除日時'
	,	US.del_user_id AS '削除ユーザーID'
	,	US.del_user_name AS '削除ユーザー名'
	,	US.del_user_agent AS '削除ユーザーエージェント'
	,	US.del_ip AS '削除IP'
	FROM mtb_users AS US
	INNER JOIN mtb_user_groups AS UG
		ON US.user_group_id = UG.user_group_id
    WHERE p_user_group_id IS NULL OR US.user_group_id = p_user_group_id
    ORDER BY user_id
    ;
    
    
END//

delimiter ;