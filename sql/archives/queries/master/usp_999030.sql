DROP PROCEDURE IF EXISTS usp_999030;
delimiter //

CREATE PROCEDURE usp_999030(
	IN p_ptncd varchar(10)
)
BEGIN    

	SELECT
		*
    FROM mtb_sp_conditions
    WHERE p_ptncd IS NULL OR PTNCD = p_ptncd
    ORDER BY PTNCD, NNSICD, SNTCD, UNSKSCD, SYUKAP, SEKKBN, NHNSKCD;

END//

delimiter ;