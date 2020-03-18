DROP PROCEDURE IF EXISTS usp_999010_divide;
delimiter //

CREATE PROCEDURE usp_999010_divide(
	IN p_get_divide tinyint
)
BEGIN    

	IF p_get_divide = 0 THEN
		SELECT
			user_group_id
		,	user_group_name
        ,	user_divide
        ,	CASE user_divide WHEN 10 THEN 'OWH' WHEN 30 THEN 'パートナー' WHEN 99 THEN '管理者' END AS user_divide_name
        ,	del_flag
		FROM mtb_user_groups
		ORDER BY user_group_id;
    END IF;	

END//

delimiter ;