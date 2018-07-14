 /*
	Creazione del database seemycity
*/

DROP DATABASE IF EXISTS seemycity;
CREATE DATABASE IF NOT EXISTS seemycity;
USE seemycity;

/*
	Creazione delle tabelle 
*/

CREATE TABLE Utente(
    Email VARCHAR(50) PRIMARY KEY NOT NULL,
    Password VARCHAR(450) NOT NULL,
    Nickname VARCHAR(50),
    DataNascita DATE ,
    NumAttrattive INT DEFAULT 0 NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    NomeCitta VARCHAR(50) NOT NULL
 )ENGINE=INNODB;

CREATE TABLE Messaggio(
    Id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    EmailMittente VARCHAR(50) NOT NULL,
    EmailDestinario VARCHAR(50) NOT NULL,
    Descrizione VARCHAR(300) NOT NULL,
    Titolo VARCHAR(70), 
    Data DATETIME
)ENGINE=INNODB;

CREATE TABLE Percorso(
	Nome VARCHAR(30) NOT NULL , 
	NomeCitta VARCHAR(30) NOT NULL ,
	Categoria ENUM("ARTE","STORIA","NATURA","GASTRONOMIA","RELAX","MISTO") NOT NULL ,
	Durata INT DEFAULT 0 NOT NULL ,
	EmailUtentePremium VARCHAR(50),
	PRIMARY KEY(Nome,EmailUtentePremium)
)ENGINE=INNODB;


CREATE TABLE Preferito(
	Nome VARCHAR(30) NOT NULL,
	NomeCitta VARCHAR(30) NOT NULL,
	EmailUtentePremium VARCHAR(50) NOT NULL ,
	Nota VARCHAR(300) ,
	PRIMARY KEY(Nome,NomeCitta,EmailUtentePremium)
)ENGINE=INNODB;


CREATE TABLE AttrattivePerPercorso(
	NomePercorso VARCHAR(30) NOT NULL , 
	NomeCittaPercorso VARCHAR(30) NOT NULL ,
	EmailUtente VARCHAR(50) NOT NULL ,
	NomeMonumento VARCHAR(30) ,
	NomeAttivita VARCHAR(30),
	Tempo INT NOT NULL,
	Ordine SMALLINT  NOT NULL,
	PRIMARY KEY(NomeCittaPercorso,NomePercorso,Ordine)
)ENGINE=INNODB;

CREATE TABLE AttrattivaMonumento(
	Nome VARCHAR(30) NOT NULL,
	NomeCitta VARCHAR(30) NOT NULL,
	EmailUtente VARCHAR(50) NOT NULL,
	Descrizione VARCHAR(300) NOT NULL,
	Stato ENUM("VISITABILE","NON VISITABILE","VISITABILE GRATIS")   NOT NULL,
	Indirizzo VARCHAR(100),
	Foto VARCHAR(1000),
	Longitudine VARCHAR(20),
	Latitudine VARCHAR(20) ,
	PRIMARY KEY(Nome,EmailUtente)
)ENGINE=INNODB;


CREATE TABLE AttrattivaAttivita(
	Nome VARCHAR(30) NOT NULL,
	NomeCitta VARCHAR(30) NOT NULL,
	EmailUtente VARCHAR(50) NOT NULL,
	Prezzo DECIMAL(8,2) NOT NULL, 
	OrarioApertura VARCHAR(10) NOT NULL,
	OrarioChiusura VARCHAR(10) NOT NULL,
	GiorniChiusura VARCHAR(50) NOT NULL,
	Indirizzo VARCHAR(100),
	Foto VARCHAR(1000),
	Longitudine VARCHAR(20),
	Latitudine VARCHAR(20) ,
	PRIMARY KEY(Nome,EmailUtente)
)ENGINE=INNODB;

CREATE TABLE Citta(
	Nome VARCHAR(30) PRIMARY KEY NOT NULL,
	Stato VARCHAR(30) NOT NULL,
	Regione VARCHAR(30) NOT NULL
)ENGINE=INNODB;

CREATE TABLE Foto(
	Id INT AUTO_INCREMENT PRIMARY KEY ,
	NomeCitta VARCHAR(30) NOT NULL ,
	Pathh VARCHAR(300) NOT NULL 
)ENGINE=INNODB;

CREATE TABLE Commento(
    Id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    Data DATETIME  NOT NULL,
    EmailUtente VARCHAR(50)  NOT NULL,
    Voto INT DEFAULT 0,
    Stato ENUM("PUBBLICO","PRIVATO") DEFAULT "PUBBLICO",
    Contenuto VARCHAR(500),
    NomeMonumento VARCHAR(50),
    NomeAttivita VARCHAR(50)
)ENGINE=INNODB;



CREATE TABLE UtenteGestore(
    EmailUtente VARCHAR(50) PRIMARY KEY NOT NULL,
    NomeAttivita VARCHAR(50) NOT NULL ,
    Indirizzo VARCHAR(50),
    Recapito VARCHAR(20),
    SitoWeb VARCHAR(30)
 )ENGINE=INNODB;


CREATE TABLE Evento(
    Id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Data DATE NOT NULL , 
    Stato ENUM("APERTO","CHIUSO") DEFAULT "APERTO",
    Titolo VARCHAR(50) NOT NULL,
    MaxPartecipanti INT NOT NULL ,
    Descrizione VARCHAR(300),
    OrarioInizio VARCHAR(30) NOT NULL,
    EmailUtenteGestore VARCHAR(50) NOT NULL 
 )ENGINE=INNODB;


