DROP PROCEDURE IF EXISTS usp_get_user_information;
delimiter //

CREATE PROCEDURE usp_get_user_information(
	IN p_user_id varchar(20)
)
BEGIN    
	 SELECT
		US.user_id
	 ,	US.user_password
     ,	US.user_name
     ,	US.user_name_kana
	 ,	UG.user_divide
     ,	US.user_group_id
     ,	UG.user_group_name
	 ,	US.management_cd
	 FROM mtb_users AS US
     INNER JOIN mtb_user_groups AS UG
		ON US.user_group_id = UG.user_group_id
	 WHERE US.user_id = p_user_id
		AND US.del_flag = 0;
     
END//

delimiter ;