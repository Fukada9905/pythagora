DROP PROCEDURE IF EXISTS usp_301000_details;
delimiter //

CREATE PROCEDURE usp_301000_details(
	IN p_target_id int
,	IN p_user_id varchar(10)
)
BEGIN
    
    SELECT
		WH.PYTStocktakingDate
	,	WH.SNTNM
    ,	CONCAT(WH.NNSINM,' (',WH.NNSICD,')') AS NNSINM
    ,	WD.SHCD
    ,	WD.DNRK
    ,	WD.SHNM
    ,	WD.RTNO
    ,	WD.KANRIK
    ,	WD.SYUKAK
    ,	WD.PYTstock1
    ,	WD.PYTstock3
    ,	WD.JitsuCase
    ,	WD.JitsuBara
    ,	WD.Comment
    ,	WD.work_detail_id
    ,	WH.work_id
    FROM wk_301000_head AS WH
    INNER JOIN wk_301000_details AS WD
		ON WH.work_id = WD.work_id
    WHERE WH.work_id = p_target_id
    ORDER BY WD.SHCD, WD.RTNO, WD.work_detail_id;
    
    
END//

delimiter ;