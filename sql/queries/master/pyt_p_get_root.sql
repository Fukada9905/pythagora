DROP PROCEDURE IF EXISTS pyt_p_get_root;
delimiter //

CREATE PROCEDURE pyt_p_get_root(
	IN p_get_divide TINYINT
,	IN p_jgscd text
,	IN p_ptncd text
)
BEGIN    


	SET @sql_sel = 'SELECT DISTINCT';
	IF p_get_divide = 1 THEN
		SET @sql_sel = CONCAT(@sql_sel, ' RT.TMCPTNCD AS PTNCD');
    ELSEIF p_get_divide = 2 THEN
		SET @sql_sel = CONCAT(@sql_sel, ' RT.CKCPTNCD AS PTNCD');
    ELSE
		SET @sql_sel = CONCAT(@sql_sel, ' RT.UNSKSPTNCD AS PTNCD');
    END IF;
    SET @sql_sel = CONCAT(@sql_sel, ', CONCAT(IFNULL(PN.PTNCDNM1,\'\'),IF(PN.PTNCDNM2 IS NULL, \'\', \' \'),IFNULL(PN.PTNCDNM2,\'\')) AS PTNNM');
    SET @sql_sel = CONCAT(@sql_sel, ' FROM pyt_m_root AS RT');
    SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN pyt_m_partners AS PN');
    IF p_get_divide = 1 THEN
		SET @sql_sel = CONCAT(@sql_sel, ' ON RT.TMCPTNCD = PN.PTNCD');
    ELSEIF p_get_divide = 2 THEN
		SET @sql_sel = CONCAT(@sql_sel, ' ON RT.CKCPTNCD = PN.PTNCD');
    ELSE
		SET @sql_sel = CONCAT(@sql_sel, ' ON RT.UNSKSPTNCD = PN.PTNCD');
    END IF;
    SET @sql_sel = CONCAT(@sql_sel, ' WHERE RT.del_flag = 0');
    IF p_jgscd IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel, ' AND RT.JGSCD IN(',p_jgscd,')');
    END IF;	
    IF p_ptncd IS NOT NULL THEN		
        SET @sql_sel = CONCAT(@sql_sel,' AND (RT.UNSKSPTNCD IN(',p_ptncd,')');
		SET @sql_sel = CONCAT(@sql_sel,' OR RT.TMCPTNCD IN(',p_ptncd,')');		
		SET @sql_sel = CONCAT(@sql_sel,' OR RT.CKCPTNCD IN(',p_ptncd,'))');	
    END IF;	
    IF p_get_divide = 1 THEN
		SET @sql_sel = CONCAT(@sql_sel, ' ORDER BY RT.TMCPTNCD');
    ELSEIF p_get_divide = 2 THEN
		SET @sql_sel = CONCAT(@sql_sel, ' ORDER BY RT.CKCPTNCD');
    ELSE
		SET @sql_sel = CONCAT(@sql_sel, ' ORDER BY RT.UNSKSPTNCD');
    END IF;
    
    PREPARE _stmt from @sql_sel;
	EXECUTE _stmt;
	DEALLOCATE PREPARE _stmt;
END//

delimiter ;