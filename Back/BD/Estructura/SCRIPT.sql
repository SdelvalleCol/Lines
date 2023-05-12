-- MySQL Script generado por MySQL Workbench
-- Thu May 11 21:41:47 2023
-- Modelo: Nuevo Modelo    Versión: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `cargo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cargo`;

CREATE TABLE IF NOT EXISTS `cargo` (
  `idCargo` INT(11) NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCargo`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `personas`;

CREATE TABLE IF NOT EXISTS `personas` (
  `numero_telefono` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `contrasena` VARCHAR(255) NOT NULL,
  `imagen` LONGTEXT NOT NULL,
  `Cargo_idCargo` INT(11) NOT NULL,
  PRIMARY KEY (`numero_telefono`),
  INDEX `fk_personas_Cargo_idx` (`Cargo_idCargo`),
  CONSTRAINT `fk_personas_Cargo`
    FOREIGN KEY (`Cargo_idCargo`)
    REFERENCES `cargo` (`idCargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `chats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `chats`;

CREATE TABLE IF NOT EXISTS `chats` (
  `idchats` INT NOT NULL AUTO_INCREMENT,
  `creacion` DATETIME NOT NULL,
  PRIMARY KEY (`idchats`)
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `chats_has_personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `chats_has_personas`;

CREATE TABLE IF NOT EXISTS `chats_has_personas` (
  `chats_idchats` INT NOT NULL,
  `personas_numero_telefono` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`chats_idchats`, `personas_numero_telefono`),
  INDEX `fk_chats_has_personas_personas1_idx` (`personas_numero_telefono`),
  INDEX `fk_chats_has_personas_chats1_idx` (`chats_idchats`),
  CONSTRAINT `fk_chats_has_personas_chats1`
    FOREIGN KEY (`chats_idchats`)
    REFERENCES `chats` (`idchats`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_chats_has_personas_personas1`
    FOREIGN KEY (`personas_numero_telefono`)
    REFERENCES `personas` (`numero_telefono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mensajes
-- -----------------------------------------------------

DROP TABLE IF EXISTS `mensajes`;

CREATE TABLE IF NOT EXISTS `mensajes` (
  `idmensajes` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(500) NOT NULL,
  `hora` DATETIME NOT NULL,
  `chats_idchats` INT NOT NULL,
  `personas_numero_telefono` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idmensajes`),
  INDEX `fk_mensajes_chats1_idx` (`chats_idchats`),
  INDEX `fk_mensajes_personas1_idx` (`personas_numero_telefono`),
  CONSTRAINT `fk_mensajes_chats1`
    FOREIGN KEY (`chats_idchats`)
    REFERENCES `chats` (`idchats`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mensajes_personas1`
    FOREIGN KEY (`personas_numero_telefono`)
    REFERENCES `personas` (`numero_telefono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
