DROP FUNCTION IF EXISTS pyt_ufn_get_KKTSR;
delimiter //

CREATE FUNCTION pyt_ufn_get_KKTSR(
	p_total		int
,	p_fraction	int
,	p_per		int
)
RETURNS int DETERMINISTIC
BEGIN   

	IF IFNULL(p_total,0) = 0 OR IFNULL(p_fraction,0) = 0 OR IFNULL(p_per,0) = 0 THEN
		RETURN 0;
    END IF;

	RETURN TRUNCATE((p_fraction / p_per),0);
						
END//
delimiter ;