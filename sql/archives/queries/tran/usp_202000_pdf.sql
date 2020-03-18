DROP PROCEDURE IF EXISTS usp_202000_pdf;
delimiter //

CREATE PROCEDURE usp_202000_pdf(
	IN p_work_id int
,	IN p_user_id varchar(10)
)
BEGIN
    SELECT
		ufn_get_date_format(NOHINYMD) AS '納品日'
	,	CONCAT(NNSINM,'(',NNSICD,')') AS '荷主'
    ,	CONCAT(SNTCD_NK,'　',SNTNM_NK) AS '入荷先'
    ,	ufn_get_date_format(DENPYOYMD) AS '伝票日付'
    ,	DENNO AS '伝票番号'
    ,	CONCAT(SHCD,'\r\n',DNRK) AS 'コード/電略'
    ,	SHNM AS '商品名称'
    ,	RTNO AS 'ロット'
    ,	KKTSR1 AS 'CS'
    ,	KKTSR3 AS 'バラ'
    ,	BIKO AS '備考'
    ,	UNSKSNM AS '業者名'
    FROM wk_202000_details
    WHERE work_id = p_work_id
    ORDER BY work_detail_id;
	
END//

delimiter ;