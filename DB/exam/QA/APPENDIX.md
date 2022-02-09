# Дополнительные материалы и уточнения, не вошедшие в список вопросов

## Управление параллелизмом

### Пессиместическое

Характеристики:

- Система блокировок не допускает, чтобы изменение данных одними пользователями влияло на других пользователей.
- После выполнения действия, ведущего к установке блокировки, другие пользователи не могут выполнять действия, конфликтующие с блокировкой пока её владелец не снимет её
- Используется в системах с высокой конкуренцией за данные, где затраты на защиту данных с помощью блокировок меньше затрат на откат транзакций в случае конфликтов параллелизма.

### Оптимистическое

Характеристики:

- Данные не блокируются на период чтения
- Когда пользователь обновляет данные, система проверяет, вносил ли другой пользователь в них изменение после считывания.
- Если другой пользователь изменял данные, возникает ошибка.
- При получении ошибки, как правило, требуется повторить операцию заново
- Используется в системах с низкой конкуренцией за данные, где затраты на периодический откат транзакции меньше затрат на блокировку данных при считывании.

### Реализация управления параллелизмом

- Блокировки – для пессимистического. Реализуются в СУБД

  - Транзакция может запрашивать блокировки различных ресурсов: строк, страниц, таблиц
  - Блокировка не дает другим транзакциям изменять ресурсы
  - Блокировка снимается после завершения транзакции

- Управление версиями строк – для оптимистического. Реализуются на прикладном уровне

  - В таблицах хранятся версии каждой измененной строки
  - При попытке изменить данные проверяется, что версия не изменилась по сравнению с той, которую прочитал пользователь, выполняющий модификацию данных
  - Вероятность того, что операция чтения будет блокировать другие транзакции, значительно снижается.

## Масштабирование СУБД

### Виды

- Вертикальное
- Горизонтальное

### Объекты

- Операции чтения
- Операции записи

### Характеристики

- Распределённые ACID-совместимые БД могут масштабировать операции чтения путём ввода в систему новых узлов
- Операции чтения масштабируются до определённого предела, создаваемого сложностями масштабирования операций записи
- Сложности масштабирования операций записи:
  - Атомарность – транзакции должны выполняться полностью или не выполняться вовсе, что требует определённой работы для обеспечения таких гарантий
  - Согласованность – все узлы в сети должны быть идентичны. Если происходит запись на одном узле, то это должно быть воспроизведено на всех остальных узлах прежде, чем будет отдан ответ на запрос клиента, инициировавший эту запись.
  - Долговечность – прежде чем отдать ответ на запрос клиента необходимо внести изменения, выполненные в рамках запроса, на диск.
- Для упрощения масштабирования операций записи СУБД ослабляют требования:
  - Отказ от требования атомарности позволяет сократить время блокировок (MongoDB, CouchDB)
  - Отказ от требования согласованности позволяет масштабировать операции записи на узлы системы (Riak, Cassandra)
  - Отказ от требования долговечности позволяет отвечать на запросы модификации данных прежде, чем изменения будут записаны на диск (Memcached, Redis)
- NoSQL СУБД как правило следуют BASE модели, отказываясь от требований A, C и/или D
- В языке SQL не хватает механизма описания запросов, в которых требования ACID могут быть ослаблены. Поэтому BASE СУБД всегда являются NoSQL