CREATE OR REPLACE PROCEDURE add_PoA_person (
        RegNumVal          VARCHAR(12)     DEFAULT NULL
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
                RandPersName('l'),
                RandPersName('f'),
                RandPersName('s'),
                RegNumVal,
                RandRegAdress(),
                RandNum(6)
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
                RandDate(),
                cast(floor(random()*28+1) as INTEGER),
                cast(floor(random()*12) as INTEGER),
                cast(floor(random()*3) as INTEGER)
            );
        --COMMIT;
        END;
    $$;

CREATE OR REPLACE PROCEDURE add_PoA_LegalEntity ()
    LANGUAGE plpgsql
    AS $$
        DECLARE
            temp_id     INTEGER;
        BEGIN
        INSERT INTO LegalRepr(TypeOfGrantor) VALUES
            ('l') RETURNING id INTO temp_id;
            --COMMIT;
        raise notice 'temp_id is %', temp_id;
        INSERT INTO GrantorLE
            (
                id,
                CompanyLF,
                CompanyName,
                RegNum,
                TaxNum,
                RegAddress,
                ZipCode
            ) VALUES
            (
                temp_id,
                RandLegalForm(),
                RandCompName(),
                RandNum(13),
                RandNum(10),
                RandRegAdress(),
                RandNum(6)
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
                RandDate(),
                cast(floor(random()*28+1) as INTEGER),
                cast(floor(random()*12) as INTEGER),
                cast(floor(random()*3) as INTEGER)
            );
        --COMMIT;
        END;
    $$;

CREATE OR REPLACE PROCEDURE add_Court()
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO Courts
                (
                    CourtName,
                    CourtAddress,
                    ZipCode,
                    WebAddress
                ) VALUES
                (
                    RandCourtName(),
                    RandRegAdress(),
                    RandNum(6),
                    RandWeb(8)
                );
        END;
    $$;

CREATE OR REPLACE PROCEDURE add_Judge()
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO Judges
                (
                    LastName,
                    FirstName,
                    SecondName,
                    TelNum,
                    Court
                ) VALUES
                (
                    RandPersName('l'),
                    RandPersName('f'),
                    RandPersName('s'),
                    RandNum(10),
                    RandGetCourt()
                );
        END;
    $$;

CREATE OR REPLACE PROCEDURE add_CaseNum()
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO CaseNum
                (
                    Num,
                    InternalId
                ) VALUES
                (
                    RandCaseNum(),
                    RandNum(20)
                );
        END;
    $$;

CREATE OR REPLACE PROCEDURE add_Cases()
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CourtId             INTEGER;
            JudgeId             INTEGER;           
        BEGIN
            CourtId = RandGetId('Courts');
            RAISE NOTICE 'this is CourtID %', CourtId;
            JudgeId = GetRandJudgeFromCourt(CourtId);
            RAISE NOTICE 'this is JudgeID %', JudgeId;
            INSERT INTO Cases
                (
                    id,
                    Сomplainant,
                    Defendant,
                    CaseBasis,
                    Court,
                    Judge,
                    CaseRole,
                    GrantorId,
                    DateStart
                ) VALUES
                (
                    RandGetId('CaseNum'),
                    RandFullName(),
                    RandFullName(),
                    RandCaseBasis('m'),
                    CourtId,
                    GetRandJudgeFromCourt(CourtId),
                    RandCaseRole('m'),
                    RandGetId('LegalRepr'),
                    RandDate(DateStart=>'2019-01-01', DateEnd=>'2020-07-01')
                );
        END;
    $$;

CREATE OR REPLACE PROCEDURE add_SubCase()
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CasesBuncr         INTEGER[];
            CaseId             INTEGER;
            temp_Date          DATE;
            Date_Start         DATE;         
        BEGIN
            CasesBuncr = array(SELECT id FROM Cases WHERE CaseBasis = 'Заявление о банкротстве');
            CaseId = RandIntArElem(CasesBuncr);
            SELECT DateStart INTO temp_Date FROM Cases WHERE id = CaseId;
            Date_Start = RandDate(DateStart => temp_Date, DateEnd => '2022-05-01');
            INSERT INTO SubCase
                (
                    Case_id,
                    CaseDescript,
                    SubСomplainant,
                    SubCaseRole,
                    DateStart
                ) VALUES
                (
                    CaseId,
                    RandCaseBasis('s'),
                    RandFullName(),
                    RandCaseRole('s'),
                    Date_Start
                );
        END;
    $$;

CREATE OR REPLACE PROCEDURE add_CaseSession()
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CaseId             INTEGER;
            SubCaseID          INTEGER ;
            temp_Date          DATE;
            Date_Session       DATE;
        BEGIN
            CaseId = RandIntArElem(Cases);
            SELECT id INTO SubCaseID FROM SubCase WHERE id = CaseId;
            IF SubCaseID NOT NULL THEN
                SELECT DateStart INTO temp_Date FROM SubCase WHERE id = SubCaseID;
            ELSE
                SELECT DateStart INTO temp_Date FROM Cases WHERE id = CaseId;
            END IF;
            Date_Session = RandDate(DateStart => temp_Date, DateEnd => '2022-05-01');
            


            
            
        /*
        */
            INSERT INTO CaseSession
                (
                    Case_id,
                    SubCase_id,
                    SessionDate,
                    SessionTime,
                    SessionRoom,
                    ParticipForm,
                    ToDo,
                    DecisionRef
                ) VALUES
                (
                    CaseId,
                    SubCaseId,
                    Date_Session,
                    ..,
                    RandNum(3),
                    ..,
                    ..,
                    RandWeb(12)
                );
        END;
    $$;