CREATE TABLE ListaFollower(
	EmailFollower VARCHAR(50) NOT NULL,
	Id INT NOT NULL,
	PRIMARY KEY(EmailFollower,Id)
	)ENGINE=INNODB;


/*
  Creazione dei vincoli di chiave esterna su tutte le tabelle
*/


ALTER TABLE Commento
ADD FOREIGN KEY (EmailUtente)
REFERENCES Utente(Email);

ALTER TABLE Utente
ADD FOREIGN KEY(NomeCitta) 
REFERENCES Citta(Nome);

ALTER TABLE UtenteGestore
ADD FOREIGN KEY(EmailUtente)
REFERENCES Utente(Email);

ALTER TABLE Messaggio
ADD FOREIGN KEY (EmailMittente)
REFERENCES Utente(Email);

ALTER TABLE Messaggio
ADD FOREIGN KEY(EmailDestinario)
REFERENCES Utente(Email);

ALTER TABLE ListaFollower
ADD FOREIGN KEY(EmailFollower)
REFERENCES Utente(Email);

ALTER TABLE ListaFollower
ADD FOREIGN KEY(Id)
REFERENCES Evento(Id);

ALTER TABLE Foto
ADD FOREIGN KEY(NomeCitta)
REFERENCES Citta(Nome);

ALTER TABLE Percorso 
ADD FOREIGN KEY(NomeCitta)
REFERENCES Citta(Nome);

ALTER TABLE Percorso 
ADD FOREIGN KEY(EmailUtentePremium)
REFERENCES Utente(Email);

ALTER TABLE Preferito 
ADD FOREIGN KEY(NomeCitta)
REFERENCES Percorso(NomeCitta);

ALTER TABLE Preferito 
ADD FOREIGN KEY(EmailUtentePremium)
REFERENCES Utente(Email);

ALTER TABLE Evento
ADD FOREIGN KEY(EmailUtenteGestore)
REFERENCES UtenteGestore(EmailUtente);

ALTER TABLE AttrattivePerPercorso 
ADD FOREIGN KEY(NomePercorso)
REFERENCES Percorso(Nome);

ALTER TABLE AttrattivePerPercorso 
ADD FOREIGN KEY(NomeCittaPercorso)
REFERENCES Percorso(NomeCitta);

ALTER TABLE AttrattivePerPercorso 
ADD FOREIGN KEY(EmailUtente)
REFERENCES Utente(Email);

ALTER TABLE AttrattivaMonumento
ADD FOREIGN KEY(NomeCitta)
REFERENCES Citta(Nome);

ALTER TABLE AttrattivaMonumento
ADD FOREIGN KEY(EmailUtente)
REFERENCES Utente(Email);

ALTER TABLE AttrattivaAttivita
ADD FOREIGN KEY(NomeCitta)
REFERENCES Citta(Nome);

ALTER TABLE AttrattivaAttivita
ADD FOREIGN KEY(EmailUtente)
REFERENCES Utente(Email);




/**********************     PROCEDURE     ************************/


/*
  Procedura che registra un nuovo utente nel database
*/


DELIMITER //
CREATE PROCEDURE Registrarsi(IN EmailIns VARCHAR(50), IN PasswordIns VARCHAR(450), IN DataNascitaIns DATE, 
                            IN NicknameIns VARCHAR(50), IN TipoIns VARCHAR(50),IN NomeCittaIns VARCHAR(50), 
                            IN NomeAttivitaIns VARCHAR(50), IN IndirizzoIns VARCHAR(50),  IN RecapitoIns VARCHAR(20), 
                            IN SitoWebIns VARCHAR(30), IN StatoCittaIns VARCHAR(20), IN RegioneCittaIns VARCHAR(20), 
                             IN PathFotoCittaIns VARCHAR(100),OUT ControlloRegis BOOLEAN)
BEGIN 
DECLARE CittaEsistente VARCHAR(30);
START TRANSACTION;
SET CittaEsistente = (SELECT Nome FROM Citta WHERE Nome=NomeCittaIns);
SET ControlloRegis = FALSE;

IF( (TipoIns="semplice") AND (CittaEsistente IS NOT NULL)) THEN
INSERT INTO Utente(Email,Password,DataNascita,Nickname,Tipo,NomeCitta)
VALUES(EmailIns,MD5(PasswordIns),DataNascitaIns,NicknameIns,TipoIns,NomeCittaIns);
IF( (PathFotoCittaIns <> "" ) AND (PathFotoCittaIns <> "uploads/") AND (PathFotoCittaIns IS NOT NULL) ) THEN
INSERT INTO Foto(NomeCitta,Pathh)
VALUES(NomeCittaIns,PathFotoCittaIns);
END IF;
SET ControlloRegis = TRUE;

ELSEIF( (TipoIns="semplice") AND (CittaEsistente IS NULL) AND (StatoCittaIns <> "") AND (RegioneCittaIns <> "") ) THEN
INSERT INTO Citta(Nome,Stato,Regione)
VALUES(NomeCittaIns,StatoCittaIns,RegioneCittaIns);
INSERT INTO Utente(Email,Password,DataNascita,Nickname,Tipo,NomeCitta)
VALUES(EmailIns,MD5(PasswordIns),DataNascitaIns,NicknameIns,TipoIns,NomeCittaIns);
IF( (PathFotoCittaIns <> "" ) AND (PathFotoCittaIns <> "uploads/") AND (PathFotoCittaIns IS NOT NULL) ) THEN
INSERT INTO Foto(NomeCitta,Pathh)
VALUES(NomeCittaIns,PathFotoCittaIns);
END IF;
SET ControlloRegis = TRUE;

