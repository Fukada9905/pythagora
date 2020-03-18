DROP PROCEDURE IF EXISTS usp_304000_pdf;
delimiter //

CREATE PROCEDURE usp_304000_pdf(
	IN p_work_id int
,	IN p_user_id varchar(10)
)
BEGIN
    SELECT
		ufn_get_date_format(WH.PYTStocktakingDate) AS '棚卸日'
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
    ,	SUM(WD.PYTstock1) AS '元在ケース'
    ,	SUM(WD.PYTstock3) AS '元在バラ'
    ,	SUM(WD.JitsuCase) AS '在庫ケース'
    ,	SUM(WD.JitsuBara) AS '在庫バラ'
    ,	SUM(WD.PYTPLQ) AS 'PL元ケース'
    ,	SUM(WD.PYTPLP) AS 'PL元バラ'
    ,	SUM((WD.JitsuCase DIV WD.PL)) AS 'PLケース'
    ,	SUM(CASE WHEN WD.PL = 0 THEN WD.JitsuCase ELSE (WD.JitsuCase % WD.PL) END) AS 'PLバラ'
    ,	WD.ReportComment AS '報告者コメント'
    ,	WD.ReviewComment AS '確認者コメント'
    ,	WD.ReportCorpName AS '報告者会社名'
    ,	WD.Reporter AS '報告者名前'
    ,	ufn_get_date_format(WD.ReportDatetime) AS '報告日'
    ,	CONCAT('大塚倉庫 ',WH.JGSNM) AS '確認者会社名'
    ,	WD.ReviewerName AS '確認者名前'
    ,	ufn_get_date_format(WD.ReviewDatetime) AS '確認日'
    ,	CONCAT('大塚倉庫 ',WH.JGSNM) AS '承認者会社名'
    ,	WD.AuthorizerName AS '承認者名前'
    ,	ufn_get_date_format(WD.AuthorizerDatetime) AS '承認日'
	FROM wk_304000_details AS WD
    INNER JOIN wk_304000_head AS WH
		ON WD.work_id = WH.work_id
    WHERE WD.work_id = p_work_id
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
    ,	WD.ReportComment
    ,	WD.ReviewComment
    ORDER BY WD.work_detail_id;
	
END//

delimiter ;