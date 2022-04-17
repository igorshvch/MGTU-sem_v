CREATE OR REPLACE FUNCTION RandPersName (mode CHAR DEFAULT 'f')
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            FirstNames      text[] = '{Андрей, Николай, Иван, Федор, Спиридон, Валентин, Порфирий, Пантелеймон}';
            LastNames       text[] = '{Акулов, Веретенников, Грязнов, Дикушников, Елькин, Жаботинский, Зиновьев, Швецов}';
            SecondNames     text[] = '{Вольдемарович, Аристархович, Никодимович, Фемистоклович, Иванович, Маркович, Лукич, Петрович}';
            BaseAr          text[];
            res             text;
        BEGIN
            IF mode = 'f' THEN
                BaseAr = FirstNames;
            ELSEIF mode = 'l' THEN
                BaseAR = LastNames;
            ELSEIF mode = 's' THEN
                BaseAR = SecondNames;
            END IF;
                
            res = BaseAR[floor(random() * array_length(BaseAR, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandNum (NumLen INTEGER DEFAULT 1)
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            IntAr           text[] = '{0,1,2,3,4,5,6,7,8,9}';
            res             text;
        BEGIN
            res = IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            IF res = '0' THEN res = '1'; END IF;
            FOR i IN 1..(NumLen-1) LOOP
                res = res|| IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            END LOOP;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandWeb (NumLen INTEGER DEFAULT 1)
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            BaseAR          text[] = '{a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z}';
            pref            text = 'www.';
            postf           text = '.ru';
            res             text = '';
        BEGIN
            FOR i IN 1..NumLen LOOP
                res = res||BaseAR[floor(random() * array_length(BaseAR, 1) + 1)];
            END LOOP;
            res = pref||res||postf;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandRegAdress ()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            Region           text[] = '{г. Москва, г. Санкт-Петербург, г. Новосибирск, г. Екатеринбург, г. Краснодар, г. Владивосток, г. Нижневартовск, г. Уфа}';
            Street           text[] = '{ул. Строителей, ул. Первомайская, ул. Ленина, ул. Маркса, ул. Красная, ул. Академическая, ул. Николаевская, ул. Мартовская, ул. Набережная}';
            IntAr            text[] = '{0,1,2,3,4,5,6,7,8,9}';
            ObjectNum        text = '';
            res              text;
        BEGIN
            FOR i IN 1..2 LOOP
                ObjectNum = ObjectNum || IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            END LOOP;
            ObjectNum = ObjectNum || '-'|| IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            ObjectNum = ObjectNum || '-';
            FOR i IN 1..3 LOOP
                ObjectNum = ObjectNum || IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            END LOOP;
            res = Region[floor(random() * array_length(Region, 1) + 1)] || ', ' || Street[floor(random() * array_length(Street, 1) + 1)] ||', '|| ObjectNum;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandCompName ()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            FirstNames      text[] = '{Банк, Вектор, Прогресс, Изделие}';
            SecondNames     text[] = '{Актив, Вперед, Продукт, Брокер}';
            res             text;
        BEGIN
            res = FirstNames[floor(random() * array_length(FirstNames, 1) + 1)] || ' ' || SecondNames[floor(random() * array_length(SecondNames, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandLegalForm ()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            LegalForm       text[] = '{ООО, АО, ПАО, ЗАО}';
            res             text;
        BEGIN
            res = LegalForm[floor(random() * array_length(LegalForm, 1) + 1)];
            RETURN res;
        END;
    $$;

/*
SELECT * FROM
    NameRand('f') as FirstName
    JOIN NameRand('s') as SecondName ON True
    JOIN NameRand('l') as LastName ON True;

SELECT * FROM NumRand(6);

SELECT RandWeb(8);

SELECT RandRegAdress();

SELECT RandCompName();

SELECT RandLegalForm();

SELECT * FROM
    RandLegalForm() as lf
    JOIN RandCompName() as cn ON TRUE;
*/