-- MySQL Script generated by MySQL Workbench
-- Mon May 13 21:52:29 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema issuefy
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `issuefy` ;

-- -----------------------------------------------------
-- Schema issuefy
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `issuefy` DEFAULT CHARACTER SET utf8 ;
USE `issuefy` ;

-- -----------------------------------------------------
-- Table `issuefy`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`user` ;

CREATE TABLE IF NOT EXISTS `issuefy`.`user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `github_id` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `login_id_UNIQUE` (`github_id` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `issuefy`.`org`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`org` ;

CREATE TABLE IF NOT EXISTS `issuefy`.`org` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `issuefy`.`repository`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`repository` ;

CREATE TABLE IF NOT EXISTS `issuefy`.`repository` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `org_id` BIGINT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_repository_org1_idx` (`org_id` ASC) VISIBLE,
  CONSTRAINT `fk_repository_org1`
    FOREIGN KEY (`org_id`)
    REFERENCES `issuefy`.`org` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `issuefy`.`issue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`issue` ;

CREATE TABLE IF NOT EXISTS `issuefy`.`issue` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `repository_id` BIGINT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_issue_repository1_idx` (`repository_id` ASC) VISIBLE,
  CONSTRAINT `fk_issue_repository1`
    FOREIGN KEY (`repository_id`)
    REFERENCES `issuefy`.`repository` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `issuefy`.`label`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`label` ;

CREATE TABLE IF NOT EXISTS `issuefy`.`label` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `issuefy`.`subscribe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`subscribe` ;

CREATE TABLE IF NOT EXISTS `issuefy`.`subscribe` (
  `user_id` BIGINT NOT NULL,
  `repository_id` BIGINT NOT NULL,
  INDEX `fk_subscribe_repository1_idx` (`repository_id` ASC) VISIBLE,
  INDEX `fk_subscribe_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_subscribe_repository1`
    FOREIGN KEY (`repository_id`)
    REFERENCES `issuefy`.`repository` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subscribe_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `issuefy`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;