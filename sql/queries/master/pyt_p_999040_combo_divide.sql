DROP PROCEDURE IF EXISTS pyt_p_999040_combo_divide;
delimiter //

CREATE PROCEDURE pyt_p_999040_combo_divide(	
	IN p_get_divide TINYINT
)
BEGIN    
	
    IF p_get_divide = 1 THEN
		SELECT
			JGSCD
		,	CONCAT(JGSCD,':',IFNULL(JGSNM,'')) AS JGSNM		
		FROM pyt_m_jigyosho
		WHERE del_flag = 0
		ORDER BY JGSCD;
    ELSE
		SELECT
			PTNCD
		,	CONCAT(IFNULL(PTNCDNM1,''),IF(PTNCDNM2 IS NULL, '', ' '),IFNULL(PTNCDNM2,'')) AS PTNNM
		,	PTNCDJUSYO		
		FROM pyt_m_partners
		WHERE del_flag = 0
		ORDER BY PTNCD;
	END IF;
END//

delimiter ;