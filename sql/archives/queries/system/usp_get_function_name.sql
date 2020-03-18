DROP PROCEDURE IF EXISTS usp_get_function_name;
delimiter //

CREATE PROCEDURE usp_get_function_name(
	IN p_user_group_id	int	
,   IN p_function_id	varchar(10)
	
)
BEGIN
	SELECT
		IFNULL(MN.menu_name, FN.function_name) AS menu_name
	FROM sys_functions AS FN
    LEFT JOIN mtb_menus AS MN
		ON FN.function_id = MN.function_id
        AND MN.user_group_id = p_user_group_id
	WHERE FN.function_id = p_function_id;
	
END//

delimiter ;