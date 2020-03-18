DROP PROCEDURE IF EXISTS usp_201030_csv;
delimiter //

CREATE PROCEDURE usp_201030_csv(
	IN p_user_id varchar(10)
)
BEGIN

	SELECT
		CASE WHEN DATA_DIVIDE = 3 THEN '総計' ELSE NOHINYMD END AS '入荷予定日'
	,	NNSINM AS '荷主名'
    ,	SHCD AS '商品コード'
    ,	DNRK AS '電略'
    ,	SHNM AS '商品名'
    ,	RTNO AS 'ロット'
	,	KKTSR1 AS '合計/ケース予定数'
	,	KKTSR3 AS 'バラ/ケース予定数'
	,	MOD_PL AS '合計/パレット数'        
	FROM wk_201030
	WHERE user_id = p_user_id;
		
    
END//

delimiter ;