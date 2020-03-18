DROP PROCEDURE IF EXISTS usp_305000;
delimiter //

CREATE PROCEDURE usp_305000(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_nnsicd text
,	IN p_ptncd text
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(10)
)
BEGIN

	DECLARE cur_date DATE;

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
		DELETE FROM wk_305000_head WHERE user_id = p_user_id;
        DROP TABLE IF EXISTS tmp_details;
        RESIGNAL;
    END;

    -- トランザクション開始
    START TRANSACTION;
    
    -- STEP.0 REFRESH WORK & SETUP PARAMS
    DELETE FROM wk_305000_head WHERE user_id = p_user_id;
    	    
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
	SET @sql_ins = CONCAT(@sql_ins, '   LS.DET_ID');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.TRNJ');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTStocktakingDate');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.JGSCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.JGSNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SNTCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SNTNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.NNSICD');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.NNSINM');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SRRNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SHCD');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SHNM');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.DNRK');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.RTNO');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.KANRIK');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SYUKAK');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.KOUJOK');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SHNKKKMEI_KS');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SR1RS');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTexStocks1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTexStocks3');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.NUKSURU1 AS PYTRecieving1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.NUKSURU3 AS PYTRecieving3');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTPicking1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTPicking3');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTstock1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTstock3');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PL');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTPLQ');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.PYTPLP');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.ZNJTZIKSURU1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.ZNJTZIKSURU3');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.NUKSURU1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.NUKSURU3');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SKSURU1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SKSURU3');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.TUJTZIKSURU1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.TUJTZIKSURU3');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SKYTI1SURU1');
	SET @sql_ins = CONCAT(@sql_ins, ' , LS.SKYTI1SURU3');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(LS.PYTStocktakingDate,\'%Y\') AS PTStocktakingDate_YYYY');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(LS.PYTStocktakingDate,\'%m\') AS PTStocktakingDate_MM');
	SET @sql_ins = CONCAT(@sql_ins, ' , DATE_FORMAT(LS.PYTStocktakingDate,\'%d\') AS PTStocktakingDate_DD');

    SET @sql_ins = CONCAT(@sql_ins, '  FROM location_stocks AS LS');	
    IF p_sntcd IS NOT NULL THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN tmp_sntcd AS ST');
        SET @sql_ins = CONCAT(@sql_ins,' ON LS.JGSCD = ST.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND LS.SNTCD = ST.SNTCD');        
	END IF;
    IF p_is_partner = 1 || p_ptncd IS NOT NULL THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN mtb_sp_conditions AS SP');
		SET @sql_ins = CONCAT(@sql_ins,' ON LS.NNSICD = SP.NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,' AND LS.JGSCD = SP.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR LS.SNTCD = SP.SNTCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND SP.ZKTISFRG = 1');        
	END IF;
    
    
    SET @sql_where = NULL;
    IF p_date_from IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';		
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');		
        END IF;        
		SET @sql_where = CONCAT(@sql_where,' LS.PYTStocktakingDate >= \'',p_date_from,'\'');		
	END IF;
	
	IF p_date_to IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';		
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');		
        END IF;        
		SET @sql_where = CONCAT(@sql_where,' LS.PYTStocktakingDate <= \'',p_date_to,'\'');		
	END IF;
    
    IF p_jgscd IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';		
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');		
        END IF;        
		SET @sql_where = CONCAT(@sql_where,' LS.JGSCD IN(',p_jgscd,')');				
	END IF;
    
    IF p_nnsicd IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';		
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');		
        END IF;        
		SET @sql_where = CONCAT(@sql_where,' LS.NNSICD IN(',p_nnsicd,')');				
	END IF;
    
    IF p_ptncd IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');	
        END IF;
		SET @sql_where = CONCAT(@sql_where,' SP.PTNCD IN(',p_ptncd,')');				
	END IF;
    
	IF p_is_partner = 1 THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';		
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');		
        END IF; 
		SET @sql_where = CONCAT(@sql_where,' SP.PTNCD = \'',p_management_cd,'\'');		
	END IF;
        

	SET @sql_ins = CONCAT(@sql_ins,IFNULL(@sql_where,''));
    
    SET @sql_ins = CONCAT(@sql_ins, ' ORDER BY ');
    SET @sql_ins = CONCAT(@sql_ins, '  LS.PYTStocktakingDate DESC');		
    SET @sql_ins = CONCAT(@sql_ins, ', LS.JGSCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', LS.SNTCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', LS.NNSICD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', LS.SHCD ASC');
    SET @sql_ins = CONCAT(@sql_ins, ', LS.RTNO ASC');    
    
	
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
    
	
    IF EXISTS(SELECT * FROM tmp_details) THEN
        
		-- STEP.2 SET UP INSERT WORK TABLE
		SELECT IFNULL(MAX(work_id),0) + 1 INTO @def_work_id FROM wk_305000_head FOR UPDATE;
		SELECT IFNULL(MAX(work_detail_id),0) + 1 INTO @work_detail_id FROM wk_305000_details FOR UPDATE;
				
		
		SET @sql_prev_key = 'CONCAT_WS(\'_\'';
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(PYTStocktakingDate,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(JGSNM,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTCD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(SNTNM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSICD,\'\')');
        SET @sql_prev_key = CONCAT(@sql_prev_key, ' , IFNULL(NNSINM,\'\')');
		SET @sql_prev_key = CONCAT(@sql_prev_key, ')');
		
		
		-- STEP.3 INSERT WORK HEAD
        SET @prevkey:=null;
		SET @work_id = @def_work_id;
        
		SET @sql_head = 'INSERT INTO wk_305000_head SELECT DISTINCT';
		SET @sql_head = CONCAT(@sql_head, '  CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_head = CONCAT(@sql_head, ', \'',p_user_id,'\' AS user_id');
		SET @sql_head = CONCAT(@sql_head, ', PYTStocktakingDate');
		SET @sql_head = CONCAT(@sql_head, ', JGSCD');
		SET @sql_head = CONCAT(@sql_head, ', JGSNM');
        SET @sql_head = CONCAT(@sql_head, ', SNTCD');
		SET @sql_head = CONCAT(@sql_head, ', SNTNM');		
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
			
		SET @sql_ins = 'INSERT INTO wk_305000_details SELECT';
		SET @sql_ins = CONCAT(@sql_ins, '   @work_detail_id:=@work_detail_id+1 AS work_detail_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , CAST(if(@prevkey <> ',@sql_prev_key,', @work_id:=@work_id+1, @work_id) AS UNSIGNED) as work_id');
		SET @sql_ins = CONCAT(@sql_ins, ' , DET_ID');
		SET @sql_ins = CONCAT(@sql_ins, ' , TRNJ');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTStocktakingDate');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , JGSNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , SNTNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , NNSICD');
		SET @sql_ins = CONCAT(@sql_ins, ' , NNSINM');
		SET @sql_ins = CONCAT(@sql_ins, ' , SRRNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHCD');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNM');
		SET @sql_ins = CONCAT(@sql_ins, ' , DNRK');
		SET @sql_ins = CONCAT(@sql_ins, ' , RTNO');
		SET @sql_ins = CONCAT(@sql_ins, ' , KANRIK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SYUKAK');
		SET @sql_ins = CONCAT(@sql_ins, ' , KOUJOK');
		SET @sql_ins = CONCAT(@sql_ins, ' , SHNKKKMEI_KS');
		SET @sql_ins = CONCAT(@sql_ins, ' , SR1RS');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTexStocks1');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTexStocks3');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTRecieving1');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTRecieving3');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTPicking1');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTPicking3');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTstock1');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTstock3');
		SET @sql_ins = CONCAT(@sql_ins, ' , PL');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTPLQ');
		SET @sql_ins = CONCAT(@sql_ins, ' , PYTPLP');
		SET @sql_ins = CONCAT(@sql_ins, ' , ZNJTZIKSURU1');
		SET @sql_ins = CONCAT(@sql_ins, ' , ZNJTZIKSURU3');
		SET @sql_ins = CONCAT(@sql_ins, ' , NUKSURU1');
		SET @sql_ins = CONCAT(@sql_ins, ' , NUKSURU3');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKSURU1');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKSURU3');
		SET @sql_ins = CONCAT(@sql_ins, ' , TUJTZIKSURU1');
		SET @sql_ins = CONCAT(@sql_ins, ' , TUJTZIKSURU3');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKYTI1SURU1');
		SET @sql_ins = CONCAT(@sql_ins, ' , SKYTI1SURU3');
		SET @sql_ins = CONCAT(@sql_ins, ' , PTStocktakingDate_YYYY');
		SET @sql_ins = CONCAT(@sql_ins, ' , PTStocktakingDate_MM');
		SET @sql_ins = CONCAT(@sql_ins, ' , PTStocktakingDate_DD');
		SET @sql_ins = CONCAT(@sql_ins, ' , @prevkey:=',@sql_prev_key);
		SET @sql_ins = CONCAT(@sql_ins, ' FROM tmp_details');
		
		PREPARE _stmt_detail from @sql_ins;
		EXECUTE _stmt_detail;
		DEALLOCATE PREPARE _stmt_detail;
		
        -- STEP.5 RETURN
		SELECT * FROM wk_305000_head WHERE user_id = p_user_id
        ORDER BY PYTStocktakingDate DESC, JGSCD ASC, SNTCD ASC, NNSICD ASC;
    ELSE
		-- NOTHINGS TO RETURN
		SELECT * FROM wk_305000_head WHERE user_id = p_user_id;
    END IF;          
    
    
    DROP TABLE IF EXISTS tmp_details;

    COMMIT;
    
END//

delimiter ;