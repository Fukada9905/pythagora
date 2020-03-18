DROP PROCEDURE IF EXISTS pyt_p_402000_update;
delimiter //

CREATE PROCEDURE pyt_p_402000_update(
	IN p_update_divide tinyint
,	IN p_target_divide tinyint
,	IN p_id	int
,	IN p_detail_no int
,	IN p_user_id	varchar(20)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    SET @dt = current_timestamp();
    
	IF p_target_divide = 0 THEN
		IF p_update_divide = 1 THEN
			UPDATE pyt_t_shaban_details SET
				departure_datetime = @dt
			,	departure_upduser = p_user_id
            WHERE id = p_id AND detail_no = p_detail_no;
        ELSE
			UPDATE pyt_t_shaban_details SET
				arrival_datetime = @dt
			,	arrival_upduser = p_user_id
            WHERE id = p_id AND detail_no = p_detail_no;
        END IF;
    ELSE
		IF p_update_divide = 1 THEN
			UPDATE pyt_t_shaban_tc_details SET
				departure_datetime = @dt
			,	departure_upduser = p_user_id
            WHERE id = p_id AND detail_no = p_detail_no;
        ELSE
			UPDATE pyt_t_shaban_tc_details SET
				arrival_datetime = @dt
			,	arrival_upduser = p_user_id
            WHERE id = p_id AND detail_no = p_detail_no;
        END IF;
    END IF;

    COMMIT;

	SELECT DATE_FORMAT(@dt,'%Y/%m/%d\r\n%H:%i') AS update_datetime;
    
END//

delimiter ;