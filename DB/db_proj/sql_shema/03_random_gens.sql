DROP FUNCTION IF EXISTS RandTxtArElem;
DROP FUNCTION IF EXISTS RandIntArElem;
DROP FUNCTION IF EXISTS RandGetId;
DROP FUNCTION IF EXISTS RandPersName;
DROP FUNCTION IF EXISTS RandNum;
DROP FUNCTION IF EXISTS RandWeb;
DROP FUNCTION IF EXISTS RandRegAdress;
DROP FUNCTION IF EXISTS RandCompName;
DROP FUNCTION IF EXISTS RandLegalForm;
DROP FUNCTION IF EXISTS RandDate;
DROP FUNCTION IF EXISTS RandTime;
DROP FUNCTION IF EXISTS RandCaseNum;
DROP FUNCTION IF EXISTS RandCourtName;
DROP FUNCTION IF EXISTS RandGetCourt;
DROP FUNCTION IF EXISTS RandCaseBasis;
DROP FUNCTION IF EXISTS RandFullName;
DROP FUNCTION IF EXISTS RandCaseRole;
DROP FUNCTION IF EXISTS GetRandJudgeFromCourt;

CREATE OR REPLACE FUNCTION RandTxtArElem(Arr text[])
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            res           text;
        BEGIN
            res = Arr[floor(random() * array_length(Arr, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandIntArElem(Arr INTEGER[])
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
        DECLARE
            res           INTEGER;
        BEGIN
            res = Arr[floor(random() * array_length(Arr, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandGetId(TblName regclass)
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
        DECLARE
            IntAr           INTEGER[];
            res             INTEGER;
        BEGIN
            RAISE NOTICE 'this is tblName %', TblName;
            EXECUTE format('SELECT array(SELECT id FROM %s)', TblName)
            INTO IntAr;
            res = IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandPersName (mode CHAR DEFAULT 'f')
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            FirstNames      text[] = '{Андрей, Николай, Иван, Федор, Спиридон, Валентин, Порфирий, Пантелеймон, Ян, Филарет, Пафнутий, Владлен, Марлен, Марлон}';
            LastNames       text[] = '{Аллилуев, Акулов, Веретенников, Грязнов, Дикушников, Елькин, Жаботинский, Зиновьев, Швецов, Васин, Воронцов, Воронов, Брандо, Константинов}';
            SecondNames     text[] = '{Вольдемарович, Аристархович, Никодимович, Фемистоклович, Иванович, Маркович, Лукич, Петрович, Янович, Игоревич, Константинович}';
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
            Region           text[] = '{г. Магнитогорск, г. Васюки, г. Иркутск, г. Магадан, г. Петропавловск-Камчатский, г. Москва, г. Санкт-Петербург, г. Новосибирск, г. Екатеринбург, г. Краснодар, г. Владивосток, г. Нижневартовск, г. Уфа}';
            Street           text[] = '{ул. Роз, ул. Грозовая, ул. Профсоюзная, ул. Васнецова, ул. Пирогова, ул. Римского-Корсакова, ул. Строителей, ул. Первомайская, ул. Ленина, ул. Маркса, ул. Красная, ул. Академическая, ул. Николаевская, ул. Мартовская, ул. Набережная}';
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
            FirstNames      text[] = '{Банк, Вектор, Прогресс, Изделие, Коллаборация, Сообщество, Объединение, Коцессия, Артель, Конгломерат, Производство, Синдикат}';
            SecondNames     text[] = '{Абсолют, Зенит, Актив, Вперед, Продукт, Брокер, Лидер, Центр, Плюс, Мастер, Варяг, Гигант, Старатель, Добытчик}';
            IntAr           text[] = '{0,1,2,3,4,5,6,7,8,9}';
            res             text;
        BEGIN
            res = RandTxtArElem(FirstNames) || ' ' || RandTxtArElem(SecondNames) || ' ';
            FOR i IN 1..3 LOOP
                res = res || RandTxtArElem(IntAr);
            END LOOP;
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

CREATE OR REPLACE FUNCTION RandDate (
        DateStart DATE DEFAULT '2018-01-01',
        DateEnd DATE DEFAULT '2022-05-01'
    )
    RETURNS DATE
    LANGUAGE plpgsql
    AS $$
        DECLARE
            res             DATE;
        BEGIN
            res = DateStart +
                cast(random() * (DateEnd-DateStart) as INTEGER);
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandTime ()
    RETURNS TIME
    LANGUAGE plpgsql
    AS $$
        DECLARE
            TimeStart       TIME = '09:00';
            TimeEnd         TIME = '17:50';
            res             TIME;
        BEGIN
            res = TimeStart +
                cast(random() * (TimeEnd-TimeStart) as INTEGER);
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandCaseNum ()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CapAlph         text[] = '{А, Б, В, Г, Д, Е, Ж, З, И, Й, К, Л, М, Н, О, П, Р, С, Т, У, Ф, Х, Ц, Ч, Ш, Щ, Ъ, Ы, Ь, Э, Ю, Я}';
            IntAr           text[] = '{0,1,2,3,4,5,6,7,8,9}';
            res             text;
        BEGIN
            res = RandTxtArElem(CapAlph);
            FOR i IN 1..2 LOOP
                res = res || RandTxtArElem(IntAr);
            END LOOP;
            res = res || '-';
            FOR i IN 1..6 LOOP
                res = res || RandTxtArElem(IntAr);
            END LOOP;
            res = res || '/';
            res = res|| (SELECT extract(year FROM date '2018-01-01' +
                                        cast(
                                        random() * 
                                        (date '2022-05-01' - date '2018-01-01')
                                        as INTEGER
                                )
                            )
                        );
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandCourtName ()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CourtNum        text[] = '{Первый, Второй, Третий, Четвертый, Пятый, Шестой, Седьмой, Восьмой, Девятый, Десятый}';
            CourtLev        text[] = '{общеисковой, апелляционный, кассационный, надзорный}';
            FuncMode        text[] = '{a, c}';
            f_mode          CHAR;
            res             text;
        BEGIN
            f_mode = RandTxtArElem(FuncMode);
            IF f_mode = 'a' THEN
                res = RandTxtArElem(CourtNum)||' арбитражный '||RandTxtArElem(CourtLev)||' суд';
            ELSEIF f_mode = 'c' THEN
                res = RandTxtArElem(CourtNum)||' '||RandTxtArElem(CourtLev)||' суд общей юрисдикции';
            END IF;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandGetCourt()
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
        DECLARE
            IntAr           INTEGER[];
            res             INTEGER;
        BEGIN
            IntAr = array(SELECT id FROM Courts);
            res = IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandCaseBasis(mode CHAR DEFAULT 'm')
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            BasisesArr1       text[] = '{Иск о взыскании убытков, Заявление о банкротстве, Иск о признании сделки недействительной, Иск о расторжении договора, Иск о взыскании неосновательного обогащения}';
            BasisesArr2       text[] = '{Заявление о включении в реестр, Заявление о разрешении разногласий, Заявление о привлечении к субсидиарной ответственности, Заявление об оспаривании сделки, Заявление об отстранении управляющего}';
            res               text;
        BEGIN
            IF mode = 'm' THEN
                res = RandTxtArElem(BasisesArr1);
            ELSEIF mode = 's' THEN
                res = RandTxtArElem(BasisesArr2);
            END IF;
            return res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandFullName()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            FuncMode        text[] = '{l, p}';
            f_mode          CHAR;
            res             text;
        BEGIN
            f_mode = RandTxtArElem(FuncMode);
            IF f_mode = 'l' THEN
                res = RandLegalForm()||' '||RandCompName();
            ELSEIF f_mode ='p' THEN
                res = RandPersName('l')||' '||RandPersName('f')||' '||RandPersName('s');
            END IF;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION RandCaseRole(mode CHAR DEFAULT 'm')
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            TextAr1          text[] = '{Истец, Заявитель, Ответчик, Третье лицо, Арбитражный управляющий}';
            TextAr2          text[] = '{Заявитель, Ответчик, Третье лицо, Арбитражный управляющий}';
            res             text;
        BEGIN
            IF mode = 'm' THEN
                res = RandTxtArElem(TextAr1);
            ELSEIF mode = 's' THEN
                res = RandTxtArElem(TextAr2);
            END IF;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION GetRandJudgeFromCourt (CourtID INTEGER)
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
        DECLARE
            IntAr           INTEGER[];
            res             INTEGER;
        BEGIN
            IntAr = array(SELECT id FROM judges WHERE court = CourtID);
            res = IntAr[floor(random() * array_length(IntAr, 1) + 1)];
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

SELECT RandDate();

SELECT RandCaseNum();
*/