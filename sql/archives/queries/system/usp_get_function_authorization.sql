DROP PROCEDURE IF EXISTS usp_get_function_authorization;
delimiter //

CREATE PROCEDURE usp_get_function_authorization(
	IN p_user_group_id	int	
,   IN p_function_id	varchar(10)
	
)
BEGIN
	SELECT
		*
	FROM sys_functions AS FN
    INNER JOIN mtb_menus AS MN
		ON FN.function_id = MN.function_id
        AND MN.user_group_id = p_user_group_id
	WHERE FN.function_id = p_function_id
    AND	(MN.del_flag = 0 OR FN.function_divide = 9);
	
END//

delimiter ;