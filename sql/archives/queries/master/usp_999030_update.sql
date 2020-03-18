DROP PROCEDURE IF EXISTS usp_999030_update;
delimiter //

CREATE PROCEDURE usp_999030_update(
	IN p_update_row	text
,	IN p_user_id	varchar(20)
)
BEGIN

	
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TEMPORARY TABLE IF EXISTS tmp_insert;
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    
    CREATE TEMPORARY TABLE tmp_insert(
		sp_conditions_id int
	,	PTNCD			varchar(10)
    ,	NNSICD			varchar(10)
    ,	JGSCD			varchar(10)
    ,	SNTCD			varchar(10)
    ,	UNSKSCD			varchar(10)
    ,	SYUKAP			varchar(10)
	,	SEKKBN			varchar(10)
    ,	NHNSKCD			varchar(10)
    ,	NKTISFRG		tinyint
    ,	SKTISFRG		tinyint
    ,	ZKTISFRG		tinyint   
    ,	new_flag		tinyint 
    ,	del_flag		tinyint    
    );
    
    IF p_update_row IS NOT NULL THEN
		SET @s = CONCAT('INSERT INTO tmp_insert VALUES ',p_update_row);    
		PREPARE stmt from @s;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;    	
    END IF;
    
    
    UPDATE mtb_sp_conditions AS SP
    INNER JOIN tmp_insert AS TP
		ON SP.sp_conditions_id = TP.sp_conditions_id
	SET SP.NKTISFRG = TP.NKTISFRG
    ,	SP.SKTISFRG = TP.SKTISFRG
    ,	SP.ZKTISFRG = TP.ZKTISFRG
    WHERE TP.new_flag = 0 AND TP.del_flag = 0
    ;
    
    DELETE SP FROM mtb_sp_conditions AS SP
    INNER JOIN tmp_insert AS TP
		ON SP.sp_conditions_id = TP.sp_conditions_id
	WHERE TP.del_flag = 1;
    
    
    INSERT INTO mtb_sp_conditions(
		PTNCD
	,	NNSICD
	,	JGSCD
	,	SNTCD
    ,	UNSKSCD
	,	SYUKAP
	,	SEKKBN
	,	NHNSKCD
	,	NKTISFRG
	,	SKTISFRG
	,	ZKTISFRG
	,	add_user_id
    )
    SELECT
		TP.PTNCD
	,	TP.NNSICD
	,	TP.JGSCD
	,	TP.SNTCD
    ,	TP.UNSKSCD
	,	TP.SYUKAP
	,	TP.SEKKBN
    ,	TP.NHNSKCD
    ,	TP.NKTISFRG
    ,	TP.SKTISFRG
    ,	TP.ZKTISFRG
	,	p_user_id    
	FROM tmp_insert AS TP
    WHERE new_flag = 1
	;
    
	DROP TEMPORARY TABLE IF EXISTS tmp_insert;
    COMMIT;
        
    
END//

delimiter ;