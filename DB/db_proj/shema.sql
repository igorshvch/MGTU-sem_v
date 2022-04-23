DROP SCHEMA IF EXISTS db_lit CASCADE;

CREATE SCHEMA db_lit;

--
CREATE TABLE IF NOT EXISTS db_lit.regions_ids (
    RegionName VARCHAR(255),
    id INTEGER PRIMARY KEY,
);

INSERT INTO db_lit.courts VALUES
    ('Москва', 77),
    ('Пермский край', 59),
    ('Московская область', 90);

--
CREATE TABLE IF NOT EXISTS db_lit.courts (
    id SERIAL PRIMARY KEY,
    CourtName VARCHAR(255),
    ZipCode INTEGER,
    Region SERIAL,
    CourtAddress VARCHAR(511),

    CONSTRAINTS fk_region FOREIGN KEY(Region)
        REFERENCES db_lit.db_lit.regions_ids(id)
        ON DELETE RESTRICT
);

INSERT INTO db_lit.courts VALUES
    ('Арбитражный суд города Москвы', 115225, '77', '115225, г. Москва, ул. Большая Тульская, д. 17'),
    ('Арбитражный суд Московской области', 107053, 90, '107053, г. Москва, пр. Академика Сахарова, д. 18'),
    ('Арбитражный суд Пермского края', 614068, 59, '614068, Пермский край, г. Пермь, ул. Екатерининская, д. 177'),
    ('Арбитражный суд Пермского края', 614068, 59, '614068, Пермский край, г. Пермь, ул. Екатерининская, д. 177'),


CREATE TABLE IF NOT EXISTS db_lit.judge (
    id  SERIAL PRIMARY KEY,
    LastName    VARCHAR(100)    NOT NULL,
    FirstName   VARCHAR(100)    NOT NULL,
    SecondName  VARCHAR(100),
    Court SERIAL,

    CONSTRAINT fk_court FOREIGN KEY(Court) 
        REFERENCES db_lit.courts(id)
        ON DELETE RESTRICT
);

INSERT INTO db_lit.Judge (LastName, FirstName, SecondName) VALUES
    ('Пономарев', 'Иван', 'Иванович', 1),
    ('Кондрат','Еватерина','Викторовна', 2);


