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
 `SupervisorCPF` VARCHAR(15) NOT NULL UNIQUE,
 `SupervisorPassword` VARCHAR(32) NOT NULL,
 `SupervisorUsername` VARCHAR(20) NOT NULL UNIQUE,
 `SupervisorCompany` INT NOT NULL,
 `SupervisorPosition` INT NOT NULL,
 `SupervisorCivilStatus_id` INT,
 `SupervisorCity_id` INT,
 `SupervisorFone_id` INT,
 `SupervisorGender_id` INT,
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
 ON UPDATE RESTRICT,
 
 CONSTRAINT `SupervisorGender_id`
 FOREIGN KEY (`SupervisorGender_id`)
 REFERENCES `Detect`.`Gender` (`GenderId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
 CONSTRAINT `SupervisorFone_id`
 FOREIGN KEY (`SupervisorFone_id`)
 REFERENCES `Detect`.`Fone` (`FoneId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,

 CONSTRAINT `SupervisorCity_id`
 FOREIGN KEY (`SupervisorCity_id`)
 REFERENCES `Detect`.`City` (`CityId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,

 CONSTRAINT `SupervisorCivilStatus_id`
 FOREIGN KEY (`SupervisorCivilStatus_id`)
 REFERENCES `Detect`.`CivilStatus` (`CivilStatusId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 
 );

-- -----------------------------------------------------
--  Table `Detect`.`TypeAddress`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`TypeAddress`;

CREATE TABLE IF NOT EXISTS `Detect`.`TypeAddress` (
 `TypeAddressId` INT NOT NULL AUTO_INCREMENT,
 `TypeAddressDescription` VARCHAR(255),
 PRIMARY KEY (`TypeAddressId`)
);

-- -----------------------------------------------------
--  Table `Detect`.`Addresss`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Address`;

CREATE TABLE IF NOT EXISTS `Detect`.`Address` (
 `AddressId` INT NOT NULL AUTO_INCREMENT,
 `AddressDescription` VARCHAR(255),
 `AddressTypeAddress_id` INT,
 `AddressDistrict_id` INT,
 PRIMARY KEY (`AddressId`),

 INDEX `AddressTypeAddress_idx` (`AddressTypeAddress_id` ASC),
 INDEX `AddressDistrict_idx` (`AddressDistrict_id` ASC),

 CONSTRAINT `AddressTypeAddress_id`
 FOREIGN KEY (`AddressTypeAddress_id`)
 REFERENCES `Detect`.`TypeAddress` (`TypeAddressId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,

 CONSTRAINT `AddressDistrict_id`
 FOREIGN KEY (`AddressDistrict_id`)
 REFERENCES `Detect`.`District` (`DistrictId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
);


-- -----------------------------------------------------
--  Table `Detect`.`Districts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`District`;

CREATE TABLE IF NOT EXISTS `Detect`.`District` (
 `DistrictId` INT NOT NULL AUTO_INCREMENT,
 `DistrictDescription` VARCHAR(255),
 `DistrictCity_id` INT,
 PRIMARY KEY (`DistrictId`),

 INDEX `DistrictCity_idx` (`DistrictCity_id` ASC),

 CONSTRAINT `DistrictCity_id`
 FOREIGN KEY (`DistrictCity_id`)
 REFERENCES `Detect`.`City` (`CityId`)
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
 `Country_id` INT,
 PRIMARY KEY (`UFId`),
 
 INDEX `Country_idx` (`Country_id` ASC),

 CONSTRAINT `Country_id`
 FOREIGN KEY (`Country_id`)
 REFERENCES `Detect`.`Country` (`CountryId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT

);

-- -----------------------------------------------------
--  Table `Detect`.`Citys`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`City`;

CREATE TABLE IF NOT EXISTS `Detect`.`City` (
 `CityId` INT NOT NULL AUTO_INCREMENT,
 `CityDescription` VARCHAR(255),
 `CityUF_id` INT,
 PRIMARY KEY (`CityId`),

 INDEX `CityUF_idx` (`CityUF_id` ASC),

 CONSTRAINT `CityUF_id`
 FOREIGN KEY (`CityUF_id`)
 REFERENCES `Detect`.`UF` (`UFId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT

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
--  Table `Detect`.`TypeFones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`TypeFone`;

CREATE TABLE IF NOT EXISTS `Detect`.`TypeFone` (
 `TypeFoneId` INT NOT NULL AUTO_INCREMENT,
 `TypeFoneDescription` VARCHAR(255),
 PRIMARY KEY (`typeFoneId`)
);

-- -----------------------------------------------------
--  Table `Detect`.`Fones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Detect`.`Fone`;

CREATE TABLE IF NOT EXISTS `Detect`.`Fone` (
 `FoneId` INT NOT NULL AUTO_INCREMENT,
 `FoneNumber` VARCHAR(15),
 `FoneTypeFone_id` INT,
 PRIMARY KEY (`FoneId`),

 INDEX `FoneTypeFone_idx` (`FoneTypeFone_id` ASC),

 CONSTRAINT `FoneTypeFone_id`
 FOREIGN KEY (`FoneTypeFone_id`)
 REFERENCES `Detect`.`TypeFone` (`TypeFoneId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT

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
--  Table `Detect`.`CivilStatus`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `Detect`.`CivilStatus`;

CREATE TABLE IF NOT EXISTS `Detect`.`CivilStatus` (
 `CivilStatusId` INT NOT NULL AUTO_INCREMENT,
 `CivilStatusDescription` VARCHAR(255),
 PRIMARY KEY (`CivilStatusId`)

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
 PRIMARY KEY (`PlatformId`)
 
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
 `RelType` INT,
 PRIMARY KEY (`RelId`),

 INDEX `RelType_idx` (`RelType` ASC),
 
 CONSTRAINT `RelType`
 FOREIGN KEY (`RelType`)
 REFERENCES `Detect`.`RelTypes` (`RelTypeId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT
 );
 
-- -----------------------------------------------------
-- Table `Detect`.`Posts`
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
 `Supervisors` INT,
 `Posts` INT,
 PRIMARY KEY (`User_PlatformId`),
 
 INDEX `UserId_idx` (`UserId` ASC),
 INDEX `PlatformId_idx` (`PlatformId` ASC),
 INDEX `Features_idx` (`Features` ASC),
 INDEX `Relationships_idx` (`Relationships` ASC),
 INDEX `Supervisors_idx` (`Supervisors` ASC),
 INDEX `Posts_idx` (`Posts` ASC),
 
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
 
 CONSTRAINT `Supervisors`
 FOREIGN KEY (`Supervisors`)
 REFERENCES `Detect`.`Supervisors` (`SupervisorId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,
 
 CONSTRAINT `Posts`
 FOREIGN KEY (`Posts`)
 REFERENCES `Detect`.`Posts` (`PostId`)
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
 `UserCPF` VARCHAR(15),
 `UserGender_id` INT,
 `UserFone_id` INT,
 `UserCity_id` INT,
 `UserCivilStatus_id` INT,
 PRIMARY KEY (`UserId`),

 CONSTRAINT `UserGender_id`
 FOREIGN KEY (`UserGender_id`)
 REFERENCES `Detect`.`Gender` (`GenderId`)
 ON DELETE RESTRICT
 ON UPDATE RESTRICT,

 CONSTRAINT `UserFone_id`
 FOREIGN KEY (`UserFone_id`)
 REFERENCES `Detect`.`Fone` (`FoneId`)
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
 

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
-- FINISHED BUILDING THE DATABASE ---------------------------------


-- START POPULATING THE DATABASE ----------------------------------

-- -----------------------------------------------------
-- Table `Detect`.`Companies`
-- -----------------------------------------------------
INSERT INTO `Companies` (`CompanyName`,`CompanyDescription`) VALUES ("Scelerisque Neque Sed Limited","Descricao generica sobre empresa tosca");
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

INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`, `SupervisorCivilStatus_id`, `SupervisorCity_id`, `SupervisorFone_id`, `SupervisorGender_id`) VALUES ("Charde","71912050247","6713","et@duinec.ca", 1, 3, 1, 2, 2, 1);
INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`, `SupervisorCivilStatus_id`, `SupervisorCity_id`, `SupervisorFone_id`, `SupervisorGender_id`) VALUES ("Regina Case","41815402199","0666","esqenta@yahoo.co",2, 3, 1, 2, 3, 2);
INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`, `SupervisorCivilStatus_id`, `SupervisorCity_id`, `SupervisorFone_id`, `SupervisorGender_id`) VALUES ("Otto","07275680190","1234","golem@pedra.to",2, 3, 2, 3, 2, 1);
INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`, `SupervisorCivilStatus_id`, `SupervisorCity_id`, `SupervisorFone_id`, `SupervisorGender_id`) VALUES ("Antonio","49818451112","4321","toin@cjr.or",3, 2, 3, 2, 1, 1);
INSERT IGNORE INTO `Supervisors` (`SupervisorName`,`SupervisorCPF`,`SupervisorPassword`,`SupervisorUsername`,`SupervisorCompany`,`SupervisorPosition`, `SupervisorCivilStatus_id`, `SupervisorCity_id`, `SupervisorFone_id`, `SupervisorGender_id`) VALUES ("Pedro","12947869602","1432","cheiroso@dez.ne", 3, 1, 2, 2, 1, 3);

-- -----------------------------------------------------
--  Table `Detect`.`Districts`
-- -----------------------------------------------------

INSERT IGNORE INTO `District` (`DistrictDescription`) VALUES ("Distrito Perigoso");
INSERT IGNORE INTO `District` (`DistrictDescription`) VALUES ("Distrito Calmo");
INSERT IGNORE INTO `District` (`DistrictDescription`) VALUES ("Distrito 13");

-- -----------------------------------------------------
--  Table `Detect`.`TypeAddress`
-- -----------------------------------------------------

INSERT IGNORE INTO `TypeAddress` (`TypeAddressDescription`) VALUES ("Residencial");
INSERT IGNORE INTO `TypeAddress` (`TypeAddressDescription`) VALUES ("Profissional");
INSERT IGNORE INTO `TypeAddress` (`TypeAddressDescription`) VALUES ("Outro");

-- -----------------------------------------------------
--  Table `Detect`.`Addresss`
-- -----------------------------------------------------

INSERT IGNORE INTO `Address` (`AddressDescription`,`AddressTypeAddress_id`,`AddressDistrict_id`) VALUES ("QSS 123 RUA 34 CASA 54", 1, 3);
INSERT IGNORE INTO `Address` (`AddressDescription`,`AddressTypeAddress_id`,`AddressDistrict_id`) VALUES ("QSS 12 RUA 56 CASA 52", 2, 3);
INSERT IGNORE INTO `Address` (`AddressDescription`,`AddressTypeAddress_id`,`AddressDistrict_id`) VALUES ("QSS 1 RUA 61 CASA 65", 2, 3);
INSERT IGNORE INTO `Address` (`AddressDescription`,`AddressTypeAddress_id`,`AddressDistrict_id`) VALUES ("QSS 321 RUA 56 CASA 12", 3, 2);
INSERT IGNORE INTO `Address` (`AddressDescription`,`AddressTypeAddress_id`,`AddressDistrict_id`) VALUES ("QSS 13 RUA 06 CASA 10", 2, 2);
INSERT IGNORE INTO `Address` (`AddressDescription`,`AddressTypeAddress_id`,`AddressDistrict_id`) VALUES ("QSS 32 RUA 45 CASA 09", 1, 1);
INSERT IGNORE INTO `Address` (`AddressDescription`,`AddressTypeAddress_id`,`AddressDistrict_id`) VALUES ("QSS 33 RUA 23 CASA 05", 1, 1);
INSERT IGNORE INTO `Address` (`AddressDescription`,`AddressTypeAddress_id`,`AddressDistrict_id`) VALUES ("QSS 23 RUA 64 CASA 02", 3, 1);

-- -----------------------------------------------------
--  Table `Detect`.`UF`
-- -----------------------------------------------------

INSERT IGNORE INTO `UF` (`UFDescription`, `Country_id`) VALUES ("DF", 1);
INSERT IGNORE INTO `UF` (`UFDescription`, `Country_id`) VALUES ("BH", 1);
INSERT IGNORE INTO `UF` (`UFDescription`, `Country_id`) VALUES ("PI", 1);
INSERT IGNORE INTO `UF` (`UFDescription`, `Country_id`) VALUES ("PA", 1);
INSERT IGNORE INTO `UF` (`UFDescription`, `Country_id`) VALUES ("GO", 1);

-- -----------------------------------------------------
--  Table `Detect`.`Citys`
-- -----------------------------------------------------

INSERT IGNORE INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Plano Piloto", 1);
INSERT IGNORE INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Salador", 2);
INSERT IGNORE INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Bom Jesus", 3);
INSERT IGNORE INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Seilalandia", 4);
INSERT IGNORE INTO `City` (`CityDescription`, `CityUF_id`) VALUES ("Planaltina", 5);

-- -----------------------------------------------------
--  Table `Detect`.`Country`
-- -----------------------------------------------------

INSERT IGNORE INTO `Country` (`CountryDescription`) VALUES ("Brasil");

-- -----------------------------------------------------
--  Table `Detect`.`TypeFones`
-- -----------------------------------------------------

INSERT IGNORE INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Residencial");
INSERT IGNORE INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Empresa");
INSERT IGNORE INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Celular");
INSERT IGNORE INTO `TypeFone` (`TypeFoneDescription`) VALUES ("Outro");

-- -----------------------------------------------------
--  Table `Detect`.`Fones`
-- -----------------------------------------------------

INSERT IGNORE INTO `Fone` (`FoneNumber`,`FoneTypeFone_id`) VALUES ("1234-3121", 1);
INSERT IGNORE INTO `Fone` (`FoneNumber`,`FoneTypeFone_id`) VALUES ("7894-8562", 2);
INSERT IGNORE INTO `Fone` (`FoneNumber`,`FoneTypeFone_id`) VALUES ("4567-2443", 2);
INSERT IGNORE INTO `Fone` (`FoneNumber`,`FoneTypeFone_id`) VALUES ("2577-2211", 3);
INSERT IGNORE INTO `Fone` (`FoneNumber`,`FoneTypeFone_id`) VALUES ("6537-2211", 3);
INSERT IGNORE INTO `Fone` (`FoneNumber`,`FoneTypeFone_id`) VALUES ("4567-2416", 4);

-- -----------------------------------------------------
--  Table `Detect`.`Gender`
-- -----------------------------------------------------

INSERT IGNORE INTO `Gender` (`GenderDescription`) VALUES ("Masculino");
INSERT IGNORE INTO `Gender` (`GenderDescription`) VALUES ("Feminino");
INSERT IGNORE INTO `Gender` (`GenderDescription`) VALUES ("Outro");

-- -----------------------------------------------------
--  Table `Detect`.`CivilStatus`
-- -----------------------------------------------------

INSERT IGNORE INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Solteiro");
INSERT IGNORE INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Casado");
INSERT IGNORE INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Viuvo");
INSERT IGNORE INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Uniao Estavel");
INSERT IGNORE INTO `CivilStatus` (`CivilStatusDescription`) VALUES ("Outro");

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
-- Associative Table `Detect`.`Relationships`
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

INSERT INTO `Relationships` (`RelType`) VALUES (1);
INSERT INTO `Relationships` (`RelType`) VALUES (2);
INSERT INTO `Relationships` (`RelType`) VALUES (3);
INSERT INTO `Relationships` (`RelType`) VALUES (4);
INSERT INTO `Relationships` (`RelType`) VALUES (5);

-- -----------------------------------------------------
-- Associative Table `Detect`.`User_Platform`
-- -----------------------------------------------------

INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (1,1,1,1);
INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (2,3,4,5);
INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (3,4,5,3);
INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (4,5,2,4);
INSERT INTO `User_Platform` (`UserId`,`PlatformId`,`Features`,`Relationships`) VALUES (5,2,3,2);

-- -----------------------------------------------------
-- Table `Detect`.`Users`
-- -----------------------------------------------------

INSERT INTO `Users` (`UserName`, `UserCPF`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCity_id`) VALUES ("Antonio H.", "12947968604", 1,1, 1, 1);
INSERT INTO `Users` (`UserName`, `UserCPF`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCity_id`) VALUES ("Velma", "12947968603", 2, 2, 3, 2);
INSERT INTO `Users` (`UserName`, `UserCPF`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCity_id`) VALUES ("Fred", "12947968602", 3, 1, 3, 3);
INSERT INTO `Users` (`UserName`, `UserCPF`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCity_id`) VALUES ("Daphne", "12947968601", 2, 4, 1, 4);
INSERT INTO `Users` (`UserName`, `UserCPF`, `UserCivilStatus_id`, `UserGender_id`, `UserFone_id`, `UserCity_id`) VALUES ("Scooby", "12947968605", 3, 6, 1, 5);


-- FINISHED POPULATING THE DATABASE -------------------------------

-- START GENERATING REPORTS ---------------------------------------

-- FINISHED GENERATING REPORTS ---------------------------------------