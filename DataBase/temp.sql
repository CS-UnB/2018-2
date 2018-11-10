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
 `FriendId` INT NOT NULL,
 `RelType` INT NOT NULL,
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
 REFERENCES `Detect`.`Realationships` (`RelId`)
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
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (1,"Scelerisque Neque Sed Limited","eu erat semper rutrum. Fusce dolor quam, elementum at, egestas"),(2,"Eleifend Cras Sed Consulting","Fusce mollis. Duis sit"),(3,"Enim PC","amet, consectetuer adipiscing elit. Aliquam auctor, velit"),(4,"Nec Euismod PC","fringilla euismod enim."),(5,"Pellentesque Ultricies Foundation","iaculis odio. Nam interdum enim"),(6,"Libero Est PC","Fusce dolor quam, elementum at, egestas a, scelerisque sed,"),(7,"Fermentum Risus At Associates","tincidunt dui augue eu tellus. Phasellus elit pede, malesuada"),(8,"Nec Orci Company","Donec felis orci,"),(9,"Scelerisque Lorem Ipsum Limited","vulputate dui, nec tempus mauris erat"),(10,"Lectus Convallis Est Associates","volutpat ornare, facilisis eget, ipsum. Donec sollicitudin adipiscing ligula.");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (11,"Libero Lacus Varius Limited","ut"),(12,"Rutrum PC","eget, volutpat ornare, facilisis eget,"),(13,"Blandit At Inc.","at pede. Cras vulputate velit eu"),(14,"Ultrices Duis Volutpat Company","at fringilla purus mauris a nunc. In at pede. Cras"),(15,"Placerat Orci Lacus Foundation","penatibus et magnis dis parturient montes, nascetur ridiculus"),(16,"In Magna Phasellus Foundation","at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat,"),(17,"Eu Tempor Erat Inc.","Cras lorem lorem, luctus ut, pellentesque eget, dictum placerat, augue."),(18,"Nunc Sed Pede Company","senectus et netus et malesuada fames ac turpis egestas. Fusce"),(19,"Donec Corp.","odio. Nam"),(20,"Mauris Magna LLP","justo. Proin non massa non ante bibendum");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (21,"Arcu Vel Incorporated","senectus et netus et malesuada fames"),(22,"Dolor Sit Consulting","Pellentesque ultricies dignissim lacus. Aliquam rutrum lorem ac"),(23,"Enim Condimentum Eget Industries","molestie pharetra nibh. Aliquam ornare, libero at"),(24,"Pulvinar Arcu Company","sit"),(25,"Orci Ut Incorporated","Cras vehicula aliquet libero. Integer in magna. Phasellus"),(26,"Phasellus Ornare Fusce PC","Donec nibh enim, gravida sit amet,"),(27,"Vestibulum Ante Ipsum Ltd","dictum"),(28,"Id Magna Et Corporation","Integer"),(29,"Eleifend Vitae PC","ut eros non enim commodo hendrerit. Donec porttitor"),(30,"Parturient Montes Associates","risus quis diam luctus");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (31,"A Industries","dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula"),(32,"Diam At Pretium Corporation","magnis dis parturient montes, nascetur"),(33,"Duis Dignissim LLC","eu nulla"),(34,"Quisque Purus Limited","Curabitur ut odio vel est tempor bibendum. Donec felis orci,"),(35,"Dictum Proin Eget Corp.","consequat"),(36,"Quis Turpis Vitae Limited","porttitor scelerisque neque."),(37,"In Lobortis Inc.","urna et arcu imperdiet ullamcorper. Duis at lacus. Quisque"),(38,"Luctus Lobortis Limited","Phasellus dapibus quam quis"),(39,"Praesent Industries","nulla ante, iaculis nec, eleifend"),(40,"Faucibus Id PC","Cras convallis convallis dolor. Quisque tincidunt pede");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (41,"Magna Consulting","Sed eget lacus."),(42,"Metus Facilisis Lorem Consulting","libero at auctor ullamcorper, nisl arcu iaculis"),(43,"Diam Lorem Limited","sit amet lorem semper auctor. Mauris vel turpis. Aliquam adipiscing"),(44,"Ut Tincidunt LLP","justo. Proin non massa non ante"),(45,"Curae; Donec Incorporated","felis. Donec tempor,"),(46,"Vel Lectus Inc.","convallis convallis dolor. Quisque tincidunt"),(47,"Sapien Nunc Pulvinar Incorporated","pede, malesuada vel, venenatis"),(48,"Dictum Inc.","nec enim. Nunc ut erat. Sed"),(49,"Egestas Company","Aenean gravida nunc sed pede. Cum sociis natoque penatibus et"),(50,"In LLP","at");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (51,"A Institute","eu lacus. Quisque imperdiet, erat nonummy"),(52,"Amet Ornare Lectus Incorporated","nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat,"),(53,"Amet Risus Donec Foundation","egestas, urna justo faucibus"),(54,"Tempor Est Ac Associates","Ut tincidunt orci quis lectus. Nullam suscipit, est ac"),(55,"Lacus Etiam Bibendum LLC","orci, adipiscing non, luctus sit amet, faucibus ut, nulla."),(56,"Cras Limited","nec"),(57,"Rutrum Non Industries","sit amet nulla. Donec non justo. Proin non massa"),(58,"Curae; Phasellus Corporation","nec luctus felis purus ac tellus. Suspendisse sed dolor."),(59,"Non Sapien Molestie Ltd","magna."),(60,"Eu Incorporated","nisi sem semper erat, in consectetuer ipsum nunc id enim.");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (61,"Sapien Aenean Inc.","Integer id magna et ipsum cursus vestibulum. Mauris magna."),(62,"Rutrum Limited","enim. Curabitur massa. Vestibulum accumsan neque"),(63,"Eu Nibh Consulting","metus."),(64,"Ipsum Curabitur Incorporated","vitae"),(65,"Sit Amet PC","pede sagittis augue, eu tempor erat neque non quam."),(66,"Etiam LLC","Quisque varius. Nam porttitor scelerisque neque."),(67,"Fames Foundation","pharetra ut, pharetra sed,"),(68,"Odio Tristique LLC","leo. Vivamus nibh dolor, nonummy ac,"),(69,"Phasellus Dolor LLP","Duis"),(70,"Lectus Incorporated","dui. Suspendisse ac metus vitae velit");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (71,"Tincidunt Corp.","dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate"),(72,"Ac Libero Corporation","egestas hendrerit neque. In ornare sagittis felis. Donec tempor,"),(73,"Molestie Pharetra Corp.","netus et malesuada fames ac turpis egestas."),(74,"Sed Ltd","nunc id enim. Curabitur massa. Vestibulum accumsan neque et nunc."),(75,"Magnis Dis PC","pede. Cras vulputate velit eu"),(76,"Neque Venenatis Lacus Corporation","mattis velit justo nec ante. Maecenas mi felis,"),(77,"Egestas Aliquam Associates","non leo. Vivamus nibh"),(78,"Risus Donec Egestas LLC","Cras lorem lorem, luctus"),(79,"Imperdiet Ltd","tristique senectus et netus et malesuada fames ac turpis"),(80,"Cum Foundation","sit amet risus. Donec egestas. Aliquam nec");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (81,"Urna Convallis Erat Foundation","at sem molestie sodales."),(82,"Volutpat Corp.","ligula. Nullam enim. Sed nulla ante, iaculis nec, eleifend"),(83,"Nisi Magna Sed Industries","magna. Nam ligula elit,"),(84,"Libero Dui LLP","eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce"),(85,"Ullamcorper Nisl Arcu PC","Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque"),(86,"Bibendum Limited","Morbi non sapien molestie orci tincidunt adipiscing. Mauris molestie"),(87,"Quis Arcu Vel Inc.","dolor vitae"),(88,"Est Tempor Bibendum Associates","et, commodo at,"),(89,"Lectus Nullam LLP","mi pede, nonummy ut, molestie in, tempus eu, ligula."),(90,"Cum PC","tellus non magna. Nam ligula elit, pretium");
INSERT INTO `Companies` (`CompanyId`,`CompanyName`,`CompanyDescription`) VALUES (91,"Id Ltd","faucibus orci luctus et ultrices posuere cubilia"),(92,"Neque Pellentesque Massa Company","dui. Cum sociis natoque penatibus et magnis dis parturient montes,"),(93,"In Hendrerit Consectetuer Ltd","imperdiet ullamcorper. Duis at lacus."),(94,"Egestas Lacinia Sed Company","neque. Sed eget lacus. Mauris non dui nec"),(95,"Purus Gravida Associates","pharetra, felis"),(96,"Consequat Dolor Vitae Foundation","eu dui. Cum"),(97,"Hendrerit A Associates","condimentum."),(98,"Commodo Tincidunt Foundation","lectus quis massa. Mauris vestibulum, neque sed dictum eleifend,"),(99,"Sed Dictum Ltd","ac turpis egestas. Aliquam"),(100,"Enim Limited","urna et");

