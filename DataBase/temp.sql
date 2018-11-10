-- -----------------------------------------------------
-- Databases Final Project
-- Students: Otto, Antonio and Pedro
--
-- Steps:
-- 	FIRST - Create Schema, Tables and Relationshps
-- 	SECOND - Populate with at least 5 mocksets of data
-- 	THIRD - Generate reports
-- -----------------------------------------------------

-- START BUILDING THE DATABASE -------------------------------
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Detect
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Detect` ;

-- -----------------------------------------------------
-- Schema Detect
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Detect` DEFAULT CHARACTER SET utf8mb4 ;
USE `Detect` ;



  -- -----------------------------------------------------
-- Table `Detect`.`Companies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Companies` ;

CREATE TABLE IF NOT EXISTS `Detect`.`Companies` (
 `CompanyId` INT NOT NULL AUTO_INCREMENT,
 `CompanyName` VARCHAR(50) NOT NULL UNIQUE,
 `CompanyDescription` VARCHAR(255),
 PRIMARY KEY (`CompanyId`)
 );
 
 
  -- -----------------------------------------------------
-- Table `Detect`.`Roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Roles` ;

CREATE TABLE IF NOT EXISTS `Detect`.`Roles` (
 `RoleId` INT NOT NULL AUTO_INCREMENT,
 `RoleName` VARCHAR(50) NOT NULL UNIQUE,
 `RoleDescription` VARCHAR(255),
 PRIMARY KEY (`RoleId`));

