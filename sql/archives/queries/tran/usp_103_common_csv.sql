DROP PROCEDURE IF EXISTS usp_103_common_csv;
delimiter //

CREATE PROCEDURE usp_103_common_csv(
	IN p_is_partner tinyint
,	IN p_target_date date
,	IN p_jgscd text
,	IN p_management_cd varchar(10)
)
BEGIN
    
    
    SET @sql_sel = 'SELECT';
    SET @sql_sel = CONCAT(@sql_sel, '  NULL AS \'データ区分名称\'');		
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.NNSICD AS \'荷主コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.NNSINM AS \'荷主名\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.JGSCD AS \'事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.JGSNM AS \'事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.JCDENNO AS \'受注伝票番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.DENNO AS \'伝票番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.DENGNO AS \'伝票行番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.SYUKAP AS \'出荷場所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.LOTK AS \'管理区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.LOTS AS \'出荷区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.FCKBNKK AS \'工場コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.SNTCD AS \'センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.SNTNM AS \'センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , CASE WHEN PN.PTNCD IS NULL THEN \'なし\' ELSE CONCAT(IFNULL(PN.PTNCDNM1,\'\'),IFNULL(PN.PTNCDNM2,\'\')) END AS \'PT名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.UNSKSCD AS \'運送会社コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.UNSKSNM AS \'運送会社名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.SKHNYKBN1 AS \'ＩＤ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.SKHNYKBN1NM AS \'ＩＤ名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.SYORIYMD AS \'処理日時\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.SYUKAYMD AS \'出荷日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.NOHINYMD AS \'納品日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.DENPYOYMD AS \'伝票日付\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.NHNSKCD AS \'納品先コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.NHNSKNM AS \'納品先名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.JYUSYO AS \'納品先住所\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.TEL AS \'納品先電話番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.JISCD AS \'地区コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.SHCD AS \'商品コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.DNRK AS \'電略\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.SHNM AS \'製品名称\'');
    SET @sql_sel = CONCAT(@sql_sel, ' , SD.SHNKKKMEI_KS AS \'規格\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.SEKKBN AS \'請求区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.RTNO AS \'ロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.SR1RS AS \'ケース入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.SR2RS AS \'中間入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.KHKBN AS \'梱端区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.PL AS \'パレット積付数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.KKTSR1 AS \'ケース数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (SD.KKTSR1 DIV SD.PL) AS \'パレット枚数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , (SD.KKTSR1 MOD SD.PL) AS \'パレット端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.KKTSR2 AS \'中間数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.KKTSR3 AS \'バラ数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SD.KKTSSR AS \'総バラ数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , TRUNCATE(SD.WGT+0.9, 0) AS \'総重量\'');
    SET @sql_sel = CONCAT(@sql_sel, ' , SH.KOJYOFLG AS \'工場直送フラグ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , SH.BIKO AS \'備考\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SD.TRKMJ,\'%Y%m%d\') AS \'ＤＢ取込時間（yyyymmdd）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SD.TRKMJ,\'%Y\') AS \'ＤＢ取込時間（yyyy）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SD.TRKMJ,\'%m\') AS \'ＤＢ取込時間（mm）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , DATE_FORMAT(SD.TRKMJ,\'%d\') AS \'ＤＢ取込時間（dd）\'');
    SET @sql_sel = CONCAT(@sql_sel, '  FROM shipment_confirms AS SH');
    SET @sql_sel = CONCAT(@sql_sel, '  INNER JOIN shipment_confirm_details AS SD');
    SET @sql_sel = CONCAT(@sql_sel, '  ON SH.ID = SD.ID');
    SET @sql_sel = CONCAT(@sql_sel,' LEFT JOIN mtb_sp_conditions AS SP');
	SET @sql_sel = CONCAT(@sql_sel,' ON SH.NNSICD = SP.NNSICD');
	SET @sql_sel = CONCAT(@sql_sel,' AND SD.JGSCD = SP.JGSCD');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SNTCD IS NULL OR SD.SNTCD = SP.SNTCD)');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.UNSKSCD IS NULL OR SH.UNSKSCD = SP.UNSKSCD)');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SYUKAP IS NULL OR SH.SYUKAP = SP.SYUKAP)');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SEKKBN IS NULL OR SD.SEKKBN = SP.SEKKBN)');
	SET @sql_sel = CONCAT(@sql_sel,' AND (SP.NHNSKCD IS NULL OR SH.NHNSKCD = SP.NHNSKCD)');
	SET @sql_sel = CONCAT(@sql_sel,' AND SP.SKTISFRG = 1');		
    SET @sql_sel = CONCAT(@sql_sel,' LEFT JOIN mtb_partners AS PN');
	SET @sql_sel = CONCAT(@sql_sel,' ON SP.PTNCD = PN.PTNCD');
    
    SET @sql_where = ' WHERE SH.SKHNYKBN1 = \'A2\'';	
    
    IF p_target_date IS NOT NULL THEN
		IF @sql_where IS NULL THEN
			SET @sql_where = ' WHERE';
        ELSE
			SET @sql_where = CONCAT(@sql_where,' AND');
        END IF;
		SET @sql_where = CONCAT(@sql_where,' SH.DENPYOYMD = \'',p_target_date,'\'');		
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
		SET @sql_where = CONCAT(@sql_where,' PN.PTNCD = \'',p_management_cd,'\'');		
	END IF;
            
	SET @sql_sel = CONCAT(@sql_sel,@sql_where,' ORDER BY SH.DENPYOYMD, SD.JGSCD, SD.SNTCD, SH.DENNO, SD.DENGNO');
    
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
END//

delimiter ;