-- -----------------------------------------------------
-- Table `Detect`.`Roles`
-- -----------------------------------------------------

INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (1,"Research and Development","Sales and Marketing is they department"),(2,"Customer Service","Quality Assurance is they department"),(3,"Media Relations","Customer Service is they department"),(4,"Sales and Marketing","Accounting is they department"),(5,"Quality Assurance","Media Relations is they department"),(6,"Quality Assurance","Tech Support"),(7,"Customer Relations","Public Relations is they department"),(8,"Sales and Marketing","Human Resources is they department"),(9,"Accounting","Human Resources is they department"),(10,"Quality Assurance","Finances is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (11,"Tech Support","Human Resources is they department"),(12,"Legal Department","Research and Development is they department"),(13,"Finances","Legal Department is they department"),(14,"Public Relations","Sales and Marketing is they department"),(15,"Research and Development","Legal Department is they department"),(16,"Sales and Marketing","Finances is they department"),(17,"Customer Service","Customer Service is they department"),(18,"Public Relations","Research and Development is they department"),(19,"Human Resources","Advertising is they department"),(20,"Quality Assurance","Legal Department is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (21,"Public Relations","Asset Management is they department"),(22,"Public Relations","Asset Management is they department"),(23,"Legal Department","Human Resources is they department"),(24,"Sales and Marketing","Legal Department is they department"),(25,"Finances","Research and Development is they department"),(26,"Public Relations","Customer Relations is they department"),(27,"Customer Relations","Customer Service is they department"),(28,"Customer Relations","Accounting is they department"),(29,"Finances","Media Relations is they department"),(30,"Accounting","Legal Department is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (31,"Media Relations","Advertising is they department"),(32,"Sales and Marketing","Legal Department is they department"),(33,"Asset Management","Research and Development is they department"),(34,"Sales and Marketing","Advertising is they department"),(35,"Sales and Marketing","Tech Support"),(36,"Customer Relations","Human Resources is they department"),(37,"Advertising","Legal Department is they department"),(38,"Customer Service","Finances is they department"),(39,"Advertising","Advertising is they department"),(40,"Payroll","Asset Management is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (41,"Customer Relations","Asset Management is they department"),(42,"Customer Service","Finances is they department"),(43,"Quality Assurance","Customer Service is they department"),(44,"Research and Development","Customer Relations is they department"),(45,"Media Relations","Media Relations is they department"),(46,"Customer Relations","Quality Assurance is they department"),(47,"Finances","Public Relations is they department"),(48,"Finances","Public Relations is they department"),(49,"Public Relations","Finances is they department"),(50,"Accounting","Accounting is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (51,"Asset Management","Payroll is they department"),(52,"Finances","Customer Relations is they department"),(53,"Accounting","Human Resources is they department"),(54,"Tech Support","Customer Relations is they department"),(55,"Customer Service","Public Relations is they department"),(56,"Research and Development","Research and Development is they department"),(57,"Legal Department","Tech Support"),(58,"Customer Service","Finances is they department"),(59,"Customer Service","Media Relations is they department"),(60,"Asset Management","Legal Department is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (61,"Legal Department","Asset Management is they department"),(62,"Accounting","Accounting is they department"),(63,"Sales and Marketing","Human Resources is they department"),(64,"Accounting","Research and Development is they department"),(65,"Advertising","Sales and Marketing is they department"),(66,"Quality Assurance","Sales and Marketing is they department"),(67,"Customer Service","Customer Service is they department"),(68,"Finances","Payroll is they department"),(69,"Quality Assurance","Human Resources is they department"),(70,"Legal Department","Advertising is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (71,"Human Resources","Customer Service is they department"),(72,"Asset Management","Asset Management is they department"),(73,"Finances","Quality Assurance is they department"),(74,"Customer Relations","Tech Support"),(75,"Customer Service","Asset Management is they department"),(76,"Customer Relations","Media Relations is they department"),(77,"Accounting","Human Resources is they department"),(78,"Quality Assurance","Quality Assurance is they department"),(79,"Advertising","Asset Management is they department"),(80,"Research and Development","Accounting is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (81,"Advertising","Accounting is they department"),(82,"Customer Relations","Quality Assurance is they department"),(83,"Research and Development","Human Resources is they department"),(84,"Legal Department","Quality Assurance is they department"),(85,"Human Resources","Tech Support"),(86,"Asset Management","Legal Department is they department"),(87,"Accounting","Customer Service is they department"),(88,"Public Relations","Customer Relations is they department"),(89,"Sales and Marketing","Quality Assurance is they department"),(90,"Media Relations","Payroll is they department");
INSERT IGNORE INTO `Roles` (`RoleId`,`RoleName`,`RoleDescription`) VALUES (91,"Legal Department","Asset Management is they department"),(92,"Customer Relations","Research and Development is they department"),(93,"Sales and Marketing","Tech Support"),(94,"Human Resources","Legal Department is they department"),(95,"Advertising","Legal Department is they department"),(96,"Legal Department","Research and Development is they department"),(97,"Sales and Marketing","Customer Relations is they department"),(98,"Customer Service","Payroll is they department"),(99,"Asset Management","Tech Support"),(100,"Customer Relations","Quality Assurance is they department");

-- -----------------------------------------------------
-- Table `Detect`.`Supervisors`
-- -----------------------------------------------------

INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (1,"Charde",71912050247,"6713","et@duinec.ca",58,34),(2,"Clark",77323505779,"4447","vitae.sodales@odioAliquam.net",70,86),(3,"Evan",92326070326,"9467","sodales.purus@eros.com",29,59),(4,"Kelly",98328718046,"6746","fringilla.cursus@sitamet.com",29,4),(5,"Joelle",79501737405,"7073","eget.nisi.dictum@leoinlobortis.edu",54,90),(6,"Brooke",75958312551,"4190","ipsum@mattisInteger.com",12,95),(7,"Isabelle",50690751274,"7822","vel.quam.dignissim@Praesent.co.uk",43,64),(8,"Bevis",47057351552,"2251","auctor@Nulla.ca",49,11),(9,"Ivor",97272530280,"3747","dui.nec@lectusante.org",20,57),(10,"Jamalia",23785688562,"1330","mattis.velit@consectetuer.ca",60,83);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (11,"Kermit",20445433962,"6906","aliquam.adipiscing.lacus@Nullamsuscipit.edu",28,13),(12,"Reese",61780678356,"5130","blandit@pellentesquemassalobortis.org",48,17),(13,"Preston",79234467653,"1288","Nam@Fuscedolor.edu",90,46),(14,"Benjamin",19443386172,"5085","orci.tincidunt@purusmaurisa.ca",5,34),(15,"Giselle",19004152549,"7501","semper.dui.lectus@vitaesodales.net",6,58),(16,"Jamalia",13680498550,"8923","purus@imperdiet.co.uk",9,83),(17,"Russell",69449308431,"2976","dapibus.id@Donecsollicitudin.com",81,2),(18,"Grady",55528961039,"8208","nibh.sit.amet@Nullamlobortis.edu",78,87),(19,"Guy",76699393490,"3102","arcu.Sed@tellusPhaselluselit.edu",45,84),(20,"Leah",81460978546,"4309","Cras.convallis.convallis@ut.net",39,14);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (21,"Quintessa",53421382812,"2178","vitae@idenimCurabitur.net",67,22),(22,"Demetrius",40337842620,"8234","Sed.eu@posuerevulputatelacus.co.uk",11,71),(23,"Tate",70818651922,"1916","ipsum@cursuspurus.org",95,10),(24,"Vivien",99628396622,"9707","Suspendisse.aliquet.sem@at.net",45,80),(25,"Neville",43757921746,"5673","elit.pretium.et@liberoDonec.net",74,15),(26,"Adara",11963229460,"9831","Vestibulum.ut@Proin.edu",48,24),(27,"Malik",42295975113,"9812","est.Nunc.ullamcorper@Cumsociisnatoque.com",23,77),(28,"Xander",25431292917,"6014","gravida@velarcu.net",11,74),(29,"Brock",35661681534,"7172","augue@euenim.co.uk",22,21),(30,"Xerxes",56175004690,"3653","malesuada.malesuada.Integer@magna.co.uk",6,64);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (31,"Jeanette",32908099186,"6051","lobortis.quis.pede@Vivamusnibh.edu",40,39),(32,"John",95012283159,"8501","metus.sit@ullamcorpermagna.net",25,41),(33,"Carson",37145343588,"5379","Aliquam.vulputate.ullamcorper@parturient.co.uk",14,38),(34,"Ori",58982506021,"6541","magna.sed.dui@sagittisfelisDonec.com",42,5),(35,"Penelope",55005174130,"3225","luctus.sit.amet@erosnonenim.com",12,42),(36,"Abraham",44323537250,"2520","eros.Nam@nonhendrerit.org",100,13),(37,"Melissa",68754361942,"3102","sit.amet@varius.com",77,77),(38,"Lucas",81258301768,"6018","facilisis.non@Sednullaante.net",5,97),(39,"Rhiannon",24433245054,"8437","Nulla.facilisis.Suspendisse@sem.co.uk",68,41),(40,"Preston",27491670846,"6141","tellus.imperdiet@mi.edu",8,81);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (41,"Karleigh",95462617278,"9883","ridiculus.mus@vulputate.org",42,57),(42,"Cameron",15645989320,"7287","orci.adipiscing.non@Aeneaneget.net",29,2),(43,"Cooper",22064070776,"1903","pellentesque@vulputate.net",32,90),(44,"Brenden",44923630315,"7848","convallis.convallis@interdumCurabiturdictum.org",35,19),(45,"Signe",89773977465,"4617","arcu@mauris.org",65,26),(46,"Carissa",93503753675,"5478","ipsum@arcuSed.ca",85,23),(47,"Haley",55141212998,"7613","ornare.facilisis.eget@Phasellusinfelis.co.uk",98,6),(48,"Felicia",53976050557,"4730","ante.ipsum.primis@interdumCurabitur.edu",4,74),(49,"Courtney",71348798150,"5760","id.magna.et@sodalespurus.ca",23,3),(50,"Kato",60367506369,"6302","Duis.gravida.Praesent@eu.co.uk",41,71);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (51,"Jack",64339268041,"4091","Phasellus@mi.org",69,92),(52,"Haley",67472655533,"5081","Suspendisse.non.leo@nequetellusimperdiet.ca",29,55),(53,"Kieran",58578569938,"4880","sodales.elit.erat@risusQuisquelibero.com",90,20),(54,"Calista",54264306856,"2068","litora.torquent.per@felis.org",47,67),(55,"Rose",28340138536,"2614","arcu.Vestibulum@habitantmorbi.edu",44,1),(56,"Barbara",80929863701,"6025","non.luctus.sit@atarcu.ca",12,63),(57,"Courtney",31491159482,"6013","Nunc.mauris.elit@Integer.net",44,63),(58,"Idola",46955409149,"5982","pede.Cum@mitemporlorem.edu",95,73),(59,"Diana",87476657869,"2975","ac.libero@velnislQuisque.co.uk",2,78),(60,"Adria",62332723827,"6560","nec.quam@non.ca",7,98);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (61,"Marvin",19717357307,"9921","malesuada.fames@temporarcuVestibulum.net",14,85),(62,"Ferdinand",36451876908,"3501","eu@Utnec.com",31,50),(63,"Fay",40182927043,"3597","Vestibulum@semmagnanec.com",70,60),(64,"Nehru",77019609386,"8640","lorem.vitae@rhoncus.co.uk",77,40),(65,"Axel",57444062373,"2128","sit.amet.dapibus@tristiquepellentesque.org",78,81),(66,"Zorita",80965877572,"9067","sit.amet.consectetuer@urna.org",14,47),(67,"Orli",65621732589,"4312","nec.luctus@dolor.net",1,7),(68,"Nathan",25537034786,"9961","non@est.com",76,11),(69,"Theodore",71174185184,"1770","vulputate.lacus@porttitorinterdum.com",15,81),(70,"Erica",58530314473,"6162","hendrerit.consectetuer.cursus@purusmaurisa.ca",32,20);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (71,"Melodie",70972776992,"5807","Aliquam@necmollis.com",20,3),(72,"Jacob",76120050085,"2645","sem.semper.erat@DonecnibhQuisque.org",59,98),(73,"Sacha",54185588988,"4695","sollicitudin.a@actellusSuspendisse.org",66,69),(74,"Violet",14453452659,"1878","a@maurisrhoncus.org",23,35),(75,"Hall",65903018994,"3271","eu.turpis@laciniavitaesodales.net",80,40),(76,"Forrest",70603508874,"6562","non.massa@fermentumconvallisligula.com",43,53),(77,"Thor",63520362435,"8204","erat@sapien.ca",92,93),(78,"Elmo",66777388420,"9659","enim.Sed.nulla@Nullatempor.co.uk",86,25),(79,"Paloma",97470575157,"4272","nec.leo@loremsemper.ca",38,35),(80,"Cara",33178240805,"4557","justo.eu.arcu@sitametrisus.com",28,52);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (81,"Harding",93111773663,"7573","Nunc.lectus@inaliquetlobortis.co.uk",21,16),(82,"Dylan",27482762435,"4207","ante.Vivamus.non@natoquepenatibuset.net",48,34),(83,"Sylvester",42711898974,"2007","nec.ante.Maecenas@odioEtiamligula.ca",23,49),(84,"Sierra",86783007283,"6210","egestas.Duis.ac@consequat.net",2,79),(85,"Cameron",34316543448,"9895","hendrerit@vel.co.uk",76,24),(86,"Kyla",66554403594,"1574","Aliquam.erat@Fuscedolor.ca",29,38),(87,"Nelle",69702875158,"3213","urna.suscipit@euodio.edu",81,79),(88,"Amanda",33386562433,"5552","mauris.rhoncus@Craseu.net",63,11),(89,"Mollie",93665826568,"4875","feugiat.Sed.nec@sapienmolestieorci.org",17,100),(90,"Iona",89376558777,"6488","eu.erat.semper@Curabiturut.co.uk",73,17);
INSERT IGNORE INTO `Supervisors` (`SupervisorId`,`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES (91,"Karyn",35689738103,"4529","ipsum@Fuscemilorem.org",16,33),(92,"Mona",78121324338,"6927","erat@pedeetrisus.org",96,38),(93,"Malcolm",67068642336,"6646","Nullam.lobortis.quam@egestaslacinia.com",7,1),(94,"Cadman",36757617402,"2650","semper.erat.in@musProinvel.net",94,46),(95,"Cassidy",30024719859,"9615","magnis.dis@semegetmassa.edu",19,45),(96,"Isaac",64950281215,"4522","commodo.hendrerit@porttitor.ca",65,85),(97,"Liberty",77725692755,"8376","ultrices@eleifendegestas.co.uk",86,3),(98,"Eve",18430745849,"6073","risus.Donec.egestas@Nunccommodo.co.uk",61,29),(99,"Jana",68808576092,"5701","eu.euismod@Donecfeugiatmetus.net",33,64),(100,"Oren",16059736534,"1621","massa.Mauris@congueInscelerisque.net",94,2);

-- -----------------------------------------------------
-- Table `Detect`.`Users`
-- -----------------------------------------------------

INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (1,"Selma",94),(2,"Britanney",51),(3,"Montana",15),(4,"Claire",52),(5,"Dennis",20),(6,"Jason",86),(7,"Zoe",82),(8,"Jonah",65),(9,"Nasim",63),(10,"Haviva",66);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (11,"Vance",26),(12,"Clio",49),(13,"Lila",72),(14,"Yoko",65),(15,"Joseph",11),(16,"Todd",39),(17,"Kyra",61),(18,"Fatima",11),(19,"Reese",62),(20,"Alexandra",74);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (21,"Mallory",25),(22,"Illana",78),(23,"Brynn",92),(24,"Yael",85),(25,"Brenda",97),(26,"Cadman",75),(27,"Jerome",77),(28,"Vanna",58),(29,"David",97),(30,"Stephanie",60);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (31,"Alana",95),(32,"Maia",37),(33,"Fulton",26),(34,"Nola",62),(35,"Ayanna",23),(36,"Drew",36),(37,"Quincy",10),(38,"Rooney",82),(39,"Jameson",9),(40,"Shay",65);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (41,"Peter",94),(42,"Lev",41),(43,"Noah",5),(44,"Teagan",27),(45,"Gannon",94),(46,"Cynthia",82),(47,"Merrill",4),(48,"Lillith",13),(49,"Nathaniel",77),(50,"Armand",3);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (51,"Ishmael",56),(52,"Thane",76),(53,"Sophia",66),(54,"Hu",4),(55,"Buffy",19),(56,"Nita",90),(57,"Kitra",38),(58,"Hadassah",86),(59,"Gannon",24),(60,"Dora",60);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (61,"Bruce",26),(62,"Blake",40),(63,"Phelan",9),(64,"Wallace",3),(65,"Vaughan",55),(66,"Blair",40),(67,"Mohammad",74),(68,"Tatum",84),(69,"Barrett",16),(70,"Burton",69);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (71,"Mikayla",85),(72,"Lillith",30),(73,"Pearl",73),(74,"Zoe",56),(75,"Joelle",40),(76,"Axel",60),(77,"Jennifer",21),(78,"Levi",36),(79,"Ariel",7),(80,"Nadine",14);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (81,"Louis",71),(82,"Odessa",67),(83,"Megan",64),(84,"Beau",85),(85,"Jocelyn",31),(86,"Theodore",7),(87,"Hadley",95),(88,"Craig",68),(89,"Rhiannon",51),(90,"Fletcher",32);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (91,"Jelani",3),(92,"Carl",33),(93,"Melodie",55),(94,"Marvin",9),(95,"Caesar",38),(96,"Finn",20),(97,"Raymond",80),(98,"Xyla",41),(99,"Virginia",90),(100,"Linda",63);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (101,"Jacob",91),(102,"Derek",70),(103,"Kirby",5),(104,"Damon",68),(105,"Sybil",81),(106,"Octavius",54),(107,"Nomlanga",27),(108,"Vera",64),(109,"Marcia",74),(110,"Rhea",48);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (111,"Lavinia",58),(112,"Desiree",94),(113,"Imogene",42),(114,"Channing",61),(115,"Lilah",51),(116,"Christopher",89),(117,"Ebony",27),(118,"Olga",62),(119,"Quentin",100),(120,"Hadley",45);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (121,"Igor",42),(122,"Louis",15),(123,"Jin",19),(124,"Hyacinth",94),(125,"Donna",73),(126,"Keaton",8),(127,"Illiana",52),(128,"Hedwig",31),(129,"Ronan",50),(130,"Samuel",28);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (131,"Mikayla",62),(132,"Kylee",11),(133,"Irma",49),(134,"Joelle",8),(135,"Regan",88),(136,"Kyra",19),(137,"Pandora",54),(138,"Cadman",3),(139,"Dalton",42),(140,"Nichole",55);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (141,"Shaine",98),(142,"Portia",27),(143,"Knox",71),(144,"Serena",82),(145,"Tad",94),(146,"Barry",67),(147,"Raja",9),(148,"Hector",47),(149,"Galena",63),(150,"Patricia",28);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (151,"Sloane",90),(152,"Tanisha",52),(153,"Armando",86),(154,"Irma",9),(155,"Moses",26),(156,"Luke",3),(157,"Catherine",53),(158,"Sloane",100),(159,"Hayes",59),(160,"Hop",2);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (161,"Roary",3),(162,"Hoyt",13),(163,"Camille",49),(164,"Hollee",38),(165,"August",44),(166,"Reuben",9),(167,"David",59),(168,"Rashad",72),(169,"Lila",8),(170,"Desirae",32);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (171,"Kiayada",28),(172,"Malik",62),(173,"Tanner",17),(174,"Carlos",59),(175,"Lenore",70),(176,"Ronan",1),(177,"Calvin",35),(178,"Uriah",38),(179,"Lysandra",31),(180,"Buckminster",13);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (181,"Vernon",81),(182,"Stewart",68),(183,"Dieter",97),(184,"Armand",8),(185,"Montana",99),(186,"Adrienne",17),(187,"Isadora",2),(188,"Dexter",82),(189,"Macaulay",79),(190,"Louis",17);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (191,"Dylan",66),(192,"Nicole",51),(193,"Morgan",82),(194,"Kyla",25),(195,"Isaac",77),(196,"Heather",47),(197,"Melodie",66),(198,"Ross",69),(199,"Steel",35),(200,"Mariam",84);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (201,"Zeus",35),(202,"Fritz",65),(203,"Farrah",70),(204,"Keaton",41),(205,"Maris",3),(206,"Lee",59),(207,"Allen",6),(208,"Magee",38),(209,"Cameron",27),(210,"Norman",25);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (211,"Xyla",75),(212,"Uma",31),(213,"Larissa",98),(214,"Meredith",80),(215,"Brenden",64),(216,"Blythe",80),(217,"Thomas",25),(218,"Cadman",98),(219,"Yeo",6),(220,"Herman",68);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (221,"Brendan",14),(222,"Ryan",33),(223,"Norman",47),(224,"Bethany",91),(225,"Camden",3),(226,"Kareem",14),(227,"Ronan",59),(228,"Jack",34),(229,"Arsenio",100),(230,"Keane",9);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (231,"Marsden",2),(232,"Azalia",2),(233,"Nadine",57),(234,"Wynter",38),(235,"Anjolie",2),(236,"Iris",13),(237,"Noel",28),(238,"Regina",44),(239,"Wade",50),(240,"Lucas",43);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (241,"Noelle",80),(242,"Ferdinand",10),(243,"Quentin",79),(244,"Allegra",29),(245,"Jana",71),(246,"Aretha",65),(247,"Ferris",13),(248,"Boris",96),(249,"Savannah",12),(250,"Jackson",44);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (251,"Cody",38),(252,"Conan",95),(253,"Brennan",46),(254,"Michael",9),(255,"Nolan",75),(256,"Fuller",16),(257,"Hu",78),(258,"Cheyenne",10),(259,"Camille",90),(260,"Lionel",96);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (261,"Dustin",62),(262,"Georgia",49),(263,"Dawn",69),(264,"Aileen",87),(265,"Ulric",48),(266,"Dexter",2),(267,"Harlan",61),(268,"Rebekah",49),(269,"Kirk",1),(270,"Tanner",55);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (271,"Reagan",93),(272,"Odette",100),(273,"Ivor",92),(274,"Quincy",58),(275,"Diana",75),(276,"Madaline",49),(277,"Andrew",33),(278,"Len",38),(279,"Willa",73),(280,"Xanthus",81);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (281,"Benjamin",56),(282,"Laith",8),(283,"Fitzgerald",9),(284,"Emi",89),(285,"Tucker",14),(286,"Sheila",63),(287,"Eric",49),(288,"Ivan",92),(289,"Martin",34),(290,"Jacqueline",79);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (291,"Maisie",49),(292,"Honorato",46),(293,"Callie",43),(294,"Shannon",93),(295,"Kaden",100),(296,"Chaim",19),(297,"Farrah",37),(298,"Cedric",93),(299,"Roth",73),(300,"Berk",3);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (301,"Olga",27),(302,"Oliver",50),(303,"Ignatius",53),(304,"Evelyn",74),(305,"Stuart",47),(306,"Karly",82),(307,"Ian",72),(308,"Sophia",21),(309,"Graham",34),(310,"Jillian",35);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (311,"Martin",32),(312,"Eugenia",24),(313,"Imelda",19),(314,"Hadassah",18),(315,"Ali",33),(316,"Prescott",48),(317,"Kelly",9),(318,"Erasmus",71),(319,"Amaya",31),(320,"Valentine",93);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (321,"Kasimir",38),(322,"Kylee",5),(323,"Stephanie",73),(324,"Amir",8),(325,"Cleo",95),(326,"Aiko",30),(327,"Hedwig",22),(328,"Isabella",90),(329,"Drew",80),(330,"August",18);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (331,"Hollee",73),(332,"Shana",14),(333,"Malachi",43),(334,"Kylan",6),(335,"Wynter",92),(336,"Cade",34),(337,"Ruth",19),(338,"Harlan",33),(339,"Kennedy",54),(340,"Nissim",88);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (341,"Ezra",86),(342,"Dean",14),(343,"Rashad",57),(344,"Solomon",7),(345,"Jack",36),(346,"Merritt",90),(347,"Aladdin",54),(348,"Conan",62),(349,"Abra",33),(350,"Gisela",61);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (351,"William",16),(352,"Lee",30),(353,"Cecilia",49),(354,"Len",89),(355,"Cailin",11),(356,"Duncan",50),(357,"Fulton",2),(358,"Bernard",34),(359,"Zena",6),(360,"Quinlan",74);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (361,"Kyla",70),(362,"Cedric",63),(363,"Paki",18),(364,"Gary",31),(365,"Octavia",2),(366,"Rana",5),(367,"Lisandra",74),(368,"Ulysses",28),(369,"Veda",5),(370,"Avram",90);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (371,"Vivien",70),(372,"Acton",2),(373,"Holly",57),(374,"Micah",92),(375,"Kristen",19),(376,"Britanni",82),(377,"Lael",17),(378,"Lance",5),(379,"Barry",22),(380,"Jaquelyn",45);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (381,"Hollee",77),(382,"Rosalyn",48),(383,"Ciaran",41),(384,"Bruce",71),(385,"Nicholas",12),(386,"Lacey",42),(387,"Elvis",58),(388,"Bryar",1),(389,"Leila",37),(390,"Nash",82);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (391,"Regan",20),(392,"Erin",44),(393,"Carl",33),(394,"Helen",52),(395,"Tatum",6),(396,"Dahlia",15),(397,"Azalia",1),(398,"Oliver",86),(399,"Raya",56),(400,"Francesca",89);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (401,"Idona",75),(402,"Xena",23),(403,"Whitney",90),(404,"Dominique",29),(405,"Theodore",70),(406,"Simon",79),(407,"April",75),(408,"Tana",27),(409,"Thor",38),(410,"Quyn",20);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (411,"Acton",86),(412,"Rebekah",64),(413,"Sarah",4),(414,"Damian",40),(415,"Keane",4),(416,"Adele",7),(417,"Byron",11),(418,"Shana",45),(419,"Xander",65),(420,"Eugenia",42);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (421,"May",52),(422,"Anika",41),(423,"Dylan",76),(424,"Otto",43),(425,"Nathaniel",45),(426,"Christopher",10),(427,"Deacon",56),(428,"Aristotle",25),(429,"Tyler",17),(430,"Sonia",45);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (431,"Sharon",63),(432,"Nina",63),(433,"Regina",59),(434,"Burke",37),(435,"Zeph",57),(436,"Inga",74),(437,"Bo",83),(438,"Paloma",3),(439,"Macon",74),(440,"Victor",49);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (441,"Emery",46),(442,"Garrett",43),(443,"Britanni",4),(444,"Jade",62),(445,"Cairo",11),(446,"Sylvia",100),(447,"Shana",39),(448,"Wang",75),(449,"Nero",3),(450,"Kendall",49);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (451,"Trevor",34),(452,"Liberty",12),(453,"Timothy",58),(454,"Yoko",82),(455,"Aladdin",57),(456,"Silas",64),(457,"Bell",26),(458,"Abraham",21),(459,"Elaine",4),(460,"Octavius",5);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (461,"Ursula",25),(462,"Gillian",88),(463,"Shay",35),(464,"Lysandra",15),(465,"Elaine",23),(466,"Echo",72),(467,"Lilah",10),(468,"Stacy",41),(469,"Conan",72),(470,"Kim",11);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (471,"Ashton",99),(472,"Nevada",85),(473,"Candice",37),(474,"Cruz",3),(475,"Meredith",3),(476,"Malik",48),(477,"Sydney",51),(478,"Gwendolyn",61),(479,"Yardley",23),(480,"Catherine",32);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (481,"Flynn",54),(482,"Connor",13),(483,"Celeste",39),(484,"Louis",49),(485,"Selma",94),(486,"Neil",31),(487,"James",96),(488,"Christine",1),(489,"Whilemina",27),(490,"Melvin",91);
INSERT INTO `Users` (`UserId`,`UserName`,`User_PlatformIdUser`) VALUES (491,"Nash",62),(492,"Orli",9),(493,"Malik",57),(494,"Iola",63),(495,"Zachery",66),(496,"Kibo",49),(497,"Quynn",83),(498,"Karen",48),(499,"Karina",13),(500,"Keane",13);

-- -----------------------------------------------------
-- Table `Detect`.`FeatureTypes`
-- -----------------------------------------------------

INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (401,"###","Lorem ipsum"),(402,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(403,"###","Lorem ipsum"),(404,"###","Lorem ipsum dolor sit"),(405,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(406,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(407,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(408,"###","Lorem ipsum dolor sit amet,"),(409,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(410,"###","Lorem ipsum");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (411,"###","Lorem ipsum dolor sit"),(412,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(413,"###","Lorem ipsum dolor sit"),(414,"###","Lorem"),(415,"###","Lorem ipsum dolor sit amet, consectetuer"),(416,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(417,"###","Lorem"),(418,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(419,"###","Lorem ipsum dolor sit"),(420,"###","Lorem ipsum dolor sit");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (421,"###","Lorem ipsum dolor sit amet, consectetuer"),(422,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(423,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(424,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(425,"###","Lorem ipsum dolor"),(426,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(427,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(428,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(429,"###","Lorem ipsum dolor"),(430,"###","Lorem ipsum");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (431,"###","Lorem ipsum"),(432,"###","Lorem ipsum dolor sit amet,"),(433,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(434,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(435,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(436,"###","Lorem ipsum dolor"),(437,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(438,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(439,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(440,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (441,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(442,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(443,"###","Lorem ipsum dolor sit amet,"),(444,"###","Lorem ipsum dolor sit amet,"),(445,"###","Lorem"),(446,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(447,"###","Lorem ipsum dolor sit amet, consectetuer"),(448,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(449,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(450,"###","Lorem ipsum dolor sit amet,");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (451,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(452,"###","Lorem ipsum dolor sit amet,"),(453,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(454,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(455,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(456,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(457,"###","Lorem ipsum dolor sit amet, consectetuer"),(458,"###","Lorem ipsum dolor sit amet,"),(459,"###","Lorem ipsum"),(460,"###","Lorem ipsum dolor sit amet,");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (461,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(462,"###","Lorem ipsum dolor sit"),(463,"###","Lorem ipsum dolor"),(464,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(465,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(466,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(467,"###","Lorem ipsum"),(468,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(469,"###","Lorem ipsum dolor sit amet, consectetuer"),(470,"###","Lorem");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (471,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(472,"###","Lorem ipsum dolor sit amet,"),(473,"###","Lorem ipsum dolor"),(474,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(475,"###","Lorem ipsum dolor"),(476,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(477,"###","Lorem ipsum dolor sit"),(478,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(479,"###","Lorem"),(480,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (481,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(482,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(483,"###","Lorem ipsum dolor sit amet, consectetuer"),(484,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(485,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(486,"###","Lorem ipsum dolor sit amet,"),(487,"###","Lorem ipsum dolor sit amet,"),(488,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(489,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(490,"###","Lorem ipsum");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeId`,`FeatureTypeName`,`FeatureTypeDescription`) VALUES (491,"###","Lorem ipsum dolor sit amet, consectetuer"),(492,"###","Lorem ipsum dolor"),(493,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(494,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(495,"###","Lorem ipsum dolor sit"),(496,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(497,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(498,"###","Lorem ipsum dolor sit amet, consectetuer"),(499,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(500,"###","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur");

-- -----------------------------------------------------
-- Table `Detect`.`Features`
-- -----------------------------------------------------

INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (1,34,"0.99","0.09","0.41","0.96"),(2,9,"0.01","0.61","0.81","0.84"),(3,60,"0.08","0.85","0.38","0.36"),(4,51,"0.90","0.36","0.53","0.97"),(5,35,"0.67","0.79","0.72","0.07"),(6,70,"0.78","0.26","0.54","0.69"),(7,12,"0.39","0.54","0.70","0.85"),(8,87,"0.05","0.50","0.55","0.70"),(9,24,"0.08","0.49","0.64","0.32"),(10,78,"0.95","0.71","0.79","0.52");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (11,11,"0.77","0.05","0.42","0.89"),(12,84,"0.90","0.64","0.46","0.79"),(13,83,"0.12","0.37","0.09","0.31"),(14,2,"0.00","0.99","0.27","0.66"),(15,40,"0.47","0.53","0.09","0.13"),(16,61,"0.67","0.29","0.92","0.84"),(17,30,"0.31","0.04","0.37","0.06"),(18,84,"0.52","0.60","1","0.72"),(19,16,"0.65","0.79","0.63","0.65"),(20,19,"0.80","0.20","0.16","0.95");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (21,43,"0.79","0.54","0.86","0.76"),(22,35,"0.81","0.41","0.74","0.57"),(23,34,"0.17","0.77","0.86","0.77"),(24,34,"0.20","0.34","0.69","0.85"),(25,92,"0.53","0.99","0.06","0.70"),(26,99,"0.15","0.87","0.77","0.93"),(27,51,"0.22","0.35","0.11","0.87"),(28,66,"0.94","0.59","0.77","0.27"),(29,78,"0.92","0.76","0.53","0.74"),(30,83,"0.84","0.88","0.32","0.80");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (31,4,"0.77","0.90","0.03","0.08"),(32,60,"0.19","0.92","0.80","0.80"),(33,10,"0.26","0.34","0.74","0.07"),(34,82,"0.10","0.43","0.63","0.58"),(35,47,"0.19","0.68","0.35","0.89"),(36,15,"0.13","0.14","1","0.52"),(37,44,"0.18","0.63","0.51","0.27"),(38,83,"0.99","0.70","0.85","0.83"),(39,65,"0.95","0.17","0.99","0.35"),(40,17,"0.55","0.00","0.19","0.61");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (41,65,"0.67","0.97","0.16","0.37"),(42,22,"0.98","0.82","0.97","0.60"),(43,85,"0.51","0.99","0.50","0.04"),(44,16,"0.07","0.56","0.08","0.26"),(45,96,"0.59","0.79","0.96","0.47"),(46,42,"0.93","0.84","0.17","0.42"),(47,4,"0.69","0.63","0.05","0.81"),(48,74,"0.81","0.05","0.77","0.48"),(49,56,"0.74","0.40","0.97","0.65"),(50,46,"0.75","0.66","0.57","0.44");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (51,74,"0.64","0.61","0.85","0.32"),(52,61,"0.12","0.16","0.07","0.19"),(53,99,"0.13","0.66","0.12","0.13"),(54,69,"0.57","0.00","0.91","0.17"),(55,37,"0.66","0.97","0.93","0.42"),(56,38,"0.78","0.63","0.19","0.78"),(57,66,"0.60","0.88","0.06","0.93"),(58,98,"0.66","0.10","0.29","0.07"),(59,43,"0.30","0.74","0.25","0.65"),(60,84,"0.38","0.41","0.64","0.49");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (61,51,"0.48","0.27","0.96","0.15"),(62,7,"1","0.55","0.99","0.69"),(63,85,"0.86","0.13","0.91","0.40"),(64,22,"0.06","0.60","0.20","0.44"),(65,78,"0.47","0.56","0.94","0.03"),(66,93,"0.15","0.17","0.78","0.90"),(67,50,"0.46","0.45","0.88","0.28"),(68,38,"0.23","0.08","0.24","0.06"),(69,49,"0.32","0.65","0.23","0.73"),(70,14,"0.89","0.60","0.88","0.70");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (71,59,"0.38","0.63","0.89","0.23"),(72,38,"0.63","0.95","0.06","0.07"),(73,95,"0.63","0.56","0.51","0.33"),(74,40,"0.45","0.54","0.17","0.82"),(75,97,"0.23","0.42","0.63","0.47"),(76,77,"0.18","0.66","0.61","0.15"),(77,61,"0.15","0.59","0.65","0.95"),(78,41,"0.68","0.43","0.86","0.63"),(79,57,"0.20","0.03","0.49","0.07"),(80,81,"0.16","0.29","0.69","0.11");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (81,22,"0.62","0.01","0.80","0.57"),(82,70,"0.62","0.57","0.86","0.60"),(83,61,"0.03","0.75","0.39","0.80"),(84,49,"0.64","1","0.86","0.45"),(85,87,"0.04","0.71","0.93","0.96"),(86,14,"0.45","0.19","0.81","0.56"),(87,15,"0.79","0.16","0.39","0.78"),(88,40,"0.61","0.58","0.02","0.63"),(89,84,"0.86","0.39","0.82","0.64"),(90,26,"0.36","0.03","0.49","0.81");
INSERT IGNORE INTO `Features` (`FeatureId`,`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (91,13,"0.85","0.18","0.27","0.38"),(92,28,"0.63","0.46","0.61","0.15"),(93,41,"0.26","0.82","0.65","0.11"),(94,68,"0.92","0.06","0.27","0.61"),(95,90,"0.51","0.99","0.91","0.87"),(96,21,"0.68","0.88","0.52","0.14"),(97,67,"0.71","0.97","0.33","0.29"),(98,9,"1","0.14","0.61","0.77"),(99,85,"0.56","0.52","0.36","0.86"),(100,13,"0.38","0.29","0.59","0.17");

-- -----------------------------------------------------
-- Table `Detect`.`RelTypes`
-- -----------------------------------------------------

INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (1,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(2,"follower","Lorem ipsum"),(3,"friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(4,"follower","Lorem"),(5,"acquaintance","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(6,"hater","Lorem ipsum dolor sit amet,"),(7,"friend","Lorem ipsum dolor"),(8,"friend","Lorem ipsum"),(9,"hater","Lorem ipsum dolor sit"),(10,"hater","Lorem ipsum dolor sit amet, consectetuer adipiscing");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (11,"friend","Lorem ipsum dolor sit amet,"),(12,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(13,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(14,"acquaintance","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(15,"hater","Lorem ipsum"),(16,"acquaintance","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(17,"friend of friend","Lorem ipsum dolor sit amet, consectetuer"),(18,"acquaintance","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(19,"follower","Lorem ipsum"),(20,"friend of friend","Lorem ipsum dolor sit amet,");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (21,"hater","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(22,"friend","Lorem"),(23,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(24,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(25,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(26,"acquaintance","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(27,"friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(28,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(29,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(30,"acquaintance","Lorem ipsum dolor sit amet, consectetuer");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (31,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(32,"hater","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(33,"hater","Lorem ipsum dolor sit amet, consectetuer"),(34,"friend","Lorem ipsum"),(35,"acquaintance","Lorem ipsum dolor"),(36,"friend of friend","Lorem ipsum dolor sit"),(37,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(38,"friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(39,"friend of friend","Lorem ipsum dolor sit"),(40,"friend","Lorem ipsum dolor sit amet, consectetuer");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (41,"acquaintance","Lorem ipsum dolor"),(42,"acquaintance","Lorem ipsum dolor sit amet,"),(43,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(44,"follower","Lorem ipsum"),(45,"acquaintance","Lorem ipsum"),(46,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(47,"acquaintance","Lorem"),(48,"acquaintance","Lorem ipsum"),(49,"friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(50,"friend of friend","Lorem ipsum dolor sit amet,");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (51,"friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(52,"follower","Lorem ipsum dolor sit amet,"),(53,"friend of friend","Lorem ipsum dolor sit amet, consectetuer"),(54,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(55,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(56,"hater","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(57,"friend of friend","Lorem ipsum"),(58,"follower","Lorem ipsum dolor"),(59,"hater","Lorem ipsum dolor sit amet,"),(60,"hater","Lorem ipsum dolor sit amet,");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (61,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(62,"friend","Lorem ipsum"),(63,"friend of friend","Lorem ipsum"),(64,"follower","Lorem ipsum dolor"),(65,"friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(66,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(67,"follower","Lorem"),(68,"hater","Lorem ipsum dolor sit"),(69,"friend of friend","Lorem ipsum"),(70,"hater","Lorem ipsum dolor sit");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (71,"acquaintance","Lorem ipsum dolor sit"),(72,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(73,"hater","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(74,"friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(75,"follower","Lorem ipsum"),(76,"friend","Lorem ipsum dolor"),(77,"acquaintance","Lorem ipsum"),(78,"friend of friend","Lorem ipsum"),(79,"friend","Lorem ipsum dolor sit amet,"),(80,"follower","Lorem ipsum dolor sit amet,");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (81,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(82,"friend of friend","Lorem ipsum dolor sit amet, consectetuer"),(83,"follower","Lorem ipsum"),(84,"acquaintance","Lorem ipsum dolor sit amet,"),(85,"follower","Lorem ipsum"),(86,"friend","Lorem"),(87,"follower","Lorem ipsum dolor sit amet,"),(88,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(89,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(90,"friend","Lorem ipsum dolor sit amet, consectetuer adipiscing");
INSERT INTO `RelTypes` (`RelTypeId`,`RelTypeName`,`RelTypeDescription`) VALUES (91,"hater","Lorem ipsum dolor sit amet, consectetuer adipiscing elit."),(92,"follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed"),(93,"follower","Lorem ipsum dolor sit amet, consectetuer"),(94,"acquaintance","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur"),(95,"hater","Lorem ipsum dolor sit amet,"),(96,"friend","Lorem ipsum dolor sit amet,"),(97,"acquaintance","Lorem ipsum"),(98,"hater","Lorem ipsum dolor sit amet, consectetuer adipiscing"),(99,"hater","Lorem ipsum dolor sit amet, consectetuer"),(100,"hater","Lorem");

-- -----------------------------------------------------
-- Associative Table `Detect`.`Relationships`
-- -----------------------------------------------------

INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (1,93,85),(2,25,58),(3,71,13),(4,65,39),(5,40,53),(6,83,47),(7,20,57),(8,28,57),(9,15,19),(10,97,42);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (11,43,70),(12,64,24),(13,91,88),(14,8,53),(15,32,3),(16,52,83),(17,38,54),(18,88,5),(19,74,89),(20,59,19);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (21,35,85),(22,83,92),(23,82,34),(24,60,75),(25,55,68),(26,90,41),(27,77,75),(28,60,1),(29,53,84),(30,89,46);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (31,12,21),(32,26,78),(33,87,72),(34,93,8),(35,72,33),(36,100,100),(37,64,8),(38,82,18),(39,41,56),(40,26,13);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (41,39,13),(42,65,69),(43,18,65),(44,37,19),(45,77,68),(46,4,77),(47,18,57),(48,93,74),(49,76,76),(50,30,60);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (51,67,40),(52,86,89),(53,23,11),(54,78,3),(55,74,35),(56,61,68),(57,17,3),(58,62,64),(59,26,69),(60,83,5);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (61,89,33),(62,43,88),(63,64,64),(64,54,8),(65,35,76),(66,79,8),(67,11,76),(68,37,50),(69,18,96),(70,42,34);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (71,57,80),(72,93,70),(73,30,10),(74,63,90),(75,84,97),(76,38,5),(77,11,20),(78,84,29),(79,47,63),(80,32,39);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (81,10,80),(82,60,80),(83,17,44),(84,44,90),(85,47,50),(86,94,94),(87,59,80),(88,51,56),(89,89,95),(90,62,60);
INSERT INTO `Relationships` (`RelId`,`FriendId`,`RelType`) VALUES (91,32,36),(92,62,74),(93,35,85),(94,37,96),(95,93,93),(96,97,94),(97,72,49),(98,21,2),(99,18,63),(100,15,7);

-- -----------------------------------------------------
-- Table `Detect`.`Platforms`
-- -----------------------------------------------------

INSERT INTO `Platforms` (`PlatformId`,`PlatformName`,`User_PlatformIdPlatform`,`ApiFeatures`) VALUES (1,"Youtube",14,10),(2,"Orkut",41,3),(3,"Reddit",47,5),(4,"Facebook",27,8),(5,"Instagram",52,9),(6,"WeChat",100,6),(7,"GooglePlus",96,10),(8,"Reddit",64,6),(9,"Youtube",50,6),(10,"LinkedIn",59,7);

-- -----------------------------------------------------
-- Associative Table `Detect`.`User_Platform`
-- -----------------------------------------------------

INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (1,22,40,64,63),(2,5,90,17,67),(3,56,1,36,11),(4,59,2,88,31),(5,63,74,66,37),(6,71,88,94,62),(7,89,98,63,85),(8,71,39,26,92),(9,36,14,40,60),(10,81,42,92,25);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (11,87,22,64,100),(12,14,39,69,2),(13,15,95,11,83),(14,42,14,2,10),(15,2,80,85,26),(16,87,70,55,12),(17,34,82,5,70),(18,75,44,32,10),(19,44,73,7,19),(20,4,69,29,37);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (21,1,61,42,50),(22,43,41,81,17),(23,15,8,76,93),(24,9,16,14,4),(25,39,70,60,52),(26,6,30,17,44),(27,32,14,96,81),(28,27,10,27,82),(29,49,74,92,48),(30,59,99,48,74);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (31,23,23,20,32),(32,9,45,56,29),(33,13,42,53,1),(34,6,2,32,19),(35,77,23,5,14),(36,35,100,28,15),(37,67,61,91,79),(38,56,24,96,40),(39,61,14,41,91),(40,87,42,31,81);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (41,53,1,82,75),(42,59,66,64,74),(43,31,99,64,68),(44,9,99,81,42),(45,89,82,32,61),(46,88,77,65,85),(47,14,4,7,96),(48,81,85,2,33),(49,53,64,75,42),(50,36,44,91,83);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (51,16,83,71,46),(52,11,95,4,27),(53,55,23,81,92),(54,4,88,3,10),(55,16,88,75,59),(56,54,4,72,66),(57,3,23,93,32),(58,6,38,59,53),(59,75,34,9,8),(60,13,29,8,28);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (61,10,85,9,33),(62,10,45,60,37),(63,73,84,20,69),(64,57,41,59,72),(65,96,10,53,26),(66,86,73,42,18),(67,70,90,29,9),(68,16,81,24,43),(69,31,87,32,7),(70,92,77,63,15);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (71,30,42,62,99),(72,72,92,92,29),(73,92,35,80,29),(74,72,78,69,62),(75,29,95,45,85),(76,88,2,78,69),(77,30,15,18,23),(78,33,62,5,74),(79,89,92,86,65),(80,88,16,54,4);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (81,92,28,79,8),(82,69,55,95,52),(83,51,38,100,21),(84,86,100,68,88),(85,1,93,71,97),(86,48,71,67,16),(87,1,80,14,28),(88,35,67,68,87),(89,52,39,10,7),(90,22,43,32,86);
INSERT INTO `User_Platform` (`User_PlatformId`,`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (91,61,84,65,25),(92,4,50,77,58),(93,54,85,98,34),(94,65,84,55,24),(95,66,38,72,90),(96,51,9,95,66),(97,13,23,72,91),(98,91,59,83,63),(99,21,62,41,69),(100,18,27,95,70);


-- FINISHED POPULATING THE DATABASE -------------------------------

-- START GENERATING REPORTS ---------------------------------------

-- FINISHED GENERATING REPORTS ---------------------------------------