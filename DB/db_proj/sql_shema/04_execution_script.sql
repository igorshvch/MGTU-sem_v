CREATE OR REPLACE PROCEDURE legal_issue_tracker.PopulateDataBase()
    LANGUAGE plpgsql
    AS $$
    DECLARE
        mltp        INTEGER;
    BEGIN
        mltp = 200;
        FOR i IN 1..mltp LOOP
            
            CALL legal_issue_tracker.add_PoA_person ();

            CALL legal_issue_tracker.add_PoA_person (RegNumVal => legal_issue_tracker.RandNum(12));

            CALL legal_issue_tracker.add_PoA_LegalEntity ();
        END LOOP;

        FOR i IN 1..(mltp/10) LOOP
            CALL legal_issue_tracker.add_Court();
        END LOOP;

        FOR i IN 1..(mltp/2) LOOP
            CALL legal_issue_tracker.add_Judge();
        END LOOP;

        FOR i IN 1..mltp LOOP
            CALL legal_issue_tracker.add_Cases();
        END LOOP;
        
        FOR i in 1..(mltp*2) LOOP
            CALL legal_issue_tracker.add_SubCase();
        END LOOP;
        
        FOR i IN 1..(mltp*7) LOOP
            CALL legal_issue_tracker.add_CaseSession();
        END LOOP;
    END;
    $$;

CALL legal_issue_tracker.PopulateDataBase();