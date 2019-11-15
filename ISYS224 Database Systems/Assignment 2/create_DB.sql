/*** Drop all tables ***/

drop table if exists staffongrade cascade;
drop table if exists workson cascade;
drop table if exists salarygrade cascade;
drop table if exists invoice cascade;
drop table if exists campaign cascade;
drop table if exists customer cascade;
drop table if exists staff cascade;
drop table if exists alerts cascade;

/***** Create all tables ***/

-- -----------------------------------------------------
-- Table `staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `staff` (
  `STAFFNO` INT(11) NOT NULL,
  `STAFFNAME` VARCHAR(20) NULL DEFAULT NULL,
  `EXPERTISE` VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (`STAFFNO`));


-- -----------------------------------------------------
-- Table `customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `customer` (
  `CUSTOMER_ID` INT(11) NOT NULL,
  `COMPANYNAME` VARCHAR(45) NOT NULL,
  `ADDRESS` VARCHAR(30) NULL DEFAULT NULL,
  `STAFF_STAFFNO` INT(11) NOT NULL,
  PRIMARY KEY (`CUSTOMER_ID`),
  INDEX `fk_CUSTOMER_STAFF1_idx` (`STAFF_STAFFNO` ASC),
  CONSTRAINT `fk_CUSTOMER_STAFF1`
    FOREIGN KEY (`STAFF_STAFFNO`)
    REFERENCES `staff` (`STAFFNO`));

-- -----------------------------------------------------
-- Table `campaign`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `campaign` (
  `CAMPAIGN_NO` INT(11) NOT NULL,
  `TITLE` VARCHAR(30) NOT NULL,
  `CUSTOMER_ID` INT(11) NOT NULL,
  `THEME` VARCHAR(40) NULL DEFAULT NULL,
  `CAMPAIGNSTARTDATE` DATE NULL DEFAULT NULL,
  `CAMPAIGNFINISHDATE` DATE NULL DEFAULT NULL,
  `ESTIMATEDCOST` INT(11) NULL DEFAULT NULL,
  `ACTUALCOST` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`CAMPAIGN_NO`),
  INDEX `OWNS_FK` (`CUSTOMER_ID` ASC),
  CONSTRAINT `FK_CAMPAIGN_OWNS_CUSTOMER`
    FOREIGN KEY (`CUSTOMER_ID`)
    REFERENCES `customer` (`CUSTOMER_ID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);


-- -----------------------------------------------------
-- Table `invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `invoice` (
  `INVOICENO` INT(11) NOT NULL AUTO_INCREMENT,
  `CAMPAIGN_NO` INT(11) NOT NULL,
  `DATEISSUED` DATE NULL DEFAULT NULL,
  `DATEPAID` DATE NULL DEFAULT NULL,
  `BALANCEOWING` INT(11) NULL DEFAULT NULL,
  `STATUS` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`INVOICENO`, `CAMPAIGN_NO`),
  INDEX `FK_INVOICE_SENDS2_CAMPAIGN_idx` (`CAMPAIGN_NO` ASC),
  CONSTRAINT `FK_INVOICE_SENDS2_CAMPAIGN`
    FOREIGN KEY (`CAMPAIGN_NO`)
    REFERENCES `campaign` (`CAMPAIGN_NO`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
AUTO_INCREMENT = 6;


-- -----------------------------------------------------
-- Table `salarygrade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `salarygrade` (
  `GRADE` INT(11) NOT NULL,
  `HOURLYRATE` FLOAT NOT NULL,
  PRIMARY KEY (`GRADE`));


-- -----------------------------------------------------
-- Table `staffongrade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `staffongrade` (
  `STAFFNO` INT(11) NOT NULL,
  `GRADE` INT(11) NOT NULL,
  `STARTDATE` DATE NULL DEFAULT NULL,
  `FINISHDATE` DATE NULL DEFAULT NULL,
  INDEX `STAFFONGRADE_FK` (`STAFFNO` ASC),
  INDEX `STAFFONGRADE2_FK` (`GRADE` ASC),
  PRIMARY KEY (`GRADE`, `STAFFNO`),
  CONSTRAINT `FK_STAFFONG_STAFFONGR_SALARYGR`
    FOREIGN KEY (`GRADE`)
    REFERENCES `salarygrade` (`GRADE`),
  CONSTRAINT `FK_STAFFONG_STAFFONGR_STAFF`
    FOREIGN KEY (`STAFFNO`)
    REFERENCES `staff` (`STAFFNO`));


-- -----------------------------------------------------
-- Table `workson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `workson` (
  `STAFFNO` INT(11) NOT NULL,
  `CAMPAIGN_NO` INT(11) NOT NULL,
  `WDATE` DATE NOT NULL,
  `HOUR` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`STAFFNO`, `CAMPAIGN_NO`, `WDATE`),
  INDEX `WORKSON_FK` (`STAFFNO` ASC),
  INDEX `FK_WORKSON_WORKSON2_CAMPAIGN_idx` (`CAMPAIGN_NO` ASC),
  CONSTRAINT `FK_WORKSON_WORKSON2_CAMPAIGN`
    FOREIGN KEY (`CAMPAIGN_NO`)
    REFERENCES `campaign` (`CAMPAIGN_NO`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `FK_WORKSON_WORKSON_STAFF`
    FOREIGN KEY (`STAFFNO`)
    REFERENCES `staff` (`STAFFNO`));

-- -----------------------------------------------------
-- TABLE ALERTS FOR PROCEDURES AND TRIGGERS
-- -----------------------------------------------------


create table alerts(
message_no int primary key AUTO_INCREMENT,
message_date date,
origin varchar(25),
message varchar(250)
);
