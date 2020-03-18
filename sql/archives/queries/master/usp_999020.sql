DROP PROCEDURE IF EXISTS usp_999020;
delimiter //

CREATE PROCEDURE usp_999020(	
)
BEGIN    

	SELECT
		*
    FROM mtb_partners
    ORDER BY PTNCD;

END//

delimiter ;