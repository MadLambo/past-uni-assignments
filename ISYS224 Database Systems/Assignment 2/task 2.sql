DELIMITER //
drop trigger if exists tr_overdue
//
create trigger tr_overdue 
after update ON invoice 
FOR EACH ROW
BEGIN
IF NEW.status = 'OVERDUE' THEN
INSERT INTO alerts (message_date, origin, message)
VALUES (current_date(), current_user(),concat('Invoice with number: ', OLD.INVOICENO' is now overdue!'));
END IF;
END
DELIMITER //