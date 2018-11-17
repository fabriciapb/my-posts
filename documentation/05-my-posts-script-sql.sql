-- MySQL Script generated by MySQL Workbench
-- sáb 17 nov 2018 01:51:25 -03
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Account` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Account` (
  `id` INT NOT NULL,
  `email` VARCHAR(66) NOT NULL,
  `password` TEXT NOT NULL,
  `dateRegistration` DATETIME NOT NULL,
  `lastAccess` DATETIME NOT NULL,
  `lastAccessLocation` VARCHAR(99) NULL,
  `isAdmin` TINYINT(1) NOT NULL DEFAULT 0,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `EMAIL_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Author` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Author` (
  `id` INT NOT NULL,
  `idAccount` INT NOT NULL,
  `nickname` VARCHAR(33) NOT NULL,
  `name` VARCHAR(63) NOT NULL,
  `fullName` VARCHAR(77) NOT NULL,
  `photo` BLOB NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `NICKNAME_UNIQUE` (`nickname` ASC),
  INDEX `ACCOUNT_INDEX` (`idAccount` ASC),
  CONSTRAINT `fkAccount`
    FOREIGN KEY (`idAccount`)
    REFERENCES `mydb`.`Account` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Post` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Post` (
  `id` INT NOT NULL,
  `idAuthor` INT NOT NULL,
  `title` VARCHAR(99) NOT NULL,
  `description` VARCHAR(333) NOT NULL,
  `content` TEXT NOT NULL,
  `note` VARCHAR(333) NULL,
  `datePublication` DATETIME NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `AUTHOR_INDEX` (`idAuthor` ASC),
  CONSTRAINT `fkAuthor`
    FOREIGN KEY (`idAuthor`)
    REFERENCES `mydb`.`Author` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Category` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Category` (
  `id` INT NOT NULL,
  `idAuthor` INT NOT NULL,
  `name` VARCHAR(99) NOT NULL,
  `description` VARCHAR(333) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `NAME_UNIQUE` (`name` ASC),
  INDEX `AUTHOR_INDEX` (`idAuthor` ASC),
  CONSTRAINT `fkAuthor`
    FOREIGN KEY (`idAuthor`)
    REFERENCES `mydb`.`Author` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Tag` (
  `id` INT NOT NULL,
  `idAuthor` INT NOT NULL,
  `name` VARCHAR(99) NOT NULL,
  `description` VARCHAR(333) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `NAME_UNIQUE` (`name` ASC),
  INDEX `AUTHOR_INDEX` (`idAuthor` ASC),
  CONSTRAINT `fkAuthor`
    FOREIGN KEY (`idAuthor`)
    REFERENCES `mydb`.`Author` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Responsible`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Responsible` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Responsible` (
  `id` INT NOT NULL,
  `name` VARCHAR(63) NOT NULL,
  `email` VARCHAR(66) NOT NULL,
  `phone` VARCHAR(16) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `EMAIL_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PostComment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`PostComment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`PostComment` (
  `id` INT NOT NULL,
  `idPost` INT NOT NULL,
  `idResponsible` INT NOT NULL,
  `title` VARCHAR(33) NOT NULL,
  `comment` TEXT NOT NULL,
  `dateComment` DATETIME NOT NULL,
  `isPublic` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `POST_INDEX` (`idPost` ASC),
  INDEX `RESPONSIBLE_INDEX` (`idResponsible` ASC),
  CONSTRAINT `fkPost`
    FOREIGN KEY (`idPost`)
    REFERENCES `mydb`.`Post` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fkResponsible`
    FOREIGN KEY (`idResponsible`)
    REFERENCES `mydb`.`Responsible` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PostHasTag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`PostHasTag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`PostHasTag` (
  `idPost` INT NOT NULL,
  `idTag` INT NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idPost`, `idTag`),
  INDEX `TAG_INDEX` (`idTag` ASC),
  INDEX `POST_INDEX` (`idPost` ASC),
  CONSTRAINT `fkPost`
    FOREIGN KEY (`idPost`)
    REFERENCES `mydb`.`Post` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fkTag`
    FOREIGN KEY (`idTag`)
    REFERENCES `mydb`.`Tag` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PostHasCategory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`PostHasCategory` ;

CREATE TABLE IF NOT EXISTS `mydb`.`PostHasCategory` (
  `idPost` INT NOT NULL,
  `idCategory` INT NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idPost`, `idCategory`),
  INDEX `CATEGORY_INDEX` USING BTREE (`idCategory` ASC),
  INDEX `POST_INDEX` (`idPost` ASC),
  CONSTRAINT `fkPost`
    FOREIGN KEY (`idPost`)
    REFERENCES `mydb`.`Post` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fkCategory`
    FOREIGN KEY (`idCategory`)
    REFERENCES `mydb`.`Category` (`id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
