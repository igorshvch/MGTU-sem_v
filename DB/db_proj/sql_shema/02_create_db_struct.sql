/*
Некоторые идеи:
https://stackoverflow.com/questions/10068033/postgresql-foreign-key-referencing-primary-keys-of-two-different-tables
*/
DROP TABLE IF EXISTS Courts                 CASCADE;
DROP TABLE IF EXISTS Judges                 CASCADE;
DROP TABLE IF EXISTS LegalRepr              CASCADE;
DROP TABLE IF EXISTS GrantorPerson          CASCADE;
DROP TABLE IF EXISTS GrantorLE              CASCADE;
DROP TABLE IF EXISTS PowerOfAttorney        CASCADE;
DROP TABLE IF EXISTS CaseNum                CASCADE;
DROP TABLE IF EXISTS Cases                  CASCADE;
DROP TABLE IF EXISTS SubCase                CASCADE;
DROP TABLE IF EXISTS CaseSession            CASCADE;

--001. Суды
CREATE TABLE IF NOT EXISTS Courts (
    id              SERIAL          PRIMARY KEY,
    CourtName       VARCHAR(200)    NOT NULL,
    CourtAddress    VARCHAR(200)    NOT NULL,
    ZipCode         VARCHAR(10)     NOT NULL,
    WebAddress      VARCHAR(200)    NOT NULL
);

--002. Судьи
CREATE TABLE IF NOT EXISTS Judges (
    id              SERIAL          PRIMARY KEY,
    LastName        VARCHAR(100)    NOT NULL,
    FirstName       VARCHAR(100)    NOT NULL,
    SecondName      VARCHAR(100),
    TelNum          VARCHAR(10)     CHECK (char_length(TelNum) = 10),
    Court           INTEGER         NOT NULL,
    CONSTRAINT fk_court
        FOREIGN KEY (Court)
            REFERENCES Courts(id)
);

--003. Аггрегированная таблица для доверенностей
CREATE TABLE IF NOT EXISTS LegalRepr (
    id              SERIAL          PRIMARY KEY,
    TypeOfGrantor   CHAR(1)         NOT NULL
);

--004. Доверенности от ФЛ
CREATE TABLE IF NOT EXISTS GrantorPerson (
    id              SERIAL          PRIMARY KEY,
    LastName        VARCHAR(100)    NOT NULL,
    FirstName       VARCHAR(100)    NOT NULL,
    SecondName      VARCHAR(100),
    RegNum          VARCHAR(12)     CHECK(char_length(RegNum) = 12),
    RegAddress      VARCHAR(500)    NOT NULL,
    ZipCode         VARCHAR(10)     NOT NULL,
    CONSTRAINT fk_id
        FOREIGN KEY(id)
            REFERENCES LegalRepr(id)
);

--005. Доверенности от ЮЛ
CREATE TABLE IF NOT EXISTS GrantorLE (
    id              SERIAL          PRIMARY KEY,
    CompanyLF       VARCHAR(10)     NOT NULL,
    CompanyName     VARCHAR(200)    NOT NULL,
    RegNum          VARCHAR(13)     CHECK(char_length(RegNum) = 13),
    TaxNum          VARCHAR(10)     CHECK(char_length(TaxNum) = 10),
    RegAddress      VARCHAR(500)    NOT NULL,
    ZipCode         VARCHAR(10)     NOT NULL,
    CONSTRAINT fk_id
        FOREIGN KEY(id)
            REFERENCES LegalRepr(id)
);

--006. Доверенности
CREATE TABLE IF NOT EXISTS PowerOfAttorney (
    id              SERIAL          PRIMARY KEY,
    Grantor         INTEGER         NOT NULL,
    DateOfGrant     DATE            NOT NULL,
    PeriodDays      INTEGER         DEFAULT NULL,
    PeriodMonths    INTEGER         DEFAULT NULL,
    PeriodYears     INTEGER         DEFAULT NULL,
    CONSTRAINT PeriodCheck
        CHECK ((PeriodDays IS NOT NULL) OR (PeriodMonths IS NOT NULL) OR (PeriodYears IS NOT NULL)),
    CONSTRAINT fk_grantor
        FOREIGN KEY (Grantor)
            REFERENCES LegalRepr(id)
);

--007. Номер дела и идентификатор, если применимо
CREATE TABLE IF NOT EXISTS CaseNum (
    id              SERIAL          PRIMARY KEY,
    Num             VARCHAR(50)     NOT NULL,
    InternalId      VARCHAR(150)
);

--008. Таблица дел
CREATE TABLE IF NOT EXISTS Cases (
    id              INTEGER          PRIMARY KEY,
    Сomplainant     VARCHAR(200)    NOT NULL,
    Defendant       VARCHAR(200)    NOT NULL,
    CaseBasis       VARCHAR(500)    NOT NULL,
    Court           INTEGER         NOT NULL,
    Judge           INTEGER         NOT NULL,
    CaseRole        VARCHAR(200)    NOT NULL,
    GrantorId       INTEGER         NOT NULL,
    DateStart       DATE            NOT NULL,
    Commentary      VARCHAR(1000),
    CONSTRAINT fk_id
        FOREIGN KEY (id)
            REFERENCES CaseNum(id),
    CONSTRAINT fk_Court
        FOREIGN KEY (Court)
            REFERENCES Courts(id),
    CONSTRAINT fk_Judge
        FOREIGN KEY (Judge)
            REFERENCES Judges(id),
    CONSTRAINT fk_GrantorId
        FOREIGN KEY (GrantorId)
            REFERENCES LegalRepr(id)
);

--009. Таблица обособленных споров
CREATE TABLE IF NOT EXISTS SubCase (
    id              SERIAL          PRIMARY KEY,
    Case_id         INTEGER         NOT NULL,
    CaseDescript    VARCHAR(500)    NOT NULL,
    SubСomplainant  VARCHAR(200)    NOT NULL,
    SubCaseRole     VARCHAR(200)    NOT NULL,
    DateStart       DATE            NOT NULL,
    Commentary      VARCHAR(1000),
    CONSTRAINT fk_Case_id
        FOREIGN KEY (Case_id)
            REFERENCES CaseNum(id)
);

--010. Заседание
CREATE TABLE IF NOT EXISTS CaseSession (
    id              SERIAL          PRIMARY KEY,
    Case_id         INTEGER         NOT NULL,
    SubCase_id      INTEGER,
    SessionDate     DATE            NOT NULL,
    SessionTime     TIME,
    SessionRoom     VARCHAR(20),
    ParticipForm    VARCHAR(20),
    ToDo            VARCHAR(200),
    Done            BOOLEAN,
    DecisionRef     VARCHAR(500),
    Commentary      VARCHAR(1000),
    CONSTRAINT fk_Case_id
        FOREIGN KEY (Case_id)
            REFERENCES CaseNum(id),
    CONSTRAINT fk_SubCase_id
        FOREIGN KEY (SubCase_id)
            REFERENCES SubCase(id)
);