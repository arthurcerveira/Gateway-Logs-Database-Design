-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema melhorenvio
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema melhorenvio
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `melhorenvio` ;
USE `melhorenvio` ;

-- -----------------------------------------------------
-- Table `melhorenvio`.`method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`method` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`method` (
  `id` INT NOT NULL,
  `name` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`request_header`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`request_header` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`request_header` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `accept` VARCHAR(20) NULL,
  `host` VARCHAR(45) NULL,
  `user_agent` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`request`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`request` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`request` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `method_id` INT NULL,
  `uri` VARCHAR(45) NULL,
  `url` VARCHAR(45) NULL,
  `size` INT NULL,
  `header_id` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `method_id_idx` (`method_id` ASC) VISIBLE,
  INDEX `request_header_id_idx` (`header_id` ASC) VISIBLE,
  CONSTRAINT `method_id`
    FOREIGN KEY (`method_id`)
    REFERENCES `melhorenvio`.`method` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `request_header_id`
    FOREIGN KEY (`header_id`)
    REFERENCES `melhorenvio`.`request_header` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`response_header`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`response_header` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`response_header` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `content_length` INT NULL,
  `connection` VARCHAR(45) NULL,
  `access_control_allow_credentials` TINYINT NULL,
  `content_type` VARCHAR(45) NULL,
  `server` VARCHAR(45) NULL,
  `access_control_allow_origin` VARCHAR(45) NULL,
  `via` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`response`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`response` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`response` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `status` INT NULL,
  `size` INT NULL,
  `header_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `response_header_id_idx` (`header_id` ASC) VISIBLE,
  CONSTRAINT `response_header_id`
    FOREIGN KEY (`header_id`)
    REFERENCES `melhorenvio`.`response_header` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`protocol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`protocol` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`protocol` (
  `id` INT NOT NULL,
  `name` VARCHAR(20) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`service` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`service` (
  `id` CHAR(36) NOT NULL,
  `connect_timeout` INT NULL,
  `created_at` CHAR(10) NULL,
  `host` VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  `path` VARCHAR(45) NULL,
  `port` INT NULL,
  `protocol_id` INT NULL,
  `read_timeout` INT NULL,
  `retries` INT NULL,
  `updated_at` CHAR(10) NULL,
  `write_timeout` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `service_protocol_idx` (`protocol_id` ASC) VISIBLE,
  CONSTRAINT `service_protocol`
    FOREIGN KEY (`protocol_id`)
    REFERENCES `melhorenvio`.`protocol` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`route`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`route` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`route` (
  `id` CHAR(36) NOT NULL,
  `created_at` VARCHAR(45) NULL,
  `hosts` VARCHAR(45) NULL,
  `preserve_host` TINYINT NULL,
  `regex_priority` INT NULL,
  `strip_path` TINYINT NULL,
  `updated_at` VARCHAR(45) NULL,
  `service_id` CHAR(36) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `route_service_idx` (`service_id` ASC) VISIBLE,
  CONSTRAINT `route_service`
    FOREIGN KEY (`service_id`)
    REFERENCES `melhorenvio`.`service` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`latencies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`latencies` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`latencies` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `proxy` INT NULL,
  `kong` INT NULL,
  `request` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`solicitation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`solicitation` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`solicitation` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `request_id` INT NULL,
  `response_id` INT NULL,
  `consumer_id` VARCHAR(45) NULL,
  `route_id` VARCHAR(45) NULL,
  `service_id` VARCHAR(45) NULL,
  `latencies_id` INT NULL,
  `client_ip` VARCHAR(45) NULL,
  `started_at` VARCHAR(45) NULL,
  `upstream_uri` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `request_id_idx` (`request_id` ASC) VISIBLE,
  INDEX `response_id_idx` (`response_id` ASC) VISIBLE,
  INDEX `route_id_idx` (`route_id` ASC) VISIBLE,
  INDEX `service_id_idx` (`service_id` ASC) VISIBLE,
  INDEX `latencies_id_idx` (`latencies_id` ASC) VISIBLE,
  CONSTRAINT `request_id`
    FOREIGN KEY (`request_id`)
    REFERENCES `melhorenvio`.`request` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `response_id`
    FOREIGN KEY (`response_id`)
    REFERENCES `melhorenvio`.`response` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `route_id`
    FOREIGN KEY (`route_id`)
    REFERENCES `melhorenvio`.`route` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `service_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `melhorenvio`.`service` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `latencies_id`
    FOREIGN KEY (`latencies_id`)
    REFERENCES `melhorenvio`.`latencies` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`route_path`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`route_path` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`route_path` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `route_id` CHAR(36) NULL,
  `path` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `route_path_constraint_id`
    FOREIGN KEY (`route_id`)
    REFERENCES `melhorenvio`.`route` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`request_query_string`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`request_query_string` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`request_query_string` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `request_id` INT NULL,
  `query_string` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `request_query_string`
    FOREIGN KEY (`request_id`)
    REFERENCES `melhorenvio`.`request` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`route_protocol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`route_protocol` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`route_protocol` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `route_id` CHAR(36) NULL,
  `protocol_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `protocol_route_constraint_idx` (`protocol_id` ASC) VISIBLE,
  CONSTRAINT `route_protocol_constraint`
    FOREIGN KEY (`route_id`)
    REFERENCES `melhorenvio`.`route` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `protocol_route_constraint`
    FOREIGN KEY (`protocol_id`)
    REFERENCES `melhorenvio`.`protocol` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `melhorenvio`.`route_method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `melhorenvio`.`route_method` ;

CREATE TABLE IF NOT EXISTS `melhorenvio`.`route_method` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `route_id` CHAR(36) NOT NULL,
  `method_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `method_route_foreign_idx` (`method_id` ASC) VISIBLE,
  CONSTRAINT `route_method_foreign`
    FOREIGN KEY (`route_id`)
    REFERENCES `melhorenvio`.`route` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `method_route_foreign`
    FOREIGN KEY (`method_id`)
    REFERENCES `melhorenvio`.`method` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