ELSEIF((TipoIns="gestore") AND (CittaEsistente IS NOT NULL)) THEN
INSERT INTO Utente(Email,Password,DataNascita,Nickname,Tipo,NomeCitta)
VALUES(EmailIns,MD5(PasswordIns),DataNascitaIns,NicknameIns,TipoIns,NomeCittaIns);
INSERT INTO UtenteGestore(EmailUtente,NomeAttivita,Indirizzo,Recapito,Sitoweb)
VALUE(EmailIns, NomeAttivitaIns, IndirizzoIns, RecapitoIns, SitoWebIns);
IF( (PathFotoCittaIns <> "" ) AND (PathFotoCittaIns <> "uploads/") AND (PathFotoCittaIns IS NOT NULL) ) THEN
INSERT INTO Foto(NomeCitta,Pathh)
VALUES(NomeCittaIns,PathFotoCittaIns);
END IF;
SET ControlloRegis = TRUE;


ELSEIF( (TipoIns="gestore") AND (CittaEsistente IS NULL) AND (StatoCittaIns <> "") AND (RegioneCittaIns <> "") ) THEN
INSERT INTO Citta(Nome,Stato,Regione)
VALUES(NomeCittaIns,StatoCittaIns,RegioneCittaIns);
INSERT INTO Utente(Email,Password,DataNascita,Nickname,Tipo,NomeCitta)
VALUES(EmailIns,MD5(PasswordIns),DataNascitaIns,NicknameIns,TipoIns,NomeCittaIns);
INSERT INTO UtenteGestore(EmailUtente,NomeAttivita,Indirizzo,Recapito,Sitoweb)
VALUE(EmailIns, NomeAttivitaIns, IndirizzoIns, RecapitoIns, SitoWebIns);
IF( (PathFotoCittaIns <> "" ) AND (PathFotoCittaIns <> "uploads/") AND (PathFotoCittaIns IS NOT NULL) ) THEN
INSERT INTO Foto(NomeCitta,Pathh)
VALUES(NomeCittaIns,PathFotoCittaIns);
END IF;
SET ControlloRegis = TRUE;

END IF;

COMMIT;
END //
DELIMITER ;



/*

  Procedura che si occupa del controllo logIn. Controlla se la password è corretta 
  e restituisce tutti i dati relativi all' utente che si è loggato.

*/

DELIMITER $
CREATE PROCEDURE LogUtente(IN Email VARCHAR(50), IN Password VARCHAR(450), OUT UserRitorno VARCHAR(50), 
OUT NicknameRitorno VARCHAR(50), OUT DataNascitaRitorno DATE,OUT NumAttrattiveRitorno INT, 
OUT TipoRitorno VARCHAR(50) , OUT NomeCittaRitorno VARCHAR(50), OUT Controllo BOOLEAN)
BEGIN
DECLARE contatore INT DEFAULT 0;
DECLARE cursore CURSOR FOR SELECT Email,Nickname,DataNascita,NumAttrattive,Tipo,NomeCitta 
FROM Utente  WHERE Utente.Email=Email && MD5(Password)=Utente.Password;
START TRANSACTION ;
SET Controllo=FALSE ;
OPEN cursore;
SELECT FOUND_ROWS() INTO contatore;
IF(contatore>0) THEN
FETCH cursore INTO UserRitorno, NicknameRitorno,DataNascitaRitorno,NumAttrattiveRitorno,TipoRitorno,NomeCittaRitorno;
SET Controllo=TRUE;
END IF ;
CLOSE cursore ;
COMMIT ;
END$ 

DELIMITER ;



/*

Procedura che si occupa del inserizione di una nuova attrativa di tipo monumento  .
Controlla che l'attrattiva non e gia creata da un dato utente e con un certo nome .


*/

DELIMITER $

CREATE PROCEDURE InserisciAttrattivaMonumento(IN NomeMon VARCHAR(50),IN NomeCittaMon VARCHAR(30),IN EmailUtenteMon VARCHAR(50), 
										   	IN DescrizioneMon VARCHAR(300),IN StatoMon ENUM("VISITABILE","NON VISITABILE","VISITABILE GRATIS"), IN IndirizzoMon VARCHAR(100),
											IN FotoMon VARCHAR(1000), IN LongitudineMon VARCHAR(20), IN LatitudineMon VARCHAR(20), OUT controlloAttrattiva BOOLEAN) 
BEGIN
DECLARE numeroAttrattiveMonumento INT DEFAULT 0 ;
DECLARE nomeCIttaUtente VARCHAR(30);
START TRANSACTION ;
SET controlloAttrattiva=FALSE;
SET numeroAttrattiveMonumento=(SELECT COUNT(*) FROM AttrattivaMonumento
							   WHERE AttrattivaMonumento.EmailUtente=EmailUtenteMon && AttrattivaMonumento.Nome=NomeMon) ;
SET nomeCIttaUtente=(SELECT  NomeCitta FROM Utente 
					 WHERE Email=EmailUtenteMon ) ;
IF(numeroAttrattiveMonumento=0  && nomeCIttaUtente=NomeCittaMon) THEN  
INSERT INTO AttrattivaMonumento(Nome,NomeCitta,EmailUtente,Descrizione,Stato,Indirizzo,Foto,Longitudine,Latitudine) 
VALUES (NomeMon,NomeCittaMon,EmailUtenteMon,DescrizioneMon,StatoMon,IndirizzoMon,FotoMon,LongitudineMon,LatitudineMon);

