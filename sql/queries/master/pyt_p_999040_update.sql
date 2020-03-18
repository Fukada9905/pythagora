DROP PROCEDURE IF EXISTS pyt_p_999040_update;
delimiter //

CREATE PROCEDURE pyt_p_999040_update(
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
		root_id			int
	,	JGSCD			varchar(10)
	,	TMCPTNCD		varchar(10)
    ,	CKCPTNCD		varchar(10)
    ,	UNSKSPTNCD		varchar(10)    
    ,	del_flag		tinyint    
    );
    
    IF p_update_row IS NOT NULL THEN
		SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',p_update_row);    
		PREPARE stmt from @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;    	
    END IF;
    
    
    UPDATE pyt_m_root AS RT
    INNER JOIN tmp_insert AS TP
		ON RT.root_id = TP.root_id        
	SET RT.JGSCD = TP.JGSCD
    ,	RT.TMCPTNCD = TP.TMCPTNCD
    ,	RT.CKCPTNCD = TP.CKCPTNCD
    ,	RT.UNSKSPTNCD = TP.UNSKSPTNCD
    ,	RT.del_flag = TP.del_flag
    ,	RT.upd_user_id = p_user_id
    ,	RT.del_datetime = CASE WHEN TP.del_flag = 1 THEN CURRENT_TIMESTAMP() ELSE null END
    ,	RT.del_user_id = CASE WHEN TP.del_flag = 1 THEN p_user_id ELSE null END
    ,	RT.del_user_name = CASE WHEN TP.del_flag = 1 THEN pyt_ufn_get_user_name(p_user_id) ELSE null END
    ,	RT.del_user_agent = CASE WHEN TP.del_flag = 1 THEN pyt_ufn_get_user_agent(p_user_id) ELSE null END
    ,	RT.del_ip = CASE WHEN TP.del_flag = 1 THEN pyt_ufn_get_ip(p_user_id) ELSE null END
    ;
    
    
    INSERT INTO pyt_m_root(
		JGSCD
	,	TMCPTNCD
	,	CKCPTNCD
    ,	UNSKSPTNCD
	,	add_user_id
	,	del_flag
	,	del_datetime
	,	del_user_id
	,	del_user_name
	,	del_user_agent
	,	del_ip    
    )
    SELECT
		TP.JGSCD
	,	TP.TMCPTNCD
	,	TP.CKCPTNCD
	,	TP.UNSKSPTNCD
    ,	p_user_id
	,	TP.del_flag
	,	CASE WHEN TP.del_flag = 1 THEN CURRENT_TIMESTAMP() ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN p_user_id ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN pyt_ufn_get_user_name(p_user_id) ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN pyt_ufn_get_user_agent(p_user_id) ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN pyt_ufn_get_ip(p_user_id) ELSE null END
	FROM tmp_insert AS TP
    WHERE TP.root_id IS NULL
	;
    
	DROP TEMPORARY TABLE IF EXISTS tmp_insert;
    COMMIT;
        
    
END//

delimiter ;