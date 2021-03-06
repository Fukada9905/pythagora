DROP PROCEDURE IF EXISTS pyt_p_999040_divide;
delimiter //

CREATE PROCEDURE pyt_p_999040_divide(	
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
    ELSEIF p_get_divide = 2 THEN
		SELECT DISTINCT
			RT.TMCPTNCD AS PTNCD
		,	CONCAT(RT.TMCPTNCD,':',IFNULL(PT.PTNCDNM1,''),IF(PT.PTNCDNM2 IS NULL, '', ' '),IFNULL(PT.PTNCDNM2,'')) AS PTNNM
		FROM pyt_m_root AS RT
        LEFT JOIN pyt_m_partners AS PT
			ON RT.TMCPTNCD = PT.PTNCD
		WHERE RT.del_flag = 0
		ORDER BY RT.TMCPTNCD;
	ELSEIF p_get_divide = 3 THEN
		SELECT DISTINCT
			RT.CKCPTNCD AS PTNCD
		,	CONCAT(RT.TMCPTNCD,':',IFNULL(PT.PTNCDNM1,''),IF(PT.PTNCDNM2 IS NULL, '', ' '),IFNULL(PT.PTNCDNM2,'')) AS PTNNM
		FROM pyt_m_root AS RT
        LEFT JOIN pyt_m_partners AS PT
			ON RT.CKCPTNCD = PT.PTNCD
		WHERE RT.del_flag = 0
		ORDER BY RT.CKCPTNCD;
	ELSEIF p_get_divide = 4 THEN
		SELECT DISTINCT
			RT.UNSKSPTNCD AS PTNCD
		,	CONCAT(RT.UNSKSPTNCD,':',IFNULL(PT.PTNCDNM1,''),IF(PT.PTNCDNM2 IS NULL, '', ' '),IFNULL(PT.PTNCDNM2,'')) AS PTNNM
		FROM pyt_m_root AS RT
        LEFT JOIN pyt_m_partners AS PT
			ON RT.UNSKSPTNCD = PT.PTNCD
		WHERE RT.del_flag = 0
		ORDER BY RT.UNSKSPTNCD;
    
    END IF;
    
END//

delimiter ;