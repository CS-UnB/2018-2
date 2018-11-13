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
 `SupervisorCPF` VARCHAR(11) NOT NULL UNIQUE,
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

 `UserCPF` VARCHAR(11) NOT NULL,
 `UserIdentity` VARCHAR(255) NOT NULL,
  -- `UserFiliation` INT NOT NULL,
  `UserGender_id` INT NOT NULL,
  `UserCivilStatus_id` INT NOT NULL,
  -- `UserNaturality` INT NOT NULL,
  `UserCity_id` INT NOT NULL,
  -- `UserNeighborhood` INT NOT NULL,
  -- `UserState` INT NOT NULL,
  `UserFone_id` INT NOT NULL,
  -- `UserFU` INT NOT NULL,            			-- Unidade Federativa --
  `UserCountry_id` INT NOT NULL,
  -- `UserEMail` INT NOT NULL,
  -- `UserSchooling` INT NOT NULL,     			-- Escolaridade --
  -- `UserRole` VARCHAR(255) NOT NULL,			-- Cargo --
 
 `User_PlatformIdUser` INT,
 PRIMARY KEY (`UserId`),
 
 INDEX `User_PlatformIdUser_idx` (`User_PlatformIdUser` ASC),
 
 CONSTRAINT `User_PlatformIdUser`
 FOREIGN KEY (`User_PlatformIdUser`)
 REFERENCES `Detect`.`User_Platform` (`User_PlatformId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
  CONSTRAINT `Gender`
 FOREIGN KEY (`UserGender_id`)
 REFERENCES `Detect`.`Gender` (`GenderId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,

 CONSTRAINT `UserFone_id`
 FOREIGN KEY (`UserFone_id`)
 REFERENCES `Detect`.`Fone` (`FoneId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,

 CONSTRAINT `UserCountry_id`
 FOREIGN KEY (`UserCountry_id`)
 REFERENCES `Detect`.`Country` (`CountryId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
  CONSTRAINT `UserCity_id`
 FOREIGN KEY (`UserCity_id`)
 REFERENCES `Detect`.`City` (`CityId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,

 CONSTRAINT `UserCivilStatus_id`
 FOREIGN KEY (`UserCivilStatus_id`)
 REFERENCES `Detect`.`CivilStatus` (`CivilStatusId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 );


-- -----------------------------------------------------
--  Table `Detect`.`CivilStatus`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `Detect`.`CivilStatus`;

CREATE TABLE IF NOT EXISTS `Detect`.`CivilStatus` (
 `CivilStatusId` INT NOT NULL AUTO_INCREMENT,
 `CivilStatusDescription` VARCHAR(255),
 PRIMARY KEY (`CivilStatusId`)
);
-- -----------------------------------------------------
--  Table `Detect`.`Country`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `Detect`.`Country`;

CREATE TABLE IF NOT EXISTS `Detect`.`Country` (
 `CountryId` INT NOT NULL AUTO_INCREMENT,
 `CountryDescription` VARCHAR(255),
 PRIMARY KEY (`CountryId`)
);

-- -----------------------------------------------------
--  Table `Detect`.`Gender`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `Detect`.`Gender`;

CREATE TABLE IF NOT EXISTS `Detect`.`Gender` (
 `GenderId` INT NOT NULL AUTO_INCREMENT,
 `GenderDescription` VARCHAR(255),
 PRIMARY KEY (`GenderId`)
);
-- -----------------------------------------------------
--  Table `Detect`.`TypeFone`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `Detect`.`TypeFone`;

CREATE TABLE IF NOT EXISTS `Detect`.`TypeFone` (
 `TypeFoneId` INT NOT NULL AUTO_INCREMENT,
 `TypeFoneDescription` VARCHAR(255),
 PRIMARY KEY (`typeFoneId`)
);
-- -----------------------------------------------------
--  Table `Detect`.`Fone`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `Detect`.`Fone`;

CREATE TABLE IF NOT EXISTS `Detect`.`Fone` (
 `FoneId` INT NOT NULL AUTO_INCREMENT,
 `FoneNumber` VARCHAR(15),
 `FoneTypeFone_id` INT NOT NULL,
 PRIMARY KEY (`FoneId`),

 -- INDEX `FoneTypeFone_idx` (`TypeFone` ASC),

 CONSTRAINT `FoneTypeFone_id`
 FOREIGN KEY (`FoneTypeFone_id`)
 REFERENCES `Detect`.`TypeFone` (`TypeFoneId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT

);
-- -----------------------------------------------------
--  Table `Detect`.`UF`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `Detect`.`UF`;

CREATE TABLE IF NOT EXISTS `Detect`.`UF` (
 `UFId` INT NOT NULL AUTO_INCREMENT,
 `UFDescription` VARCHAR(255),
 PRIMARY KEY (`UFId`)

);

-- -----------------------------------------------------
--  Table `Detect`.`City`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `Detect`.`City`;

CREATE TABLE IF NOT EXISTS `Detect`.`City` (
 `CityId` INT NOT NULL AUTO_INCREMENT,
 `CityDescription` VARCHAR(255),
 `CityUF_id` INT NOT NULL,
 PRIMARY KEY (`CityId`),

 -- INDEX `City_idx` (`TypeFone` ASC),

 CONSTRAINT `CityUF_id`
 FOREIGN KEY (`CityUF_id`)
 REFERENCES `Detect`.`City` (`CityId`)
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
 `RelTypeName` VARCHAR(50) NOT NULL,
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
INSERT INTO `Companies` (`CompanyName`,`CompanyDescription`) VALUES ("Bang Bangs Company","Trabalhamos com produtos para cowboys");
INSERT INTO `Companies` (`CompanyName`,`CompanyDescription`) VALUES ("Compania de humanos","Uma compania perfeitamente normal com humanos normais e sem nenhum robô do espaço.");
INSERT INTO `Companies` (`CompanyName`,`CompanyDescription`) VALUES ("Hellwomann's","Fabricamos maioneses feministas");
INSERT INTO `Companies` (`CompanyName`,`CompanyDescription`) VALUES ("Google","eh soh pesquisar no google sobre a gente");

-- -----------------------------------------------------
-- Table `Detect`.`Roles`
-- -----------------------------------------------------

INSERT IGNORE INTO `Roles` (`RoleName`,`RoleDescription`) VALUES ("Research and Development","Sales and Marketing is their department.");
INSERT IGNORE INTO `Roles` (`RoleName`,`RoleDescription`) VALUES ("Vendas e Servicos","Trocam seus produtos e sua mão de obra por dinheiro.");
INSERT IGNORE INTO `Roles` (`RoleName`,`RoleDescription`) VALUES ("Outro","Assuntos aleatórios");
INSERT IGNORE INTO `Roles` (`RoleName`,`RoleDescription`) VALUES ("Desenvolvimento Sustentavel","Ajudam empresas a produzir de forma sustentavel");
INSERT IGNORE INTO `Roles` (`RoleName`,`RoleDescription`) VALUES ("Negócios","habilidades relacionadas, para performances de alto nivel em determinadas tarefas.");
-- -----------------------------------------------------
-- Table `Detect`.`Supervisors`
-- -----------------------------------------------------

INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES ("Charde","71912050247","6713","et@duinec.ca",1,5);
INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES ("Regina Case","41815402199","0666","esqenta@yahoo.co",1,4);
INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES ("Otto","07275680190","1234","golem@pedra.to",2,2);
INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES ("Antonio","49818451112","4321","toin@cjr.or",3,3);
INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`) VALUES ("Pedro","12947869602","1432","cheiroso@dez.ne",4,3);

-- -----------------------------------------------------
-- Table `Detect`.`Country`
-- -----------------------------------------------------
INSERT INTO `Country` (`CountryDescription`) VALUES ("Brasil");
INSERT INTO `Country` (`CountryDescription`) VALUES ("Rússia");
INSERT INTO `Country` (`CountryDescription`) VALUES ("Canadá");
INSERT INTO `Country` (`CountryDescription`) VALUES ("Estados Unidos");
INSERT INTO `Country` (`CountryDescription`) VALUES ("Japão");
-- -----------------------------------------------------
-- Table `Detect`.`City`
-- -----------------------------------------------------
INSERT INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Manaus", 1);
INSERT INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Belém", 2);
INSERT INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("São Luís", 3);
INSERT INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Texas", 4);
INSERT INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Alagoinhas", 5);
-- -----------------------------------------------------
-- Table `Detect`.`UF`
-- -----------------------------------------------------
INSERT INTO `UF` (`UFDescription`) VALUES ("PA");
INSERT INTO `UF` (`UFDescription`) VALUES ("MA");
INSERT INTO `UF` (`UFDescription`) VALUES ("IN");
INSERT INTO `UF` (`UFDescription`) VALUES ("TX");
INSERT INTO `UF` (`UFDescription`) VALUES ("DF");
-- -----------------------------------------------------
-- Table `Detect`.`Gender`
-- -----------------------------------------------------
INSERT INTO `Gender` (`GenderDescription`) VALUES ("Heterosexual");
INSERT INTO `Gender` (`GenderDescription`) VALUES ("Homosexual");
INSERT INTO `Gender` (`GenderDescription`) VALUES ("Bisexual");
INSERT INTO `Gender` (`GenderDescription`) VALUES ("Pansexual");
INSERT INTO `Gender` (`GenderDescription`) VALUES ("Apache Helicopter");
-- -----------------------------------------------------
-- Table `Detect`.`TypePhone`
-- -----------------------------------------------------
INSERT INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Comercial");
INSERT INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Pessoal");
INSERT INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Especial");
INSERT INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Secreto");
INSERT INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Outro");
-- -----------------------------------------------------
-- Table `Detect`.`Fone`
-- -----------------------------------------------------
INSERT INTO `Fone` (`FoneNumber`, `FoneTypeFone_id`) VALUES ("61981450180", 1);
INSERT INTO `Fone` (`FoneNumber`, `FoneTypeFone_id`) VALUES ("61961550180", 2);
INSERT INTO `Fone` (`FoneNumber`, `FoneTypeFone_id`) VALUES ("61991550180", 1);
INSERT INTO `Fone` (`FoneNumber`, `FoneTypeFone_id`) VALUES ("61981557180", 4);
INSERT INTO `Fone` (`FoneNumber`, `FoneTypeFone_id`) VALUES ("61981550181", 5);
-- -----------------------------------------------------
-- Table `Detect`.`UserCivilStatus`
-- -----------------------------------------------------
INSERT INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Solteiro");
INSERT INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Namorando");
INSERT INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Casado");
INSERT INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Enrolando");
INSERT INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Complicado");
-- -----------------------------------------------------
-- Table `Detect`.`Users`
-- -----------------------------------------------------

INSERT INTO `Users` (`UserName`, `UserCPF`, `UserIdentity`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCountry_id`, `UserCity_id`) VALUES ("Antonio H.", "12947968604", "12445678910", 1, 2, 1, 5, 1);
INSERT INTO `Users` (`UserName`, `UserCPF`, `UserIdentity`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCountry_id`, `UserCity_id`) VALUES ("Velma", "12947968603", "12345678910", 2, 1, 1, 4, 2);
INSERT INTO `Users` (`UserName`, `UserCPF`, `UserIdentity`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCountry_id`, `UserCity_id`) VALUES ("Fred", "12947968602", "12245678910", 3, 1, 1, 1, 3);
INSERT INTO `Users` (`UserName`, `UserCPF`, `UserIdentity`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCountry_id`, `UserCity_id`) VALUES ("Daphne", "12947968601", "12145678910", 4, 1, 1, 3, 4);
INSERT INTO `Users` (`UserName`, `UserCPF`, `UserIdentity`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCountry_id`, `UserCity_id`) VALUES ("Scooby", "12947968605", "12045678910", 2, 1, 1, 1, 5);

-- -----------------------------------------------------
-- Table `Detect`.`FeatureTypes`
-- -----------------------------------------------------

INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("Posting_Volume","Lorem ipsum");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("Posting_mass","Ipsum lorem");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("Posting_size","Losum iprem");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("Posting_density","Iprem losum");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("Posting_flavor","Lorem loren");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("Replies","Lorem loren");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("Questions","Lorem loren");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("PA","Lorem loren");
INSERT IGNORE INTO `FeatureTypes` (`FeatureTypeName`,`FeatureTypeDescription`) VALUES ("NA","Lorem loren");


-- -----------------------------------------------------
-- Table `Detect`.`Features`
-- -----------------------------------------------------

INSERT IGNORE INTO `Features` (`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (1,"0.99","0.09","0.41","0.96");
INSERT IGNORE INTO `Features` (`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (2,"0.98","0.08","0.40","0.95");
INSERT IGNORE INTO `Features` (`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (3,"0.97","0.07","0.39","0.94");
INSERT IGNORE INTO `Features` (`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (4,"0.96","0.06","0.38","0.93");
INSERT IGNORE INTO `Features` (`FeatureType`,`Mean`,`MeanMomentum`,`Variance`,`Entropy`) VALUES (5,"0.95","0.05","0.37","0.99");

-- -----------------------------------------------------
-- Table `Detect`.`Platforms`
-- -----------------------------------------------------

INSERT INTO `Platforms` (`PlatformName`) VALUES ("Youtube");
INSERT INTO `Platforms` (`PlatformName`) VALUES ("Orkut");
INSERT INTO `Platforms` (`PlatformName`) VALUES ("Reddit");
INSERT INTO `Platforms` (`PlatformName`) VALUES ("Facebook");
INSERT INTO `Platforms` (`PlatformName`) VALUES ("Instagram");

-- -----------------------------------------------------
-- Associative Table `Detect`.`Posts`
-- -----------------------------------------------------

INSERT INTO `Posts` (`PostText`, `PostLikes`, `Shares`, `Emotion`) VALUES ("Lorem Ipsum",1, 2, "Joy");
INSERT INTO `Posts` (`PostText`, `PostLikes`, `Shares`, `Emotion`) VALUES ("hoje eu to legal.", 0, 0, "Indifference");
INSERT INTO `Posts` (`PostText`, `PostLikes`, `Shares`, `Emotion`) VALUES ("Olha o meu almoço que interessante!", 300, 2, "Habituation");
INSERT INTO `Posts` (`PostText`, `PostLikes`, `Shares`, `Emotion`) VALUES ("Motivos para viajar para Manaus [parte 5]",7000000, 13954, "Curiosity");
INSERT INTO `Posts` (`PostText`, `PostLikes`, `Shares`, `Emotion`) VALUES ("Alguem sabe o nome desse moreninho de Ciencia da Computação?",22, 0, "Love");
-- -----------------------------------------------------
-- Table `Detect`.`RelTypes`
-- -----------------------------------------------------

INSERT INTO `RelTypes` (`RelTypeName`,`RelTypeDescription`) VALUES ("friend of friend","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur");
INSERT INTO `RelTypes` (`RelTypeName`,`RelTypeDescription`) VALUES ("friend","Lorem ipsum dolor sit amet,");
INSERT INTO `RelTypes` (`RelTypeName`,`RelTypeDescription`) VALUES ("acquaintance","Lorem ipsum dolor");
INSERT INTO `RelTypes` (`RelTypeName`,`RelTypeDescription`) VALUES ("follower","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed");
INSERT INTO `RelTypes` (`RelTypeName`,`RelTypeDescription`) VALUES ("same community","Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed");

-- -----------------------------------------------------
-- Associative Table `Detect`.`Relationships`
-- -----------------------------------------------------

INSERT INTO `Relationships` (`FriendId`,`RelType`) VALUES (1,1);
INSERT INTO `Relationships` (`FriendId`,`RelType`) VALUES (2,2);
INSERT INTO `Relationships` (`FriendId`,`RelType`) VALUES (3,3);
INSERT INTO `Relationships` (`FriendId`,`RelType`) VALUES (4,4);
INSERT INTO `Relationships` (`FriendId`,`RelType`) VALUES (5,5);


-- -----------------------------------------------------
-- Associative Table `Detect`.`User_Platform`
-- -----------------------------------------------------

INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`, `PostId`) VALUES (1,1,1,1,1);
INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`, `PostId`) VALUES (2,3,4,5,5);
INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`, `PostId`) VALUES (3,4,5,3,4);
INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`, `PostId`) VALUES (4,5,2,4,3);
INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`, `PostId`) VALUES (5,2,3,2,2);

-- FINISHED POPULATING THE DATABASE -------------------------------

-- START GENERATING REPORTS ---------------------------------------

-- FINISHED GENERATING REPORTS ---------------------------------------
