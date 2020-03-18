DROP PROCEDURE IF EXISTS pyt_p_101050_pdf;
DELIMITER //
CREATE PROCEDURE pyt_p_101050_pdf(
	IN p_process_divide tinyint
,	IN p_target_divide tinyint    
,	IN p_ids text
,	IN p_user_id varchar(10)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_rtno_total;
		DROP TABLE IF EXISTS tmp_data_nnsi_total;
		DROP TABLE IF EXISTS tmp_data_total;
		DROP TABLE IF EXISTS tmp_data;
        RESIGNAL;
    END;
    
    
	SET @sql_sel = 'CREATE TEMPORARY TABLE tmp_data SELECT';
    
    IF p_target_divide = 1 THEN 
		-- フロア別ピッキングリスト
        SET @sql_sel = CONCAT(@sql_sel, ' JGSCD');
        SET @sql_sel = CONCAT(@sql_sel, ', SNTCD');
		SET @sql_sel = CONCAT(@sql_sel, ', SNTNM');
        SET @sql_sel = CONCAT(@sql_sel, ', DATEYMD');
		SET @sql_sel = CONCAT(@sql_sel, ', NNSICD');
		SET @sql_sel = CONCAT(@sql_sel, ', NNSINM');
        SET @sql_sel = CONCAT(@sql_sel, ', SHCD');
		SET @sql_sel = CONCAT(@sql_sel, ', DNRK');
        SET @sql_sel = CONCAT(@sql_sel, ', RTNO');
        SET @sql_sel = CONCAT(@sql_sel, ', LOTK');
        SET @sql_sel = CONCAT(@sql_sel, ', UNSKSCD');
		SET @sql_sel = CONCAT(@sql_sel, ', UNSKSNM');
        
        SET @sql_sel = CONCAT(@sql_sel,', KKTSR1');
		SET @sql_sel = CONCAT(@sql_sel,', KKTSR3');
        
    		        
    ELSEIF p_target_divide = 2 THEN
		-- 業者別ピッキングリスト
        
        SET @sql_sel = CONCAT(@sql_sel, ' UNSKSCD');
        SET @sql_sel = CONCAT(@sql_sel, ', DATEYMD');
		SET @sql_sel = CONCAT(@sql_sel, ', UNSKSNM');
        SET @sql_sel = CONCAT(@sql_sel, ', NNSICD');
		SET @sql_sel = CONCAT(@sql_sel, ', NNSINM');
        SET @sql_sel = CONCAT(@sql_sel, ', SHCD');
		SET @sql_sel = CONCAT(@sql_sel, ', DNRK');
        SET @sql_sel = CONCAT(@sql_sel, ', RTNO');
        SET @sql_sel = CONCAT(@sql_sel, ', LOTK');
        SET @sql_sel = CONCAT(@sql_sel, ', JGSCD');
        SET @sql_sel = CONCAT(@sql_sel, ', SNTCD');
		SET @sql_sel = CONCAT(@sql_sel, ', SNTNM');
        
        SET @sql_sel = CONCAT(@sql_sel,', KKTSR1');
		SET @sql_sel = CONCAT(@sql_sel,', KKTSR3');
        
    ELSEIF p_target_divide = 3 THEN
		-- 店別ピッキングリスト
        
        SET @sql_sel = CONCAT(@sql_sel, ' UNSKSCD');
		SET @sql_sel = CONCAT(@sql_sel, ', UNSKSNM');
        SET @sql_sel = CONCAT(@sql_sel, ', NNSICD');
		SET @sql_sel = CONCAT(@sql_sel, ', NNSINM');
        SET @sql_sel = CONCAT(@sql_sel, ', SYUKAYMD');
        SET @sql_sel = CONCAT(@sql_sel, ', NOHINYMD');
        SET @sql_sel = CONCAT(@sql_sel, ', NHNSKCD');
		SET @sql_sel = CONCAT(@sql_sel, ', NHNSKNM');
		SET @sql_sel = CONCAT(@sql_sel, ', SHCD');
		SET @sql_sel = CONCAT(@sql_sel, ', DNRK');
        SET @sql_sel = CONCAT(@sql_sel, ', RTNO');
        SET @sql_sel = CONCAT(@sql_sel, ', LOTK');
        
        SET @sql_sel = CONCAT(@sql_sel,', KKTSR1');
		SET @sql_sel = CONCAT(@sql_sel,', KKTSR3');

    END IF;
       
	SET @sql_sel = CONCAT(@sql_sel,' FROM pyt_w_101050_details');
    IF p_ids IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' WHERE user_id = \'',p_user_id,'\'');
		SET @sql_sel = CONCAT(@sql_sel,' AND process_divide = ',p_process_divide);
		SET @sql_sel = CONCAT(@sql_sel,' AND work_id IN(',p_ids,')');
	ELSE
		SET @sql_sel = CONCAT(@sql_sel,' WHERE user_id = \'',p_user_id,'\'');
		SET @sql_sel = CONCAT(@sql_sel,' AND process_divide = ',p_process_divide);
	END IF;
    	
	PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;
    
    
    IF EXISTS(SELECT * FROM tmp_data LIMIT 1) THEN
    
		IF p_target_divide = 1 THEN 
        
			
			CREATE TEMPORARY TABLE tmp_data_details
			SELECT
				JGSCD
			,	SNTCD
			,	SNTNM
			,	pyt_ufn_get_date_format(DATEYMD) AS DATEYMD
			,	NNSICD
			,	NNSINM
			,	SHCD
			,	DNRK
			,	RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	LOTK
			,	UNSKSCD
			,	UNSKSNM
			,	1 AS DATA_DIVIDE
			FROM tmp_data
			GROUP BY
				JGSCD
			,	SNTCD
			,	SNTNM
			,	DATEYMD
			,	NNSICD
			,	NNSINM
			,	SHCD
			,	DNRK
			,	RTNO
			,	LOTK
			,	UNSKSCD
			,	UNSKSNM
			;
			
			CREATE TEMPORARY TABLE tmp_data_nnsi_total
			SELECT
				JGSCD
			,	SNTCD
			,	SNTNM
			,	pyt_ufn_get_date_format(DATEYMD) AS DATEYMD
			,	NNSICD
			,	NNSINM
			,	'ZZZZZZZZZZ' AS SHCD
			,	'' AS DNRK
			,	'ZZZZZZZZZZZZZZZZZZZZ' AS RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	'' AS LOTK
			,	'ZZZZZZZZZZ' UNSKSCD
			,	'' AS UNSKSNM
			,	3 AS DATA_DIVIDE
			FROM tmp_data
			GROUP BY
				JGSCD
			,	SNTCD
			,	SNTNM
			,	DATEYMD
			,	NNSICD
			,	NNSINM                
			;
			
			
			CREATE TEMPORARY TABLE tmp_data_total
			SELECT
				JGSCD
			,	SNTCD
			,	SNTNM
			,	pyt_ufn_get_date_format(DATEYMD) AS DATEYMD
			,	'ZZZZZZZZZZ' AS NNSICD
			,	'' AS NNSINM
			,	'ZZZZZZZZZZ' AS SHCD
			,	'' AS DNRK
			,	'ZZZZZZZZZZZZZZZZZZZZ' AS RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	'' AS LOTK
			,	'ZZZZZZZZZZ' UNSKSCD
			,	'' AS UNSKSNM
			,	4 AS DATA_DIVIDE
			FROM tmp_data
			GROUP BY
				JGSCD
			,	SNTCD
			,	SNTNM
			,	DATEYMD
			;
		
			SELECT
				SNTCD AS 'センターコード'
			,	SNTNM AS 'センター名'
			,	DATEYMD AS '日付'
			,	CASE WHEN DATA_DIVIDE IN(3,4) THEN '' ELSE CONCAT(NNSINM,' (',NNSICD,')') END AS '荷主'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE SHCD END AS '商品コード'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE DNRK END AS '電略'
			,	CASE WHEN DATA_DIVIDE IN(4) THEN '合計' WHEN DATA_DIVIDE IN(3) THEN '荷主合計' WHEN DATA_DIVIDE IN(2) THEN 'ロット別商品合計' ELSE RTNO END AS 'ロット'
			,	KKTSR1 AS 'ケース'
			,	KKTSR3 AS 'バラ'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE LOTK END AS '管理区分'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE UNSKSNM END AS '運送業者名'
            ,	NNSICD AS '荷主コード'
            ,	NNSINM AS '荷主名'
			,	DATA_DIVIDE
			FROM
			(
				SELECT
					*
				FROM tmp_data_details
				UNION ALL
				SELECT
					*
				FROM tmp_data_nnsi_total
                ORDER BY JGSCD,SNTCD,DATEYMD,NNSICD,SHCD,RTNO,DATA_DIVIDE,UNSKSCD
			) AS ret
			ORDER BY JGSCD,SNTCD,DATEYMD,NNSICD,SHCD,RTNO,DATA_DIVIDE,UNSKSCD;
            
            DROP TABLE IF EXISTS tmp_data_rtno_total;
			DROP TABLE IF EXISTS tmp_data_nnsi_total;
    
		ELSEIF p_target_divide = 2 THEN
        
			 
			CREATE TEMPORARY TABLE tmp_data_details
			SELECT
				UNSKSCD
			,	UNSKSNM
            ,	pyt_ufn_get_date_format(DATEYMD) AS DATEYMD
			,	NNSICD
			,	NNSINM
			,	SHCD
			,	DNRK
			,	RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	LOTK
			,	JGSCD
			,	SNTCD
			,	SNTNM
			,	1 AS DATA_DIVIDE
			FROM tmp_data
			GROUP BY
				UNSKSCD
			,	UNSKSNM
            ,	DATEYMD
			,	NNSICD
			,	NNSINM
			,	SHCD
			,	DNRK
			,	RTNO
			,	LOTK
			,	JGSCD
			,	SNTCD
			,	SNTNM
			;
			
            CREATE TEMPORARY TABLE tmp_data_nnsi_total
			SELECT
				UNSKSCD
			,	UNSKSNM
			,	pyt_ufn_get_date_format(DATEYMD) AS DATEYMD
			,	NNSICD
			,	NNSINM
			,	'ZZZZZZZZZZ' AS SHCD
			,	'' AS DNRK
			,	'ZZZZZZZZZZZZZZZZZZZZ' AS RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	'' AS LOTK
			,	'ZZZZZZZZZZ' AS JGSCD
            ,	'ZZZZZZZZZZ' AS SNTCD
            ,	'' AS SNTNM
			,	3 AS DATA_DIVIDE
			FROM tmp_data
			GROUP BY
				UNSKSCD
			,	UNSKSNM
			,	DATEYMD
			,	NNSICD
			,	NNSINM                
			;
			
			CREATE TEMPORARY TABLE tmp_data_total
			SELECT
				UNSKSCD
			,	UNSKSNM
			,	pyt_ufn_get_date_format(DATEYMD) AS DATEYMD
			,	'ZZZZZZZZZZ' AS NNSICD
			,	'' AS NNSINM
			,	'ZZZZZZZZZZ' AS SHCD
			,	'' AS DNRK
			,	'ZZZZZZZZZZZZZZZZZZZZ' AS RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	'' AS LOTK
			,	'ZZZZZZZZZZ' AS JGSCD
            ,	'ZZZZZZZZZZ' AS SNTCD
            ,	'' AS SNTNM
			,	4 AS DATA_DIVIDE
			FROM tmp_data
			GROUP BY
				UNSKSCD
			,	UNSKSNM
			,	DATEYMD
			;
		
        
			SELECT
				UNSKSCD AS '運送業者コード'
			,	UNSKSNM AS '運送業者名'
			,	DATEYMD AS '日付'
			,	CASE WHEN DATA_DIVIDE IN(3,4) THEN '' ELSE CONCAT(NNSINM,' (',NNSICD,')') END AS '荷主'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE SHCD END AS '商品コード'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE DNRK END AS '電略'
			,	CASE WHEN DATA_DIVIDE IN(4) THEN '合計' WHEN DATA_DIVIDE IN(3) THEN '荷主合計' WHEN DATA_DIVIDE IN(2) THEN 'ロット別商品合計' ELSE RTNO END AS 'ロット'
			,	KKTSR1 AS 'ケース'
			,	KKTSR3 AS 'バラ'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE LOTK END AS '管理区分'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE SNTNM END AS 'センター名'
            ,	NNSICD AS '荷主コード'
            ,	NNSINM AS '荷主名'
			,	DATA_DIVIDE
			FROM
			(
				SELECT
					*
				FROM tmp_data_details
				/*
                UNION ALL
				SELECT
					*
				FROM tmp_data_rtno_total
				*/
                UNION ALL
				SELECT
					*
				FROM tmp_data_nnsi_total
                /*
				UNION ALL
				SELECT
					*
				FROM tmp_data_total
                */
				ORDER BY UNSKSCD,DATEYMD,NNSICD,SHCD,RTNO,DATA_DIVIDE,JGSCD,SNTCD
			) AS ret
			ORDER BY UNSKSCD,DATEYMD,NNSICD,SHCD,RTNO,DATA_DIVIDE,JGSCD,SNTCD;
            
            DROP TABLE IF EXISTS tmp_data_rtno_total;
			DROP TABLE IF EXISTS tmp_data_nnsi_total;
            
        
        ELSEIF p_target_divide = 3 THEN
			CREATE TEMPORARY TABLE tmp_data_details
			SELECT
				UNSKSCD
			,	UNSKSNM
            ,	SYUKAYMD
            ,	NOHINYMD
			,	NNSICD
			,	NNSINM
            ,	NHNSKCD
			,	NHNSKNM
			,	SHCD
			,	DNRK
			,	RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	LOTK
			,	1 AS DATA_DIVIDE
			FROM tmp_data
			GROUP BY
				UNSKSCD
			,	UNSKSNM
            ,	SYUKAYMD
            ,	NOHINYMD
			,	NNSICD
			,	NNSINM
            ,	NHNSKCD
			,	NHNSKNM
			,	SHCD
			,	DNRK
			,	RTNO
			,	LOTK			
			;
            
            
            CREATE TEMPORARY TABLE tmp_data_total
			SELECT
				UNSKSCD
			,	UNSKSNM
            ,	SYUKAYMD
            ,	NOHINYMD
			,	NNSICD
			,	NNSINM
            ,	NHNSKCD
			,	NHNSKNM
			,	'ZZZZZZZZZZ' AS SHCD
			,	'' AS DNRK
			,	'' AS RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	'' AS LOTK
			,	2 AS DATA_DIVIDE
			FROM tmp_data
			GROUP BY
				UNSKSCD
			,	UNSKSNM
            ,	SYUKAYMD
            ,	NOHINYMD
			,	NNSICD
			,	NNSINM
            ,	NHNSKCD
			,	NHNSKNM
			;
            
            
            SELECT
				UNSKSCD AS '運送業者コード'
			,	UNSKSNM AS '運送業者名'
			,	pyt_ufn_get_date_format(SYUKAYMD) AS '出荷日'
            ,	pyt_ufn_get_date_format(NOHINYMD) AS '納品日'
            ,	NNSICD AS '荷主コード'
			,	NNSINM AS '荷主名'
            ,	NHNSKCD AS '納品先コード'
            ,	NHNSKNM AS '納品先名'
			,	CASE WHEN DATA_DIVIDE IN(2) THEN '' ELSE SHCD END AS '商品コード'
			,	CASE WHEN DATA_DIVIDE IN(2) THEN '' ELSE DNRK END AS '電略'
			,	CASE WHEN DATA_DIVIDE IN(2) THEN '合計' ELSE RTNO END AS 'ロット'
			,	KKTSR1 AS 'ケース'
			,	KKTSR3 AS 'バラ'
			,	CASE WHEN DATA_DIVIDE IN(2,3,4) THEN '' ELSE LOTK END AS '管理区分'
			
			,	DATA_DIVIDE
			FROM
			(
				SELECT
					*
				FROM tmp_data_details
				UNION ALL
				SELECT
					*
				FROM tmp_data_total
				ORDER BY UNSKSCD,SYUKAYMD,NOHINYMD,NNSICD,NHNSKCD,DATA_DIVIDE,SHCD,RTNO
			) AS ret
			ORDER BY UNSKSCD,SYUKAYMD,NOHINYMD,NNSICD,NHNSKCD,NHNSKNM,DATA_DIVIDE,SHCD,RTNO;
            
        END IF;
        
	ELSE
		SELECT * FROM tmp_data;
    END IF;
    
    
    DROP TABLE IF EXISTS tmp_sntcd;
    DROP TABLE IF EXISTS tmp_data_details;
    
    DROP TABLE IF EXISTS tmp_data_total;
	DROP TABLE IF EXISTS tmp_data;
	DROP TABLE IF EXISTS tmp_order_data_type;
    
END//
DELIMITER ;
