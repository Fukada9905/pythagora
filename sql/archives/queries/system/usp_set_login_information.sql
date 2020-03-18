DROP PROCEDURE IF EXISTS usp_set_login_information;
delimiter //

CREATE PROCEDURE usp_set_login_information(
	IN p_process_divide	tinyint
,	IN p_user_id		varchar(20)
,	IN p_function_id	varchar(10)
,	IN p_remote_ip		varchar(15)
,	IN p_user_agent		text
,	IN p_ticket			varchar(50)
)
BEGIN
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        RESIGNAL;
    END;
    
    SET @cur_date = CURRENT_TIMESTAMP;
    
    -- トランザクション開始
    START TRANSACTION;
    
    DELETE FROM sys_login_informations WHERE user_id = p_user_id;
    
    IF p_process_divide = 1 THEN
		INSERT sys_login_informations(
			user_id	
		,	function_id
		,	remote_ip	
		,	user_agent
        ,	ticket
        ,	login_datetime
		)VALUES(
			p_user_id	
		,	p_function_id	
        ,	p_remote_ip	
		,	p_user_agent
        ,	p_ticket
        ,	@cur_date
		);
        
        INSERT INTO sys_login_records(
			user_id
		,	remote_ip
        ,	user_agent
        ,	ticket
        ,	login_datetime
        )VALUES(
			p_user_id	
		,	p_remote_ip	
		,	p_user_agent
        ,	p_ticket
        ,	@cur_date
        );
                
        
    ELSE
		INSERT sys_login_informations(
			user_id	
		,	function_id
		,	remote_ip	
		,	user_agent
        ,	ticket
        ,	login_datetime
		)
        SELECT
			user_id
        ,	p_function_id  
		,	remote_ip
        ,	user_agent
        ,	ticket
        ,	login_datetime
        FROM sys_login_records
        WHERE user_id = p_user_id
        ORDER BY login_record_id DESC
        LIMIT 1;
                
    END IF;
    
    
    COMMIT;
END//

delimiter ;