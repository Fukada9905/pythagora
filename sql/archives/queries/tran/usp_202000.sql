DROP PROCEDURE IF EXISTS usp_202000;
delimiter //

CREATE PROCEDURE usp_202000(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(10)
)
BEGIN

	DECLARE cur_date DATE;

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
		DELETE FROM wk_202000_head WHERE user_id = p_user_id;
        DROP TABLE IF EXISTS tmp_details;
        RESIGNAL;
    END;

    -- トランザクション開始
	START TRANSACTION;
    
    -- STEP.0 REFRESH WORK & SETUP PARAMS
    DELETE FROM wk_202000_head WHERE user_id = p_user_id;
    
	SET cur_date = CURRENT_DATE();
    -- SET cur_date = '2018-03-15';
    
    SET @date_from = DATE_FORMAT(cur_date,'%Y-%m-%d');
    SET @date_to = DATE_FORMAT(DATE_ADD(cur_date,INTERVAL 1 DAY),'%Y-%m-%d');
        
	IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD = CONCAT('INSERT INTO tmp_sntcd(JGSCD,SNTCD) VALUES',p_sntcd);
                
        PREPARE stmt_SNTCD from @sql_SNTCD;
		EXECUTE stmt_SNTCD;
		DEALLOCATE PREPARE stmt_SNTCD;
	END IF;
    
    
    -- STEP.1 SELECT TARGET DATA
    DROP TABLE IF EXISTS tmp_details;
	SET @sql_ins = ' CREATE TEMPORARY TABLE tmp_details SELECT';    
 	SET @sql_ins = CONCAT(@sql_ins, '   AH.SYORIYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.SYUKAYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.NOHINYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.DENPYOYMD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.NNSICD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.NNSINM');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.JGSCD_SK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.JGSNM_SK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.SNTCD_SK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.SNTNM_SK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.UNSKSCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.UNSKSNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.JGSCD_NK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.JGSNM_NK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.SNTCD_NK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.SNTNM_NK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.SKHNYKBN1');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.SKHNYKBN1NM');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.DENNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.DENGNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , AH.BIKO');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.SHCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.DNRK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.SHNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.SHNKKKMEI_KS AS SHNKKKMEI');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.SEKKBN');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.SR1RS');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.SR2RS');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.KHKBN');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.RTNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.LOTK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.LOTS');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.FCKBNKK');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.PL');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.KKTSR1');
	SET @sql_ins = CONCAT(@sql_ins, ' , (AD.KKTSR1 DIV AD.PL) AS PL_DIV');
	SET @sql_ins = CONCAT(@sql_ins, ' , (AD.KKTSR1 MOD AD.PL) AS PL_MOD');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.KKTSR2');
	SET @sql_ins = CONCAT(@sql_ins, ' , AD.KKTSR3');
	SET @sql_ins = CONCAT(@sql_ins, ' , TRUNCATE(AD.WGT+0.9, 0) AS WGT');
    SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(AH.TRKMJ,\'%Y%m%d\') AS TRKMJ');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(AH.TRKMJ,\'%Y\') AS TRKMJ_YYYY');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(AH.TRKMJ,\'%m\') AS TRKMJ_MM');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(AH.TRKMJ,\'%d\') AS TRKMJ_DD');
    SET @sql_ins = CONCAT(@sql_ins, '  FROM arrival_schedules AS AH');
	SET @sql_ins = CONCAT(@sql_ins, '  INNER JOIN arrival_schedule_details AS AD');
	SET @sql_ins = CONCAT(@sql_ins, '  ON AH.ID = AD.ID');   
    IF p_sntcd IS NOT NULL THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN tmp_sntcd AS ST');
        SET @sql_ins = CONCAT(@sql_ins,' ON AH.JGSCD_NK = ST.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND AH.SNTCD_NK = ST.SNTCD');        
	END IF;
    IF p_is_partner = 1 THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN mtb_sp_conditions AS SP');
		SET @sql_ins = CONCAT(@sql_ins,' ON AH.NNSICD = SP.NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,' AND AH.JGSCD_NK = SP.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR AH.SNTCD_NK = SP.SNTCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.UNSKSCD IS NULL OR AH.UNSKSCD = SP.UNSKSCD)');
		/*
        SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SYUKAP IS NULL OR AS.SYUKAP = SP.SYUKAP)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SEKKBN IS NULL OR AD.SEKKBN = SP.SEKKBN)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.NHNSKCD IS NULL OR AS.NHNSKCD = SP.NHNSKCD)');
        */
		SET @sql_ins = CONCAT(@sql_ins,' AND SP.NKTISFRG = 1');        
	END IF;
    
    
    SET @sql_where = CONCAT(' WHERE AH.TRKMJ BETWEEN \'',@date_from,'\' AND \'',@date_to,'\'');
    
	IF p_date_from IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND AH.NOHINYMD >= \'',p_date_from,'\'');		
	END IF;
	
	IF p_date_to IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND AH.NOHINYMD <= \'',p_date_to,'\'');		
	END IF;
    
    IF p_jgscd IS NOT NULL THEN
		SET @sql_where = CONCAT(@sql_where,' AND AH.JGSCD_NK IN(',p_jgscd,')');				
	END IF;
    
	IF p_is_partner = 1 THEN
		SET @sql_where = CONCAT(@sql_where,' AND SP.PTNCD = \'',p_management_cd,'\'');		
	END IF;
        

	SET @sql_ins = CONCAT(@sql_ins,IFNULL(@sql_where,''));
    
    SET @sql_ins = CONCAT(@sql_ins, ' ORDER BY ');
    SET @sql_ins = CONCAT(@sql_ins, '  AH.NOHINYMD DESC');		
    SET @sql_ins = CONCAT(@sql_ins, ', AH.JGSCD_NK ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.SNTCD_NK ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.NNSICD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.DENNO ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AD.DENGNO ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', AD.RTNO ASC');
    
	
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
    
	
    IF EXISTS(SELECT * FROM tmp_details) THEN
        
		-- STEP.2 SET UP INSERT WORK TABLE
		SELECT IFNULL(MAX(work_id),0) + 1 INTO @def_work_id FROM wk_202000_head FOR UPDATE;
		SELECT IFNULL(MAX(work_detail_id),0) + 1 INTO @work_detail_id FROM wk_202000_details FOR UPDATE;
				
		
		SET @sql_prev_key = 'CONCAT_WS(\'_\'';
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NOHINYMD,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSCD_NK,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSNM_NK,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTCD_NK,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTNM_NK,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSICD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSINM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ')');
		
		
		-- STEP.3 INSERT WORK HEAD
        SET @prevkey:=null;
		SET @work_id = @def_work_id;
        
		SET @sql_head = 'INSERT INTO wk_202000_head SELECT DISTINCT';
		SET @sql_head = CONCAT(@sql_head, '  CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_head = CONCAT(@sql_head, ', \'',p_user_id,'\' AS user_id');
		SET @sql_head = CONCAT(@sql_head, ', NOHINYMD');
		SET @sql_head = CONCAT(@sql_head, ', JGSCD_NK');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM_NK');
        SET @sql_head = CONCAT(@sql_head, ', SNTCD_NK');
		SET @sql_head = CONCAT(@sql_head, ', SNTNM_NK');		
		SET @sql_head = CONCAT(@sql_head, ', NNSICD');
		SET @sql_head = CONCAT(@sql_head, ', NNSINM');
        SET @sql_head = CONCAT(@sql_head, ', NULL AS STATUS');
		SET @sql_head = CONCAT(@sql_head, ', @prevkey:=',@sql_prev_key);	
		SET @sql_head = CONCAT(@sql_head, ' FROM tmp_details');
			
		
		PREPARE _stmt_head from @sql_head;
		EXECUTE _stmt_head;
		DEALLOCATE PREPARE _stmt_head;
		
		
        
        -- STEP.4 INSERT WORK DETAIL
		SET @prevkey:=null;
		SET @work_id = @def_work_id;
			
		SET @sql_ins = 'INSERT INTO wk_202000_details SELECT';
		SET @sql_ins = CONCAT(@sql_ins, '   @work_detail_id:=@work_detail_id+1 AS work_detail_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYORIYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYUKAYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NOHINYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENPYOYMD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NNSICD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NNSINM');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSCD_SK');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSNM_SK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTCD_SK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTNM_SK');
		SET @sql_ins = CONCAT(@sql_ins, ' , UNSKSCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , UNSKSNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSCD_NK');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSNM_NK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTCD_NK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTNM_NK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKHNYKBN1');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKHNYKBN1NM');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , DENGNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , BIKO');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , DNRK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNKKKMEI');
		SET @sql_ins = CONCAT(@sql_ins, ' , SEKKBN');
		SET @sql_ins = CONCAT(@sql_ins, ' , SR1RS');
		SET @sql_ins = CONCAT(@sql_ins, ' , SR2RS');
		SET @sql_ins = CONCAT(@sql_ins, ' , KHKBN');
		SET @sql_ins = CONCAT(@sql_ins, ' , RTNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , LOTK');
		SET @sql_ins = CONCAT(@sql_ins, ' , LOTS');
		SET @sql_ins = CONCAT(@sql_ins, ' , FCKBNKK');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL_DIV');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL_MOD');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR2');
		SET @sql_ins = CONCAT(@sql_ins, ' , KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins, ' , WGT');
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
		SELECT * FROM wk_202000_head WHERE user_id = p_user_id
        ORDER BY NOHINYMD DESC, JGSCD ASC, SNTCD ASC, NNSICD ASC;
    ELSE
		-- NOTHINGS TO RETURN
		SELECT * FROM wk_202000_head WHERE user_id = p_user_id;
    END IF;          
    
    
    DROP TABLE IF EXISTS tmp_details;

	COMMIT;
    
END//

delimiter ;