DROP PROCEDURE IF EXISTS usp_get_csv_informations;
delimiter //

CREATE PROCEDURE usp_get_csv_informations(
	IN p_function_id	varchar(10)	
,   IN p_process_divide	tinyint
	
)
BEGIN
	SELECT
		file_name
	,	is_output_header
    ,	is_output_number		
	FROM sys_csv_management
    WHERE function_id = p_function_id
    AND process_divide = p_process_divide;
	
END//

delimiter ;