SET controlloAttrattiva=TRUE ;
END IF ;
COMMIT;
END$

DELIMITER ;


/*

Procedura che si occupa del inserizione di una nuova attrativa di tipo attivita  .
Controlla che l'attrattiva non e gia creata da un dato utente e con un certo nome
 e controlla se la citta inserita e quello della reseidenza del utente .


*/
DELIMITER $

CREATE PROCEDURE InserisciAttrattivaAttivita(IN NomeAttiv VARCHAR(30),IN NomeCittaAttiv VARCHAR(30),IN EmailUtenteAttiv VARCHAR(50), 
										   	IN PrezzoAttiv DECIMAL(8,2),IN OrarioAperturaAttiv VARCHAR(10), 
                                            IN OrarioChiusuraAttiv VARCHAR(10),IN GiorniChiusuraAttiv VARCHAR(1000),
                                            IN IndirizzoAttiv VARCHAR(100),IN FotoAttiv VARCHAR(1000), 
											IN LongitudineAttiv VARCHAR(20), IN LatitudineAttiv VARCHAR(20), OUT controlloAttrattivaAttiv BOOLEAN) 
BEGIN
DECLARE numeroAttrattiveAttivita INT DEFAULT 0 ;
DECLARE nomeCIttaUtenteAttiv VARCHAR(30);
START TRANSACTION ;
SET controlloAttrattivaAttiv=FALSE;
SET numeroAttrattiveAttivita =(SELECT COUNT(*) FROM AttrattivaAttivita
							   WHERE AttrattivaAttivita.EmailUtente=EmailUtenteAttiv && AttrattivaAttivita.Nome=NomeAttiv) ;
SET nomeCIttaUtenteAttiv=(SELECT  NomeCitta FROM Utente 
					 	  WHERE Email=EmailUtenteAttiv ) ;
IF(numeroAttrattiveAttivita=0  && nomeCIttaUtenteAttiv=NomeCittaAttiv) THEN  
INSERT INTO AttrattivaAttivita(Nome,NomeCitta,EmailUtente,Prezzo,OrarioApertura,OrarioChiusura,GiorniChiusura,
                               Indirizzo,Foto,Longitudine,Latitudine) 
VALUES (NomeAttiv,NomeCittaAttiv,EmailUtenteAttiv,PrezzoAttiv,OrarioAperturaAttiv,OrarioChiusuraAttiv,
        GiorniChiusuraAttiv,IndirizzoAttiv,FotoAttiv,LongitudineAttiv,LatitudineAttiv);


SET controlloAttrattivaAttiv=TRUE ;
END IF ;
COMMIT;
END$

DELIMITER ;


/*
Procedura che si occupa del inserizione di un commento . 
*/

DELIMITER $

CREATE PROCEDURE InserisciCommento(IN EmailUtenteCommento VARCHAR(50),IN VotoCommento INT ,
                                   IN StatoCommnento ENUM("PUBBLICO","PRIVATO"),IN ContenutoCommento VARCHAR(500), 
                                   IN NomeMonumentoCommento VARCHAR(50), IN NomeAttivitaCommento VARCHAR(50),
                                   OUT ControlloInser BOOLEAN)

BEGIN
DECLARE ControlloNomeAttivita VARCHAR(50);
DECLARE ControlloNomeMonum VARCHAR(50);
START TRANSACTION;
SET ControlloInser = FALSE;
SET ControlloNomeAttivita = ( SELECT DISTINCT Nome FROM AttrattivaAttivita WHERE Nome=NomeAttivitaCommento);
SET ControlloNomeMonum = ( SELECT DISTINCT Nome FROM AttrattivaMonumento WHERE Nome=NomeMonumentoCommento);
IF(ControlloNomeAttivita=NomeAttivitaCommento OR ControlloNomeMonum=NomeMonumentoCommento) THEN
INSERT INTO Commento(Data,EmailUtente,Voto,Stato,Contenuto,NomeMonumento,NomeAttivita)
VALUES (NOW(),EmailUtenteCommento,VotoCommento,StatoCommnento,ContenutoCommento,NomeMonumentoCommento,NomeAttivitaCommento);
SET ControlloInser = TRUE;
END IF;
COMMIT;
END$

DELIMITER ;

/*

Procedura che inserisce un nuovo evento organizzato da un utente gestore . 
Controlla che l'evento non esiste gia e che l'utente sia Gestore .

*/

DELIMITER $

CREATE PROCEDURE AddEvento(IN DataInser DATE, IN TitoloInser VARCHAR(50), IN MaxPartecipantiInser INT, 
                           IN DescrizioneInser VARCHAR(300),IN OrarioInizioInser VARCHAR(30), 
                           IN EmailUtenteGestoreInser VARCHAR(50), OUT idControllo INT )

BEGIN
DECLARE utente VARCHAR (10) ;
DECLARE idEsistente INT DEFAULT 0 ;
START TRANSACTION ; 
SET utente = (SELECT Tipo FROM Utente WHERE Utente.Email = EmailUtenteGestoreInser);
SET idEsistente = (SELECT Id From Evento 
				   WHERE Evento.Data = DataInser && Evento.Titolo= TitoloInser &&  
				  	 	 Evento.Descrizione=DescrizioneInser);
