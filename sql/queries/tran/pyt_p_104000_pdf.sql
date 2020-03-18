DROP PROCEDURE IF EXISTS pyt_p_104000_pdf;
delimiter //

CREATE PROCEDURE pyt_p_104000_pdf(
	IN p_process_divide tinyint
,	IN p_ids text
,	IN p_user_id varchar(10)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TABLE IF EXISTS tmp_data;
		DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_total_NHNSKCD;
		DROP TABLE IF EXISTS tmp_data_total_UNSKSCD;
        RESIGNAL;
    END;
    
    
    SET @sql_sel = 'CREATE TEMPORARY TABLE tmp_data SELECT';
	SET @sql_sel = CONCAT(@sql_sel, '   WD.DKBNNM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NNSICD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NNSINM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSCD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSNM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JCDENNO');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DENNO');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DENGNO');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SYUKAP');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.LOTK');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.LOTS');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.FCKBNKK');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTCD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTNM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PTNNM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.UNSKSCD');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.UNSKSNM');    
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SKHNYKBN1');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SKHNYKBN1NM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SYORIYMD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SYUKAYMD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NOHINYMD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DENPYOYMD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NHNSKCD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NHNSKNM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JYUSYO');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TEL');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JISCD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHCD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DNRK');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHNM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHNKKKMEI');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SEKKBN');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.RTNO');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SR1RS');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SR2RS');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KHKBN');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSR1');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL_DIV');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL_MOD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSR2');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSR3');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSSR');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.WGT');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KOJYOFLG');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.BIKO');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRKMJ');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRKMJ_YYYY');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRKMJ_MM');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRKMJ_DD');    
    SET @sql_sel = CONCAT(@sql_sel,' FROM pyt_w_104000_details AS WD');
    IF p_ids IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' WHERE WD.user_id = \'',p_user_id,'\'');
		SET @sql_sel = CONCAT(@sql_sel,' AND WD.work_id IN(',p_ids,')');
        SET @sql_sel = CONCAT(@sql_sel,' AND WD.process_divide = ',p_process_divide);
	ELSE
		SET @sql_sel = CONCAT(@sql_sel,' WHERE WD.user_id = \'',p_user_id,'\'');
		SET @sql_sel = CONCAT(@sql_sel,' AND WD.process_divide = ',p_process_divide);
	END IF;   
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
    
    IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
		
        SELECT user_name INTO @user_name FROM pyt_m_users WHERE user_id = p_user_id;
        
        CREATE TEMPORARY TABLE tmp_data_details
		SELECT DISTINCT
			pyt_ufn_get_date_format(NOHINYMD) AS NOHINYMD
		,	NNSICD
		,	NNSINM
        ,	JGSCD
		,	JGSNM
		,	SYUKAP
        ,	UNSKSCD
        ,	UNSKSNM
        ,	NHNSKCD
        ,	NHNSKNM
        ,	JYUSYO
        ,	TEL
		,	DENNO
        ,	DENGNO
		,	BIKO
        ,	SHCD
        ,	DNRK
        ,	RTNO
        ,	KKTSR1
        ,	KKTSR2
        ,	KKTSR3
        ,	PL_DIV
        ,	PL_MOD
        ,	LOTK
        ,	LOTS
        ,	TRUNCATE(WGT,1) AS WGT
        ,	SNTCD
        ,	SNTNM
        ,	SHNM
        ,	SHNKKKMEI
		,	1 AS DATA_DIVIDE    
        ,	@user_name AS UserName
		FROM tmp_data		
		;
        
        CREATE TEMPORARY TABLE tmp_data_total_NHNSKCD
		SELECT DISTINCT
			pyt_ufn_get_date_format(NOHINYMD) AS NOHINYMD
		,	NNSICD
		,	NNSINM
        ,	JGSCD
		,	JGSNM
		,	SYUKAP
        ,	UNSKSCD
        ,	UNSKSNM
        ,	NHNSKCD
        ,	NHNSKNM
        ,	'' AS JYUSYO
        ,	'' AS TEL
		,	'' AS DENNO
        ,	0 AS DENGNO
		,	'' AS BIKO
        ,	'' AS SHCD
        ,	'' AS DNRK
        ,	'' AS RTNO
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR2) AS KKTSR2
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(PL_DIV) AS PL_DIV
        ,	SUM(PL_MOD) AS PL_MOD
        ,	'' AS LOTK
        ,	'' AS LOTS
        ,	SUM(TRUNCATE(WGT,1)) AS WGT
        ,	'' AS SNTCD
        ,	'' AS SNTNM
        ,	'(配送先　計)' AS SHNM
        ,	'' AS SHNKKKMEI
		,	2 AS DATA_DIVIDE
        ,	@user_name AS UserName
		FROM tmp_data		
        GROUP BY
			NOHINYMD
        ,	NNSICD
		,	NNSINM
        ,	JGSCD
		,	JGSNM
		,	SYUKAP
        ,	UNSKSCD
        ,	UNSKSNM
        ,	NHNSKCD
        ,	NHNSKNM   
		;
        
        
        CREATE TEMPORARY TABLE tmp_data_total_UNSKSCD
		SELECT DISTINCT
			pyt_ufn_get_date_format(NOHINYMD) AS NOHINYMD
		,	NNSICD
		,	NNSINM
        ,	JGSCD
		,	JGSNM
		,	SYUKAP
        ,	UNSKSCD
        ,	UNSKSNM
        ,	'ZZZZZZZZZZ' AS NHNSKCD
        ,	'' AS NHNSKNM
        ,	'' AS JYUSYO
        ,	'' AS TEL
		,	'' AS DENNO
        ,	0 AS DENGNO
		,	'' AS BIKO
        ,	'' AS SHCD
        ,	'' AS DNRK
        ,	'' AS RTNO
        ,	SUM(KKTSR1) AS KKTSR1
        ,	SUM(KKTSR2) AS KKTSR2
        ,	SUM(KKTSR3) AS KKTSR3
        ,	SUM(PL_DIV) AS PL_DIV
        ,	SUM(PL_MOD) AS PL_MOD
        ,	'' AS LOTK
        ,	'' AS LOTS
        ,	SUM(TRUNCATE(WGT,1)) AS WGT
        ,	'' AS SNTCD
        ,	'' AS SNTNM
        ,	'(車両計 / 運送業者　計)' AS SHNM
        ,	'' AS SHNKKKMEI
		,	3 AS DATA_DIVIDE
        ,	@user_name AS UserName
		FROM tmp_data		
        GROUP BY
			NOHINYMD
        ,	NNSICD
		,	NNSINM
        ,	JGSCD
		,	JGSNM
		,	SYUKAP
        ,	UNSKSCD        
		;
        
        
        SELECT * FROM tmp_data_details
        UNION ALL
        SELECT * FROM tmp_data_total_NHNSKCD
        UNION ALL
        SELECT * FROM tmp_data_total_UNSKSCD
        ORDER BY
			NOHINYMD
		,	NNSICD
        ,	NNSINM
        ,	JGSCD
		,	JGSNM
		,	SYUKAP
        ,	UNSKSCD
        ,	NHNSKCD
        ,	DATA_DIVIDE
		,	DENNO	
        ,	DENGNO;
			
        
    
    ELSE
		SELECT * FROM tmp_data;
    END IF;
    
    
    DROP TABLE IF EXISTS tmp_data;
    DROP TABLE IF EXISTS tmp_data_details;
    DROP TABLE IF EXISTS tmp_data_total_NHNSKCD;
    DROP TABLE IF EXISTS tmp_data_total_UNSKSCD;
    
    
END//

delimiter ;