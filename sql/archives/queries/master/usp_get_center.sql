DROP PROCEDURE IF EXISTS usp_get_center;
delimiter //

CREATE PROCEDURE usp_get_center(
	IN p_jgscd text
,	IN p_process_divide tinyint
,	IN p_is_partner tinyint
,	IN p_management_cd varchar(10)
)
BEGIN    

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;
  
    
    SET @sql_sel = ' SELECT DISTINCT';
    SET @sql_sel = CONCAT(@sql_sel, '   JG.JGSCD');
    SET @sql_sel = CONCAT(@sql_sel, ' , JG.JGSRMEI AS JGSNM');
    SET @sql_sel = CONCAT(@sql_sel, ' , CN.SNTCD');
    SET @sql_sel = CONCAT(@sql_sel, ' , CN.SNTNM');
    SET @sql_sel = CONCAT(@sql_sel, ' FROM mtb_center AS CN');
    SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN mtb_jigyosho AS JG');
    SET @sql_sel = CONCAT(@sql_sel, '   ON CN.JGSCD = JG.JGSCD');
    IF p_is_partner = 1 THEN
		SET @sql_sel = CONCAT(@sql_sel, ' INNER JOIN mtb_sp_conditions AS SP');
        SET @sql_sel = CONCAT(@sql_sel, '  ON CN.JGSCD = SP.JGSCD');
        SET @sql_sel = CONCAT(@sql_sel, '  AND (SP.SNTCD IS NULL OR CN.SNTCD = SP.SNTCD)');
        SET @sql_sel = CONCAT(@sql_sel, '  AND SP.PTNCD = \'',p_management_cd, '\'');
        CASE p_process_divide
			WHEN 1 THEN            
				SET @sql_sel = CONCAT(@sql_sel, '  AND SP.SKTISFRG = 1');
			WHEN 2 THEN            
				SET @sql_sel = CONCAT(@sql_sel, '  AND SP.NKTISFRG = 1');
			WHEN 3 THEN            
				SET @sql_sel = CONCAT(@sql_sel, '  AND SP.ZKTISFRG = 1');
		END CASE;
    END IF;
    SET @sql_sel = CONCAT(@sql_sel, ' WHERE CN.del_flag = 0');
    IF p_jgscd IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel, '  AND CN.JGSCD IN(',p_jgscd, ')');
    END IF;
    SET @sql_sel = CONCAT(@sql_sel, ' ORDER BY JG.JGSCD,CN.SNTCD');
	
	PREPARE stmt from @sql_sel;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
END//

delimiter ;