IF (utente = "gestore" &&  idEsistente IS NULL ) THEN 
INSERT INTO Evento(Data,Titolo,MaxPartecipanti,Descrizione,OrarioInizio,EmailUtenteGestore)
VALUES (DataInser,TitoloInser,MaxPartecipantiInser,DescrizioneInser,OrarioInizioInser,EmailUtenteGestoreInser);
END IF ;
IF(idEsistente IS NULL ) THEN
SET idEsistente=(SELECT Id FROM Evento WHERE(Evento.Data = DataInser AND Evento.Titolo= TitoloInser AND  
				  	 	 Evento.Descrizione=DescrizioneInser)); 
END IF;
SET idControllo=idEsistente;
COMMIT;
END$

DELIMITER ;



/* procedura che inserisce un utente come follower ad un evento  */

DELIMITER // 
CREATE PROCEDURE addFollower(IN EmailFollowerIns VARCHAR(50), IN IdEventoIns INT , OUT ControlloInserzione BOOLEAN)
BEGIN
DECLARE statoEvento VARCHAR(50) ; 
START TRANSACTION;
SET ControlloInserzione = FALSE ;
SET statoEvento=(SELECT Stato From Evento WHERE Evento.Id=IdEventoIns) ;
IF statoEvento = "APERTO" THEN 
INSERT INTO ListaFollower(EmailFollower,Id)
VALUES(EmailFollowerIns,IdEventoIns);
SET ControlloInserzione = TRUE ;
END IF;
COMMIT;
END // 
DELIMITER ;




/* procedura che aggiunge un nuovo percorso */

DELIMITER //
CREATE PROCEDURE addPercorso(IN NomeIns VARCHAR(30),IN NomeCittaIns VARCHAR(30), 
                             IN Categoria ENUM("ARTE","STORIA","NATURA","GASTRONOMIA","RELAX","MISTO"), 
                             IN EmailUtenteIns VARCHAR(50) , OUT ControlloInserzione BOOLEAN )
BEGIN
DECLARE ControlloTipo VARCHAR(30);
DECLARE nomeCIttaUtentePrem VARCHAR(50);
START TRANSACTION;
SET ControlloInserzione = FALSE;
SET ControlloTipo = (SELECT Tipo FROM Utente WHERE(Email = EmailUtenteIns));
SET nomeCIttaUtentePrem=(SELECT  NomeCitta FROM Utente 
					 	  WHERE Email=EmailUtenteIns) ;
IF(ControlloTipo = "premium" && nomeCIttaUtentePrem=NomeCittaIns) THEN 
INSERT INTO Percorso(Nome,NomeCitta,Categoria,EmailUtentePremium)
VALUES(NomeIns,NomeCittaIns,Categoria,EmailUtenteIns);
SET ControlloInserzione = TRUE;
END IF;
COMMIT;
END //
DELIMITER ;




/* procedura che aggiunge un percorso alla lista dei preferiti  */

DELIMITER  //
CREATE PROCEDURE addPreferito(IN NomePercorsoIns VARCHAR(30),IN NomeCittaIns VARCHAR(30),
                              IN EmailUtenteIns VARCHAR(50),IN NotaIns VARCHAR(300),OUT ControlloInserzione BOOLEAN)
BEGIN 
DECLARE ControlloTipo VARCHAR(30);
START TRANSACTION;
SET ControlloInserzione = FALSE;
SET ControlloTipo = (SELECT Tipo FROM Utente WHERE(Email = EmailUtenteIns));
IF(ControlloTipo = "premium") THEN 
INSERT INTO Preferito(Nome,NomeCitta,EmailUtentePremium,Nota)
VALUES(NomePercorsoIns,NomeCittaIns,EmailUtenteIns,NotaIns);
SET ControlloInserzione = TRUE;
END IF;
COMMIT;
END //
DELIMITER ;



/* procedura che elimina un percorso dalla lista dei preferiti  */

DELIMITER  //
CREATE PROCEDURE eliminaPreferito(IN NomePercorsoIns VARCHAR(30),IN NomeCittaIns VARCHAR(30),IN EmailUtenteIns VARCHAR(50),
                                    OUT ControlloInserzione BOOLEAN)
BEGIN 
DECLARE ControlloTipo VARCHAR(30);
START TRANSACTION;
SET ControlloInserzione = FALSE;
SET ControlloTipo = (SELECT Tipo FROM Utente WHERE(Email = EmailUtenteIns));
IF(ControlloTipo = "premium") THEN 
DELETE FROM Preferito WHERE(Nome=NomePercorsoIns AND NomeCitta=NomeCittaIns AND EmailUtentePremium=EmailUtenteIns) ;
SET ControlloInserzione = TRUE;
END IF;
COMMIT;
END //
DELIMITER ;




/* procedura che aggiunge un attrattiva ad un percorso */
DELIMITER //
CREATE PROCEDURE attrattivaToPercorso(IN NomePercorsoIns VARCHAR(30),IN NomeCittaPercorsoIns VARCHAR(30),
                                      IN EmailUtenteIns VARCHAR(50),IN NomeMonumentoIns VARCHAR(30),
                                      IN NomeAttivitaIns VARCHAR(30),IN TempoIns INT ,IN OrdineIns SMALLINT,
                                      OUT ControlloInserzione BOOLEAN)
BEGIN 
START TRANSACTION;
SET ControlloInserzione = FALSE;
INSERT INTO AttrattivePerPercorso(NomePercorso,NomeCittaPercorso,EmailUtente,NomeMonumento,NomeAttivita,Tempo,Ordine)
VALUES(NomePercorsoIns,NomeCittaPercorsoIns,EmailUtenteIns,NomeMonumentoIns,NomeAttivitaIns,TempoIns,OrdineIns);

