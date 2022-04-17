CREATE OR REPLACE PROCEDURE add_PoA_person (
        LastName        VARCHAR(100),
        FirstName       VARCHAR(100),
        RegAddress      VARCHAR(500),
        ZipCode         VARCHAR(10),
        DateOfGrant     date,
        SecondName      VARCHAR(100)    DEFAULT NULL,
        RegNum          VARCHAR(12)     DEFAULT NULL,
        PeriodDays      INTEGER         DEFAULT NULL,
        PeriodMonths    INTEGER         DEFAULT NULL,
        PeriodYears     INTEGER         DEFAULT NULL
    )
    LANGUAGE plpgsql
    AS $$
        DECLARE
            temp_id     INTEGER;
        BEGIN
        INSERT INTO LegalRepr(TypeOfGrantor) VALUES
            ('p') RETURNING id INTO temp_id;
        --COMMIT;
        raise notice 'temp_id is %', temp_id;
        INSERT INTO GrantorPerson
            (
                id,
                LastName,
                FirstName,
                SecondName,
                RegNum,
                RegAddress,
                ZipCode
            ) VALUES
            (
                temp_id,
                LastName,
                FirstName,
                SecondName,
                RegNum,
                RegAddress,
                ZipCode
            );
        --COMMIT;
        INSERT INTO PowerOfAttorney
            (
                Grantor,
                DateOfGrant,
                PeriodDays,
                PeriodMonths,
                PeriodYears
            ) VALUES
            (
                temp_id,
                DateOfGrant,
                PeriodDays,
                PeriodMonths,
                PeriodYears
            );
        --COMMIT;
        END;
    $$;


CALL add_PoA_person (
    LastName        =>  'Фамилия',
    FirstName       =>  'Имя',
    SecondName      =>  'Отчество',
    RegAddress      =>  'Адрес регистрации',
    ZipCode         =>  '123456',
    DateOfGrant     =>  '2022-01-01',
    PeriodYears     =>  2
);