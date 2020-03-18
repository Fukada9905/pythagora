DROP PROCEDURE IF EXISTS usp_999020_update;
delimiter //

CREATE PROCEDURE usp_999020_update(
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
		PTNCD			varchar(10)
	,	PTNCDNM1		varchar(50)
    ,	PTNCDNM2		varchar(50)
    ,	PTNCDJUSYO		varchar(100)
    ,	del_flag		tinyint    
    );
    
    IF p_update_row IS NOT NULL THEN
		SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',p_update_row);    
		PREPARE stmt from @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;    	
    END IF;
    
    
    UPDATE mtb_partners AS PN
    INNER JOIN tmp_insert AS TP
		ON PN.PTNCD = TP.PTNCD
	SET PN.PTNCDNM1 = TP.PTNCDNM1
    ,	PN.PTNCDNM2 = TP.PTNCDNM2
    ,	PN.PTNCDJUSYO = TP.PTNCDJUSYO
    ,	PN.del_flag = TP.del_flag
    ,	PN.upd_user_id = p_user_id
    ,	PN.del_datetime = CASE WHEN TP.del_flag = 1 THEN CURRENT_TIMESTAMP() ELSE null END
    ,	PN.del_user_id = CASE WHEN TP.del_flag = 1 THEN p_user_id ELSE null END
    ,	PN.del_user_name = CASE WHEN TP.del_flag = 1 THEN ufn_get_user_name(p_user_id) ELSE null END
    ,	PN.del_user_agent = CASE WHEN TP.del_flag = 1 THEN ufn_get_user_agent(p_user_id) ELSE null END
    ,	PN.del_ip = CASE WHEN TP.del_flag = 1 THEN ufn_get_ip(p_user_id) ELSE null END
    ;
    
    
    INSERT INTO mtb_partners(
		PTNCD
	,	PTNCDNM1
	,	PTNCDNM2
	,	PTNCDJUSYO
    ,	add_user_id
    ,	del_flag
	,	del_datetime
	,	del_user_id
	,	del_user_name
	,	del_user_agent
	,	del_ip    
    )
    SELECT
		TP.PTNCD
	,	TP.PTNCDNM1
	,	TP.PTNCDNM2
	,	TP.PTNCDJUSYO
    ,	p_user_id
    ,	TP.del_flag
	,	CASE WHEN TP.del_flag = 1 THEN CURRENT_TIMESTAMP() ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN p_user_id ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN ufn_get_user_name(p_user_id) ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN ufn_get_user_agent(p_user_id) ELSE null END
	,	CASE WHEN TP.del_flag = 1 THEN ufn_get_ip(p_user_id) ELSE null END
	FROM tmp_insert AS TP
    LEFT JOIN mtb_partners AS PN
		ON TP.PTNCD = PN.PTNCD
	WHERE PN.PTNCD IS NULL
	;
    
	DROP TEMPORARY TABLE IF EXISTS tmp_insert;
    COMMIT;
        
    
END//

delimiter ;