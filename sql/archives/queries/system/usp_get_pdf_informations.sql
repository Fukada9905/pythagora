DROP PROCEDURE IF EXISTS usp_get_pdf_informations;
delimiter //

CREATE PROCEDURE usp_get_pdf_informations(
	IN p_function_id	varchar(10)	
,   IN p_process_divide	tinyint
	
)
BEGIN
	SELECT
		file_name
	,	paper_size
    ,	land_scape
    ,	is_print_pager
    ,	template_file_name
	FROM sys_pdf_management
    WHERE function_id = p_function_id
    AND process_divide = p_process_divide;
	
END//

delimiter ;