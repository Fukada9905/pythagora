DROP PROCEDURE IF EXISTS usp_303000_details;
delimiter //

CREATE PROCEDURE usp_303000_details(
	IN p_work_id int
,	IN p_user_id varchar(10)
)
BEGIN


	SELECT
		ufn_get_date_format(WK.PYTStocktakingDate) AS PYTStocktakingDate
    ,	WK.JGSNM AS JGSNM
    ,	CONCAT(WK.SNTCD, ' : ' , WK.SNTNM) AS SNTNM    
    ,	CONCAT(WK.NNSICD, ' : ' , WK.NNSINM) AS NNSINM
    ,	CONCAT(WD.ReportCorpName,'　|　',WD.Reporter,'　|　',ufn_get_date_format(ReportDatetime)) AS Reporter
    ,	CONCAT('大塚倉庫 ',WK.JGSNM,'　|　',WD.ReviewerName,'　|　',ufn_get_date_format(ReviewDatetime)) AS Reviewer
    ,	CASE WHEN WD.AuthorizerComment IS NULL THEN '' ELSE CONCAT('大塚倉庫 ',WK.JGSNM,' ',IFNULL(WD.AuthorizerName,''),'　｜　',IFNULL(WD.AuthorizerComment,'')) END AS AuthorizerComment    
    ,	WD.SHCD
    ,	WD.DNRK
    ,	WD.SHNM
    ,	WD.RTNO
    ,	WD.KANRIK
    ,	WD.SYUKAK
    ,	CONCAT(WD.PYTstock1,'\r\n',WD.PYTstock3) AS KKTSR1
    ,	CONCAT(WD.JitsuCase,'\r\n',WD.JitsuBara) AS KKTSR3
    ,	CONCAT(WD.ReportComment,'\r\n',WD.ReviewComment) AS ReviewComment    
    ,	CASE WHEN WD.PYTstock1 != WD.JitsuCase || WD.PYTstock3 != WD.JitsuBara THEN 1 ELSE 0 END AS IsModifyRow
    ,	WK.Status
    ,	WK.work_id
    ,	WD.work_detail_id
	FROM wk_303000_details AS WD
    INNER JOIN wk_303000_head AS WK
		ON WD.work_id = WK.work_id
	WHERE WK.work_id = p_work_id
    ORDER BY WK.work_id, WD.work_detail_id;
    
    
END//

delimiter ;