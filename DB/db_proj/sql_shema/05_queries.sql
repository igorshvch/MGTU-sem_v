--все заседания по банкротным делам в июне 2021
SELECT *
    FROM legal_issue_tracker.casesession
    WHERE 
        SessionDate BETWEEN '2021-05-31' AND '2021-07-01'
        AND subcase_id IS NOT NULL;

--все заседания по банкротным делам в июне 2021 (с CTE)
WITH cte_01 AS (
    SELECT id 
        FROM legal_issue_tracker.cases
        WHERE casebasis = 'Заявление о банкротстве'
)
SELECT *
    FROM legal_issue_tracker.casesession
    WHERE 
        case_id IN (SELECT id from cte_01)
        AND SessionDate BETWEEN '2021-05-31' AND '2021-07-01';

--все дела по банкротству
SELECT id 
    FROM legal_issue_tracker.cases
    WHERE casebasis = 'Заявление о банкротстве';

--выбрать все дела с января по апрель 2022 года
SELECT *
    FROM legal_issue_tracker.Cases
    WHERE DateStart > '2022-01-01';

--выбрать все заседания с января по апрель 2022 года
SELECT *
    FROM legal_issue_tracker.Casesession
    WHERE SessionDate > '2022-01-01';

--выбрать все заседания в апреле 2022
SELECT *
    FROM legal_issue_tracker.Casesession
    WHERE SessionDate BETWEEN '2020-03-01' AND '2020-03-31';

--посчитать заработок за месяц по текущим делам
SELECT
        paymentmethod as Способ,
        sum(paymentammount) as Заработок,
        count(*)
    FROM legal_issue_tracker.Casesession cs
        JOIN legal_issue_tracker.payment p ON cs.case_id = p.case_id
        JOIN legal_issue_tracker.casenum cn ON cs.case_id = cn.id
    WHERE SessionDate BETWEEN '2020-03-01' AND '2020-03-31'
        AND p.paymentmethod != 'За все дело'
    GROUP BY paymentmethod;

--вывести все дела с оплатой "За все дело" и подсчитать среднее значение заработка, а также общий доход
SELECT
    Num as Номер_дела,
    paymentmethod as Способ,
    avg(paymentammount::NUMERIC) OVER() as Среднее_по_оплате,
    sum(paymentammount) OVER() as Всего_оплата
    FROM legal_issue_tracker.Casesession cs
        JOIN legal_issue_tracker.payment p ON cs.case_id = p.case_id
        JOIN legal_issue_tracker.casenum cn ON cs.case_id = cn.id
    WHERE p.paymentmethod = 'За все дело';

/*
 * Посчитать и вывести данные о том, сколько заседаний за месяц
 * прошли с методами оплаты "Ежемесячно" или "За заседание", а также
 * доход от них; посчитать процент в заседаниях от общего числа за месяц (с учетом
 * тех, что прошли с методом оплаты "За все дело"); посчитать процент в деньгах
 * от общего заработка за месяц (считается без заработка "За все дело", т.к.
 * оплата по таким делам в общем случае не совпадает с окончанием календарного
 * месяца)
 */
DROP VIEW IF EXISTS legal_issue_tracker.monthly_income;

CREATE OR REPLACE VIEW legal_issue_tracker.monthly_income as 
    WITH cte_1 AS ( --считаем общее количество заседаний
        SELECT
            count(*) as totalsessions
        FROM
            legal_issue_tracker.Casesession cs
            WHERE SessionDate BETWEEN '2020-03-01' AND '2020-03-31'
    ), cte_2 AS (   --считаем агрегированное значение по оплате за месяц
        SELECT
            paymentmethod,
            sum(paymentammount) as income,
            count(*) as CourtSessions
        FROM legal_issue_tracker.Casesession cs
            JOIN legal_issue_tracker.payment p ON cs.case_id = p.case_id
            JOIN legal_issue_tracker.casenum cn ON cs.case_id = cn.id
        WHERE SessionDate BETWEEN '2020-03-01' AND '2020-03-31'
        GROUP BY paymentmethod
    ), cte_3 AS (  --считаем общую оплату за месяц без учета заседаний с методом оплаты "За все дело"
        SELECT
            sum(paymentammount) as totalincome
        FROM legal_issue_tracker.Casesession cs
            JOIN legal_issue_tracker.payment p ON cs.case_id = p.case_id
            JOIN legal_issue_tracker.casenum cn ON cs.case_id = cn.id
        WHERE SessionDate BETWEEN '2020-03-01' AND '2020-03-31'
            AND paymentmethod != 'За все дело'
    )
    SELECT
            CourtSessions,
            paymentmethod,
            to_char((CourtSessions::real / (SELECT totalsessions FROM cte_1)) *100, '99%') as SessionsPercent,
            sum(income) OVER () as totalpermonth,
            income,
            to_char((income / (SELECT totalincome FROM cte_3)) *100, '99%') as IncomePercent
        FROM cte_2
        WHERE paymentmethod != 'За все дело';

SELECT * from legal_issue_tracker.monthly_income;

/*
 * Создаем функцию, аналогичную предыдущему представлению, но которая
 * может принимать в качестве аргументов различные значения начала
 * и конца периода
 */
DROP FUNCTION IF EXISTS legal_issue_tracker.income_per_period;

CREATE OR REPLACE FUNCTION legal_issue_tracker.income_per_period(DateStart DATE, DateEnd DATE)
    RETURNS TABLE(
        Число_заседани   INTEGER,
        Метод_оплаты   TEXT,
        Процент_от_засеадния   TEXT,
        Всего_за_период   MONEY,
        За_период_метод   MONEY,
        Процент_по_методу   TEXT
    )
    LANGUAGE sql
    AS $$
        WITH cte_1 AS ( --считаем общее количество заседаний
            SELECT
                count(*) as totalsessions
            FROM
                legal_issue_tracker.Casesession cs
                WHERE SessionDate BETWEEN DateStart AND DateEnd
        ), cte_2 AS (   --считаем агрегированное значение по оплате за месяц
            SELECT
                paymentmethod,
                sum(paymentammount) as income,
                count(*) as CourtSessions
            FROM legal_issue_tracker.Casesession cs
                JOIN legal_issue_tracker.payment p ON cs.case_id = p.case_id
                JOIN legal_issue_tracker.casenum cn ON cs.case_id = cn.id
            WHERE SessionDate BETWEEN DateStart AND DateEnd
            GROUP BY paymentmethod
        ), cte_3 AS (  --считаем общую оплату за месяц без учета заседаний с методом оплаты "За все дело"
            SELECT
                sum(paymentammount) as totalincome
            FROM legal_issue_tracker.Casesession cs
                JOIN legal_issue_tracker.payment p ON cs.case_id = p.case_id
                JOIN legal_issue_tracker.casenum cn ON cs.case_id = cn.id
            WHERE SessionDate BETWEEN DateStart AND DateEnd
                AND paymentmethod != 'За все дело'
        )
        SELECT
                CourtSessions,
                paymentmethod,
                to_char((CourtSessions::real / (SELECT totalsessions FROM cte_1)) *100, '99%') as SessionsPercent,
                sum(income) OVER () as totalpermonth,
                income,
                to_char((income / (SELECT totalincome FROM cte_3)) *100, '99%') as IncomePercent
            FROM cte_2
            WHERE paymentmethod != 'За все дело';
    $$;

SELECT * FROM legal_issue_tracker.income_per_period('2020-03-01', '2021-03-31');

