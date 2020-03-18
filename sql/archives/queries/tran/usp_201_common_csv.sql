DROP PROCEDURE IF EXISTS usp_201_common_csv;
delimiter //

CREATE PROCEDURE usp_201_common_csv(
	IN p_is_partner tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_sntcd text
,	IN p_management_cd varchar(10)
)
BEGIN
    
    DECLARE cur_date DATE;
    
    SET cur_date = CURRENT_DATE();
        
    SET @date_from = DATE_FORMAT(cur_date,'%Y-%m-%d');
    SET @date_to = DATE_FORMAT(DATE_ADD(cur_date,INTERVAL 1 DAY),'%Y-%m-%d');
    
    IF p_sntcd IS NOT NULL THEN
		CREATE TEMPORARY TABLE tmp_sntcd(JGSCD varchar(10),SNTCD varchar(10), PRIMARY KEY (JGSCD,SNTCD));				
		SET @sql_SNTCD = CONCAT('INSERT INTO tmp_sntcd(JGSCD,SNTCD) VALUES',p_sntcd);
        
        PREPARE stmt_SNTCD from @sql_SNTCD;
		EXECUTE stmt_SNTCD;
		DEALLOCATE PREPARE stmt_SNTCD;
	END IF;
    
    
    SET @sql_sel = 'SELECT';
	SET @sql_sel = CONCAT(@sql_sel, '   AH.SYORIYMD		AS \'処理日時\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.SYUKAYMD		AS \'出荷日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.NOHINYMD		AS \'納品日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.DENPYOYMD	AS \'伝票日付\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.NNSICD		AS \'荷主コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.NNSINM		AS \'荷主名\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.JGSCD_SK		AS \'出荷元事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.JGSNM_SK		AS \'出荷元事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.SNTCD_SK		AS \'出荷元センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.SNTNM_SK		AS \'出荷元センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.UNSKSCD		AS \'運送会社コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.UNSKSNM		AS \'運送会社名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.JGSCD_NK		AS \'入荷事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.JGSNM_NK		AS \'入荷事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.SNTCD_NK		AS \'入荷センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.SNTNM_NK		AS \'入荷センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.SKHNYKBN1	AS \'ＩＤ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.SKHNYKBN1NM	AS \'ＩＤ名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.DENNO		AS \'伝票番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.DENGNO		AS \'伝票行番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AH.BIKO		AS \'備考\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.SHCD		AS \'商品コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.DNRK		AS \'電略\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.SHNM		AS \'製品名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.SHNKKKMEI_KS	AS \'規格\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.SEKKBN		AS \'請求区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.SR1RS		AS \'ケース入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.SR2RS		AS \'中間入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.KHKBN		AS \'梱端区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.RTNO		AS \'ロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.LOTK		AS \'管理区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.LOTS		AS \'出荷区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.FCKBNKK		AS \'工場コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.PL		AS \'パレット積付数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.KKTSR1		AS \'入荷予定ケース数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (AD.KKTSR1 DIV AD.PL)		AS \'パレット枚数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (AD.KKTSR1 MOD AD.PL)		AS \'パレット端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.KKTSR2		AS \'入荷予定中間数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , AD.KKTSR3		AS \'入荷予定バラ数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , TRUNCATE(AD.WGT+0.9, 0)		AS \'入荷予定総重量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(AH.TRKMJ,\'%Y%m%d\')		AS \'ＤＢ取込時間（yyyymmdd）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(AH.TRKMJ,\'%Y\')	AS \'ＤＢ取込時間（yyyy）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(AH.TRKMJ,\'%m\')		AS \'ＤＢ取込時間（mm）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(AH.TRKMJ,\'%d\')		AS \'ＤＢ取込時間（dd）\'');
    
    SET @sql_sel = CONCAT(@sql_sel, '  FROM arrival_schedules AS AH');
	SET @sql_sel = CONCAT(@sql_sel, '  INNER JOIN arrival_schedule_details AS AD');
	SET @sql_sel = CONCAT(@sql_sel, '  ON AH.ID = AD.ID');   
    IF p_sntcd IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN tmp_sntcd AS ST');
        SET @sql_sel = CONCAT(@sql_sel,' ON AH.JGSCD_NK = ST.JGSCD');
		SET @sql_sel = CONCAT(@sql_sel,' AND AH.SNTCD_NK = ST.SNTCD');        
	END IF;
    IF p_is_partner = 1 THEN
		SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN mtb_sp_conditions AS SP');
		SET @sql_sel = CONCAT(@sql_sel,' ON AH.NNSICD = SP.NNSICD');
		SET @sql_sel = CONCAT(@sql_sel,' AND AH.JGSCD_NK = SP.JGSCD');
		SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SNTCD IS NULL OR AH.SNTCD_NK = SP.SNTCD)');
		SET @sql_sel = CONCAT(@sql_sel,' AND (SP.UNSKSCD IS NULL OR AH.UNSKSCD = SP.UNSKSCD)');		
		SET @sql_sel = CONCAT(@sql_sel,' AND SP.NKTISFRG = 1');        
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
    
    SET @sql_sel = CONCAT(@sql_sel,IFNULL(@sql_where,''));
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
END//

delimiter ;