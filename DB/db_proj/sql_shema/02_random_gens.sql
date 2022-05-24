DROP FUNCTION IF EXISTS legal_issue_tracker.RandTxtArElem;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandIntArElem;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandGetId;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandPersName;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandNum;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandWeb;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandRegAdress;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandCompName;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandLegalForm;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandDate;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandTime;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandCaseNum;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandCourtName;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandGetCourt;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandCaseBasis;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandFullName;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandParticipForm;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandToDo;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandDone;
DROP FUNCTION IF EXISTS legal_issue_tracker.RandPayment;
--DROP FUNCTION IF EXISTS legal_issue_tracker.GetRandJudgeFromCourt;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandTxtArElem(Arr text[])
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

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandIntArElem(Arr INTEGER[])
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

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandGetId(TblName regclass)
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
        DECLARE
            IntAr           INTEGER[];
            res             INTEGER;
        BEGIN
            EXECUTE format('SELECT array(SELECT id FROM %s)', TblName)
            INTO IntAr;
            res = IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandPersName (mode CHAR DEFAULT 'f')
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

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandNum (NumLen INTEGER DEFAULT 1)
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

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandWeb (NumLen INTEGER DEFAULT 1)
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

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandRegAdress ()
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

--Генрация случайного наименования юридического лица
CREATE OR REPLACE FUNCTION legal_issue_tracker.RandCompName ()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            FirstNames      text[] = '{Банк, Вектор, Прогресс, Изделие, Коллаборация, Сообщество, Объединение, Коцессия, Артель, Конгломерат, Производство, Синдикат}';
            SecondNames     text[] = '{Абсолют, Зенит, Актив, Вперед, Продукт, Брокер, Лидер, Центр, Плюс, Мастер, Варяг, Гигант, Старатель, Добытчик}';
            IntAr           text[] = '{0,1,2,3,4,5,6,7,8,9}';
            res             text;
        BEGIN
            res = legal_issue_tracker.RandTxtArElem(FirstNames) || ' ' || legal_issue_tracker.RandTxtArElem(SecondNames) || ' ';
            FOR i IN 1..3 LOOP
                res = res || legal_issue_tracker.RandTxtArElem(IntAr);
            END LOOP;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandLegalForm ()
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

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandDate (
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

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandTime ()
    RETURNS TIME
    LANGUAGE plpgsql
    AS $$
        DECLARE
            TimeStart       TIME = '09:00';
            TimeEnd         TIME = '17:50';
            res             TIME;
        BEGIN
            res = to_char(TimeStart +(random() * (TimeEnd-TimeStart)), 'HH24:MI')::TIME;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandCaseNum ()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            CapAlph         text[] = '{А, Б, В, Г, Д, Е, Ж, З, И, Й, К, Л, М, Н, О, П, Р, С, Т, У, Ф, Х, Ц, Ч, Ш, Щ, Ъ, Ы, Ь, Э, Ю, Я}';
            IntAr           text[] = '{0,1,2,3,4,5,6,7,8,9}';
            res             text;
        BEGIN
            res = legal_issue_tracker.RandTxtArElem(CapAlph);
            FOR i IN 1..2 LOOP
                res = res || legal_issue_tracker.RandTxtArElem(IntAr);
            END LOOP;
            res = res || '-';
            FOR i IN 1..6 LOOP
                res = res || legal_issue_tracker.RandTxtArElem(IntAr);
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

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandCourtName ()
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
            f_mode = legal_issue_tracker.RandTxtArElem(FuncMode);
            IF f_mode = 'a' THEN
                res = legal_issue_tracker.RandTxtArElem(CourtNum)||' арбитражный '||legal_issue_tracker.RandTxtArElem(CourtLev)||' суд';
            ELSEIF f_mode = 'c' THEN
                res = legal_issue_tracker.RandTxtArElem(CourtNum)||' '||legal_issue_tracker.RandTxtArElem(CourtLev)||' суд общей юрисдикции';
            END IF;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandGetCourt()
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
        DECLARE
            IntAr           INTEGER[];
            res             INTEGER;
        BEGIN
            IntAr = array(SELECT id FROM legal_issue_tracker.Courts);
            res = IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandCaseBasis(mode CHAR DEFAULT 'm')
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            BasisesArr1       text[] = '{Иск о взыскании убытков, Заявление о банкротстве, Иск о признании сделки недействительной, Иск о расторжении договора, Иск о взыскании неосновательного обогащения}';
            BasisesArr2       text[] = '{Заявление о включении в реестр, Заявление о разрешении разногласий, Заявление о привлечении к субсидиарной ответственности, Заявление об оспаривании сделки, Заявление об отстранении управляющего}';
            res               text;
        BEGIN
            IF mode = 'm' THEN
                res = legal_issue_tracker.RandTxtArElem(BasisesArr1);
            ELSEIF mode = 's' THEN
                res = legal_issue_tracker.RandTxtArElem(BasisesArr2);
            END IF;
            return res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandFullName()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            FuncMode        text[] = '{l, p}';
            f_mode          CHAR;
            res             text;
        BEGIN
            f_mode = legal_issue_tracker.RandTxtArElem(FuncMode);
            IF f_mode = 'l' THEN
                res = legal_issue_tracker.RandLegalForm()||' '||legal_issue_tracker.RandCompName();
            ELSEIF f_mode ='p' THEN
                res = legal_issue_tracker.RandPersName('l')||' '||legal_issue_tracker.RandPersName('f')||' '||legal_issue_tracker.RandPersName('s');
            END IF;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandCaseRole(mode CHAR DEFAULT 'm')
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            TextAr1          text[] = '{Истец, Заявитель, Ответчик, Третье лицо, Арбитражный управляющий}';
            TextAr2          text[] = '{Заявитель, Ответчик, Третье лицо, Арбитражный управляющий}';
            res             text;
        BEGIN
            IF mode = 'm' THEN
                res = legal_issue_tracker.RandTxtArElem(TextAr1);
            ELSEIF mode = 's' THEN
                res = legal_issue_tracker.RandTxtArElem(TextAr2);
            END IF;
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandParticipForm()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            TextAr          text[] = '{Заседание, Он-лайн, Только позиция}';
            res             text;
        BEGIN
            res = legal_issue_tracker.RandTxtArElem(TextAr);
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandToDo()
    RETURNS text
    LANGUAGE plpgsql
    AS $$
        DECLARE
            TextAr          text[] = '{Написать позицию, Дополнить позицию, Написать отзыв, Написать ходатайство или  заявление}';
            res             text;
        BEGIN
            res = legal_issue_tracker.RandTxtArElem(TextAr);
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandDone()
    RETURNS BOOLEAN
    LANGUAGE plpgsql
    AS $$
        DECLARE
            BoolAr          BOOLEAN[] = '{TRUE, FALSE}';
            res             BOOLEAN;
        BEGIN
            res = BoolAr[floor(random() * array_length(BoolAr, 1) + 1)];
            RETURN res;
        END;
    $$;

CREATE OR REPLACE FUNCTION legal_issue_tracker.RandPayment()
    RETURNS legal_issue_tracker.ITEM
    LANGUAGE plpgsql
    AS $$
        DECLARE
            TextAr          TEXT[] = '{За заседание, Ежемесячно, За все дело}';
            MoneyAr         Money[] = '{15000, 20000, 25000}';
            temp_item       legal_issue_tracker.ITEM;
        BEGIN
            temp_item.temp_text = legal_issue_tracker.RandTxtArElem(TextAr);
            IF temp_item.temp_text = 'За заседание' THEN
                temp_item.temp_money = MoneyAr[floor(random() * array_length(MoneyAr, 1) + 1)];
            ELSIF temp_item.temp_text = 'Ежемесячно' THEN
                temp_item.temp_money = MoneyAr[floor(random() * array_length(MoneyAr, 1) + 1)]*3;
            ELSIF temp_item.temp_text = 'За все дело' THEN
                temp_item.temp_money = MoneyAr[floor(random() * array_length(MoneyAr, 1) + 1)]*10;
            END IF;
            RETURN temp_item;
        END;
    $$;
/*
CREATE OR REPLACE FUNCTION legal_issue_tracker.GetRandJudgeFromCourt (CourtID INTEGER)
    RETURNS INTEGER
    LANGUAGE plpgsql
    AS $$
        DECLARE
            IntAr           INTEGER[];
            res             INTEGER;
        BEGIN
            IntAr = array(SELECT id FROM legal_issue_tracker.judges WHERE court = CourtID);
            res = IntAr[floor(random() * array_length(IntAr, 1) + 1)];
            RETURN res;
        END;
    $$;
*/

/*
SELECT * FROM
    legal_issue_tracker.NameRand('f') as FirstName
    JOIN legal_issue_tracker.NameRand('s') as SecondName ON True
    JOIN legal_issue_tracker.NameRand('l') as LastName ON True;

SELECT * FROM legal_issue_tracker.NumRand(6);

SELECT legal_issue_tracker.RandWeb(8);

SELECT legal_issue_tracker.RandRegAdress();

SELECT legal_issue_tracker.RandCompName();

SELECT legal_issue_tracker.RandLegalForm();

SELECT * FROM
    legal_issue_tracker.RandLegalForm() as lf
    JOIN legal_issue_tracker.RandCompName() as cn ON TRUE;

SELECT legal_issue_tracker.RandDate();

SELECT legal_issue_tracker.RandCaseNum();
*/