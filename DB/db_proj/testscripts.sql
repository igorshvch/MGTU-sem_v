DROP TABLE IF EXISTS Country CASCADE;
DROP TABLE IF EXISTS UNrepresentative CASCADE;


CREATE TABLE Country
    (
        Pk_Country_Id   INT PRIMARY KEY,
        Name            VARCHAR(100),
        Officiallang    VARCHAR(100)
    );

CREATE TABLE UNrepresentative
    (
        Pk_UNrepresentative_Id INT PRIMARY KEY,
        Name            VARCHAR(100),
        Gender          VARCHAR(100),
        Fk_Country_Id   INT,
        UNIQUE(Fk_Country_Id),
        CONSTRAINT fk_con
            FOREIGN KEY (Fk_Country_Id)
                REFERENCES Country(Pk_Country_Id)
    );

/*
INSERT INTO Country ('Name','Officiallang',’Size’)
VALUES ('Nigeria','English',923,768);
INSERT INTO Country ('Name','Officiallang',’Size’)
VALUES ('Ghana','English',238,535);
INSERT INTO Country ('Name','Officiallang',’Size’)
VALUES ('South Africa','English',1,219,912);
INSERT INTO UNrepresentative ('Pk_Unrepresentative_Id','Name','Gender','Fk_Country_Id')
VALUES (51,'Abubakar Ahmad','Male',1);
INSERT INTO UNrepresentative ('Pk_Unrepresentative_Id','Name','Gender','Fk_Country_Id')
VALUES (52,'Joseph Nkrumah','Male',2);
INSERT INTO UNrepresentative ('Pk_Unrepresentative_Id','Name','Gender','Fk_Country_Id')
VALUES (53,'Lauren Zuma','Female',3);

SELECT * FROM Country
SELECT * FROM UNrepresentative;
*/