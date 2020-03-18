DROP PROCEDURE IF EXISTS usp_201010;
delimiter //

CREATE PROCEDURE usp_201010(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(20)
)
BEGIN

	DECLARE cur_date DATE;

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
    	DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_ymd_total;
		DROP TABLE IF EXISTS tmp_data_total;
		DROP TABLE IF EXISTS tmp_data;
        DROP TABLE IF EXISTS tmp_sntcd;
        RESIGNAL;
    END;

    -- トランザクション開始
    START TRANSACTION;
    
	DELETE FROM wk_201010 WHERE user_id = p_user_id;
	
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
    
    
	CREATE TEMPORARY TABLE tmp_data(
		NOHINYMD date
	,	NNSICD varchar(10)
    ,	NNSINM varchar(50)
    ,	KKTSR1 int NOT NULL DEFAULT 0
    ,	KKTSR3 int NOT NULL DEFAULT 0
    ,	MOD_PL int NOT NULL DEFAULT 0    
    );
	

    
    SET @sql_ins = 'INSERT INTO tmp_data';
	SET @sql_ins = CONCAT(@sql_ins, ' SELECT');
    SET @sql_ins = CONCAT(@sql_ins, '  AH.NOHINYMD');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.NNSICD');
    SET @sql_ins = CONCAT(@sql_ins, ', AH.NNSINM');    
    SET @sql_ins = CONCAT(@sql_ins, ', AD.KKTSR1');
	SET @sql_ins = CONCAT(@sql_ins, ', AD.KKTSR3');
	SET @sql_ins = CONCAT(@sql_ins, ', CASE WHEN AD.PL >= AD.KKTSR1 THEN 1 ELSE TRUNCATE((AD.KKTSR1/AD.PL)+.9,0) END AS MOD_PL');
	SET @sql_ins = CONCAT(@sql_ins, '  FROM arrival_schedules AS AH');
	SET @sql_ins = CONCAT(@sql_ins, '  INNER JOIN arrival_schedule_details AS AD');
	SET @sql_ins = CONCAT(@sql_ins, '  ON AH.ID = AD.ID');    
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
    IF p_sntcd IS NOT NULL THEN
		SET @sql_ins = CONCAT(@sql_ins,' INNER JOIN tmp_sntcd AS ST');
        IF p_is_partner = 0 THEN
			SET @sql_ins = CONCAT(@sql_ins,' ON AH.JGSCD_NK = ST.JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,' AND AH.SNTCD_NK = ST.SNTCD');
        ELSE
			SET @sql_ins = CONCAT(@sql_ins,' ON SP.JGSCD = ST.JGSCD');
			SET @sql_ins = CONCAT(@sql_ins,' AND SP.SNTCD = ST.SNTCD');
        END IF;
		
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

		
	PREPARE _stmt_ins from @sql_ins;
	EXECUTE _stmt_ins;
	DEALLOCATE PREPARE _stmt_ins;
            
    IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
		CREATE TEMPORARY TABLE tmp_data_details
        SELECT
			ufn_get_date_format(NOHINYMD) AS NOHINYMD
		,	NNSICD
        ,	NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(MOD_PL) AS MOD_PL
        ,	1 AS DATA_DIVIDE
		FROM tmp_data
        GROUP BY
			NOHINYMD
		,	NNSICD
        ,	NNSINM;
        
        CREATE TEMPORARY TABLE tmp_data_ymd_total
        SELECT
			CONCAT(ufn_get_date_format(NOHINYMD),' 集計') AS NOHINYMD
		,	'ZZZZZZZZZZ' AS NNSICD
        ,	'' AS NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(MOD_PL) AS MOD_PL
        ,	2 AS DATA_DIVIDE
		FROM tmp_data
        GROUP BY
			NOHINYMD
		;
        
        CREATE TEMPORARY TABLE tmp_data_total
        SELECT
			'ZZZZZZZZZZ' AS NOHINYMD
		,	'ZZZZZZZZZZ' AS NNSICD
        ,	'' AS NNSINM
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(MOD_PL) AS MOD_PL
        ,	3 AS DATA_DIVIDE
		FROM tmp_data
        ;
		
               
		SELECT IFNULL(MAX(work_id),0) INTO @work_id FROM wk_201010 FOR UPDATE;
        
        INSERT INTO wk_201010
        SELECT
			@work_id:=@work_id+1
		,	p_user_id
		,	DT.NOHINYMD
		,	DT.NNSICD
        ,	DT.NNSINM
        ,	DT.KKTSR1
        ,	DT.KKTSR3
        ,	DT.MOD_PL
        ,	DT.DATA_DIVIDE
        FROM
        (
			SELECT
				*
			FROM tmp_data_details
			UNION ALL
			SELECT
				*
			FROM tmp_data_ymd_total
			UNION ALL
			SELECT
				*
			FROM tmp_data_total
			ORDER BY NOHINYMD,DATA_DIVIDE,NNSICD
        ) AS DT;
        
        SELECT
			NOHINYMD
		,	NNSINM
        ,	KKTSR1
        ,	KKTSR3
        ,	MOD_PL
        ,	DATA_DIVIDE        
        FROM wk_201010
        WHERE user_id = p_user_id;
        
        
	ELSE
		SELECT * FROM tmp_data;
    END IF;
    
    
    DROP TABLE IF EXISTS tmp_data_details;
	DROP TABLE IF EXISTS tmp_data_ymd_total;
	DROP TABLE IF EXISTS tmp_data_total;
	DROP TABLE IF EXISTS tmp_data;
    DROP TABLE IF EXISTS tmp_sntcd;

    COMMIT;
        
    
END//

delimiter ;