DROP PROCEDURE IF EXISTS usp_999010_update;
delimiter //

CREATE PROCEDURE usp_999010_update(
	IN p_update_row	text
,	IN p_user_id	varchar(20)
)
BEGIN

	
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TEMPORARY TABLE IF EXISTS tmp_insert;
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    
    CREATE TEMPORARY TABLE tmp_insert(
		user_id			varchar(20)
	,	user_password	varchar(20)
    ,	user_name		varchar(40)
    ,	user_name_kana	varchar(40)
    ,	user_group_id	varchar(10)
    ,	management_cd	varchar(10)
    ,	del_flag		tinyint    
    );
    
    IF p_update_row IS NOT NULL THEN
		SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',p_update_row);    
		PREPARE stmt from @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;    	
    END IF;
    
    
    UPDATE mtb_users AS US
    INNER JOIN tmp_insert AS TP
		ON US.user_id = TP.user_id
	SET US.user_password = TP.user_password
    ,	US.user_name = TP.user_name
    ,	US.user_name_kana = TP.user_name_kana
    ,	US.user_group_id = TP.user_group_id
    ,	US.management_cd = TP.management_cd
    ,	US.del_flag = TP.del_flag
    ,	US.upd_user_id = p_user_id
    ,	US.del_datetime = CASE WHEN TP.del_flag = 1 THEN CURRENT_TIMESTAMP() ELSE null END
    ,	US.del_user_id = CASE WHEN TP.del_flag = 1 THEN p_user_id ELSE null END
    ,	US.del_user_name = CASE WHEN TP.del_flag = 1 THEN ufn_get_user_name(p_user_id) ELSE null END
    ,	US.del_user_agent = CASE WHEN TP.del_flag = 1 THEN ufn_get_user_agent(p_user_id) ELSE null END
    ,	US.del_ip = CASE WHEN TP.del_flag = 1 THEN ufn_get_ip(p_user_id) ELSE null END
    ;
    
    
    INSERT INTO mtb_users(
		user_id
	,	user_password
	,	user_name
	,	user_name_kana
    ,	user_group_id
	,	management_cd
    ,	add_user_id
	,	del_flag
	,	del_datetime
	,	del_user_id
	,	del_user_name
	,	del_user_agent
	,	del_ip    
    )
    SELECT
		TP.user_id
	,	TP.user_password
	,	TP.user_name
	,	TP.user_name_kana
    ,	TP.user_group_id
	,	TP.management_cd
	,	p_user_id
	,	TP.del_flag
	,	CASE WHEN TP.del_flag = 1 THEN CURRENT_TIMESTAMP() ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN p_user_id ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN ufn_get_user_name(p_user_id) ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN ufn_get_user_agent(p_user_id) ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN ufn_get_ip(p_user_id) ELSE null END
	FROM tmp_insert AS TP
    LEFT JOIN mtb_users AS US
		ON TP.user_id = US.user_id
	WHERE US.user_id IS NULL
	;
    
	DROP TEMPORARY TABLE IF EXISTS tmp_insert;
    COMMIT;
        
    
END//

delimiter ;