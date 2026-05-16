-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema datawarehouse
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema datawarehouse
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `datawarehouse` ;
USE `datawarehouse` ;

-- -----------------------------------------------------
-- Table `datawarehouse`.`dim_film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`dim_film` (
  `film_key` INT NOT NULL AUTO_INCREMENT,
  `film_id` INT NULL DEFAULT NULL,
  `title` VARCHAR(100) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `rating` VARCHAR(20) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `rental_rate` DECIMAL(5,2) NULL DEFAULT NULL,
  `rental_duration` INT NULL DEFAULT NULL,
  `release_year` INT NULL DEFAULT NULL,
  PRIMARY KEY (`film_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`dim_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`dim_category` (
  `category_key` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NULL DEFAULT NULL,
  `category_name` VARCHAR(50) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  PRIMARY KEY (`category_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`bridge_film_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`bridge_film_category` (
  `film_key` INT NOT NULL,
  `category_key` INT NOT NULL,
  PRIMARY KEY (`film_key`, `category_key`),
  INDEX `category_key` (`category_key` ASC) VISIBLE,
  CONSTRAINT `bridge_film_category_ibfk_1`
    FOREIGN KEY (`film_key`)
    REFERENCES `datawarehouse`.`dim_film` (`film_key`),
  CONSTRAINT `bridge_film_category_ibfk_2`
    FOREIGN KEY (`category_key`)
    REFERENCES `datawarehouse`.`dim_category` (`category_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`dim_customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`dim_customer` (
  `customer_key` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NULL DEFAULT NULL,
  `full_name` VARCHAR(100) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `city` VARCHAR(50) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `country` VARCHAR(50) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  PRIMARY KEY (`customer_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`dim_date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`dim_date` (
  `date_key` INT NOT NULL AUTO_INCREMENT,
  `full_date` DATE NULL DEFAULT NULL,
  `day_name` VARCHAR(20) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `month_name` VARCHAR(20) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `quarter_name` VARCHAR(10) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `year_number` INT NULL DEFAULT NULL,
  PRIMARY KEY (`date_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`dim_location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`dim_location` (
  `location_key` INT NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(50) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `country` VARCHAR(50) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `district` VARCHAR(50) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  PRIMARY KEY (`location_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`dim_staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`dim_staff` (
  `staff_key` INT NOT NULL AUTO_INCREMENT,
  `staff_id` INT NULL DEFAULT NULL,
  `full_name` VARCHAR(100) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `store_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`staff_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`dim_store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`dim_store` (
  `store_key` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NULL DEFAULT NULL,
  `manager_name` VARCHAR(100) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `city` VARCHAR(50) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  `country` VARCHAR(50) COLLATE 'utf8mb3_unicode_ci' NULL DEFAULT NULL,
  PRIMARY KEY (`store_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`fact_payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`fact_payment` (
  `payment_key` INT NOT NULL AUTO_INCREMENT,
  `customer_key` INT NULL DEFAULT NULL,
  `film_key` INT NULL DEFAULT NULL,
  `store_key` INT NULL DEFAULT NULL,
  `staff_key` INT NULL DEFAULT NULL,
  `date_key` INT NULL DEFAULT NULL,
  `amount` DECIMAL(10,2) NULL DEFAULT NULL,
  `payment_count` INT NULL DEFAULT NULL,
  PRIMARY KEY (`payment_key`),
  INDEX `customer_key` (`customer_key` ASC) VISIBLE,
  INDEX `film_key` (`film_key` ASC) VISIBLE,
  INDEX `store_key` (`store_key` ASC) VISIBLE,
  INDEX `staff_key` (`staff_key` ASC) VISIBLE,
  INDEX `date_key` (`date_key` ASC) VISIBLE,
  CONSTRAINT `fact_payment_ibfk_1`
    FOREIGN KEY (`customer_key`)
    REFERENCES `datawarehouse`.`dim_customer` (`customer_key`),
  CONSTRAINT `fact_payment_ibfk_2`
    FOREIGN KEY (`film_key`)
    REFERENCES `datawarehouse`.`dim_film` (`film_key`),
  CONSTRAINT `fact_payment_ibfk_3`
    FOREIGN KEY (`store_key`)
    REFERENCES `datawarehouse`.`dim_store` (`store_key`),
  CONSTRAINT `fact_payment_ibfk_4`
    FOREIGN KEY (`staff_key`)
    REFERENCES `datawarehouse`.`dim_staff` (`staff_key`),
  CONSTRAINT `fact_payment_ibfk_5`
    FOREIGN KEY (`date_key`)
    REFERENCES `datawarehouse`.`dim_date` (`date_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`fact_rental_film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`fact_rental_film` (
  `rental_film_key` INT NOT NULL AUTO_INCREMENT,
  `film_key` INT NULL DEFAULT NULL,
  `store_key` INT NULL DEFAULT NULL,
  `date_key` INT NULL DEFAULT NULL,
  `rental_duration` INT NULL DEFAULT NULL,
  `days_late` INT NULL DEFAULT NULL,
  `rental_count` INT NULL DEFAULT NULL,
  PRIMARY KEY (`rental_film_key`),
  INDEX `film_key` (`film_key` ASC) VISIBLE,
  INDEX `store_key` (`store_key` ASC) VISIBLE,
  INDEX `date_key` (`date_key` ASC) VISIBLE,
  CONSTRAINT `fact_rental_film_ibfk_1`
    FOREIGN KEY (`film_key`)
    REFERENCES `datawarehouse`.`dim_film` (`film_key`),
  CONSTRAINT `fact_rental_film_ibfk_2`
    FOREIGN KEY (`store_key`)
    REFERENCES `datawarehouse`.`dim_store` (`store_key`),
  CONSTRAINT `fact_rental_film_ibfk_3`
    FOREIGN KEY (`date_key`)
    REFERENCES `datawarehouse`.`dim_date` (`date_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `datawarehouse`.`fact_store_performance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `datawarehouse`.`fact_store_performance` (
  `store_performance_key` INT NOT NULL AUTO_INCREMENT,
  `store_key` INT NULL DEFAULT NULL,
  `location_key` INT NULL DEFAULT NULL,
  `date_key` INT NULL DEFAULT NULL,
  `total_rentals` INT NULL DEFAULT NULL,
  `total_revenue` DECIMAL(10,2) NULL DEFAULT NULL,
  `total_late_returns` INT NULL DEFAULT NULL,
  PRIMARY KEY (`store_performance_key`),
  INDEX `store_key` (`store_key` ASC) VISIBLE,
  INDEX `location_key` (`location_key` ASC) VISIBLE,
  INDEX `date_key` (`date_key` ASC) VISIBLE,
  CONSTRAINT `fact_store_performance_ibfk_1`
    FOREIGN KEY (`store_key`)
    REFERENCES `datawarehouse`.`dim_store` (`store_key`),
  CONSTRAINT `fact_store_performance_ibfk_2`
    FOREIGN KEY (`location_key`)
    REFERENCES `datawarehouse`.`dim_location` (`location_key`),
  CONSTRAINT `fact_store_performance_ibfk_3`
    FOREIGN KEY (`date_key`)
    REFERENCES `datawarehouse`.`dim_date` (`date_key`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
