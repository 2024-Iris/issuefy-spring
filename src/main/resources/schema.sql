-- MySQL Script generated by MySQL Workbench
-- Mon May 20 23:44:38 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE =
        'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema issuefy
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `issuefy`;

CREATE SCHEMA IF NOT EXISTS `issuefy` DEFAULT CHARACTER SET utf8;
USE `issuefy`;

-- -----------------------------------------------------
-- Table `issuefy`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`user`;

CREATE TABLE IF NOT EXISTS `issuefy`.`user`
(
    `id`           BIGINT       NOT NULL AUTO_INCREMENT,
    `github_id`    VARCHAR(255) NOT NULL,
    `email`        VARCHAR(255) NULL,
    `alert_status` TINYINT      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `github_id_UNIQUE` (`github_id` ASC) VISIBLE,
    UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `issuefy`.`organization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`organization`;
CREATE TABLE IF NOT EXISTS `issuefy`.`organization`
(
    `id`        BIGINT       NOT NULL AUTO_INCREMENT,
    `name`      VARCHAR(100) NOT NULL,
    `gh_org_id` BIGINT       NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `gh_org_id_UNIQUE` (`gh_org_id` ASC) VISIBLE
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `issuefy`.`repository`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`repository`;

CREATE TABLE IF NOT EXISTS `issuefy`.`repository`
(
    `id`         BIGINT      NOT NULL AUTO_INCREMENT,
    `org_id`     BIGINT      NOT NULL,
    `name`       VARCHAR(45) NOT NULL,
    `is_starred` TINYINT     NOT NULL DEFAULT 0,
    `gh_repo_id` BIGINT      NOT NULL,
    `updated_at` DATETIME    NOT NULL DEFAULT NOW(),
    PRIMARY KEY (`id`),
    INDEX `fk_repository_org_idx` (`org_id` ASC) VISIBLE,
    UNIQUE INDEX `gh_repo_id_UNIQUE` (`gh_repo_id` ASC) VISIBLE,
    CONSTRAINT `fk_repository_org`
        FOREIGN KEY (`org_id`)
            REFERENCES `issuefy`.`organization` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `issuefy`.`issue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`issue`;

CREATE TABLE IF NOT EXISTS `issuefy`.`issue`
(
    `id`            BIGINT                               NOT NULL AUTO_INCREMENT,
    `repository_id` BIGINT                               NOT NULL,
    `title`         VARCHAR(255) CHARACTER SET 'utf8mb4' NULL,
    `is_starred`    TINYINT                              NOT NULL DEFAULT 0,
    `is_read`       TINYINT                              NOT NULL DEFAULT 0,
    `gh_issue_id`   BIGINT                               NOT NULL,
    `state`         VARCHAR(45)                          NOT NULL,
    `created_at`    DATETIME                             NOT NULL,
    `updated_at`    DATETIME                             NULL,
    `closed_at`     DATETIME                             NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `gh_issue_id_UNIQUE` (`gh_issue_id` ASC) VISIBLE,
    INDEX `fk_issue_repository_idx` (`repository_id` ASC) VISIBLE,
    CONSTRAINT `fk_issue_repository`
        FOREIGN KEY (`repository_id`)
            REFERENCES `issuefy`.`repository` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE
)
    ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `issuefy`.`label`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`label`;

CREATE TABLE IF NOT EXISTS `issuefy`.`label`
(
    `id`    BIGINT                              NOT NULL AUTO_INCREMENT,
    `name`  VARCHAR(45) CHARACTER SET 'utf8mb4' NOT NULL,
    `color` VARCHAR(45)                         NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `issuefy`.`issue_label`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`issue_label`;

CREATE TABLE IF NOT EXISTS `issuefy`.`issue_label`
(
    `id`       BIGINT NOT NULL AUTO_INCREMENT,
    `issue_id` BIGINT NOT NULL,
    `label_id` BIGINT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_issue_label_issue_idx` (`issue_id` ASC) VISIBLE,
    INDEX `fk_issue_label_label_idx` (`label_id` ASC) VISIBLE,
    CONSTRAINT `fk_issue_label_issue`
        FOREIGN KEY (`issue_id`)
            REFERENCES `issuefy`.`issue` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT `fk_issue_label_label`
        FOREIGN KEY (`label_id`)
            REFERENCES `issuefy`.`label` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `issuefy`.`notification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`notification`;
CREATE TABLE IF NOT EXISTS `issuefy`.`notification`
(
    `id`            BIGINT       NOT NULL AUTO_INCREMENT,
    `repository_id` BIGINT       NOT NULL,
    `message`       VARCHAR(255) NOT NULL,
    `push_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_read`       TINYINT      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `fk_notification_repository1_idx` (`repository_id` ASC) VISIBLE,
    CONSTRAINT `fk_notification_repository1`
        FOREIGN KEY (`repository_id`)
            REFERENCES `issuefy`.`repository` (`id`)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `issuefy`.`subscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`subscription`;

CREATE TABLE IF NOT EXISTS `issuefy`.`subscription`
(
    `id`            BIGINT NOT NULL AUTO_INCREMENT,
    `user_id`       BIGINT NOT NULL,
    `repository_id` BIGINT NOT NULL,
    INDEX `fk_subscription_repository_idx` (`repository_id` ASC) VISIBLE,
    INDEX `fk_subscription_user_idx` (`user_id` ASC) VISIBLE,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_subscription_repository`
        FOREIGN KEY (`repository_id`)
            REFERENCES `issuefy`.`repository` (`id`)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT `fk_subscription_user`
        FOREIGN KEY (`user_id`)
            REFERENCES `issuefy`.`user` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `issuefy`.`user_notification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issuefy`.`user_notification`;
CREATE TABLE IF NOT EXISTS `issuefy`.`user_notification`
(
    `user_id`         BIGINT  NOT NULL,
    `notification_id` BIGINT  NOT NULL,
    `is_read`         TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`, `notification_id`),
    INDEX `fk_user_notification_user_idx` (`user_id` ASC) VISIBLE,
    INDEX `fk_user_notification_notification_idx` (`notification_id` ASC) VISIBLE,
    CONSTRAINT `fk_user_notification_notification`
        FOREIGN KEY (`notification_id`)
            REFERENCES `issuefy`.`notification` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT `fk_user_notification_user`
        FOREIGN KEY (`user_id`)
            REFERENCES `issuefy`.`user` (`id`)
            ON DELETE CASCADE
            ON UPDATE CASCADE
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4;

SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;