UPDATE Percorso SET Durata = Durata + TempoIns WHERE(Nome=NomePercorsoIns AND NomeCitta=NomeCittaPercorsoIns);
SET ControlloInserzione = TRUE;
COMMIT;
END //
DELIMITER ;



/* procedura che si occupa di inviare messaggio tra utenti */
DELIMITER //
CREATE PROCEDURE inviaMessaggio(IN pEmailMittente VARCHAR(50),IN pEmailDestin VARCHAR(50),
                                IN Descrizione VARCHAR(300),IN Titolo VARCHAR(70))
BEGIN
START TRANSACTION;
INSERT INTO Messaggio(EmailMittente,EmailDestinario,Descrizione,Titolo,Data)
VALUES(pEmailMittente,pEmailDestin,Descrizione,Titolo,NOW());
COMMIT;
END //
DELIMITER ;






/******************************  VIEWS  ******************************/

/* visualizzare dati anagrafici + commenti pubblici */
CREATE VIEW VisDatiUtente AS 
SELECT Email,Nickname,DataNascita,NumAttrattive,Tipo,NomeCitta,Data AS DataCommento,Voto,Contenuto,NomeMonumento,NomeAttivita
FROM Utente LEFT JOIN Commento ON (Utente.Email=Commento.EmailUtente and (Commento.Stato="PUBBLICO"))
;

/* Visualizzare le attrattive per una specifica città */
CREATE VIEW attrattivePerCitta AS
SELECT NomeCitta,Nome AS NomeAttrattiva,Indirizzo,Foto,Longitudine,Latitudine
FROM AttrattivaMonumento 
UNION ALL
SELECT NomeCitta,Nome AS NomeAttrattiva,Indirizzo,Foto,Longitudine,Latitudine
FROM AttrattivaAttivita ;


/* Visualizzare la lista dei commenti “privati” */
CREATE VIEW listaCommentiPrivati AS
SELECT * FROM Commento 
WHERE(Stato="PRIVATO");


/* Visualizzare la lista degli eventi */
CREATE VIEW listaEventi AS
SELECT Data,Stato,Titolo,MaxPartecipanti,Descrizione,OrarioInizio,EmailUtenteGestore
FROM Evento;


/********     Statistiche     *********/

/* Visualizzare la classifica delle attrattive più popolari per una certa città, 
   ordinate in base ai voti medi degli utenti */

CREATE VIEW votiMedi AS
SELECT NomeMonumento AS NomeAtt, AVG(Voto) AS VotoMedio
FROM Commento 
GROUP BY NomeMonumento
UNION
SELECT NomeAttivita AS NomeAtt , AVG(Voto) AS VotoMedio
FROM Commento 
GROUP BY NomeAttivita;



CREATE VIEW tutteAttrattive AS
SELECT NomeCitta,Nome AS Attrattiva FROM AttrattivaMonumento
UNION ALL
SELECT NomeCitta,Nome AS Attrattiva FROM AttrattivaAttivita;



CREATE VIEW classificaAttrattive AS 
SELECT NomeCitta , Attrattiva , VotoMedio
FROM tutteAttrattive, votiMedi
WHERE (tutteAttrattive.Attrattiva=votiMedi.NomeAtt)
ORDER BY VotoMedio DESC;




/* Visualizzare la classifica dei percorsi più popolari per una certa città (popolarità di un
 percorso=numero di volte in cui il percorso appare tra i preferiti, considerando tutti gli
 utenti PREMIUM della piattaforma) */


CREATE VIEW classificaPercorsi AS
SELECT Nome,NomeCitta,count(*) AS NumVolte
FROM Preferito
GROUP BY Nome,NomeCitta
ORDER BY NumVolte;




/* Visualizzare la classifica degli utenti più attivi, calcolata in base al numero di contenuti
(attrattive + percorsi) inseriti da ciascun utente */

CREATE VIEW emailUtenti AS
SELECT EmailUtente FROM AttrattivaAttivita
UNION ALL
SELECT EmailUtente FROM AttrattivaMonumento
UNION ALL
SELECT EmailUtentePremium AS EmailUtente FROM Percorso;

CREATE VIEW classificaUtenti AS
SELECT EmailUtente, count(*) AS NumAttPerc
FROM emailUtenti
GROUP BY EmailUtente
ORDER BY NumAttPerc DESC;




/*****************************  TRIGGERS  *******************************/



/* Trigger per il controllo del voto */
DELIMITER $$

CREATE TRIGGER CHECKVOTO  
BEFORE INSERT ON Commento  
FOR EACH ROW  
BEGIN  
  IF (NEW.Voto < 0 OR NEW.Voto > 5)  
THEN  
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il voto deve essere tra 0 e 5 ';
END IF;
END $$

DELIMITER ;



/* Triggers che permettono l'operazione di promozione da un utente Sempilce a utente Premium */

DELIMITER $
CREATE TRIGGER updateStatoUtente
AFTER INSERT ON AttrattivaMonumento 
FOR EACH ROW
BEGIN 
DECLARE NumAtt INT;
DECLARE TipoUtente VARCHAR(20);
UPDATE Utente SET Utente.NumAttrattive = Utente.NumAttrattive+1
WHERE Utente.Email= NEW.EmailUtente ;
SET NumAtt = (SELECT NumAttrattive FROM Utente WHERE(Utente.Email=NEW.EmailUtente));
SET TipoUtente = (SELECT Tipo FROM Utente WHERE Utente.Email=New.EmailUtente);
IF(NumAtt >= 3 AND TipoUtente="semplice") THEN 
UPDATE Utente SET Utente.Tipo ="premium" WHERE (Utente.Email=NEW.EmailUtente);
END IF;
END$
DELIMITER ;


