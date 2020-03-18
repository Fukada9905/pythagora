DROP PROCEDURE IF EXISTS pyt_p_402000;
DELIMITER //

CREATE PROCEDURE pyt_p_402000(
	IN p_is_partner tinyint
,	IN p_is_get_divide1 tinyint
,	IN p_is_get_divide2 tinyint
,	IN p_is_get_divide3 tinyint
,	IN p_is_get_divide4 tinyint
,	IN p_date_divide tinyint
,	IN p_date_from date
,	IN p_date_to date
,	IN p_jgscd text
,	IN p_nnsicd text
,	IN p_ptncd text
,	IN p_rootpt3 text
,	IN p_management_cd varchar(10)
,	IN p_user_id varchar(10)
)
BEGIN
	
	-- EXIT HANDLE
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		DELETE FROM pyt_w_402000 WHERE user_id = p_user_id;
        DROP TABLE IF EXISTS tmp_data;
		DROP TABLE IF EXISTS tmp_sntcd; 
        RESIGNAL;
    END;
    
    
    DELETE FROM pyt_w_402000 WHERE user_id = p_user_id;
    
    CREATE TEMPORARY TABLE tmp_data(
		shipper_code 				varchar(10)
	,	shipper_name 				varchar(50)
	,	transporter_code 			varchar(10)
	,	transporter_name 			varchar(30)
	,	sales_office_code 			varchar(10)
	,	warehouse_code 				varchar(10)
	,	warehouse_name 				varchar(30)
	,	delivery_code 				varchar(20)
	,	delivery_name 				varchar(120)
	,	delivery_address 			varchar(120)
	,	slip_number 				varchar(20)
	,	retrieval_date 				date
	,	delivery_date 				date
    ,	warehouse_accounting_date	date
	,	package_count				int
	,	fraction					int
	,	shipping_weight				int		
	,	shaban_id					int
	,	departure_count				int
	,	arrival_count				int
    ,	detail_count				int
	,	target_divide				tinyint
	);
    
    
    IF p_is_get_divide1 = 1 || p_is_get_divide2 = 1 || p_is_get_divide4 = 1 THEN
		-- STEP.0 SETUP PARAMS
		SELECT GROUP_CONCAT(CONCAT('\'',NNSICD,'\'')) INTO @nnsicd FROM pyt_m_ninushi;		
			
				
        SET @sql_sel = 'INSERT INTO tmp_data SELECT';        
        SET @sql_sel = CONCAT(@sql_sel,' SH.shipper_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,MN.NNSINM AS shipper_name');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.transporter_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.transporter_name');		
        SET @sql_sel = CONCAT(@sql_sel,' ,SH.sales_office_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.warehouse_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.warehouse_name');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.delivery_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,CONCAT(IFNULL(MAX(SH.delivery_name1),\'\'), IFNULL(MAX(SH.delivery_name2),\'\'), IFNULL(MAX(SH.delivery_name3),\'\')) AS delivery_name');
		SET @sql_sel = CONCAT(@sql_sel,' ,CONCAT(IFNULL(MAX(SH.delivery_address1),\'\'), IFNULL(MAX(SH.delivery_address2),\'\'),IFNULL(MAX(SH.delivery_address3),\'\')) AS delivery_address');
        SET @sql_sel = CONCAT(@sql_sel,' ,SH.slip_number');
        SET @sql_sel = CONCAT(@sql_sel,' ,SH.retrieval_date');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.delivery_date');
        SET @sql_sel = CONCAT(@sql_sel,' ,SH.warehouse_accounting_date');
		SET @sql_sel = CONCAT(@sql_sel,' ,SUM(SH.package_count) AS package_count');
		SET @sql_sel = CONCAT(@sql_sel,' ,SUM(SH.fraction) AS fraction');
		SET @sql_sel = CONCAT(@sql_sel,' ,SUM(TRUNCATE(SH.shipping_weight+0.9, 0)) AS shipping_weight');
        SET @sql_sel = CONCAT(@sql_sel,' ,SB.ID AS shaban_id');
        SET @sql_sel = CONCAT(@sql_sel,' ,SB.departure_count');
        SET @sql_sel = CONCAT(@sql_sel,' ,SB.arrival_count');
		SET @sql_sel = CONCAT(@sql_sel,' ,SB.detail_count');
        SET @sql_sel = CONCAT(@sql_sel,' ,0 AS target_divide');
        
		SET @sql_sel = CONCAT(@sql_sel,' FROM t_shipment AS SH');
		SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN pyt_m_ninushi AS MN');
		SET @sql_sel = CONCAT(@sql_sel,' ON SH.shipper_code = MN.NNSICD');
		SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN (SELECT');
		SET @sql_sel = CONCAT(@sql_sel,'  SH.id');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.shipper_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.transporter_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.transporter_name');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.slip_number');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.sales_office_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.warehouse_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.warehouse_name');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.delivery_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.retrieval_date');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.delivery_date');
		SET @sql_sel = CONCAT(@sql_sel,' ,SUM(CASE WHEN SD.departure_datetime IS NOT NULL THEN 1 ELSE 0 END) AS departure_count');
		SET @sql_sel = CONCAT(@sql_sel,' ,SUM(CASE WHEN SD.arrival_datetime IS NOT NULL THEN 1 ELSE 0 END) AS arrival_count');
		SET @sql_sel = CONCAT(@sql_sel,' ,COUNT(SD.detail_no) AS detail_count');
		SET @sql_sel = CONCAT(@sql_sel,' FROM pyt_t_shaban AS SH');
		SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN pyt_t_shaban_details AS SD');
		SET @sql_sel = CONCAT(@sql_sel,' ON SH.id = SD.id');
		SET @sql_sel = CONCAT(@sql_sel,' GROUP BY');
		SET @sql_sel = CONCAT(@sql_sel,'  SH.id');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.shipper_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.transporter_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.transporter_name');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.slip_number');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.sales_office_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.warehouse_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.warehouse_name');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.delivery_code');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.retrieval_date');
		SET @sql_sel = CONCAT(@sql_sel,' ,SH.delivery_date');
		SET @sql_sel = CONCAT(@sql_sel,') AS SB');
		SET @sql_sel = CONCAT(@sql_sel,' ON SH.shipper_code = SB.shipper_code');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.transporter_code = SB.transporter_code');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.transporter_name = SB.transporter_name');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.slip_number = SB.slip_number');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.sales_office_code = SB.sales_office_code');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.warehouse_code = SB.warehouse_code');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.warehouse_name = SB.warehouse_name');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.delivery_code = SB.delivery_code');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.retrieval_date = SB.retrieval_date');
		SET @sql_sel = CONCAT(@sql_sel,' AND SH.delivery_date = SB.delivery_date');
        IF p_ptncd IS NOT NULL OR p_is_partner = 1 THEN
			SET @sql_sel = CONCAT(@sql_sel,' LEFT JOIN pyt_m_sp_conditions AS SP');
			SET @sql_sel = CONCAT(@sql_sel,' ON MN.NNSICD = SP.NNSICD');
			SET @sql_sel = CONCAT(@sql_sel,' AND SH.sales_office_code = SP.JGSCD');
			SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SNTCD IS NULL OR SH.warehouse_code = SP.SNTCD)');
			SET @sql_sel = CONCAT(@sql_sel,' AND (SP.UNSKSCD IS NULL OR SH.transporter_code = SP.UNSKSCD)');
			SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SYUKAP IS NULL OR SH.shipping_location_code = SP.SYUKAP)');
			SET @sql_sel = CONCAT(@sql_sel,' AND (SP.SEKKBN IS NULL OR SH.billing_type = SP.SEKKBN)');
			SET @sql_sel = CONCAT(@sql_sel,' AND (SP.NHNSKCD IS NULL OR SH.delivery_code = SP.NHNSKCD)');
			SET @sql_sel = CONCAT(@sql_sel,' AND SP.SKTISFRG = 1');
		END IF;
		
		SET @sql_where = CONCAT(' WHERE SH.shipper_code IN(',@nnsicd,')');
        
        IF p_is_get_divide1 = 1 && p_is_get_divide2 = 0 && p_is_get_divide4 = 0 THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_trading_short_name = \'A2\'');    
		ELSEIF p_is_get_divide1 = 1 && p_is_get_divide2 = 1 && p_is_get_divide4 = 0 THEN 
			SET @sql_where = CONCAT(@sql_where,' AND (');
            SET @sql_where = CONCAT(@sql_where,' (SH.shipper_trading_short_name = \'A2\')');    
            SET @sql_where = CONCAT(@sql_where,' OR');
            SET @sql_where = CONCAT(@sql_where,' (SH.shipper_trading_short_name != \'A2\' AND SH.factory_direct = \'01\')');    
            SET @sql_where = CONCAT(@sql_where,' )');    
		ELSEIF p_is_get_divide1 = 1 && p_is_get_divide2 = 0 && p_is_get_divide4 = 1 THEN 
			SET @sql_where = CONCAT(@sql_where,' AND (');
            SET @sql_where = CONCAT(@sql_where,' (SH.shipper_trading_short_name = \'A2\')');    
            SET @sql_where = CONCAT(@sql_where,' OR');
            SET @sql_where = CONCAT(@sql_where,' (SH.shipper_trading_short_name != \'A2\' AND IFNULL(SH.factory_direct,\'00\') = \'00\')');    
            SET @sql_where = CONCAT(@sql_where,' )');
		ELSEIF p_is_get_divide1 = 0 && p_is_get_divide2 = 1 && p_is_get_divide4 = 1 THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_trading_short_name != \'A2\' AND IFNULL(SH.factory_direct,\'00\') IN(\'00\',\'01\')');    
		ELSEIF p_is_get_divide1 = 0 && p_is_get_divide2 = 1 && p_is_get_divide4 = 0 THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_trading_short_name != \'A2\' AND IFNULL(SH.factory_direct,\'00\') =\'00\'');    
		ELSEIF p_is_get_divide1 = 0 && p_is_get_divide2 = 0 && p_is_get_divide4 = 1 THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_trading_short_name != \'A2\' AND SH.factory_direct =\'01\'');    
        END IF;
			
		IF p_date_from IS NOT NULL AND p_date_to IS NOT NULL AND p_date_from = p_date_to THEN		
			IF p_date_divide = 1 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.retrieval_date = \'',p_date_from,'\'');
			ELSEIF p_date_divide = 2 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.delivery_date = \'',p_date_from,'\'');
			ELSEIF p_date_divide = 3 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.warehouse_accounting_date = \'',p_date_from,'\'');
			ELSEIF p_date_divide = 4 THEN
				SET @sql_where = CONCAT(@sql_where,' AND SH.created_at >= \'',p_date_from,'\' AND SH.created_at < \'',DATE_ADD(p_date_from, INTERVAL 1 DAY),'\'');
			END IF;							
		ELSE
			IF p_date_from IS NOT NULL THEN
				IF p_date_divide = 1 THEN
					SET @sql_where = CONCAT(@sql_where,' AND SH.retrieval_date >= \'',p_date_from,'\'');
				ELSEIF p_date_divide = 2 THEN
					SET @sql_where = CONCAT(@sql_where,' AND SH.delivery_date >= \'',p_date_from,'\'');
				ELSEIF p_date_divide = 3 THEN
					SET @sql_where = CONCAT(@sql_where,' AND SH.warehouse_accounting_date >= \'',p_date_from,'\'');
				ELSEIF p_date_divide = 4 THEN
					SET @sql_where = CONCAT(@sql_where,' AND SH.created_at >= \'',p_date_from,'\'');
				END IF;										
			END IF;
			
			IF p_date_to IS NOT NULL THEN
				IF p_date_divide = 1 THEN
					SET @sql_where = CONCAT(@sql_where,' AND SH.retrieval_date <= \'',p_date_to,'\'');
				ELSEIF p_date_divide = 2 THEN
					SET @sql_where = CONCAT(@sql_where,' AND SH.delivery_date <= \'',p_date_to,'\'');
				ELSEIF p_date_divide = 3 THEN
					SET @sql_where = CONCAT(@sql_where,' AND SH.warehouse_accounting_date <= \'',p_date_to,'\'');
				ELSEIF p_date_divide = 4 THEN
					SET @sql_where = CONCAT(@sql_where,' AND SH.created_at < \'',DATE_ADD(p_date_to, INTERVAL 1 DAY),'\'');
				END IF;				
			END IF;
		END IF;
		
		IF p_jgscd IS NOT NULL THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.sales_office_code IN(',p_jgscd,')');				
		END IF;
		
		IF p_nnsicd IS NOT NULL THEN
			SET @sql_where = CONCAT(@sql_where,' AND SH.shipper_code IN(',p_nnsicd,')');				
		END IF;
        
        IF p_ptncd IS NOT NULL THEN
			SET @sql_where = CONCAT(@sql_where,' AND SP.PTNCD IN(',p_ptncd,')');		
		END IF;
		
		IF p_is_partner = 1 THEN
			SET @sql_where = CONCAT(@sql_where,' AND SP.PTNCD = \'',p_management_cd,'\'');		
		END IF;
		
		SET @sql_group = ' GROUP BY ';
		SET @sql_group = CONCAT(@sql_group,'  SH.shipper_code');
		SET @sql_group = CONCAT(@sql_group,' ,MN.NNSINM');
		SET @sql_group = CONCAT(@sql_group,' ,SH.transporter_code');
		SET @sql_group = CONCAT(@sql_group,' ,SH.transporter_name');
		SET @sql_group = CONCAT(@sql_group,' ,SH.sales_office_code');        
		SET @sql_group = CONCAT(@sql_group,' ,SH.warehouse_code');
		SET @sql_group = CONCAT(@sql_group,' ,SH.warehouse_name');
		SET @sql_group = CONCAT(@sql_group,' ,SH.delivery_code');
        SET @sql_group = CONCAT(@sql_group,' ,SH.slip_number');
		SET @sql_group = CONCAT(@sql_group,' ,SH.retrieval_date');
		SET @sql_group = CONCAT(@sql_group,' ,SH.delivery_date');
        SET @sql_group = CONCAT(@sql_group,' ,SH.warehouse_accounting_date');
		SET @sql_group = CONCAT(@sql_group,' ,SB.id');
        SET @sql_group = CONCAT(@sql_group,' ,SB.departure_count');
        SET @sql_group = CONCAT(@sql_group,' ,SB.arrival_count');
		SET @sql_group = CONCAT(@sql_group,' ,SB.detail_count');
		SET @sql_group = CONCAT(@sql_group,' ORDER BY ');
		SET @sql_group = CONCAT(@sql_group,'  SH.shipper_code');    
		SET @sql_group = CONCAT(@sql_group,' ,SH.transporter_code');
		SET @sql_group = CONCAT(@sql_group,' ,SH.transporter_name');
		SET @sql_group = CONCAT(@sql_group,' ,SH.slip_number');
		SET @sql_group = CONCAT(@sql_group,' ,SH.warehouse_code');
		SET @sql_group = CONCAT(@sql_group,' ,SH.warehouse_name');
		SET @sql_group = CONCAT(@sql_group,' ,SH.delivery_code');
		SET @sql_group = CONCAT(@sql_group,' ,SH.retrieval_date');
		SET @sql_group = CONCAT(@sql_group,' ,SH.delivery_date');
		
		SET @sql_sel = CONCAT(@sql_sel,@sql_where,@sql_group);
		
        
		PREPARE _stmt_sel from @sql_sel;
		EXECUTE _stmt_sel;
		DEALLOCATE PREPARE _stmt_sel; 
    END IF;
    
    IF p_is_get_divide3 = 1 THEN
		
    
		SET @target_date = p_date_from;
		WHILE @target_date <= p_date_to DO
			
            SET @sql_sel = 'INSERT INTO tmp_data SELECT';
			SET @sql_sel = CONCAT(@sql_sel,' \'\' AS shipper_code');
			SET @sql_sel = CONCAT(@sql_sel,' ,\'TC幹線\' AS shipper_name');
			SET @sql_sel = CONCAT(@sql_sel,' ,RT.UNSKSPTNCD AS transporter_code');
			SET @sql_sel = CONCAT(@sql_sel,' ,CONCAT(IFNULL(PN1.PTNCDNM1,\'\'),IF(PN1.PTNCDNM2 IS NULL, \'\', \' \'),IFNULL(PN1.PTNCDNM2,\'\')) AS transporter_name');
			SET @sql_sel = CONCAT(@sql_sel,' ,RT.JGSCD AS sales_office_code');
			SET @sql_sel = CONCAT(@sql_sel,' ,RT.TMCPTNCD AS warehouse_code');
			SET @sql_sel = CONCAT(@sql_sel,' ,CONCAT(IFNULL(PN2.PTNCDNM1,\'\'),IF(PN2.PTNCDNM2 IS NULL, \'\', \' \'),IFNULL(PN2.PTNCDNM2,\'\')) AS warehouse_name');
			SET @sql_sel = CONCAT(@sql_sel,' ,RT.CKCPTNCD AS delivery_code');
			SET @sql_sel = CONCAT(@sql_sel,' ,CONCAT(IFNULL(PN3.PTNCDNM1,\'\'),IF(PN3.PTNCDNM2 IS NULL, \'\', \' \'),IFNULL(PN3.PTNCDNM2,\'\')) AS delivery_name');
			SET @sql_sel = CONCAT(@sql_sel,' ,PN3.PTNCDJUSYO AS delivery_address');
			SET @sql_sel = CONCAT(@sql_sel,' ,\'\' AS slip_number');
            SET @sql_sel = CONCAT(@sql_sel,' ,\'',@target_date,'\' AS retrieval_date');
            SET @sql_sel = CONCAT(@sql_sel,' ,\'',@target_date,'\' AS delivery_date');
            SET @sql_sel = CONCAT(@sql_sel,' ,\'',@target_date,'\' AS warehouse_accounting_date');
			SET @sql_sel = CONCAT(@sql_sel,' ,0 AS package_count');
			SET @sql_sel = CONCAT(@sql_sel,' ,0 AS fraction');
			SET @sql_sel = CONCAT(@sql_sel,' ,0 AS shipping_weight');
			SET @sql_sel = CONCAT(@sql_sel,' ,SB.id AS shaban_id');
            SET @sql_sel = CONCAT(@sql_sel,' ,SB.departure_count');
			SET @sql_sel = CONCAT(@sql_sel,' ,SB.arrival_count');
			SET @sql_sel = CONCAT(@sql_sel,' ,SB.detail_count');
            SET @sql_sel = CONCAT(@sql_sel,' ,1 AS target_divide');
			SET @sql_sel = CONCAT(@sql_sel,' FROM pyt_m_root AS RT');
			SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN pyt_m_partners AS PN1');
			SET @sql_sel = CONCAT(@sql_sel,' ON RT.UNSKSPTNCD = PN1.PTNCD');
			SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN pyt_m_partners AS PN2');
			SET @sql_sel = CONCAT(@sql_sel,' ON RT.TMCPTNCD = PN2.PTNCD');
			SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN pyt_m_partners AS PN3');
			SET @sql_sel = CONCAT(@sql_sel,' ON RT.CKCPTNCD = PN3.PTNCD');            
            SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN (SELECT');
			SET @sql_sel = CONCAT(@sql_sel,'  SH.id');
			SET @sql_sel = CONCAT(@sql_sel,' ,SH.root_id');
			SET @sql_sel = CONCAT(@sql_sel,' ,SUM(CASE WHEN SD.departure_datetime IS NOT NULL THEN 1 ELSE 0 END) AS departure_count');
			SET @sql_sel = CONCAT(@sql_sel,' ,SUM(CASE WHEN SD.arrival_datetime IS NOT NULL THEN 1 ELSE 0 END) AS arrival_count');
			SET @sql_sel = CONCAT(@sql_sel,' ,COUNT(SD.detail_no) AS detail_count');
			SET @sql_sel = CONCAT(@sql_sel,' FROM pyt_t_shaban_tc AS SH');
			SET @sql_sel = CONCAT(@sql_sel,' INNER JOIN pyt_t_shaban_tc_details AS SD');
			SET @sql_sel = CONCAT(@sql_sel,' ON SH.id = SD.id');
            SET @sql_sel = CONCAT(@sql_sel,' WHERE SH.target_date = \'',@target_date,'\'');
			SET @sql_sel = CONCAT(@sql_sel,' GROUP BY');
			SET @sql_sel = CONCAT(@sql_sel,'  SH.id');
			SET @sql_sel = CONCAT(@sql_sel,' ,SH.root_id');
			SET @sql_sel = CONCAT(@sql_sel,') AS SB');
            SET @sql_sel = CONCAT(@sql_sel,' ON RT.root_id = SB.root_id');
            SET @sql_sel = CONCAT(@sql_sel,' WHERE RT.del_flag = 0');
			IF p_rootpt3 IS NOT NULL THEN
				SET @sql_sel = CONCAT(@sql_sel,' AND RT.UNSKSPTNCD IN(',p_rootpt3,')');                
			END IF;
			IF p_jgscd IS NOT NULL THEN
				SET @sql_sel = CONCAT(@sql_sel,' AND RT.JGSCD IN(',p_jgscd,')');				
			END IF;
            IF p_is_partner = 1 THEN
				SET @sql_sel = CONCAT(@sql_sel,' AND (RT.UNSKSPTNCD = \'',p_management_cd,'\'');
                SET @sql_sel = CONCAT(@sql_sel,' OR RT.TMCPTNCD = \'',p_management_cd,'\'');		
                SET @sql_sel = CONCAT(@sql_sel,' OR RT.CKCPTNCD = \'',p_management_cd,'\')');		
			END IF;
            SET @sql_sel = CONCAT(@sql_sel,' GROUP BY');
            SET @sql_sel = CONCAT(@sql_sel,' RT.UNSKSPTNCD');
            SET @sql_sel = CONCAT(@sql_sel,' ,RT.UNSKSPTNCD');
            SET @sql_sel = CONCAT(@sql_sel,' ,PN1.PTNCDNM1');
            SET @sql_sel = CONCAT(@sql_sel,' ,PN1.PTNCDNM2');
            SET @sql_sel = CONCAT(@sql_sel,' ,RT.JGSCD');
            SET @sql_sel = CONCAT(@sql_sel,' ,RT.TMCPTNCD');
            SET @sql_sel = CONCAT(@sql_sel,' ,PN2.PTNCDNM1');
            SET @sql_sel = CONCAT(@sql_sel,' ,PN2.PTNCDNM2');
            SET @sql_sel = CONCAT(@sql_sel,' ,RT.CKCPTNCD');
            SET @sql_sel = CONCAT(@sql_sel,' ,PN3.PTNCDNM1');
            SET @sql_sel = CONCAT(@sql_sel,' ,PN3.PTNCDNM2');
            SET @sql_sel = CONCAT(@sql_sel,' ,PN3.PTNCDJUSYO');
            SET @sql_sel = CONCAT(@sql_sel,' ,SB.id');
            SET @sql_sel = CONCAT(@sql_sel,' ,SB.departure_count');
			SET @sql_sel = CONCAT(@sql_sel,' ,SB.arrival_count');
			SET @sql_sel = CONCAT(@sql_sel,' ,SB.detail_count');
            
			
			PREPARE _stmt_sel from @sql_sel;
			EXECUTE _stmt_sel;
			DEALLOCATE PREPARE _stmt_sel;
                        
            SET @target_date = DATE_ADD(@target_date, INTERVAL 1 DAY);
		END WHILE;        
		
    END IF;
    
    
    SET @rownum = 0;
    INSERT INTO pyt_w_402000
    SELECT
		p_user_id
	,	@rownum:=@rownum+1 as ROW_NUM
    ,	target_divide
	,	shipper_code
    ,	shipper_name
    ,	transporter_code
    ,	transporter_name
    ,	slip_number
    ,	sales_office_code
    ,	warehouse_code
    ,	warehouse_name
    ,	delivery_code
    ,	delivery_name
    ,	delivery_address
    ,	retrieval_date
    ,	warehouse_accounting_date
    ,	delivery_date
    ,	package_count
    ,	fraction
    ,	shipping_weight
    ,	shaban_id
    ,	departure_count
    ,	arrival_count
    ,	detail_count
    
    FROM tmp_data;
    
    SELECT * FROM pyt_w_402000 WHERE user_id = p_user_id;
    
    DROP TABLE IF EXISTS tmp_data;
    DROP TABLE IF EXISTS tmp_sntcd;
     
END//