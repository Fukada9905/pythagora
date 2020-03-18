DROP PROCEDURE IF EXISTS usp_get_jigyosho;
delimiter //

CREATE PROCEDURE usp_get_jigyosho(
)
BEGIN    
	SELECT
		JGSCD
	,	JGSRMEI AS JGSNM
	FROM mtb_jigyosho
    WHERE del_flag = 0
	ORDER BY JGSCD;
END//

delimiter ;