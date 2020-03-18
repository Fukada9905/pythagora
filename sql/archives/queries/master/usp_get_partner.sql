DROP PROCEDURE IF EXISTS usp_get_partner;
delimiter //

CREATE PROCEDURE usp_get_partner(
	IN p_jgscd text
)
BEGIN    


	SET @sql_sel = 'SELECT DISTINCT';
    SET @sql_sel = CONCAT(@sql_sel, '  PN.PTNCD');
    SET @sql_sel = CONCAT(@sql_sel, ', CONCAT(IFNULL(PN.PTNCDNM1,\'\'),IFNULL(PN.PTNCDNM2,\'\')) AS PTNNM');
    SET @sql_sel = CONCAT(@sql_sel, ' FROM mtb_partners AS PN');
    IF p_jgscd IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN mtb_sp_conditions AS SP');
		SET @sql_sel = CONCAT(@sql_sel, '  ON PN.PTNCD = SP.PTNCD');
		SET @sql_sel = CONCAT(@sql_sel, '  AND SP.JGSCD IN(',p_jgscd,')');
    END IF;
	SET @sql_sel = CONCAT(@sql_sel, ' WHERE PN.del_flag = 0');
    SET @sql_sel = CONCAT(@sql_sel, ' ORDER BY PN.PTNCD');
    
    
    PREPARE _stmt from @sql_sel;
	EXECUTE _stmt;
	DEALLOCATE PREPARE _stmt;
END//

delimiter ;