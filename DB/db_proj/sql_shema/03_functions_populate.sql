DROP PROCEDURE IF EXISTS legal_issue_tracker.add_PoA_person;
DROP PROCEDURE IF EXISTS legal_issue_tracker.add_PoA_LegalEntity;
DROP PROCEDURE IF EXISTS legal_issue_tracker.add_Court;
DROP PROCEDURE IF EXISTS legal_issue_tracker.add_Judge;
DROP FUNCTION IF EXISTS  legal_issue_tracker.add_CaseNum_n_Payment;
DROP PROCEDURE IF EXISTS legal_issue_tracker.add_Cases;
DROP PROCEDURE IF EXISTS legal_issue_tracker.add_SubCase;
DROP PROCEDURE IF EXISTS legal_issue_tracker.add_CaseSession;


CREATE OR REPLACE PROCEDURE legal_issue_tracker.add_PoA_person (
        RegNumVal          VARCHAR(12)     DEFAULT NULL
    )
    LANGUAGE plpgsql
    AS $$
        DECLARE
            temp_id     INTEGER;
        BEGIN
        INSERT INTO legal_issue_tracker.LegalRepr(TypeOfGrantor) VALUES
            ('p') RETURNING id INTO temp_id;
        INSERT INTO legal_issue_tracker.GrantorPerson
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
                legal_issue_tracker.RandPersName('l'),
                legal_issue_tracker.RandPersName('f'),
                legal_issue_tracker.RandPersName('s'),
                RegNumVal,
                legal_issue_tracker.RandRegAdress(),
                legal_issue_tracker.RandNum(6)
            );
        INSERT INTO legal_issue_tracker.PowerOfAttorney
            (
                Grantor,
                DateOfGrant,
                PeriodDays,
                PeriodMonths,
                PeriodYears
            ) VALUES
            (
                temp_id,
                legal_issue_tracker.RandDate(),
                cast(floor(random()*28+1) as INTEGER),
                cast(floor(random()*12) as INTEGER),
                cast(floor(random()*3) as INTEGER)
            );
        END;
    $$;

CREATE OR REPLACE PROCEDURE legal_issue_tracker.add_PoA_LegalEntity ()
    LANGUAGE plpgsql
    AS $$
        DECLARE
            temp_id     INTEGER;
        BEGIN
        INSERT INTO legal_issue_tracker.LegalRepr(TypeOfGrantor) VALUES
            ('l') RETURNING id INTO temp_id;
        INSERT INTO legal_issue_tracker.GrantorLE
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
                legal_issue_tracker.RandLegalForm(),
                legal_issue_tracker.RandCompName(),
                legal_issue_tracker.RandNum(13),
                legal_issue_tracker.RandNum(10),
                legal_issue_tracker.RandRegAdress(),
                legal_issue_tracker.RandNum(6)
            );
        INSERT INTO legal_issue_tracker.PowerOfAttorney
            (
                Grantor,
                DateOfGrant,
                PeriodDays,
                PeriodMonths,
                PeriodYears
            ) VALUES
            (
                temp_id,
                legal_issue_tracker.RandDate(),
                cast(floor(random()*28+1) as INTEGER),
                cast(floor(random()*12) as INTEGER),
                cast(floor(random()*3) as INTEGER)
            );
        END;
    $$;

CREATE OR REPLACE PROCEDURE legal_issue_tracker.add_Court()
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO legal_issue_tracker.Courts
                (
                    CourtName,
                    CourtAddress,
                    ZipCode,
                    WebAddress
                ) VALUES
                (
                    legal_issue_tracker.RandCourtName(),
                    legal_issue_tracker.RandRegAdress(),
                    legal_issue_tracker.RandNum(6),
                    legal_issue_tracker.RandWeb(8)
                );
        END;
    $$;

CREATE OR REPLACE PROCEDURE legal_issue_tracker.add_Judge()
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO legal_issue_tracker.Judges
                (
                    LastName,
                    FirstName,
                    SecondName,
                    TelNum,
                    Court
                ) VALUES
                (
                    legal_issue_tracker.RandPersName('l'),
                    legal_issue_tracker.RandPersName('f'),
                    legal_issue_tracker.RandPersName('s'),
                    legal_issue_tracker.RandNum(10),
                    legal_issue_tracker.RandGetCourt()
                );
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.add_CaseNum_n_Payment()
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
        DECLARE
            temp_item           legal_issue_tracker.ITEM;
            temp_id             INTEGER;
        BEGIN
            SELECT * INTO temp_item FROM legal_issue_tracker.RandPayment();
            INSERT INTO legal_issue_tracker.CaseNum
                (
                    Num,
                    InternalId
                ) VALUES
                (
                    legal_issue_tracker.RandCaseNum(),
                    legal_issue_tracker.RandNum(20)
                ) RETURNING id INTO temp_id;
            INSERT INTO legal_issue_tracker.Payment
                (
                    Case_id,
                    PaymentMethod,
                    PaymentAmmount
                ) VALUES
                (
                    temp_id,
                    temp_item.temp_text,
                    temp_item.temp_money
                ) RETURNING id INTO temp_id;
            RETURN temp_id;
        END;
    $$;

