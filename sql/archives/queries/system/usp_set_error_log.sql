DROP PROCEDURE IF EXISTS usp_set_error_log;
delimiter //

CREATE PROCEDURE usp_set_error_log(
	IN p_queries	text
,	IN p_params		text
,	IN p_detail		text
,	IN p_user_id	varchar(20)
)
BEGIN
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        -- RESIGNAL;
    END;
    
    INSERT INTO sys_error_logs(
		queries
	,	params
	,	detail
	,	user_id
	,	remote_ip
	,	user_agent
    )
    VALUES(
		p_queries
	,	p_params
    ,	p_detail
    ,	ifnull(p_user_id,SUBSTRING_INDEX(USER(),'@',1))
    ,	ufn_get_ip(p_user_id)
    ,	ufn_get_user_agent(p_user_id)
    );
    	
	
    COMMIT;
END//

delimiter ;