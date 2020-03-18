DROP PROCEDURE IF EXISTS pyt_p_301000_pdf;
delimiter //

CREATE PROCEDURE pyt_p_301000_pdf(
	IN p_work_id int
,	IN p_user_id varchar(20)
)
BEGIN
    SELECT
		pyt_ufn_get_date_format(WH.PYTStocktakingDate) AS '棚卸日'
    ,	WH.SNTNM AS '倉庫'   
	,	CONCAT(WH.NNSINM,'(',WH.NNSICD,')') AS '荷主'    
    ,	WD.SHCD AS '外装商品CD'
    ,	WD.DNRK AS '電略'
    ,	WD.SR1RS AS '入目'
    ,	WD.SHNKKKMEI_KS AS '規格'
    ,	WD.SHNM AS '商品名'
    ,	CASE WHEN WD.SRRNO = '1' THEN '未' ELSE '' END AS '未'
    ,	WD.RTNO AS 'ロット'
    ,	WD.KANRIK AS 'K'
    ,	WD.SYUKAK AS 'S'
    ,	SUM(WD.PYTexStocks1) AS '前残ケース'
    ,	SUM(WD.PYTexStocks3) AS '前残バラ'
    ,	SUM(WD.NUKSURU1) AS '入庫ケース'
    ,	SUM(WD.NUKSURU3) AS '入庫バラ'
    ,	SUM(WD.PYTPicking1) AS '出庫ケース'
    ,	SUM(WD.PYTPicking3) AS '出庫バラ'
    ,	SUM(WD.PYTstock1) AS '在庫ケース'
    ,	SUM(WD.PYTstock3) AS '在庫バラ'
    ,	SUM(WD.PYTPLQ) AS 'PLケース'
    ,	SUM(WD.PYTPLP) AS 'PLバラ'
	FROM pyt_w_301000_details AS WD
    INNER JOIN pyt_w_301000_head AS WH
		ON WD.work_id = WH.work_id    
        AND WD.user_id = WH.user_id
    WHERE WD.work_id = p_work_id
    AND WD.user_id = p_user_id
    GROUP BY
		WH.PYTStocktakingDate
	,	WH.SNTNM
    ,	WH.NNSINM
    ,	WH.NNSICD
    ,	WD.SHCD
    ,	WD.DNRK
    ,	WD.SR1RS
    ,	WD.SHNKKKMEI_KS
    ,	WD.SHNM
    ,	WD.SRRNO
    ,	WD.RTNO
    ,	WD.KANRIK 
    ,	WD.SYUKAK 
    ORDER BY WD.SHCD, WD.RTNO, WD.work_detail_id;
	
END//

delimiter ;