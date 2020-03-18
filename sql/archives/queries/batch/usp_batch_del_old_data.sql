DROP PROCEDURE IF EXISTS usp_batch_del_old_data;
delimiter //

CREATE PROCEDURE usp_batch_del_old_data(	
)
BEGIN
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DROP TABLE IF EXISTS tmp_shipment_provisionals;
		DROP TABLE IF EXISTS tmp_shipment_confirms;
		DROP TABLE IF EXISTS tmp_arrival_schedules;
		DROP TABLE IF EXISTS tmp_location_stocks;
		ROLLBACK;
        RESIGNAL;
    END;
    
    -- トランザクション開始
    START TRANSACTION;
    
    CREATE TEMPORARY TABLE tmp_shipment_provisionals(
		id			int(11)	
    );
        
    INSERT INTO tmp_shipment_provisionals
    SELECT ID FROM shipment_provisionals
    WHERE DENPYOYMD <= date_add(date(now()), interval -8 DAY);
    
    DELETE SH FROM shipment_provisionals AS SH
    INNER JOIN tmp_shipment_provisionals AS TP
		ON SH.ID = TP.ID;
	
    
    CREATE TEMPORARY TABLE tmp_shipment_confirms(
		id			int(11)	
    );
    
    INSERT INTO tmp_shipment_confirms
    SELECT ID FROM shipment_confirms
    WHERE DENPYOYMD <= date_add(date(now()), interval -8 DAY);
    
    DELETE SC FROM shipment_confirms AS SC
    INNER JOIN tmp_shipment_confirms AS TP
		ON SC.ID = TP.ID;
        
    CREATE TEMPORARY TABLE tmp_arrival_schedules(
		id			int(11)	
    );
    
    INSERT INTO tmp_arrival_schedules
    SELECT ID FROM arrival_schedules
    WHERE DENPYOYMD <= date_add(date(now()), interval -8 DAY);
    
    DELETE AR FROM arrival_schedules AS AR
    INNER JOIN tmp_arrival_schedules AS TP
		ON AR.ID = TP.ID;
        
    
    CREATE TEMPORARY TABLE tmp_location_stocks(
		id			int(11)	
    );
    
    INSERT INTO tmp_location_stocks
    SELECT ID FROM location_stocks
    WHERE TRKMJ <= date_add(date(now()), interval -8 DAY);
    
    
    DELETE LS FROM location_stocks AS LS
    INNER JOIN tmp_location_stocks AS TP
		ON LS.ID = TP.ID;
    
    COMMIT;
    
    
    SELECT
		'仮出荷情報' AS TABLE_NAMES
	,	COUNT(*) AS PROCESS_COUNT
    FROM tmp_shipment_provisionals
    UNION ALL
    SELECT
		'出荷確定情報' AS TABLE_NAMES
	,	COUNT(*) AS PROCESS_COUNT
    FROM tmp_shipment_confirms
    UNION ALL
    SELECT
		'入荷情報' AS TABLE_NAMES
	,	COUNT(*) AS PROCESS_COUNT
    FROM tmp_arrival_schedules
    UNION ALL
    SELECT
		'在庫情報' AS TABLE_NAMES
	,	COUNT(*) AS PROCESS_COUNT
    FROM tmp_location_stocks;
    
    
    DROP TABLE IF EXISTS tmp_shipment_provisionals;
    DROP TABLE IF EXISTS tmp_shipment_confirms;
    DROP TABLE IF EXISTS tmp_arrival_schedules;
    DROP TABLE IF EXISTS tmp_location_stocks;
    
    ALTER TABLE shipment_confirms ENGINE = InnoDB;
	ALTER TABLE shipment_confirm_details ENGINE = InnoDB;
	ALTER TABLE shipment_provisionals ENGINE = InnoDB;
	ALTER TABLE shipment_provisional_details ENGINE = InnoDB;
	ALTER TABLE arrival_schedules ENGINE = InnoDB;
	ALTER TABLE arrival_schedule_details ENGINE = InnoDB;
	ALTER TABLE location_stocks ENGINE = InnoDB;

       
        
    
END//

delimiter ;