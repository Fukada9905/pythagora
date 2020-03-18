DROP PROCEDURE IF EXISTS usp_103020;
delimiter //

CREATE PROCEDURE usp_103020(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_management_cd varchar(10)
,	IN p_pt_name_divide tinyint
,	IN p_user_id varchar(10)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
		DELETE FROM wk_103020_head WHERE user_id = p_user_id;
        DROP TABLE IF EXISTS tmp_head;
        RESIGNAL;
    END;

    -- トランザクション開始
    START TRANSACTION;
    
    -- STEP.0 REFRESH WORK
    DELETE FROM wk_103020_head WHERE user_id = p_user_id;
    
    -- STEP.1 SELECT TARGET DATA
    DROP TABLE IF EXISTS tmp_details;
	SET @sql_ins = ' CREATE TEMPORARY TABLE tmp_details SELECT';    
	SET @sql_ins = CONCAT(@sql_ins, '   NULL AS DKBNNM');		
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.NNSICD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.NNSINM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.JGSCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.JGSNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.JCDENNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.DENNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.DENGNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.SYUKAP');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.LOTK');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.LOTS');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.FCKBNKK');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.SNTCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.SNTNM');
    IF p_pt_name_divide = 1 THEN
	SET @sql_ins = CONCAT(@sql_ins, ' , PN.PTNCD');
    SET @sql_ins = CONCAT(@sql_ins, ' , CASE WHEN PN.PTNCD IS NULL THEN \'なし\' ELSE CONCAT(IFNULL(PN.PTNCDNM1,\'\'),IFNULL(PN.PTNCDNM2,\'\')) END AS PTNNM');
    END IF;
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.UNSKSCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.UNSKSNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.SKHNYKBN1');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.SKHNYKBN1NM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.SYORIYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.SYUKAYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.NOHINYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.DENPYOYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.NHNSKCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.NHNSKNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.JYUSYO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.TEL');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.JISCD');
    SET @sql_ins = CONCAT(@sql_ins, ' , SH.KRMBN');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.SHCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.DNRK');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.SHNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.SHNKKKMEI_KS AS SHNKKKMEI');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.SEKKBN');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.RTNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.SR1RS');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.SR2RS');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.KHKBN');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.PL');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.KKTSR1');
	SET @sql_ins = CONCAT(@sql_ins, ' , (SD.KKTSR1 DIV SD.PL) AS PL_DIV');
	SET @sql_ins = CONCAT(@sql_ins, ' , (SD.KKTSR1 MOD SD.PL) AS PL_MOD');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.KKTSR2');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.KKTSR3');
	SET @sql_ins = CONCAT(@sql_ins, ' , SD.KKTSSR');
	SET @sql_ins = CONCAT(@sql_ins, ' , TRUNCATE(SD.WGT+0.9, 0) AS WGT');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.KOJYOFLG');
	SET @sql_ins = CONCAT(@sql_ins, ' , SH.BIKO');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(SD.TRKMJ,\'%Y%m%d\') AS TRKMJ');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(SD.TRKMJ,\'%Y\') AS TRKMJ_YYYY');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(SD.TRKMJ,\'%m\') AS TRKMJ_MM');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(SD.TRKMJ,\'%d\') AS TRKMJ_DD');
    SET @sql_from = '';
    SET @sql_from = CONCAT(@sql_from, '  FROM shipment_confirms AS SH');
    SET @sql_from = CONCAT(@sql_from, '  INNER JOIN shipment_confirm_details AS SD');
    SET @sql_from = CONCAT(@sql_from, '  ON SH.ID = SD.ID');
    IF p_pt_name_divide = 1 THEN
    SET @sql_from = CONCAT(@sql_from,' LEFT JOIN mtb_sp_conditions AS SP');
	SET @sql_from = CONCAT(@sql_from,' ON SH.NNSICD = SP.NNSICD');
	SET @sql_from = CONCAT(@sql_from,' AND SD.JGSCD = SP.JGSCD');
	SET @sql_from = CONCAT(@sql_from,' AND (SP.SNTCD IS NULL OR SD.SNTCD = SP.SNTCD)');
	SET @sql_from = CONCAT(@sql_from,' AND (SP.UNSKSCD IS NULL OR SH.UNSKSCD = SP.UNSKSCD)');
	SET @sql_from = CONCAT(@sql_from,' AND (SP.SYUKAP IS NULL OR SH.SYUKAP = SP.SYUKAP)');
	SET @sql_from = CONCAT(@sql_from,' AND (SP.SEKKBN IS NULL OR SD.SEKKBN = SP.SEKKBN)');
	SET @sql_from = CONCAT(@sql_from,' AND (SP.NHNSKCD IS NULL OR SH.NHNSKCD = SP.NHNSKCD)');
	SET @sql_from = CONCAT(@sql_from,' AND SP.SKTISFRG = 1');		
    SET @sql_from = CONCAT(@sql_from,' LEFT JOIN mtb_partners AS PN');
	SET @sql_from = CONCAT(@sql_from,' ON SP.PTNCD = PN.PTNCD');
    END IF;
    
    SET @sql_where = ' WHERE SH.SKHNYKBN1 = \'A2\'';
	IF p_date_from IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND SH.DENPYOYMD >= \'',p_date_from,'\'');
    END IF;
    
    IF p_date_to IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND SH.DENPYOYMD <= \'',p_date_to,'\'');
    END IF;
    
	IF p_jgscd IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND SD.JGSCD IN(',p_jgscd,')');				
	END IF;
    
	IF p_is_partner = 1 THEN
		SET @sql_where = CONCAT(@sql_where,' AND SP.PTNCD = \'',p_management_cd,'\'');		
	END IF;

	SET @sql_ins = CONCAT(@sql_ins,IFNULL(@sql_from,''),IFNULL(@sql_where,''));
    
    SET @sql_ins = CONCAT(@sql_ins, ' ORDER BY ');
    SET @sql_ins = CONCAT(@sql_ins, '  SH.DENPYOYMD DESC');
    SET @sql_ins = CONCAT(@sql_ins, ', SD.JGSCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SD.SNTCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.UNSKSCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SH.NNSICD ASC');
	SET @sql_ins = CONCAT(@sql_ins, ', SH.DENNO ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SD.DENGNO ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', SD.RTNO ASC');
    
        
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
    
    IF EXISTS(SELECT * FROM tmp_details) THEN
        
		-- STEP.2 SET UP INSERT WORK TABLE
		SELECT IFNULL(MAX(work_id),0) + 1 INTO @def_work_id FROM wk_103020_head FOR UPDATE;
		SELECT IFNULL(MAX(work_detail_id),0) + 1 INTO @work_detail_id FROM wk_103020_details FOR UPDATE;
				
		
		SET @sql_prev_key = 'CONCAT_WS(\'_\'';
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(DENPYOYMD,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSNM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTNM,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(UNSKSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(UNSKSNM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSICD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSINM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ')');
		
		
		-- STEP.3 INSERT WORK HEAD
        SET @prevkey:=null;
		SET @work_id = @def_work_id;
        
		SET @sql_head = 'INSERT INTO wk_103020_head SELECT DISTINCT';
		SET @sql_head = CONCAT(@sql_head, '  CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_head = CONCAT(@sql_head, ', \'',p_user_id,'\' AS user_id');
		SET @sql_head = CONCAT(@sql_head, ', DENPYOYMD');
		SET @sql_head = CONCAT(@sql_head, ', JGSCD');
        SET @sql_head = CONCAT(@sql_head, ', SNTCD');
		SET @sql_head = CONCAT(@sql_head, ', SNTNM');
		SET @sql_head = CONCAT(@sql_head, ', UNSKSCD');
        SET @sql_head = CONCAT(@sql_head, ', UNSKSNM');
		SET @sql_head = CONCAT(@sql_head, ', NNSICD');
		SET @sql_head = CONCAT(@sql_head, ', NNSINM');
		SET @sql_head = CONCAT(@sql_head, ', @prevkey:=',@sql_prev_key);	
		SET @sql_head = CONCAT(@sql_head, ' FROM tmp_details');
			
		
		PREPARE _stmt_head from @sql_head;
		EXECUTE _stmt_head;
		DEALLOCATE PREPARE _stmt_head;
		
		
        
        -- STEP.4 INSERT WORK DETAIL
		SET @prevkey:=null;
		SET @work_id = @def_work_id;
			
		SET @sql_ins = 'INSERT INTO wk_103020_details SELECT';
		SET @sql_ins = CONCAT(@sql_ins, '   @work_detail_id:=@work_detail_id+1 AS work_detail_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , DKBNNM');		
		SET @sql_ins = CONCAT(@sql_ins, ' , NNSICD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NNSINM');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , JCDENNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENGNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYUKAP');
		SET @sql_ins = CONCAT(@sql_ins, ' , LOTK');
		SET @sql_ins = CONCAT(@sql_ins, ' , LOTS');
		SET @sql_ins = CONCAT(@sql_ins, ' , FCKBNKK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTNM');
        IF p_pt_name_divide = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins, ' , PTNNM');
        ELSE
        SET @sql_ins = CONCAT(@sql_ins, ' , NULL AS PTNNM');
        END IF;
		SET @sql_ins = CONCAT(@sql_ins, ' , UNSKSCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , UNSKSNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKHNYKBN1');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKHNYKBN1NM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYORIYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYUKAYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NOHINYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENPYOYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NHNSKCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NHNSKNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , JYUSYO');
		SET @sql_ins = CONCAT(@sql_ins, ' , TEL');
		SET @sql_ins = CONCAT(@sql_ins, ' , JISCD');
        SET @sql_ins = CONCAT(@sql_ins, ' , KRMBN');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , DNRK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNKKKMEI');	
		SET @sql_ins = CONCAT(@sql_ins, ' , SEKKBN');
		SET @sql_ins = CONCAT(@sql_ins, ' , RTNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , SR1RS');
		SET @sql_ins = CONCAT(@sql_ins, ' , SR2RS');
		SET @sql_ins = CONCAT(@sql_ins, ' , KHKBN');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL_DIV');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL_MOD');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR2');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSSR');
		SET @sql_ins = CONCAT(@sql_ins, ' , WGT');
		SET @sql_ins = CONCAT(@sql_ins, ' , KOJYOFLG');
		SET @sql_ins = CONCAT(@sql_ins, ' , BIKO');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRKMJ');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRKMJ_YYYY');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRKMJ_MM');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRKMJ_DD');
		SET @sql_ins = CONCAT(@sql_ins, ' , @prevkey:=',@sql_prev_key);
		SET @sql_ins = CONCAT(@sql_ins, ' FROM tmp_details');
		
		PREPARE _stmt_detail from @sql_ins;
		EXECUTE _stmt_detail;
		DEALLOCATE PREPARE _stmt_detail;
		
        -- STEP.5 RETURN
		SELECT * FROM wk_103020_head WHERE user_id = p_user_id
        ORDER BY DENPYOYMD DESC, JGSCD ASC, SNTCD ASC, UNSKSCD ASC, NNSICD ASC;
    ELSE
		-- NOTHINGS TO RETURN
		SELECT * FROM wk_103020_head WHERE user_id = p_user_id;
    END IF;          
    
    
    DROP TABLE IF EXISTS tmp_details;

    COMMIT;
    
END//

delimiter ;