CREATE OR REPLACE PROCEDURE legal_issue_tracker.add_Cases()
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CourtId             INTEGER;
            JudgeId             INTEGER;
            temp_id             INTEGER;        
        BEGIN
            JudgeId = legal_issue_tracker.RandGetId('legal_issue_tracker.Judges');
            SELECT Court INTO CourtId FROM legal_issue_tracker.Judges WHERE id = JudgeID;
            temp_id = legal_issue_tracker.add_CaseNum_n_Payment();
            INSERT INTO legal_issue_tracker.Cases
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
                    temp_id,
                    legal_issue_tracker.RandFullName(),
                    legal_issue_tracker.RandFullName(),
                    legal_issue_tracker.RandCaseBasis('m'),
                    CourtId,
                    JudgeId,
                    legal_issue_tracker.RandCaseRole('m'),
                    legal_issue_tracker.RandGetId('legal_issue_tracker.LegalRepr'),
                    legal_issue_tracker.RandDate(DateStart=>'2019-01-01', DateEnd=>'2022-05-01')
                );
        END;
    $$;

CREATE OR REPLACE PROCEDURE legal_issue_tracker.add_SubCase()
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CasesBuncr         INTEGER[];
            CaseId             INTEGER;
            temp_Date          DATE;
            Date_Start         DATE;         
        BEGIN
            CasesBuncr = array(SELECT id FROM legal_issue_tracker.Cases WHERE CaseBasis = 'Заявление о банкротстве');
            CaseId = legal_issue_tracker.RandIntArElem(CasesBuncr);
            SELECT DateStart INTO temp_Date FROM legal_issue_tracker.Cases WHERE id = CaseId;
            Date_Start = legal_issue_tracker.RandDate(DateStart => temp_Date, DateEnd => '2022-05-01');
            INSERT INTO legal_issue_tracker.SubCase
                (
                    Case_id,
                    CaseDescript,
                    SubСomplainant,
                    SubCaseRole,
                    DateStart
                ) VALUES
                (
                    CaseId,
                    legal_issue_tracker.RandCaseBasis('s'),
                    legal_issue_tracker.RandFullName(),
                    legal_issue_tracker.RandCaseRole('s'),
                    Date_Start
                );
        END;
    $$;


CREATE OR REPLACE PROCEDURE legal_issue_tracker.add_CaseSession()
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CaseId             INTEGER;
            SubCaseID          INTEGER ;
            temp_Date          DATE;
            Date_Session       DATE;
        BEGIN
            CaseId = legal_issue_tracker.RandGetId('legal_issue_tracker.Cases');
            SELECT id INTO SubCaseID FROM legal_issue_tracker.SubCase WHERE Case_id = CaseId;
            IF SubCaseID IS NOT NULL THEN
                SELECT DateStart INTO temp_Date FROM legal_issue_tracker.SubCase WHERE id = SubCaseID;
            ELSE
                SELECT DateStart INTO temp_Date FROM legal_issue_tracker.Cases WHERE id = CaseId;
            END IF;
            Date_Session = legal_issue_tracker.RandDate(DateStart => temp_Date, DateEnd => '2022-05-01');
            INSERT INTO legal_issue_tracker.CaseSession
                (
                    Case_id,
                    SubCase_id,
                    SessionDate,
                    SessionTime,
                    SessionRoom,
                    ParticipForm,
                    ToDo,
                    Done,
                    DecisionRef
                ) VALUES
                (
                    CaseId,
                    SubCaseId,
                    Date_Session,
                    legal_issue_tracker.RandTime(),
                    legal_issue_tracker.RandNum(3),
                    legal_issue_tracker.RandParticipForm(),
                    legal_issue_tracker.RandToDo(),
                    legal_issue_tracker.RandDone(),
                    legal_issue_tracker.RandWeb(12)
                );
        END;
    $$;