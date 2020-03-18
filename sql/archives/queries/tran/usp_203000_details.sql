DROP PROCEDURE IF EXISTS usp_203000_details;
delimiter //

CREATE PROCEDURE usp_203000_details(
	IN p_ids text
,	IN p_user_id varchar(10)
)
BEGIN
    
    SET @sql_sel = 'SELECT WD.* FROM wk_203000_details AS WD';
    SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN wk_203000_head AS WK');
    SET @sql_sel = CONCAT(@sql_sel,' ON WD.work_id = WK.work_id');    
    IF p_ids IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' WHERE WK.work_id IN(',p_ids,')');
	ELSE
		SET @sql_sel = CONCAT(@sql_sel,' WHERE WK.user_id = \'',p_user_id,'\'');		
	END IF;
    SET @sql_sel = CONCAT(@sql_sel,' ORDER BY WK.work_id, WD.work_detail_id');
        
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
END//

delimiter ;