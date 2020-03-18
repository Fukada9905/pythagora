DROP PROCEDURE IF EXISTS usp_201010_csv;
delimiter //

CREATE PROCEDURE usp_201010_csv(
	IN p_user_id varchar(10)
)
BEGIN

	SELECT
		CASE WHEN DATA_DIVIDE = 3 THEN '総計' ELSE NOHINYMD END AS '入荷予定日'
	,	NNSINM AS '荷主名'
	,	KKTSR1 AS '合計/ケース予定数'
	,	KKTSR3 AS 'バラ/ケース予定数'
	,	MOD_PL AS '合計/パレット数'        
	FROM wk_201010
	WHERE user_id = p_user_id;
		
    
END//

delimiter ;