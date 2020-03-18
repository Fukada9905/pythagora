DROP PROCEDURE IF EXISTS pyt_p_103020_pdf;
delimiter //

CREATE PROCEDURE pyt_p_103020_pdf(
	IN p_process_divide tinyint
,	IN p_ids text
,	IN p_user_id varchar(10)
)
BEGIN
    
    -- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		
		DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_denno_totals;
        DROP TABLE IF EXISTS tmp_data_krmbn_totals;
		DROP TABLE IF EXISTS tmp_data_nhnskcd_totals;
        DROP TABLE IF EXISTS tmp_data_unsks_totals;
		DROP TABLE IF EXISTS tmp_data;
        RESIGNAL;
    END;
    
    SET @sql_sel = 'CREATE TEMPORARY TABLE tmp_data SELECT';
    SET @sql_sel = CONCAT(@sql_sel, '   WD.JGSCD');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSNM');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.SYUKAYMD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NOHINYMD');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.UNSKSCD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.UNSKSNM');
    SET @sql_sel = CONCAT(@sql_sel, ' , IFNULL(WD.KRMBN,\'\') AS KRMBN');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.NHNSKCD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NHNSKNM');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.JYUSYO');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.BIKO');
    SET @sql_sel = CONCAT(@sql_sel, ' , \'\' AS hikiate');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.DENNO');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.NNSICD');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHCD');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DNRK');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.RTNO');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSR1');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL_DIV');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL_MOD');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSR3');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTCD');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTNM');
	SET @sql_sel = CONCAT(@sql_sel, ' , TRUNCATE(WD.WGT,1) AS WGT');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHNM');
    SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHNKKKMEI');
    
    
    SET @sql_sel = CONCAT(@sql_sel,' FROM pyt_w_103020_details AS WD');
    SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN pyt_w_103020_head AS WK');
    SET @sql_sel = CONCAT(@sql_sel,' ON WD.work_id = WK.work_id');    
    IF p_ids IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' WHERE WK.work_id IN(',p_ids,')');
	ELSE
		SET @sql_sel = CONCAT(@sql_sel,' WHERE WK.user_id = \'',p_user_id,'\'');		
	END IF;
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
    
    IF p_process_divide = 1 THEN
		CREATE TEMPORARY TABLE tmp_data_details
		SELECT
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	UNSKSCD
		,	UNSKSNM
        ,	UNSKSNM AS UNSKSNM2
		,	KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	JYUSYO
		,	BIKO
		,	hikiate
		,	DENNO
		,	NNSICD
		,	SHCD
		,	DNRK
		,	RTNO
		,	KKTSR1
		,	PL
		,	PL_DIV
		,	PL_MOD
		,	KKTSR3
		,	CONCAT(SNTCD,' ',SNTNM) AS SNTNM
		,	WGT AS WGT
		,	SHNM
		,	SHNKKKMEI
		,	1 AS DATA_DIVIDE
        ,	'' AS SUM_TITLE
		FROM tmp_data;
		
		CREATE TEMPORARY TABLE tmp_data_krmbn_totals
		SELECT
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	UNSKSCD
		,	UNSKSNM
        ,	'' AS UNSKSNM2
		,	KRMBN AS KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	'' AS JYUSYO
		,	'' AS BIKO
		,	'' AS hikiate
		,	'ZZZZZZZZZZ' AS DENNO
		,	'' AS NNSICD
		,	'' AS SHCD
		,	'' AS DNRK
		,	'' AS RTNO
		,	SUM(KKTSR1) AS KKTSR1
		,	SUM(PL) AS PL
		,	SUM(PL_DIV) AS PL_DIV
		,	SUM(PL_MOD) AS PL_MOD
		,	SUM(KKTSR3) AS KKTSR3
		,	'' AS SNTNM
		,	SUM(WGT) AS WGT
		,	'' AS SHNM
		,	'' AS SHNKKKMEI
		,	2 AS DATA_DIVIDE
        ,	'車番計' AS SUM_TITLE
		FROM tmp_data
		GROUP BY
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	UNSKSCD
		,	UNSKSNM
		,	NHNSKCD
		,	NHNSKNM
		,	KRMBN
		;
		
		CREATE TEMPORARY TABLE tmp_data_nhnskcd_totals
		SELECT
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	UNSKSCD
		,	UNSKSNM
        ,	'' AS UNSKSNM2
		,	'ZZZZZZZZ' AS KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	'' AS JYUSYO
		,	'' AS BIKO
		,	'' AS hikiate
		,	'ZZZZZZZZZZ' AS DENNO
		,	'' AS NNSICD
		,	'' AS SHCD
		,	'' AS DNRK
		,	'' AS RTNO
		,	SUM(KKTSR1) AS KKTSR1
		,	SUM(PL) AS PL
		,	SUM(PL_DIV) AS PL_DIV
		,	SUM(PL_MOD) AS PL_MOD
		,	SUM(KKTSR3) AS KKTSR3
		,	'' AS SNTNM
		,	SUM(WGT) AS WGT
		,	'' AS SHNM
		,	'' AS SHNKKKMEI
		,	3 AS DATA_DIVIDE
        ,	'納品先計' AS SUM_TITLE
		FROM tmp_data
		GROUP BY
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	UNSKSCD
		,	UNSKSNM
		,	NHNSKCD
        ,	NHNSKNM
		;
        
        
        CREATE TEMPORARY TABLE tmp_data_unsks_totals
		SELECT
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	UNSKSCD
		,	UNSKSNM
        ,	'' AS UNSKSNM2
		,	'ZZZZZZZZ' AS KRMBN
		,	'ZZZZZZZZ' AS NHNSKCD
		,	'' AS NHNSKNM
		,	'' AS JYUSYO
		,	'' AS BIKO
		,	'' AS hikiate
		,	'ZZZZZZZZZZ' AS DENNO
		,	'' AS NNSICD
		,	'' AS SHCD
		,	'' AS DNRK
		,	'' AS RTNO
		,	SUM(KKTSR1) AS KKTSR1
		,	SUM(PL) AS PL
		,	SUM(PL_DIV) AS PL_DIV
		,	SUM(PL_MOD) AS PL_MOD
		,	SUM(KKTSR3) AS KKTSR3
		,	'' AS SNTNM
		,	SUM(WGT) AS WGT
		,	'' AS SHNM
		,	'' AS SHNKKKMEI
		,	4 AS DATA_DIVIDE
        ,	'運送会社計' AS SUM_TITLE
		FROM tmp_data
		GROUP BY
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	UNSKSCD
		,	UNSKSNM
		;
		
		
		SELECT
			JGSCD
		,	JGSNM AS '事業所名称'
		,	SYUKAYMD AS '出荷日'
		,	NOHINYMD AS '納品日'
		,	UNSKSCD AS '運送会社CD'
		,	UNSKSNM AS '運送会社名'
        ,	UNSKSNM2 AS '業者名'
		,	KRMBN AS '車番'
		,	NHNSKCD AS '納品先CD'
		,	NHNSKNM AS '納品先名'
		,	JYUSYO AS '納品先住所'
		,	BIKO AS '備考'
		,	hikiate AS '引当状況'
		,	DENNO AS '伝票番号'
		,	NNSICD AS '荷主'
		,	SHCD AS '商品CD'
		,	DNRK AS '電略'
		,	RTNO AS 'ロット'
		,	KKTSR1 AS 'ケース'
		,	PL AS 'PL積数'
		,	PL_DIV AS 'PL枚数'
		,	PL_MOD AS '端数'
		,	KKTSR3 AS 'バラ'
		,	SNTNM AS '出荷倉庫'
		,	WGT AS '重量'
		,	SHNM AS '商品名称'
		,	SHNKKKMEI AS '規格'
		,	DATA_DIVIDE
		,	CONCAT_WS('_',JGSCD, SYUKAYMD, NOHINYMD, UNSKSCD) AS HEADER_KEY
        ,	SUM_TITLE AS '合計タイトル'
		FROM(
			SELECT * FROM tmp_data_details
			UNION ALL
			SELECT * FROM tmp_data_krmbn_totals
			UNION ALL
			SELECT * FROM tmp_data_nhnskcd_totals
            UNION ALL
			SELECT * FROM tmp_data_unsks_totals
		) AS RC
		ORDER BY JGSCD, SYUKAYMD, NOHINYMD, UNSKSCD, NHNSKCD, KRMBN, DENNO, DATA_DIVIDE, SHCD;
    ELSE
		CREATE TEMPORARY TABLE tmp_data_details
		SELECT
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	SNTCD
        ,	SNTNM
        ,	UNSKSNM AS UNSKSNM2
		,	KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	JYUSYO
		,	BIKO
		,	hikiate
		,	DENNO
		,	NNSICD
		,	SHCD
		,	DNRK
		,	RTNO
		,	KKTSR1
		,	PL
		,	PL_DIV
		,	PL_MOD
		,	KKTSR3        
        ,	CONCAT(UNSKSCD,' ',UNSKSNM) AS UNSKSNM
        ,	WGT AS WGT
		,	SHNM
		,	SHNKKKMEI
		,	1 AS DATA_DIVIDE
        ,	'' AS SUM_TITLE
		FROM tmp_data;
		
		CREATE TEMPORARY TABLE tmp_data_denno_totals
		SELECT
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	SNTCD
        ,	SNTNM
        ,	'' AS UNSKSNM2
		,	'' AS KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	'' AS JYUSYO
		,	'' AS BIKO
		,	'' AS hikiate
		,	DENNO
		,	'' AS NNSICD
		,	'' AS SHCD
		,	'' AS DNRK
		,	'' AS RTNO
		,	SUM(KKTSR1) AS KKTSR1
		,	SUM(PL) AS PL
		,	SUM(PL_DIV) AS PL_DIV
		,	SUM(PL_MOD) AS PL_MOD
		,	SUM(KKTSR3) AS KKTSR3
		,	'' AS UNSKSNM
		,	SUM(WGT) AS WGT
		,	'' AS SHNM
		,	'' AS SHNKKKMEI
		,	2 AS DATA_DIVIDE
        ,	'伝票番号計' AS SUM_TITLE
		FROM tmp_data
		GROUP BY
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	SNTCD
        ,	SNTNM
		,	NHNSKCD
		,	NHNSKNM
		,	DENNO
		;
        
        
        CREATE TEMPORARY TABLE tmp_data_nhnskcd_totals
		SELECT
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	SNTCD
        ,	SNTNM
        ,	'' AS UNSKSNM2
		,	'' AS KRMBN
		,	NHNSKCD
		,	NHNSKNM
		,	'' AS JYUSYO
		,	'' AS BIKO
		,	'' AS hikiate
		,	'ZZZZZZZZZZ' AS DENNO
		,	'' AS NNSICD
		,	'' AS SHCD
		,	'' AS DNRK
		,	'' AS RTNO
		,	SUM(KKTSR1) AS KKTSR1
		,	SUM(PL) AS PL
		,	SUM(PL_DIV) AS PL_DIV
		,	SUM(PL_MOD) AS PL_MOD
		,	SUM(KKTSR3) AS KKTSR3
		,	'' AS UNSKSNM
		,	SUM(WGT) AS WGT
		,	'' AS SHNM
		,	'' AS SHNKKKMEI
		,	3 AS DATA_DIVIDE
        ,	'納品先計' AS SUM_TITLE
		FROM tmp_data
		GROUP BY
			JGSCD
		,	JGSNM
		,	SYUKAYMD
		,	NOHINYMD
		,	SNTCD
        ,	SNTNM
		,	NHNSKCD
        ,	NHNSKNM
		;
        
        
        SELECT
			JGSCD
		,	JGSNM AS '事業所名称'
		,	SYUKAYMD AS '出荷日'
		,	NOHINYMD AS '納品日'
		,	SNTCD AS '出荷倉庫CD'
		,	SNTNM AS '出荷倉庫名'
        ,	UNSKSNM2 AS '業者名'
		,	KRMBN AS '車番'
		,	NHNSKCD AS '納品先CD'
		,	NHNSKNM AS '納品先名'
		,	JYUSYO AS '納品先住所'
		,	BIKO AS '備考'
		,	hikiate AS '引当状況'
		,	DENNO AS '伝票番号'
		,	NNSICD AS '荷主'
		,	SHCD AS '商品CD'
		,	DNRK AS '電略'
		,	RTNO AS 'ロット'
		,	KKTSR1 AS 'ケース'
		,	PL AS 'PL積数'
		,	PL_DIV AS 'PL枚数'
		,	PL_MOD AS '端数'
		,	KKTSR3 AS 'バラ'
		,	UNSKSNM AS '運送会社'
		,	WGT AS '重量'
		,	SHNM AS '商品名称'
		,	SHNKKKMEI AS '規格'
		,	DATA_DIVIDE
		,	CONCAT_WS('_',JGSCD, SYUKAYMD, NOHINYMD, SNTCD) AS HEADER_KEY
        ,	SUM_TITLE AS '合計タイトル'
		FROM(
			SELECT * FROM tmp_data_details
			UNION ALL
			SELECT * FROM tmp_data_denno_totals
			UNION ALL
			SELECT * FROM tmp_data_nhnskcd_totals
		) AS RC
		ORDER BY JGSCD, SYUKAYMD, NOHINYMD, SNTCD, NHNSKCD, DENNO, DATA_DIVIDE, SHCD;
        
			
    
    END IF;
    DROP TABLE IF EXISTS tmp_data_details;
	DROP TABLE IF EXISTS tmp_data_denno_totals;
    DROP TABLE IF EXISTS tmp_data_krmbn_totals;
	DROP TABLE IF EXISTS tmp_data_nhnskcd_totals;
    DROP TABLE IF EXISTS tmp_data_unsks_totals;
	DROP TABLE IF EXISTS tmp_data;
    
END//

delimiter ;