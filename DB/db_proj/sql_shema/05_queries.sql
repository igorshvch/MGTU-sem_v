--все заседания по банкротным делам в июне 2021
SELECT *
    FROM casesession
    WHERE 
        SessionDate BETWEEN '2021-05-31' AND '2021-07-01'
        AND subcase_id IS NOT NULL;

--все заседания по банкротным делам в июне 2021 (с CTE)
WITH cte_01 AS (
    SELECT id 
        FROM cases
        WHERE casebasis = 'Заявление о банкротстве'
)
SELECT *
    FROM casesession
    WHERE 
        case_id IN (SELECT id from cte_01)
        AND SessionDate BETWEEN '2021-05-31' AND '2021-07-01';


--все дела по банкротству
SELECT id 
        FROM cases
        WHERE casebasis = 'Заявление о банкротстве';
