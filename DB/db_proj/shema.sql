CREATE TABLE Judge (
    id  SERIAL,
    LastName    VARCHAR(100)    NOT NULL,
    FirstName   VARCHAR(100)    NOT NULL,
    SecondName  VARCHAR(100)
);

INSERT INTO Judge (LastName, FirstName, SecondName) VALUES
    ('Пономарев', 'Иван', 'Иванович'),
    ('Кондрат','Еватерина','Викторовна');