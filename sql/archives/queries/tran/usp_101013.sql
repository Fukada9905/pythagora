DROP PROCEDURE IF EXISTS usp_101013;
delimiter //

CREATE PROCEDURE usp_101013(
	IN p_process_divide tinyint
,	IN p_is_partner tinyint
,	IN p_date_divide tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_management_cd varchar(10)
,	IN p_sntcd text
)
BEGIN

	    
	DECLARE _nnsicd varchar(10);
    DECLARE _nnsinm varchar(50);
    DECLARE _cur CURSOR FOR SELECT NNSICD, NNSINM FROM mtb_ninushi;
    
    

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TABLE IF EXISTS tmp_sntcd ;
		DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_ptncd_total;
		DROP TABLE IF EXISTS tmp_data_total;
		DROP TABLE IF EXISTS tmp_data;
        RESIGNAL;
    END;
    
	CREATE TEMPORARY TABLE tmp_data(
		PTNCD varchar(10)
    ,	PTNNM varchar(50)
    ,	DATEYMD date
    ,	NNSICD varchar(10)
    ,	NNSINM varchar(50)    
    ,	TOTAL_KKTSR1 int NOT NULL DEFAULT 0
    ,	TOTAL_KKTSR3 int NOT NULL DEFAULT 0
    ,	TOTAL_WGT int NOT NULL DEFAULT 0
    
    );

	
	
	IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD = CONCAT('INSERT INTO tmp_sntcd(JGSCD,SNTCD) VALUES',p_sntcd);
        
        PREPARE stmt_SNTCD from @sql_SNTCD;
		EXECUTE stmt_SNTCD;
		DEALLOCATE PREPARE stmt_SNTCD;
	END IF;
	
	
		
	SET @sql_sum = '';  
    
	
	SELECT COUNT(*) INTO @total FROM mtb_ninushi;
    
    SET @pos = 0;
    OPEN _cur;
    
    WHILE @total > @pos DO
    	FETCH _cur INTO _nnsicd, _nnsinm;
		SET @sql_cr = 'ALTER TABLE tmp_data';
        SET @sql_cr = CONCAT(@sql_cr , ' ADD COLUMN ',_nnsicd,'_KKTSR1 int NOT NULL DEFAULT 0');
		SET @sql_cr = CONCAT(@sql_cr , ',ADD COLUMN ',_nnsicd,'_KKTSR3 int NOT NULL DEFAULT 0');
		SET @sql_cr = CONCAT(@sql_cr , ',ADD COLUMN ',_nnsicd,'_WGT int NOT NULL DEFAULT 0');
		
        PREPARE _stmt_cr from @sql_cr;
		EXECUTE _stmt_cr;
		DEALLOCATE PREPARE _stmt_cr;
		SET @pos = @pos +1;
	END WHILE;
    
    CLOSE _cur;
    
    OPEN _cur;
    SET @pos = 0;
    
    
    WHILE @total > @pos DO
		FETCH _cur INTO _nnsicd, _nnsinm;
        
        SET @sql_ins = 'INSERT INTO tmp_data(';
		SET @sql_ins = CONCAT(@sql_ins,'  PTNCD');
		SET @sql_ins = CONCAT(@sql_ins,', PTNNM');
        SET @sql_ins = CONCAT(@sql_ins,', DATEYMD');			
        SET @sql_ins = CONCAT(@sql_ins,', NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,', NNSINM');
		SET @sql_ins = CONCAT(@sql_ins,', TOTAL_KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins,', TOTAL_KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins,', TOTAL_WGT');
		SET @sql_ins = CONCAT(@sql_ins,', ',_nnsicd,'_KKTSR1');
		SET @sql_ins = CONCAT(@sql_ins,', ',_nnsicd,'_KKTSR3');
		SET @sql_ins = CONCAT(@sql_ins,', ',_nnsicd,'_WGT');
		SET @sql_ins = CONCAT(@sql_ins,')');
        SET @sql_ins = CONCAT(@sql_ins,' SELECT');
        SET @sql_ins = CONCAT(@sql_ins,'  IFNULL(PN.PTNCD,\'ZZZZZZZZZ\')');
		SET @sql_ins = CONCAT(@sql_ins,', CASE WHEN PN.PTNCD IS NULL THEN \'なし\' ELSE CONCAT(IFNULL(PN.PTNCDNM1,\'\'),IFNULL(PN.PTNCDNM2,\'\')) END AS PTNNM');
        IF p_date_divide = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins,', SH.SYUKAYMD AS DATEYMD');			
        ELSE
			SET @sql_ins = CONCAT(@sql_ins,', SH.NOHINYMD AS DATEYMD');
        END IF;
		SET @sql_ins = CONCAT(@sql_ins,', SH.NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,', SH.NNSINM');
		
        
              
		-- 仮出荷
		IF p_process_divide = 1 THEN 
        
			SET @sql_ins = CONCAT(@sql_ins,', SD.JCSR1');
			SET @sql_ins = CONCAT(@sql_ins,', SD.JCSR3');
			SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SD.JCSJR+0.9, 0)');
			SET @sql_ins = CONCAT(@sql_ins,', SD.JCSR1');
			SET @sql_ins = CONCAT(@sql_ins,', SD.JCSR3');
			SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SD.JCSJR+0.9, 0)');
			SET @sql_ins = CONCAT(@sql_ins,' FROM shipment_provisionals AS SH');
			SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN shipment_provisional_details AS SD');
			SET @sql_ins = CONCAT(@sql_ins,' ON SH.ID = SD.ID');
            
		-- 出荷確定
        ELSE
			SET @sql_ins = CONCAT(@sql_ins,', SD.KKTSR1');
			SET @sql_ins = CONCAT(@sql_ins,', SD.KKTSR3');
			SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SD.WGT+0.9, 0)');
			SET @sql_ins = CONCAT(@sql_ins,', SD.KKTSR1');
			SET @sql_ins = CONCAT(@sql_ins,', SD.KKTSR3');
			SET @sql_ins = CONCAT(@sql_ins,', TRUNCATE(SD.WGT+0.9, 0)');
			SET @sql_ins = CONCAT(@sql_ins,' FROM shipment_confirms AS SH');
			SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN shipment_confirm_details AS SD');
			SET @sql_ins = CONCAT(@sql_ins,' ON SH.ID = SD.ID');
        END IF;
        
        IF p_sntcd IS NOT NULL THEN
			SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN tmp_sntcd AS ST');
			SET @sql_ins = CONCAT(@sql_ins,' ON SD.JGSCD = ST.JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,' AND SD.SNTCD = ST.SNTCD');
        END IF;
        
        SET @sql_ins = CONCAT(@sql_ins,' LEFT JOIN mtb_sp_conditions AS SP');
		SET @sql_ins = CONCAT(@sql_ins,' ON SH.NNSICD = SP.NNSICD');
		SET @sql_ins = CONCAT(@sql_ins,' AND SD.JGSCD = SP.JGSCD');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SNTCD IS NULL OR SD.SNTCD = SP.SNTCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.UNSKSCD IS NULL OR SH.UNSKSCD = SP.UNSKSCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SYUKAP IS NULL OR SH.SYUKAP = SP.SYUKAP)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.SEKKBN IS NULL OR SD.SEKKBN = SP.SEKKBN)');
		SET @sql_ins = CONCAT(@sql_ins,' AND (SP.NHNSKCD IS NULL OR SH.NHNSKCD = SP.NHNSKCD)');
		SET @sql_ins = CONCAT(@sql_ins,' AND SP.SKTISFRG = 1');
        SET @sql_ins = CONCAT(@sql_ins,' LEFT JOIN mtb_partners AS PN');
		SET @sql_ins = CONCAT(@sql_ins,' ON SP.PTNCD = PN.PTNCD');
        
        
        SET @sql_ins = CONCAT(@sql_ins,' WHERE SH.NNSICD = \'',_nnsicd,'\'');
        IF p_process_divide = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SH.DKBN = \'AM\'');
		ELSE
			SET @sql_ins = CONCAT(@sql_ins,' AND SH.SKHNYKBN1 != \'A2\'');		
		END IF;
		IF p_date_from IS NOT NULL THEN
			IF p_date_divide = 1 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.SYUKAYMD >= \'',p_date_from,'\'');
			ELSE
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.NOHINYMD >= \'',p_date_from,'\'');
			END IF;					
		END IF;
		
		IF p_date_to IS NOT NULL THEN
			IF p_date_divide = 1 THEN
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.SYUKAYMD <= \'',p_date_to,'\'');
			ELSE
				SET @sql_ins = CONCAT(@sql_ins,' AND SH.NOHINYMD <= \'',p_date_to,'\'');
			END IF;					
		END IF;
        
        IF p_jgscd IS NOT NULL THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SD.JGSCD IN(',p_jgscd,')');				
		END IF;
        IF p_is_partner = 1 THEN
			SET @sql_ins = CONCAT(@sql_ins,' AND SP.PTNCD = \'',p_management_cd,'\'');		
        END IF;
        
		
        PREPARE _stmt_ins from @sql_ins;
		EXECUTE _stmt_ins;
		DEALLOCATE PREPARE _stmt_ins;
        
        SET @sql_sum = CONCAT(@sql_sum, ', SUM(',_nnsicd,'_KKTSR1) AS ',_nnsicd,'_KKTSR1');
        SET @sql_sum = CONCAT(@sql_sum, ', SUM(',_nnsicd,'_KKTSR3) AS ',_nnsicd,'_KKTSR3');
        SET @sql_sum = CONCAT(@sql_sum, ', SUM(',_nnsicd,'_WGT) AS ',_nnsicd,'_WGT');
                
                                      
        SET @pos = @pos +1;
	END WHILE;
    
    CLOSE _cur;
    
    IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
		SET @sql_ret = 'CREATE TEMPORARY TABLE tmp_data_details';
		SET @sql_ret = CONCAT(@sql_ret,' SELECT');
		SET @sql_ret = CONCAT(@sql_ret,'  PTNCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,PTNNM');
        SET @sql_ret = CONCAT(@sql_ret,' ,ufn_get_date_format(DATEYMD) AS DATEYMD');
        SET @sql_ret = CONCAT(@sql_ret,@sql_sum);
        SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR1) AS TOTAL_KKTSR1');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR3) AS TOTAL_KKTSR3');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_WGT) AS TOTAL_WGT');        
        SET @sql_ret = CONCAT(@sql_ret,' ,1 AS DATA_DIVIDE');
        SET @sql_ret = CONCAT(@sql_ret,' FROM tmp_data AS DD');
        SET @sql_ret = CONCAT(@sql_ret,' GROUP BY');
		SET @sql_ret = CONCAT(@sql_ret,'  PTNCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,PTNNM');
		SET @sql_ret = CONCAT(@sql_ret,' ,DATEYMD');
		
        
        PREPARE _stmt_ret1 from @sql_ret;
		EXECUTE _stmt_ret1;
		DEALLOCATE PREPARE _stmt_ret1;
        
        
        
        SET @sql_ret = 'CREATE TEMPORARY TABLE tmp_data_ptncd_total';
		SET @sql_ret = CONCAT(@sql_ret,' SELECT');
		SET @sql_ret = CONCAT(@sql_ret,'  PTNCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,CONCAT(IFNULL(PTNNM,\'\'),\' 集計\') AS PTNNM');
        SET @sql_ret = CONCAT(@sql_ret,' ,\'\' AS DATEYMD');
        SET @sql_ret = CONCAT(@sql_ret,@sql_sum);
        SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR1) AS TOTAL_KKTSR1');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR3) AS TOTAL_KKTSR3');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_WGT) AS TOTAL_WGT');        
        SET @sql_ret = CONCAT(@sql_ret,' ,2 AS DATA_DIVIDE');
        SET @sql_ret = CONCAT(@sql_ret,' FROM tmp_data AS DD');
        SET @sql_ret = CONCAT(@sql_ret,' GROUP BY');
		SET @sql_ret = CONCAT(@sql_ret,'  PTNCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,PTNNM');
		
        
        PREPARE _stmt_ret2 from @sql_ret;
		EXECUTE _stmt_ret2;
		DEALLOCATE PREPARE _stmt_ret2;
               
        
        SET @sql_ret = 'CREATE TEMPORARY TABLE tmp_data_total';
		SET @sql_ret = CONCAT(@sql_ret,' SELECT');
		SET @sql_ret = CONCAT(@sql_ret,'  \'ZZZZZZZZZZ\' AS PTNCD');
		SET @sql_ret = CONCAT(@sql_ret,' ,\'\' AS PTNNM');
        SET @sql_ret = CONCAT(@sql_ret,' ,\'\' AS DATEYMD');        
        SET @sql_ret = CONCAT(@sql_ret,@sql_sum);
        SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR1) AS TOTAL_KKTSR1');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_KKTSR3) AS TOTAL_KKTSR3');
		SET @sql_ret = CONCAT(@sql_ret,' ,SUM(TOTAL_WGT) AS TOTAL_WGT');
        SET @sql_ret = CONCAT(@sql_ret,' ,3 AS DATA_DIVIDE');
        SET @sql_ret = CONCAT(@sql_ret,' FROM tmp_data AS DD');
        
        
        PREPARE _stmt_ret3 from @sql_ret;
		EXECUTE _stmt_ret3;
		DEALLOCATE PREPARE _stmt_ret3;
        
        
        SELECT * FROM tmp_data_details
		UNION ALL
        SELECT * FROM tmp_data_ptncd_total
        UNION ALL
		SELECT * FROM tmp_data_total
		ORDER BY PTNCD,DATA_DIVIDE,DATEYMD;
        
        		
	ELSE
		SELECT * FROM tmp_data;
    END IF;
    
    DROP TABLE IF EXISTS tmp_sntcd ;
    DROP TABLE IF EXISTS tmp_data_details;
	DROP TABLE IF EXISTS tmp_data_ptncd_total;
	DROP TABLE IF EXISTS tmp_data_total;
    DROP TABLE IF EXISTS tmp_data;
        
    
END//

delimiter ;