DELIMITER $
CREATE TRIGGER updateStatoUtenteS
AFTER INSERT ON AttrattivaAttivita 
FOR EACH ROW
BEGIN 
DECLARE NumAtt INT;
DECLARE TipoUtente VARCHAR(20);
UPDATE Utente SET Utente.NumAttrattive = Utente.NumAttrattive+1
WHERE Utente.Email= NEW.EmailUtente ;
SET NumAtt = (SELECT NumAttrattive FROM Utente WHERE(Utente.Email=NEW.EmailUtente));
SET TipoUtente = (SELECT Tipo FROM Utente WHERE Utente.Email=New.EmailUtente);
IF(NumAtt >= 3 AND TipoUtente="semplice") THEN 
UPDATE Utente SET Utente.Tipo ="premium" WHERE (Utente.Email=NEW.EmailUtente);
END IF;
END$
DELIMITER ;



/* trigger che cambia lo stato del evento da APERTO a CHIUSO */
DELIMITER $
CREATE TRIGGER updateStatoEvento
AFTER INSERT ON ListaFollower
FOR EACH ROW 
BEGIN
DECLARE NumPartic INT;
DECLARE NumFollower INT;
SET NumPartic = (SELECT MaxPartecipanti FROM Evento WHERE(Evento.Id=New.Id));
SET NumFollower = (SELECT COUNT(*) FROM ListaFollower WHERE(Id=New.Id));

IF(NumPartic=NumFollower) THEN
UPDATE Evento SET Stato="CHIUSO"
WHERE Evento.Id=NEW.Id;
END IF;
END$

DELIMITER ;


/***********************************POPOLAMENTO DEL DATABASE *************************************/



/*Inserimento degli utenti e le citta in cui rissiedono */


CALL Registrarsi("admin_premium@yahoo.com","admin","1999-09-09","adminpremium","semplice","Bologna","","","","","Italia",
                 "Emiglia-Romagna","uploads/bologna.jpg",@var);
CALL Registrarsi("admin_gestore@yahoo.com","admin","1999-09-09","admingestore","gestore","Bologna","attivitaAdmin",
                 "via zamboni","039","www.admin.com","","","",@var);
CALL Registrarsi("mario09@yahoo.com","mario09",
                 "1997-03-09","mario","semplice","Verona","","","","","Italia","Veneto","uploads/verona.jpg",@var);
CALL Registrarsi("francesco_gal@yahoo.com","francesco_gal",
                 "1996-05-08","francesco","semplice","Bari","","","","","Italia","Puglia","uploads/bari.jpg",@var);
CALL Registrarsi("jack_mi@yahoo.com","jack_mi","1995-11-12","jack","semplice","London","","","","","United Kingdom",
                 "Greater London","uploads/london.png",@var);
CALL Registrarsi("enrique04@yahoo.com","enrique04","1993-06-07","enrique","semplice","Madrid","","","","","Spain",
                 "Community of Madrid","uploads/madrid.jpg",@var);
CALL Registrarsi("michel01@yahoo.com","michel01","1992-03-01","michel","semplice","Paris","","","","","France",
                 "North Paris","uploads/paris.jpg",@var);
CALL Registrarsi("leo11@yahoo.com","leo11","1991-04-11","leo","semplice","Bologna","","","","","","","",@var);
CALL Registrarsi("raul12@yahoo.com","raul12","1990-07-10","raul","semplice","Milano","","","","",
                 "Italia","Lombardia","uploads/milano.jpg",@var);
CALL Registrarsi("matteo13@yahoo.com","matteo13","1994-10-10","matteo","semplice","Roma","","","","","Italia","Lazio","uploads/roma.jpg",@var);
CALL Registrarsi("bruno14@yahoo.com","bruno14","1997-02-04","bruno","gestore","Genova","Gara di nuoto","Boccadasse",
                 "00393210458","www.piscinebruno.com","Italia","Liguria","uploads/genova.jpg",@var);
CALL Registrarsi("lorenzo15@yahoo.com","lorenzo15","1985-02-05","lorenzo","gestore","Venezia","Paint the streets",
                 "via ...","00395245220","www.lorenzocolors.com","Italia","Veneto","uploads/venezia.jpg",@var);


/*Inserimento delle attrattive */


                                            
CALL InserisciAttrattivaMonumento("Due Torri","Bologna","admin_premium@yahoo.com","simbolo della città","VISITABILE",
                                  "Centro della citta","uploads/attrattive/dueTorri.jpg","442939.12N","112048.12E",@var);
CALL InserisciAttrattivaMonumento("Sette Chiese","Bologna","admin_premium@yahoo.com"," un complesso di edifici di culto ",
                                  "VISITABILE","Piazza Santo Stefano","uploads/attrattive/settechiese.jpg","442938.13N","112047.13E",@var);
CALL InserisciAttrattivaAttivita("BotanicoMusic","Bologna","admin_premium@yahoo.com","5 euro ","21:00","24:00",
                                 "da Lunedi a Venerdi","Via Filipo Re ,1","uploads/attrattive/botanico.jpg","442938.13N","112047.13E",@var);
CALL InserisciAttrattivaMonumento("Arena di Verona","Verona","mario09@yahoo.com","anfiteatro romano","VISITABILE",
                                  "Centro storico","uploads/attrattive/arenaVerona.jpg","442939.12N","442939.12N",@var);
