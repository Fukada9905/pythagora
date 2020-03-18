DROP PROCEDURE IF EXISTS usp_get_main_menu;
delimiter //

CREATE PROCEDURE usp_get_main_menu(
	IN p_user_id 			varchar(20)
,	IN p_parent_function_id	varchar(10)
)
BEGIN    
	SELECT
		IFNULL(MN.menu_name,FN.function_name) AS menu_name
	,	FN.function_id
    ,	FN.icon_name
    ,	MN.params
    ,	FN.function_divide
    FROM mtb_menus AS MN
    INNER JOIN mtb_users AS US
		ON MN.user_group_id = US.user_group_id
	INNER JOIN sys_functions AS FN
		ON MN.function_id = FN.function_id
	WHERE US.user_id = p_user_id
    AND MN.del_flag = 0
    AND	  (
			(p_parent_function_id IS NULL AND MN.parent_function_id IS NULL)
			OR
			(p_parent_function_id IS NOT NULL AND MN.parent_function_id = p_parent_function_id)
		  )
	ORDER BY MN.position_order;
END//

delimiter ;