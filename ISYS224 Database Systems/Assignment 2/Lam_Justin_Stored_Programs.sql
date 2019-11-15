/********************************************************
****** Stored Programs for Assignment 2, 2019 **********
********** Justin Lam, 45197083 ************************
************ 30th October 2019 *************************
** I declare that the code provided below is my own work **
******* Any help received is duely acknowledged here ******
**********************************************************/

/********* Trigger TR_OVERDUE ************/

delimiter //
drop trigger if exists tr_overdue
//
create trigger tr_overdue 
after update ON invoice 
FOR EACH ROW

    begin
IF NEW.status = 'OVERDUE' THEN
INSERT INTO alerts (message_date, origin, message)
VALUES (current_date(), current_user(),concat('Invoice with number: ', OLD.INVOICENO ,'is now overdue!'));
END IF;    
    end
//

/************* Helper Functions/Procedures used, two functions for example ****************/

DELIMITER //
 drop function if exists rate_on_date //

create function rate_on_date(staff_id int, given_date DATE)
returns float
deterministic

BEGIN 
		DECLARE hourly_rate float;
        
        DECLARE r_hour cursor for 
		SELECT HOURLYRATE
		FROM staffongrade, salaryongrade
		WHERE STAFFONGRADE.GRADE = SALARYONGRADE.GRADE
		AND WORKSON.STAFFNO = staff_id	       
		AND given_date >= STARTDATE and (FINISHDATE is NULL or given_date <= FINISHDATE);
 
open r_hour;
fetch r_hour into hourly_rate;
close r_hour;
RETURN hourly_rate;
	END //

--
--
--
drop function if exists cost_of_campaign //
create function cost_of_campaign (camp_id int) 
returns float 
DETERMINISTIC

begin
declare staff_id int;
declare work_date date;
declare hours float;

declare t_cost float;
declare hand int default 0;


declare c_cursor cursor for
select staffno, WDATE, 'Hours'
from workson
where CAMPAIGN_NO = camp_id;
    
declare continue handler for not found set hand = 1;
    
open c_cursor;
set t_cost = 0;
while hand != 1 DO  
fetch c_cursor into staff_id, work_date, hours;
set t_cost = t_cost + (hours * rate_on_date (staff_id, work_date)); 
end while; 
close c_cursor;
RETURN t_cost;
	END //

/************ Procedure SP_FINISH_CAMPAIGN******************/

Delimiter //
drop procedure if exists sp_finish_campaign //


create procedure sp_finish_campaign (in c_title varchar(30))

begin
	declare number_of_campaigns int;
	
    select COUNT(campaign.CAMPAIGN_NO) into number_of_campaigns from campaign WHERE campaign.TITLE = c_title;

	if number_of_campaigns = 0 then
		select 'ERROR! Campaign title does not exist' as 'msg';
	
    elseif number_of_campaigns = 1 then 
	update campaign	
	set 
	campaign.CAMPAIGNFINISHDATE = CURRENT_DATE(),
	campaign.ACTUALCOST = cost_of_campaign(campaign.CAMPAIGN_NO)
    where campaign.TITLE = c_title;
    

	
            end if;

	end //
	Delimiter ;
    

/************ Procedure SYNC_INVOICE******************/

Delimiter //
DROP PROCEDURE IF EXISTS sync_invoice //
--
CREATE PROCEDURE sync_invoice()
	BEGIN
		UPDATE invoice
		SET invoice.STATUS = 'overdue'
		WHERE invoice.DATEISSUED + 30 <= CURRENT_DATE()
		AND invoice.DATEPAID IS NULL;
        
		SELECT ROW_COUNT() AS 'Number of invoices updated.';
	END //
DELIMITER ;