CALL InserisciAttrattivaMonumento("London Eye","London","jack_mi@yahoo.com","giant ferris","VISITABILE",
                                  "River Thames","uploads/attrattive/londonEye.jpg","442939.12N","442939.12N",@var);
CALL InserisciAttrattivaMonumento("Plaza Mayor","Madrid","enrique04@yahoo.com","central plaza","VISITABILE",
                                  "Centro Citta","uploads/attrattive/plazaMayor.jpg","442939.12N","442939.12N",@var);
CALL InserisciAttrattivaMonumento("Eiffel Tower","Paris","michel01@yahoo.com","historical monument","VISITABILE GRATIS",
                                  "city centre ","uploads/attrattive/tourEiffel.jpg","442939.12N","442939.12N",@var);
CALL InserisciAttrattivaMonumento("San Siro ","Milano","raul12@yahoo.com","stadio","VISITABILE","quartiere san siro",
                                  "uploads/attrattive/sansiro.jpg","442939.12","442939.12N",@var);
CALL InserisciAttrattivaMonumento("Colosseum","Roma","matteo13@yahoo.com","historical","VISITABILE","centro",
                                    "uploads/attrattive/Colosseum.jpg","442939.12","442939.12N",@var);
CALL InserisciAttrattivaAttivita("DolphinsAcquario","Genova","bruno14@yahoo.com","10 euro","18:00","24:00",
                                 "mercoledi e Venerdi","via massarenti","uploads/attrattive/acquarioGenova.jpg","442938.13N","112047.13E",@var);
CALL InserisciAttrattivaMonumento("Piazza San Marco","Venezia","lorenzo15@yahoo.com","culturale","VISITABILE","centro",
                                  "uploads/attrattive/PiazzaSanMarco.jpg","442939.12","442939.12N",@var);
CALL InserisciAttrattivaMonumento("Big Ben","London","jack_mi@yahoo.com","campana Clock Tower","VISITABILE GRATIS",
                                  "Westminster Londres SW1A 0AA","uploads/attrattive/bigBen.png","442939.12","442939.12",@var);
CALL InserisciAttrattivaMonumento("Buckingham Palace","London","jack_mi@yahoo.com"," la residenza ufficiale del sovrano del Regno Unito",
                                  "NON VISITABILE","Westminster Londres SW1A 1AA","uploads/attrattive/buckinghamPalace.jpg","442939.12","442939.12",@var);

/*Inserimento degli eventi creati da utenti gestori */ 




CALL AddEvento("2018-01-25","Gara di nuoto ",3,"Gara di nuoto da tre partecipanti","18:00","bruno14@yahoo.com",@Id1);
CALL AddEvento("2017-08-24","Concorso di pittura",5,"Concorso libero di pittura per strada","14:00","admin_gestore@yahoo.com",@Id2);
CALL AddEvento("2018-08-15","Gara di Tennis",4,"Gara di tennis da quatro partecipanti","10:00","admin_gestore@yahoo.com",@Id2);

/*Inserimento di commenti per le attrattive create*/


CALL InserisciCommento("leo11@yahoo.com","4","PUBBLICO","Acquaria molto bello , uno tra i piu grandi in Europa e vicino al centro. ",
                       "","DolphinsAcquario",@var);
CALL InserisciCommento("raul12@yahoo.com","3","PUBBLICO","Piazza santo stefano era un posto meraviglioso","Sette Chiese","",@var);
CALL InserisciCommento("enrique04@yahoo.com","5","PUBBLICO","The most beautiful historical place Ive ever been to .","Colosseum","",@var);
CALL InserisciCommento("matteo13@yahoo.com","2","PUBBLICO","A messy place . London has much more beautiful places to be .",
                       "London Eye","",@var);


/* Inserimento di percorsi da utenti premium */

CALL addPercorso("London Tour","London","MISTO","jack_mi@yahoo.com", @var);                       
CALL addPercorso("Tour di Bologna","Bologna","MISTO","admin_premium@yahoo.com" , @var);                       
                             
                             
/* Inserimento di attrattive in percorsi */

CALL attrattivaToPercorso("London Tour","London","jack_mi@yahoo.com","London Eye","",30,1,@var);
CALL attrattivaToPercorso("London Tour","London","jack_mi@yahoo.com","Big Ben","",20,2,@var);
CALL attrattivaToPercorso("London Tour","London","jack_mi@yahoo.com","Buckingham Palace","",20,3,@var);

CALL attrattivaToPercorso("Tour di Bologna","Bologna","admin_premium@yahoo.com","Due Torri","",40,1,@var);
CALL attrattivaToPercorso("Tour di Bologna","Bologna","admin_premium@yahoo.com","Sette Chiese","",30,2,@var);
CALL attrattivaToPercorso("Tour di Bologna","Bologna","admin_premium@yahoo.com","","BotanicoMusic",60,3,@var);


/* Inserimento di percorsi preferiti a utenti premium */

                              
CALL addPreferito("London Tour","London","admin_premium@yahoo.com",'mi piace questo percorso',@var);
CALL addPreferito("Tour di Bologna","Bologna","jack_mi@yahoo.com",'i like this tour',@var);


/* Inserimento di followers di eventi */

CALL addFollower('mario09@yahoo.com',1,@var);
CALL addFollower('francesco_gal@yahoo.com',1,@var);
CALL addFollower('jack_mi@yahoo.com',1,@var);

CALL addFollower('enrique04@yahoo.com',2,@var);
CALL addFollower('michel01@yahoo.com',2,@var);
CALL addFollower('leo11@yahoo.com',2,@var);
CALL addFollower('raul12@yahoo.com',2,@var);






