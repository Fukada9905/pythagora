DROP PROCEDURE IF EXISTS usp_202000_csv;
delimiter //

CREATE PROCEDURE usp_202000_csv(
	IN p_ids text
,	IN p_user_id varchar(10)
)
BEGIN
    
    SET @sql_sel = 'SELECT';
	SET @sql_sel = CONCAT(@sql_sel, '   WD.SYORIYMD		AS \'処理日時\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SYUKAYMD		AS \'出荷日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NOHINYMD		AS \'納品日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DENPYOYMD	AS \'伝票日付\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NNSICD		AS \'荷主コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NNSINM		AS \'荷主名\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSCD_SK		AS \'出荷元事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSNM_SK		AS \'出荷元事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTCD_SK		AS \'出荷元センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTNM_SK		AS \'出荷元センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.UNSKSCD		AS \'運送会社コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.UNSKSNM		AS \'運送会社名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSCD_NK		AS \'入荷事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSNM_NK		AS \'入荷事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTCD_NK		AS \'入荷センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTNM_NK		AS \'入荷センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SKHNYKBN1	AS \'ＩＤ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SKHNYKBN1NM	AS \'ＩＤ名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DENNO		AS \'伝票番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DENGNO		AS \'伝票行番号\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.BIKO		AS \'備考\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHCD		AS \'商品コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DNRK		AS \'電略\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHNM		AS \'製品名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHNKKKMEI	AS \'規格\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SEKKBN		AS \'請求区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SR1RS		AS \'ケース入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SR2RS		AS \'中間入目\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KHKBN		AS \'梱端区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.RTNO		AS \'ロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.LOTK		AS \'管理区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.LOTS		AS \'出荷区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.FCKBNKK		AS \'工場コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL		AS \'パレット積付数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSR1		AS \'入荷予定ケース数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL_DIV		AS \'パレット枚数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL_MOD		AS \'パレット端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSR2		AS \'入荷予定中間数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KKTSR3		AS \'入荷予定バラ数量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , TRUNCATE(WD.WGT+0.9, 0)		AS \'入荷予定総重量\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRKMJ		AS \'ＤＢ取込時間（yyyymmdd）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRKMJ_YYYY	AS \'ＤＢ取込時間（yyyy）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRKMJ_MM		AS \'ＤＢ取込時間（mm）\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRKMJ_DD		AS \'ＤＢ取込時間（dd）\'');

    
    SET @sql_sel = CONCAT(@sql_sel,' FROM wk_202000_details AS WD');
    SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN wk_202000_head AS WK');
    SET @sql_sel = CONCAT(@sql_sel,' ON WD.work_id = WK.work_id');    
    IF p_ids IS NOT NULL THEN
		SET @sql_sel = CONCAT(@sql_sel,' WHERE WK.work_id IN(',p_ids,')');
	ELSE
		SET @sql_sel = CONCAT(@sql_sel,' WHERE WK.user_id = \'',p_user_id,'\'');		
	END IF;
    SET @sql_sel = CONCAT(@sql_sel,' ORDER BY WK.work_id, WD.work_detail_id');
    
    PREPARE _stmt_sel from @sql_sel;
	EXECUTE _stmt_sel;
	DEALLOCATE PREPARE _stmt_sel;    
    
END//

delimiter ;