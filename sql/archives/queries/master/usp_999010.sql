DROP PROCEDURE IF EXISTS usp_999010;
delimiter //

CREATE PROCEDURE usp_999010(
	IN p_user_group_id varchar(10)
)
BEGIN    

	SELECT
		*
    FROM mtb_users
    WHERE p_user_group_id IS NULL OR user_group_id = p_user_group_id
    ORDER BY user_id;

END//

delimiter ;