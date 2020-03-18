DROP PROCEDURE IF EXISTS pyt_p_301000_details;
delimiter //

CREATE PROCEDURE pyt_p_301000_details(
	IN p_target_id int
,	IN p_user_id varchar(20)
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
    FROM pyt_w_301000_head AS WH
    INNER JOIN pyt_w_301000_details AS WD
		ON WH.work_id = WD.work_id
        AND WH.user_id = WD.user_id
    WHERE WH.work_id = p_target_id
    AND WH.user_id = p_user_id
    ORDER BY WD.SHCD, WD.RTNO, WD.work_detail_id;
    
    
END//

delimiter ;