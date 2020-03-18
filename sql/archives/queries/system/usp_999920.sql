DROP PROCEDURE IF EXISTS usp_999920;
delimiter //

CREATE PROCEDURE usp_999920(
	IN p_target_date_from	date,
    IN p_target_date_to		date
)
BEGIN    

	SET p_target_date_to = DATE_ADD(p_target_date_to,INTERVAL 1 DAY);

	SELECT DISTINCT
    	ufn_get_date_format(LR.login_datetime) AS login_date
	,	LR.user_id
    ,	US.user_name    
	,	LR.user_agent    
    FROM sys_login_records AS LR
    INNER JOIN mtb_users AS US
		ON LR.user_id = US.user_id
	WHERE (p_target_date_from IS NULL OR LR.login_datetime >= p_target_date_from)
    AND	(p_target_date_to IS NULL OR LR.login_datetime < p_target_date_to)
    ORDER BY login_date,LR.user_id DESC;

END//

delimiter ;