DROP PROCEDURE IF EXISTS pyt_p_205000_details;
delimiter //

CREATE PROCEDURE pyt_p_205000_details(
	IN p_work_id int
,	IN p_user_id varchar(10)
)
BEGIN


	SELECT
		WK.DENNO
	,	CONCAT(WK.JGSCD_SK, ' : ' , WK.JGSNM_SK) AS JGSCD_SK
    ,	CONCAT(WK.SNTCD_NK, ' : ' , WK.SNTNM_NK) AS SNTCD_NK
    ,	pyt_ufn_get_date_format(WK.DENPYOYMD) AS DENPYOYMD
    ,	pyt_ufn_get_date_format(WK.SYUKAYMD) AS SYUKAYMD
    ,	pyt_ufn_get_date_format(WK.NOHINYMD) AS NOHINYMD
    ,	pyt_ufn_get_datetime_format(WK.SYORIYMD) AS SYORIYMD
    ,	CONCAT(WK.UNSKSCD, ' : ' , WK.UNSKSNM) AS UNSKSNM
    ,	CONCAT(WK.NNSICD, ' : ' , WK.NNSINM) AS NNSINM
    ,	WD.SHCD
    ,	WD.DNRK
    ,	WD.SHNM
    ,	WD.RTNO
    ,	CASE WHEN WD.KKTSR1 = WD.JitsuCase THEN WD.JitsuCase ELSE CONCAT(WD.KKTSR1,'\r\n',WD.JitsuCase) END AS KKTSR1
    ,	CASE WHEN WD.KKTSR3 = WD.JitsuBara THEN WD.JitsuBara ELSE CONCAT(WD.KKTSR3,'\r\n',WD.JitsuBara) END AS KKTSR3
    ,	WD.Comment
    ,	CONCAT(WD.Reporter,' (',pyt_ufn_get_date_format(WK.ReportDatetime),')') AS Reporter
    ,	CONCAT(WD.Registrant,' (',pyt_ufn_get_date_format(WD.Registdatetime),')') AS Registrant
    ,	CASE WHEN WD.KKTSR1 != WD.JitsuCase || WD.KKTSR3 != WD.JitsuBara THEN 1 ELSE 0 END AS IsModifyRow
    ,	WK.Status
    ,	WK.work_id
	FROM pyt_w_205000_details AS WD
    INNER JOIN pyt_w_205000_head AS WK
		ON WD.work_id = WK.work_id
	WHERE WK.work_id = p_work_id
    ORDER BY WK.work_id, WD.work_detail_id;
    
    
END//

delimiter ;