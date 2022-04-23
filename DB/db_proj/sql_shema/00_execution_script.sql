CREATE OR REPLACE PROCEDURE iterations()
    LANGUAGE plpgsql
    AS $$
    BEGIN
        FOR i IN 1..1800 LOOP
            /*
            CALL add_PoA_person ();

            CALL add_PoA_person (RegNumVal => RandNum(12));

            CALL add_PoA_LegalEntity ();

            CALL add_Court();

            CALL add_Judge();

            CALL add_Cases();
            
            CALL add_SubCase();
            */
            

            CALL add_CaseSession();
            /*
            
            
            

            */
        END LOOP;
    END;
    $$;

CALL iterations();