-- -----------------------------------------------------
-- Table `Detect`.`Supervisors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Supervisors` ;
CREATE TABLE IF NOT EXISTS `Detect`.`Supervisors` (
 `SupervisorId` INT NOT NULL AUTO_INCREMENT,
 `SupervisorName` VARCHAR(255) NOT NULL,
 `SupervisorCPF` INT NOT NULL UNIQUE,
 `SupervisorPassword` VARCHAR(32) NOT NULL,
 `SupervisorUsername` VARCHAR(20) NOT NULL UNIQUE,
 `SupervisorCompany` INT NOT NULL,
 `SupervisorPosition` INT NOT NULL,
 PRIMARY KEY (`SupervisorId`),
 
 INDEX `SupervisorCompany_idx` (`SupervisorCompany` ASC),
 INDEX `SupervisorPosition_idx` (`SupervisorPosition` ASC),
 
 CONSTRAINT `SupervisorCompany`
 FOREIGN KEY (`SupervisorCompany`)
 REFERENCES `Detect`.`Companies` (`CompanyId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
 CONSTRAINT `SupervisorPosition`
 FOREIGN KEY (`SupervisorPosition`)
 REFERENCES `Detect`.`Roles` (`RoleId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 );


-- -----------------------------------------------------
-- Table `Detect`.`Users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Users` ;

CREATE TABLE IF NOT EXISTS `Detect`.`Users` (
 `UserId` INT NOT NULL AUTO_INCREMENT,
 `UserName` VARCHAR(255) NOT NULL,
 `User_PlatformIdUser` INT,
 PRIMARY KEY (`UserId`),
 
 INDEX `User_PlatformIdUser_idx` (`User_PlatformIdUser` ASC),
 
 CONSTRAINT `User_PlatformIdUser`
 FOREIGN KEY (`User_PlatformIdUser`)
 REFERENCES `Detect`.`User_Platform` (`User_PlatformId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 );

  -- -----------------------------------------------------
-- Table `Detect`.`FeatureTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`FeatureTypes` ;

CREATE TABLE IF NOT EXISTS `Detect`.`FeatureTypes` (
 `FeatureTypeId` INT NOT NULL AUTO_INCREMENT,
 `FeatureTypeName` VARCHAR(50) NOT NULL UNIQUE,
 `FeatureTypeDescription` VARCHAR(255) NOT NULL,
 PRIMARY KEY (`FeatureTypeId`));
 
  -- -----------------------------------------------------
-- Table `Detect`.`Features`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Features` ;

CREATE TABLE IF NOT EXISTS `Detect`.`Features` (
 `FeatureId` INT NOT NULL AUTO_INCREMENT,
 `FeatureType` INT NOT NULL UNIQUE,
 `Mean` FLOAT,
 `MeanMomentum` FLOAT,
 `Variance` FLOAT,
 `Entropy` FLOAT,
 PRIMARY KEY (`FeatureId`),
 
 INDEX `FeatureType_idx` (`FeatureType` ASC),
 CONSTRAINT `FeatureType`
 FOREIGN KEY (`FeatureType`)
 REFERENCES `Detect`.`FeatureTypes` (`FeatureTypeId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 );

-- -----------------------------------------------------
-- Table `Detect`.`Platforms`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Platforms` ;

CREATE TABLE IF NOT EXISTS `Detect`.`Platforms` (
 `PlatformId` INT NOT NULL AUTO_INCREMENT,
 `PlatformName` VARCHAR(255) NOT NULL UNIQUE,
 `User_PlatformIdPlatform` INT,
 PRIMARY KEY (`PlatformId`),
 
 INDEX `User_PlatformIdPlatform_idx` (`User_PlatformIdPlatform` ASC),
 
 CONSTRAINT `User_PlatformIdPlatform`
 FOREIGN KEY (`User_PlatformIdPlatform`)
 REFERENCES `Detect`.`User_Platform` (`User_PlatformId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 );

 
   -- -----------------------------------------------------
-- Table `Detect`.`RelTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`RelTypes` ;

CREATE TABLE IF NOT EXISTS `Detect`.`RelTypes` (
 `RelTypeId` INT NOT NULL AUTO_INCREMENT,
 `RelTypeName` VARCHAR(50) NOT NULL UNIQUE,
 `RelTypeDescription` VARCHAR(255),
 PRIMARY KEY (`RelTypeId`));
 
 
  -- -----------------------------------------------------
-- Associative Table `Detect`.`Relationships`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Relationships` ;

CREATE TABLE IF NOT EXISTS `Detect`.`Relationships` (
 `RelId` INT NOT NULL AUTO_INCREMENT,
 `FriendId` INT,
 `RelType` INT,
 PRIMARY KEY (`RelId`),
 
 INDEX `FriendId_idx` (`FriendId` ASC),
 INDEX `RelType_idx` (`RelType` ASC),

 CONSTRAINT `FriendId`
 FOREIGN KEY (`FriendId`)
 REFERENCES `Detect`.`Users` (`UserId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
 CONSTRAINT `RelType`
 FOREIGN KEY (`RelType`)
 REFERENCES `Detect`.`RelTypes` (`RelTypeId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 );
 
    -- -----------------------------------------------------
-- Table `Detect`.`RelTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Posts` ;

CREATE TABLE IF NOT EXISTS `Detect`.`Posts` (
 `PostId` INT NOT NULL AUTO_INCREMENT,
 `PostText` VARCHAR(250) NOT NULL,
 `PostLikes` INT,
 `Shares` INT,
 `Emotion` VARCHAR(20),
 PRIMARY KEY (`PostId`));
 
 
 -- -----------------------------------------------------
-- Associative Table `Detect`.`User_Platform`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`User_Platform` ;

CREATE TABLE IF NOT EXISTS `Detect`.`User_Platform` (
 `User_PlatformId` INT NOT NULL AUTO_INCREMENT,
 `UserId` INT NOT NULL,
 `PlatformId` INT NOT NULL,
 `Features` INT NOT NULL,
 `Relationships` INT NOT NULL,
 `PostId` INT NOT NULL,
 PRIMARY KEY (`User_PlatformId`),
 
 INDEX `UserId_idx` (`UserId` ASC),
 INDEX `PlatformId_idx` (`PlatformId` ASC),
 INDEX `Features_idx` (`Features` ASC),
 INDEX `Relationships_idx` (`Relationships` ASC),
 INDEX `PostId_idx` (`PostId` ASC),


 
 CONSTRAINT `UserId`
 FOREIGN KEY (`UserId`)
 REFERENCES `Detect`.`Users` (`UserId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
 CONSTRAINT `PlatformId`
 FOREIGN KEY (`PlatformId`)
 REFERENCES `Detect`.`Platforms` (`PlatformId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
 CONSTRAINT `Features`
 FOREIGN KEY (`Features`)
 REFERENCES `Detect`.`Features` (`FeatureId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
 CONSTRAINT `Relationships`
 FOREIGN KEY (`Relationships`)
 REFERENCES `Detect`.`Relationships` (`RelId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
 CONSTRAINT `PostId`
 FOREIGN KEY (`PostId`)
 REFERENCES `Detect`.`Posts` (`PostId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 
 );
 

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
-- FINISHED BUILDING THE DATABASE ---------------------------------


-- START POPULATING THE DATABASE ----------------------------------

-- Population by: http://www.generatedata.com/

-- -----------------------------------------------------
-- Table `Detect`.`Companies`
-- -----------------------------------------------------
INSERT INTO `Companies` (`CompanyName`,`CompanyDescription`) VALUES ("Scelerisque Neque Sed Limited","eu erat semper rutrum. Fusce dolor quam, elementum at, egestas");

-- -----------------------------------------------------
-- Table `Detect`.`Roles`
-- -----------------------------------------------------

INSERT IGNORE INTO `Roles` (`RoleName`,`RoleDescription`) VALUES ("Research and Development","Sales and Marketing is their department");

-- -----------------------------------------------------
-- Table `Detect`.`Supervisors`
-- -----------------------------------------------------

INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES ("Charde",71912050247,"6713","et@duinec.ca",0,0);

-- -----------------------------------------------------
-- Table `Detect`.`Users`
-- -----------------------------------------------------

INSERT INTO `Users` (`UserName`) VALUES ("Selma"), ("Wilma");

-- -----------------------------------------------------
-- Table `Detect`.`FeatureTypes`
-- -----------------------------------------------------

INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("Posting_Volume","Lorem ipsum");

-- -----------------------------------------------------
-- Table `Detect`.`Features`
-- -----------------------------------------------------

INSERT IGNORE INTO `Features` (`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (1,"0.99","0.09","0.41","0.96");


-- -----------------------------------------------------
-- Table `Detect`.`Platforms`
-- -----------------------------------------------------

INSERT INTO `Platforms` (`PlatformName`) VALUES ("Youtube"),("Orkut"),("Reddit"),("Facebook"),("Instagram");


-- -----------------------------------------------------
-- Associative Table `Detect`.`Relationships`
-- -----------------------------------------------------

INSERT INTO `Posts` (`PostText`, `PostLikes`, `Shares`, `Emotion`) VALUES ("Lorem Ipsum",1, 2, "Joy");

-- -----------------------------------------------------
-- Table `Detect`.`RelTypes`
-- -----------------------------------------------------

INSERT INTO `RelTypes` (`RelTypeName`,`RelTypeDescription`) VALUES ("friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),("friend","Lorem ipsum dolor sit amet,"),("acquaintance","Lorem ipsum dolor"),("follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed");


-- -----------------------------------------------------
-- Associative Table `Detect`.`Relationships`
-- -----------------------------------------------------

INSERT INTO `Relationships` (`FriendId`,`RelType`) VALUES (1,1), (2,1), (1,1);

-- -----------------------------------------------------
-- Associative Table `Detect`.`User_Platform`
-- -----------------------------------------------------

INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`, `PostId`) VALUES (1,1,1,1,1);


-- FINISHED POPULATING THE DATABASE -------------------------------

-- START GENERATING REPORTS ---------------------------------------

-- FINISHED GENERATING REPORTS ---------------------------------------