DROP PROCEDURE IF EXISTS usp_999030_divide;
delimiter //

CREATE PROCEDURE usp_999030_divide(
	IN p_get_divide tinyint
)
BEGIN    

	IF p_get_divide = 0 THEN
		SELECT
			PTNCD
		,	CONCAT(PTNCD, ':', IFNULL(PTNCDNM1,''),' ',IFNULL(PTNCDNM2,'')) AS PTNNM
        ,	del_flag
		FROM mtb_partners
		ORDER BY PTNCD;
    END IF;	

END//

delimiter ;