DROP PROCEDURE IF EXISTS usp_101021_pdf;
delimiter //

CREATE PROCEDURE usp_101021_pdf(
	IN p_process_divide tinyint
,	IN p_target_divide tinyint    
,	IN p_is_partner tinyint
,	IN p_date_divide tinyint
,	IN p_target_date date
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_management_cd varchar(10)
)
BEGIN

	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TABLE IF EXISTS tmp_sntcd;
		DROP TABLE IF EXISTS tmp_data_details;
		DROP TABLE IF EXISTS tmp_data_nnsi_total;
		DROP TABLE IF EXISTS tmp_data_total;
		DROP TABLE IF EXISTS tmp_data;
        RESIGNAL;
    END;
    
    
    IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD = CONCAT('INSERT INTO tmp_sntcd(JGSCD,SNTCD) VALUES',p_sntcd);
                
        PREPARE stmt_SNTCD from @sql_SNTCD;
		EXECUTE stmt_SNTCD;
		DEALLOCATE PREPARE stmt_SNTCD;
	END IF;
    
    	
    
	SET @sql_sel = 'CREATE TEMPORARY TABLE tmp_data SELECT';
    
    IF p_target_divide = 1 THEN 
		-- 出荷倉庫別ピッキングリスト
		SET @sql_sel = CONCAT(@sql_sel, '  SD.JGSCD');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.SNTCD');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.SNTNM');
		IF p_date_divide = 1 THEN
			SET @sql_sel = CONCAT(@sql_sel, ', SH.SYUKAYMD AS DATEYMD');
		ELSE
			SET @sql_sel = CONCAT(@sql_sel, ', SH.NOHINYMD AS DATEYMD');
		END IF;
		SET @sql_sel = CONCAT(@sql_sel, ', SH.NNSICD');
        SET @sql_sel = CONCAT(@sql_sel, ', SH.NNSINM');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.SHCD');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.DNRK');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.RTNO');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.LOTK');
        IF p_process_divide = 1 THEN
			SET @sql_sel = CONCAT(@sql_sel, ', SD.JCSR1 AS KKTSR1');
			SET @sql_sel = CONCAT(@sql_sel, ', SD.JCSR3 AS KKTSR3');
		ELSE
			SET @sql_sel = CONCAT(@sql_sel, ', SD.KKTSR1 AS KKTSR1');
			SET @sql_sel = CONCAT(@sql_sel, ', SD.KKTSR3 AS KKTSR3');
		END IF;
    ELSEIF p_target_divide = 2 THEN
		-- 店別ピッキングリスト
        SET @sql_sel = CONCAT(@sql_sel, '  SH.UNSKSCD');
		SET @sql_sel = CONCAT(@sql_sel, ', SH.UNSKSNM');
        SET @sql_sel = CONCAT(@sql_sel, ', SH.NNSICD');
        SET @sql_sel = CONCAT(@sql_sel, ', SH.NNSINM');
        SET @sql_sel = CONCAT(@sql_sel, ', SH.SYUKAYMD');
        SET @sql_sel = CONCAT(@sql_sel, ', SH.NOHINYMD');
        SET @sql_sel = CONCAT(@sql_sel, ', SH.NHNSKCD');
        SET @sql_sel = CONCAT(@sql_sel, ', SH.NHNSKNM');
                
		SET @sql_sel = CONCAT(@sql_sel, ', SD.SHCD');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.DNRK');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.RTNO');
		SET @sql_sel = CONCAT(@sql_sel, ', SD.LOTK');
		IF p_process_divide = 1 THEN
			SET @sql_sel = CONCAT(@sql_sel, ', SD.JCSR1 AS KKTSR1');
			SET @sql_sel = CONCAT(@sql_sel, ', SD.JCSR3 AS KKTSR3');
		ELSE
			SET @sql_sel = CONCAT(@sql_sel, ', SD.KKTSR1 AS KKTSR1');
			SET @sql_sel = CONCAT(@sql_sel, ', SD.KKTSR3 AS KKTSR3');
		END IF;
    END IF;
        
	IF p_process_divide = 1 THEN		
        SET @sql_from = '  FROM shipment_provisionals AS SH';
        SET @sql_from = CONCAT(@sql_from, '  INNER JOIN shipment_provisional_details AS SD');
        SET @sql_from = CONCAT(@sql_from, '  ON SH.ID = SD.ID');		
	ELSE
        SET @sql_from = '  FROM shipment_confirms AS SH';
        SET @sql_from = CONCAT(@sql_from, '  INNER JOIN shipment_confirm_details AS SD');
        SET @sql_from = CONCAT(@sql_from, '  ON SH.ID = SD.ID');    
    END IF;
    
    IF p_sntcd IS NOT NULL THEN
		SET @sql_from = CONCAT(@sql_from,' INNER JOIN tmp_sntcd AS ST');
        SET @sql_from = CONCAT(@sql_from,' ON (SD.JGSCD = ST.JGSCD');
		SET @sql_from = CONCAT(@sql_from,' AND SD.SNTCD = ST.SNTCD)');        		
	END IF;
    
    SET @sql_from = CONCAT(@sql_from,' LEFT JOIN mtb_sp_conditions AS SP');
	SET @sql_from = CONCAT(@sql_from,' ON SH.NNSICD = SP.NNSICD');
    IF p_sntcd IS NOT NULL THEN
		SET @sql_from = CONCAT(@sql_from,' AND ST.JGSCD = SP.JGSCD');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.SNTCD IS NULL OR ST.SNTCD = SP.SNTCD)');
    ELSE
		SET @sql_from = CONCAT(@sql_from,' AND SD.JGSCD = SP.JGSCD');
		SET @sql_from = CONCAT(@sql_from,' AND (SP.SNTCD IS NULL OR SD.SNTCD = SP.SNTCD)');
    END IF;
	SET @sql_from = CONCAT(@sql_from,' AND (SP.UNSKSCD IS NULL OR SH.UNSKSCD = SP.UNSKSCD)');
	SET @sql_from = CONCAT(@sql_from,' AND (SP.SYUKAP IS NULL OR SH.SYUKAP = SP.SYUKAP)');
	SET @sql_from = CONCAT(@sql_from,' AND (SP.SEKKBN IS NULL OR SD.SEKKBN = SP.SEKKBN)');
	SET @sql_from = CONCAT(@sql_from,' AND (SP.NHNSKCD IS NULL OR SH.NHNSKCD = SP.NHNSKCD)');
	SET @sql_from = CONCAT(@sql_from,' AND SP.SKTISFRG = 1');	
    SET @sql_from = CONCAT(@sql_from,' LEFT JOIN mtb_partners AS PN');
    SET @sql_from = CONCAT(@sql_from,' ON SP.PTNCD = PN.PTNCD');
    
    SET @sql_where = null;
    IF p_process_divide = 1 THEN
		SET @sql_where = ' WHERE SH.DKBN = \'AM\'';	
	ELSE
		SET @sql_where = ' WHERE SH.SKHNYKBN1 != \'A2\'';	
	END IF;
        
	IF p_target_date IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		IF p_date_divide = 1 THEN
			SET @sql_where = CONCAT(@sql_where,' SH.SYUKAYMD = \'',p_target_date,'\'');
		ELSE
			SET @sql_where = CONCAT(@sql_where,' SH.NOHINYMD = \'',p_target_date,'\'');
		END IF;					
	END IF;
    	
    IF p_jgscd IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		SET @sql_where = CONCAT(@sql_where,' SD.JGSCD IN(',p_jgscd,')');				
	END IF;
        
	IF p_is_partner = 1 THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		SET @sql_where = CONCAT(@sql_where,' SP.PTNCD = \'',p_management_cd,'\'');		
	END IF;
       

	SET @sql_sel = CONCAT(@sql_sel,@sql_from,IFNULL(@sql_where,''));

	
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
			,	ufn_get_date_format(DATEYMD) AS DATEYMD
			,	NNSICD
			,	NNSINM
			,	SHCD
			,	DNRK
			,	RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	LOTK
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
			;
			
						
			CREATE TEMPORARY TABLE tmp_data_nnsi_total
			SELECT
				JGSCD
			,	SNTCD
			,	SNTNM
			,	ufn_get_date_format(DATEYMD) AS DATEYMD
			,	NNSICD
			,	NNSINM
			,	'ZZZZZZZZZZ' AS SHCD
			,	'' AS DNRK
			,	'ZZZZZZZZZZZZZZZZZZZZ' AS RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	'' AS LOTK
			,	2 AS DATA_DIVIDE
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
			,	ufn_get_date_format(DATEYMD) AS DATEYMD
			,	'ZZZZZZZZZZ' AS NNSICD
			,	'' AS NNSINM
			,	'ZZZZZZZZZZ' AS SHCD
			,	'' AS DNRK
			,	'ZZZZZZZZZZZZZZZZZZZZ' AS RTNO
			,	SUM(KKTSR1) AS KKTSR1
			,	SUM(KKTSR3) AS KKTSR3
			,	'' AS LOTK
			,	3 AS DATA_DIVIDE
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
			,	CASE WHEN DATA_DIVIDE IN(3) THEN '' ELSE CONCAT(NNSINM,' (',NNSICD,')') END AS '荷主'
			,	CASE WHEN DATA_DIVIDE IN(2,3) THEN '' ELSE SHCD END AS '商品コード'
			,	CASE WHEN DATA_DIVIDE IN(2,3) THEN '' ELSE DNRK END AS '電略'
			,	CASE WHEN DATA_DIVIDE IN(3) THEN '合計' WHEN DATA_DIVIDE IN(2) THEN '荷主合計' ELSE RTNO END AS 'ロット'
			,	KKTSR1 AS 'ケース'
			,	KKTSR3 AS 'バラ'
			,	CASE WHEN DATA_DIVIDE IN(2,3) THEN '' ELSE LOTK END AS '管理区分'
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
				UNION ALL
				SELECT
					*
				FROM tmp_data_total
				ORDER BY JGSCD,SNTCD,DATEYMD,NNSICD,SHCD,RTNO,DATA_DIVIDE
			) AS ret
			ORDER BY JGSCD,SNTCD,DATEYMD,NNSICD,SHCD,RTNO,DATA_DIVIDE;
            
            DROP TABLE IF EXISTS tmp_data_nnsi_total;
    
		ELSEIF p_target_divide = 2 THEN
				
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
			,	ufn_get_date_format(SYUKAYMD) AS '出荷日'
            ,	ufn_get_date_format(NOHINYMD) AS '納品日'
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
				ORDER BY UNSKSCD,SYUKAYMD,NOHINYMD,NNSICD,NHNSKCD,NHNSKNM,DATA_DIVIDE,SHCD,RTNO
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
        
    
END//

delimiter ;