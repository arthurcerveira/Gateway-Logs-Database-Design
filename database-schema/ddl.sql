-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`method`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`method` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`request` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `method_id` INT NULL,
  `uri` VARCHAR(45) NULL,
  `url` VARCHAR(45) NULL,
  `query_string` VARCHAR(45) NULL,
  `size` INT NULL,
  `header_accept` VARCHAR(45) NULL,
  `header_host` VARCHAR(45) NULL,
  `header_user_agent` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `method_id_idx` (`method_id` ASC) VISIBLE,
  CONSTRAINT `method_id`
    FOREIGN KEY (`method_id`)
    REFERENCES `mydb`.`method` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`response`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`response` (
  `id` INT NOT NULL,
  `status` INT NULL,
  `size` INT NULL,
  `header_content_lenght` INT NULL,
  `header_via` VARCHAR(45) NULL,
  `header_connection` VARCHAR(45) NULL,
  `header_access_control_allow_credentials` TINYINT NULL,
  `header_content_type` VARCHAR(45) NULL,
  `header_server` VARCHAR(45) NULL,
  `header_access_control_allow_origin` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`service` (
  `id` VARCHAR(45) NOT NULL,
  `connection_timeout` INT NULL,
  `created_at` VARCHAR(45) NULL,
  `host` VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  `path` VARCHAR(45) NULL,
  `port` INT NULL,
  `protocol` VARCHAR(45) NULL,
  `read_timeout` INT NULL,
  `retries` INT NULL,
  `updated_at` VARCHAR(45) NULL,
  `write_timeout` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`route`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`route` (
  `id` VARCHAR(45) NOT NULL,
  `created_at` VARCHAR(45) NULL,
  `hosts` VARCHAR(45) NULL,
  `preserve_host` TINYINT NULL,
  `regex_priority` INT NULL,
  `strip_path` TINYINT NULL,
  `updated_at` VARCHAR(45) NULL,
  `service_id` VARCHAR(45) NULL,
  `protocol_http` TINYINT NULL,
  `protocol_https` TINYINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `route_service_idx` (`service_id` ASC) VISIBLE,
  CONSTRAINT `route_service`
    FOREIGN KEY (`service_id`)
    REFERENCES `mydb`.`service` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`latencies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`latencies` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `proxy` INT NULL,
  `kong` INT NULL,
  `request` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`solicitation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`solicitation` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `request_id` INT NULL,
  `response_id` INT NULL,
  `consumer_id` VARCHAR(45) NULL,
  `route_id` VARCHAR(45) NULL,
  `service_id` VARCHAR(45) NULL,
  `lantecies_id` INT NULL,
  `client_ip` VARCHAR(45) NULL,
  `started_at` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `request_id_idx` (`request_id` ASC) VISIBLE,
  INDEX `response_id_idx` (`response_id` ASC) VISIBLE,
  INDEX `route_id_idx` (`route_id` ASC) VISIBLE,
  INDEX `service_id_idx` (`service_id` ASC) VISIBLE,
  INDEX `latencies_id_idx` (`lantecies_id` ASC) VISIBLE,
  CONSTRAINT `request_id`
    FOREIGN KEY (`request_id`)
    REFERENCES `mydb`.`request` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `response_id`
    FOREIGN KEY (`response_id`)
    REFERENCES `mydb`.`response` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `route_id`
    FOREIGN KEY (`route_id`)
    REFERENCES `mydb`.`route` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `service_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `mydb`.`service` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `latencies_id`
    FOREIGN KEY (`lantecies_id`)
    REFERENCES `mydb`.`latencies` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`route_methods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`route_methods` (
  `route_id` VARCHAR(45) NOT NULL,
  `method_id` INT NOT NULL,
  PRIMARY KEY (`route_id`, `method_id`),
  INDEX `route_method_id_2_idx` (`method_id` ASC) VISIBLE,
  CONSTRAINT `route_method_id`
    FOREIGN KEY (`route_id`)
    REFERENCES `mydb`.`route` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `route_method_id_2`
    FOREIGN KEY (`method_id`)
    REFERENCES `mydb`.`method` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`route_paths`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`route_paths` (
  `route_id` VARCHAR(45) NOT NULL,
  `path` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`route_id`, `path`),
  CONSTRAINT `route_paths_id`
    FOREIGN KEY (`route_id`)
    REFERENCES `mydb`.`route` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
