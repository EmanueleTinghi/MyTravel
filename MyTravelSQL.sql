CREATE DATABASE IF NOT EXISTS MyTravel;
USE MyTravel;

-- ---------------------------------------------------------------- TABLE STRUCTURE --------------------------------------------------------
/*Utente*/
DROP TABLE IF EXISTS Utente;
CREATE TABLE `Utente`(
	`NomeUtente` VARCHAR(50) NOT NULL,
    `indiceProssimoViaggio` INT(10) UNSIGNED NOT NULL,
    PRIMARY KEY(`NomeUtente`)
) ENGINE = innoDB DEFAULT CHARSET = latin1;

/*Viaggi*/
DROP TABLE IF EXISTS Viaggi;
CREATE TABLE `Viaggi` (
    `NomeUtente` VARCHAR(50) NOT NULL,
    `IdViaggio` INT(10) UNSIGNED NOT NULL,
    `Targa` VARCHAR(50) NOT NULL,
    `KmPercorsi` FLOAT UNSIGNED NOT NULL,
    `Data` DATE NOT NULL,
    PRIMARY KEY (`NomeUtente` , `IdViaggio`),
    CONSTRAINT `NomeUtente` FOREIGN KEY (`NomeUtente`)
        REFERENCES `Utente` (`NomeUtente`)
        ON DELETE CASCADE ON UPDATE CASCADE
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ---------------------------------------------------POPOLAMENTO DATABASE -----------------------------------------------------------
/*Viaggi*/

INSERT INTO `Utente` VALUES
("Emanuele Tinghi", 32);

INSERT INTO `Viaggi` VALUES 


("Emanuele Tinghi", 0, "AA123AA", 27.5,"2021-03-20"),
("Emanuele Tinghi", 1, "AA123AA", 12.0, "2021-03-21"),
("Emanuele Tinghi", 2, "AA123AA", 3.1, "2021-03-27"),
("Emanuele Tinghi", 3, "AA123AA", 10.0, "2021-01-01"),
("Emanuele Tinghi", 4, "AA123AA", 11.0, "2021-01-08"),
("Emanuele Tinghi", 5, "AA123AA", 15.0, "2021-01-15"),
("Emanuele Tinghi", 6, "AA123AA", 20.0, "2021-01-22"),
("Emanuele Tinghi", 7, "AA123AA", 25.0, "2021-01-29"),
("Emanuele Tinghi", 8, "AA123AA", 20.0, "2021-02-05"),
("Emanuele Tinghi", 9, "AA123AA", 11.0, "2021-02-12"),
("Emanuele Tinghi", 10, "AA123AA", 15.0, "2021-02-19"),
("Emanuele Tinghi", 11, "AA123AA", 20.0, "2021-02-26"),
("Emanuele Tinghi", 12, "AA123AA", 25.0, "2021-03-05"),
("Emanuele Tinghi", 13, "AA123AA", 20.0, "2021-02-12"),

("Emanuele Tinghi", 14, "BB555BB", 2.4, "2021-02-25"),
("Emanuele Tinghi", 15, "BB555BB", 30.1, "2021-03-02"),
("Emanuele Tinghi", 16, "BB555BB", 3.0, "2021-03-09"),
("Emanuele Tinghi", 17, "BB555BB", 12.6, "2021-03-16"),
("Emanuele Tinghi", 18, "BB555BB", 15.9, "2021-03-23"),
("Emanuele Tinghi", 19, "BB555BB", 2.1, "2021-03-30"),

("Emanuele Tinghi", 20, "CC999CC", 10.0, "2021-02-24"),
("Emanuele Tinghi", 21, "CC999CC", 1.2, "2021-03-01"),
("Emanuele Tinghi", 22, "CC999CC", 27.6, "2021-03-08"),
("Emanuele Tinghi", 23, "CC999CC", 1.3, "2021-03-15"),
("Emanuele Tinghi", 24, "CC999CC", 4.0, "2021-03-22"),
("Emanuele Tinghi", 25, "CC999CC", 10.0, "2021-03-29"),

("Emanuele Tinghi", 26, "DD000DD", 7.4, "2021-02-28"),
("Emanuele Tinghi", 27, "DD000DD", 21.7, "2021-03-7"),
("Emanuele Tinghi", 28, "DD000DD", 5.3, "2021-03-14"),
("Emanuele Tinghi", 29, "DD000DD", 17.9, "2021-03-21"),
("Emanuele Tinghi", 30, "DD000DD", 11.0, "2021-03-28"),
("Emanuele Tinghi", 31, "DD000DD", 21.7, "2021-04-05");

-- ---------------------------------------------------TRIGGERS/PROCEDURES -------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE controlloUtente (IN user VARCHAR(50))
BEGIN
	DECLARE u VARCHAR(50);

	SELECT NomeUtente INTO u
	FROM Utente
	WHERE nomeUtente = user;

	IF u IS NULL
		THEN
			INSERT INTO utente VALUES (user, 0);
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER utente_inserimento
BEFORE INSERT ON Utente
FOR EACH ROW
BEGIN
	SET new.indiceProssimoViaggio = 0;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER viaggio_consistenza
BEFORE UPDATE ON Viaggi
FOR EACH ROW
BEGIN
	IF new.data > CURRENT_DATE()
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Impossibile aggiungere una spesa futura";
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER viaggio_inserimento
BEFORE INSERT ON Viaggi
FOR EACH ROW
BEGIN
	DECLARE indice_viaggi INT UNSIGNED DEFAULT NULL;
	
	IF new.data > CURRENT_DATE()
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = "Impossibile aggiungere una spesa futura";
	END IF;

	SELECT indiceProssimoViaggio INTO indice_viaggi
	FROM Utente u
	WHERE u.NomeUtente = new.NomeUtente
	FOR UPDATE;

	UPDATE utente u
	SET u.indiceProssimoViaggio = u.indiceProssimoViaggio + 1
	WHERE u.NomeUtente = new.NomeUtente;

	IF indice_viaggi IS NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "L\'utente non esiste";
	END IF;

	SET new.IdViaggio = indice_viaggi;
END $$
DELIMITER ;



























