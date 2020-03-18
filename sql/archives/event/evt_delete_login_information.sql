SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS evt_delete_login_information;

CREATE EVENT evt_delete_login_information
ON SCHEDULE EVERY 1 MINUTE STARTS now()
DO
call usp_delete_login_information();