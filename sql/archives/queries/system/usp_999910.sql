DROP PROCEDURE IF EXISTS usp_999910;
delimiter //

CREATE PROCEDURE usp_999910(
	
)
BEGIN    

	SELECT
		LI.user_id
	,	CONCAT(FN.function_name, ':', LI.function_id) AS function_name
    ,	LI.remote_ip
    ,	LI.user_agent
    ,	ufn_get_datetime_format(LI.login_datetime) AS login_datetime
    FROM sys_login_informations AS LI
    INNER JOIN sys_functions AS FN
		ON LI.function_id = FN.function_id
    ORDER BY login_datetime DESC;

END//

delimiter ;