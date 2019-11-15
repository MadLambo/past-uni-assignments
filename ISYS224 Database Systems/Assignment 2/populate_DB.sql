		/*****Populate Tables*****/

INSERT INTO `staff` (`STAFFNO`, `STAFFNAME`) VALUES ('1', 'John');
INSERT INTO `staff` (`STAFFNO`, `STAFFNAME`) VALUES ('3', 'Adam');
INSERT INTO `staff` (`STAFFNO`, `STAFFNAME`) VALUES ('5', 'Eve');

INSERT INTO `customer` (`CUSTOMER_ID`, `COMPANYNAME`, `ADDRESS`,   `STAFF_STAFFNO`) 
	VALUES ('1', 'MQ', 'N Ryde',  '3');
INSERT INTO `customer` (`CUSTOMER_ID`, `COMPANYNAME`, `ADDRESS`,  `STAFF_STAFFNO`) 
	VALUES ('3', 'UWS', 'Parramatta',  '1');

INSERT INTO `campaign` (`CAMPAIGN_NO`, `TITLE`, `CUSTOMER_ID`, `THEME`, `CAMPAIGNSTARTDATE`, `CAMPAIGNFINISHDATE`, `ESTIMATEDCOST`, `ACTUALCOST`) 
    VALUES ('1', 'Blue', '1', 'Fall', '2018-01-01', '2019-07-01', '1500', '1350');

INSERT INTO `campaign` (`CAMPAIGN_NO`, `TITLE`, `CUSTOMER_ID`, `THEME`, `CAMPAIGNSTARTDATE`, `ESTIMATEDCOST`) 
    VALUES ('2', 'Red', '3', 'Spring', '2019-01-03', '1000');

INSERT INTO `workson` (`STAFFNO`, `CAMPAIGN_NO`, `WDATE`,  `HOUR`) 
    VALUES ('1', '2', '2019-02-01',  '8');
    
INSERT INTO `workson` (`STAFFNO`, `CAMPAIGN_NO`, `WDATE`,  `HOUR`) 
    VALUES ('5', '1', '2018-02-01',  '7');
    
INSERT INTO `workson` (`STAFFNO`, `CAMPAIGN_NO`, `WDATE`,  `HOUR`) 
    VALUES ('3', '1', '2018-05-01',  '5');

INSERT INTO `workson` (`STAFFNO`, `CAMPAIGN_NO`, `WDATE`,  `HOUR`) 
    VALUES ('1', '2', '2019-05-01',  '7');

INSERT INTO `workson` (`STAFFNO`, `CAMPAIGN_NO`, `WDATE`,  `HOUR`) 
    VALUES ('5', '1', '2019-06-01',  '8');


INSERT INTO `salarygrade` (`GRADE`, `HOURLYRATE`) VALUES ('1', '30');
INSERT INTO `salarygrade` (`GRADE`, `HOURLYRATE`) VALUES ('2', '45');
INSERT INTO `salarygrade` (`GRADE`, `HOURLYRATE`) VALUES ('3', '70');
INSERT INTO `salarygrade` (`GRADE`, `HOURLYRATE`) VALUES ('4', '75');
INSERT INTO `salarygrade` (`GRADE`, `HOURLYRATE`) VALUES ('5', '150');

INSERT INTO `staffongrade` (`STAFFNO`, `GRADE`, `STARTDATE`, `FINISHDATE`) 
    VALUES ('1', '1', '2018-01-01','2019-01-04');
INSERT INTO `staffongrade` (`STAFFNO`, `GRADE`, `STARTDATE`, `FINISHDATE`) 
    VALUES ('3', '2', '2018-01-05','2018-12-31');
INSERT INTO `staffongrade` (`STAFFNO`, `GRADE`, `STARTDATE`, `FINISHDATE`) 
    VALUES ('5', '4', '2018-01-01', '2019-06-01');    
INSERT INTO `staffongrade` (`STAFFNO`, `GRADE`, `STARTDATE`) 
    VALUES ('1', '2', '2019-01-05');
INSERT INTO `staffongrade` (`STAFFNO`, `GRADE`, `STARTDATE`) 
    VALUES ('3', '3', '2019-01-01');
    
    
INSERT INTO `invoice` (`INVOICENO`, `CAMPAIGN_NO`, `DATEISSUED`, `DATEPAID`, `BALANCEOWING`, `STATUS`) 
    VALUES ('1', '1', '2019-07-19',  '2019-07-31', '0', 'PAID');

INSERT INTO `invoice` (`INVOICENO`, `CAMPAIGN_NO`, `DATEISSUED`, `BALANCEOWING`, `STATUS`) 
    VALUES ('2', '2', '2019-09-10', '675', 'UNPAID');
    
commit;



