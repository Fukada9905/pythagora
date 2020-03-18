DROP PROCEDURE IF EXISTS usp_305000_csv;
delimiter //

CREATE PROCEDURE usp_305000_csv(
	IN p_ids text
,	IN p_user_id varchar(10)
)
BEGIN
    
    SET @sql_sel = 'SELECT';
	SET @sql_sel = CONCAT(@sql_sel, '   WD.DET_ID AS \'在庫管理ID\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TRNJ AS \'DB取込時間\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTStocktakingDate AS \'棚卸日\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSCD AS \'事業所コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.JGSNM AS \'事業所名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTCD AS \'センターコード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SNTNM AS \'センター名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NNSICD AS \'荷主コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NNSINM AS \'荷主名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SRRNO AS \'未合区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHCD AS \'商品コード\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHNM AS \'製品名称\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.DNRK AS \'電略\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.RTNO AS \'ロット\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KANRIK AS \'管理区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SYUKAK AS \'出荷区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.KOUJOK AS \'工場区分\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SHNKKKMEI_KS AS \'規格ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SR1RS AS \'入目１\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTexStocks1 AS \'前日在庫ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTexStocks3 AS \'前日在庫バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTRecieving1 AS \'入庫ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTRecieving3 AS \'入庫バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTPicking1 AS \'出庫ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTPicking3 AS \'出庫バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTstock1 AS \'在庫ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTstock3 AS \'在庫バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PL AS \'パレット積数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTPLQ AS \'PL枚数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PYTPLP AS \'PL端数\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.ZNJTZIKSURU1 AS \'会計前日在庫ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.ZNJTZIKSURU3 AS \'会計前日在庫バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NUKSURU1 AS \'会計入庫ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.NUKSURU3 AS \'会計入庫バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SKSURU1 AS \'会計出庫ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SKSURU3 AS \'会計出庫バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TUJTZIKSURU1 AS \'会計当日在庫ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.TUJTZIKSURU3 AS \'会計当日在庫バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SKYTI1SURU1 AS \'会計出庫予定１ケース\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.SKYTI1SURU3 AS \'会計出庫予定１バラ\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PTStocktakingDate_YYYY AS \'年\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PTStocktakingDate_MM AS \'月\'');
	SET @sql_sel = CONCAT(@sql_sel, ' , WD.PTStocktakingDate_DD AS \'日\'');

    SET @sql_sel = CONCAT(@sql_sel,' FROM wk_305000_details AS WD');
    SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN wk_305000_head AS WK');
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