## Пул запросов для сложной выборки из БД

---

### Запросы с несколькими условиями

WHERE условие

Логические операторы позволяют объединить несколько условий

- AND
    
    ```sql
    SELECT Id, Name, Surname
    FROM User
    WHERE Name REGEXP "^A" AND Id BETWEEN 5 and 15;
    ```
    
- OR
    
    ```sql
    SELECT Id, Name, Surname
    FROM User
    WHERE (Name REGEXP "^A" OR Surname REGEXP ".l") AND Id BETWEEN 5 and 15;
    ```
    
- NOT
    
    ```sql
    SELECT Id, Name, Surname
    FROM User
    WHERE (Name REGEXP "^A" OR Surname REGEXP ".l") AND NOT Id BETWEEN 5 and 15;
    ```
    

---

### Запросы с вложенными конструкциями

**Коррелирующие подзапросы**

```sql
SELECT Title, Description,
(SELECT Title FROM InsuranceObject
WHERE InsuranceObject.Id = InsuranceType.InsuranceObjectId) AS Object
FROM InsuranceType;
```

```sql
select title, rate,
	(select avg(rate) from insurancetype as catrate
	where catrate.categoryid = instypes.categoryid) as avgrate
from insurancetype as instypes
where rate >
	(select avg(rate) from insurancetype as catrate
    where catrate.categoryid = instypes.categoryid);
```

```sql
select 
	(select name
    from user
    where user.id=insuranceagent.userid) as name,
    (select distinct(title)
    from post
    where insuranceagent.postid = post.id) as post
from insuranceagent;
```

```sql
select 
	(select name from user
    where user.id = insuranceagent.userid) as name,
    (select surname from user
    where user.id = insuranceagent.userid) as surname,
    (select title from post
    where post.id = insuranceagent.postid) as post,
    (select address from insuranceoffice
    where insuranceoffice.id = insuranceagent.insuranceofficeid)
from insuranceagent;
```

**Не коррелирующие подзапросы**

Выборка с использованием агрегатных функций

- AVG
    
    ```sql
    select title, rate
    from insurancetype
    where rate >= (select avg(rate) from insurancetype
    ```
    
- MIN
    
    ```sql
    select title, rate
    from insurancetype
    where rate = (select min(rate) from insurancetype);
    ```
    
- MAX
    
    ```sql
    select title, rate
    from insurancetype
    where rate = (select max(rate) from insurancetype);
    ```
    

---

## Пул запросов для получения представлений в БД

---

### JOIN-запросы различных видов

- ******Неявное соединение таблиц******
    
    ```sql
    select agent.id, office.name, post.title
    from insuranceagent as agent, insuranceoffice as office, post
    where agent.insuranceofficeid = office.id and agent.postid = post.id
    ```
    
- INNER
    
    ```sql
    select 
    	(select name from user
        where user.id = insuranceagent.userid) as name,
        (select surname from user
        where user.id = insuranceagent.userid) as surname,
        insuranceoffice.address, insuranceoffice.name
    from insuranceagent
    join insuranceoffice on insuranceoffice.id = insuranceagent.insuranceofficeid
    ```
    
    ```sql
    select 
    	user.name, user.surname,
        insuranceoffice.address, insuranceoffice.name
    from insuranceagent
    join insuranceoffice on insuranceoffice.id = insuranceagent.insuranceofficeid
    join user on user.id = insuranceagent.userid
    ```
    
    ```sql
    select
    client.id, user.email
    from client
    join user on user.id = client.userid and user.email regexp "ins"
    ```
    
- OUTER
    
    ********LEFT********
    
    ```sql
    select 
    	insuranceagent.id, 
    	insuranceoffice.name as office, insuranceoffice.address
    from insuranceagent
    left join insuranceoffice on insuranceoffice.id = insuranceagent.insuranceofficeid
    order by insuranceagent.id
    ```
    
    **RIGHT**
    
    ```sql
    select 
    	insuranceagent.id, 
    	insuranceoffice.name as office, insuranceoffice.address
    from insuranceagent
    right join insuranceoffice on insuranceoffice.id = insuranceagent.insuranceofficeid
    order by insuranceagent.id
    ```
    
- OUTER + INNER
    
    ```sql
    select 
    	insuranceagent.id,
    	user.name, user.surname,
        insuranceoffice.name as office, insuranceoffice.address
    from insuranceagent
    join user on user.id = insuranceagent.userid
    left join insuranceoffice on insuranceoffice.id = insuranceagent.insuranceofficeid
    ```
    
    ```sql
    select 
    	insuranceagent.id,
    	user.name, user.surname,
        insuranceoffice.name as office, insuranceoffice.address
    from insuranceagent
    join user on user.id = insuranceagent.userid
    right join insuranceoffice on insuranceoffice.id = insuranceagent.insuranceofficeid
    ```
    
- FULL

FULL JOIN включает в результат все строки из обех таблиц, даже если нет совпадающих строк в другой таблице. Если нет совпадений для какой-либо строки, возвращается NULL для столбцов из другой таблицы. FULL JOIN возвращает объединение всех строк из левой (правой) и правой (второй) таблиц, при этом строки без совпадений в одной из таблиц будут включены.

- CROSS

CROSS (CARTESIAN) JOIN выполняет комбинаторное объединение строк из двух таблиц, возвращая все возможные комбинации. Этот тип соединения может привести к большому количеству строк в результате, и его следует использовать осторожно, так как он может привести к декартову произведению особенно если таблицы содержат большое количество строк.

```sql
select
client.id, user.email
from client
cross join user on user.id = client.userid
```

- SELF

SELF JOIN - соединение таблицы с самой собой. Он используется, когда нужно сравнивать данные в таблице между разными строками этой же таблицы. Может быть полезным при работе с иерархическими данными, где одна строка ссылается на другую в той же таблице

```sql
select a.title as instypea, b.title as instypeb, a.description
from insurancetype as a, insurancetype as b
```

---

## Пул запросов для получения сгруппированных данных

---

Операторы GROUP BY и HAVING позволяют сгруппировать данные. Они употребляются в рамках команды SELECT.

SELECT столбцы

FROM таблица

WHERE условие фильтрации

GROUP BY столбцы для группировки

HAVING условие фильтрации групп

ORDER BY столбцы для сортировки

### GROUP BY + агрегирующие функции

```sql
select
    user.name as clientname,
    count(contract.id) as contractcount
from user
left join client on user.id = client.userid
left join journal on client.id = journal.clientid
left join contract on journal.id = contract.journalid
where user.status = 'Client'
group by user.id, user.name
```

---

### PARTITION OVER + оконные функции

Оконная функция - функция, которая работает с выделенным набором строк (окном, партицией) и выполняет вычисление для этого набора строк в отдельном столбце.

Партиции (окна из набора строк) - набор строк, указанный для оконной функции по одному из столбцов или группе столбцов таблицы. Партиции для каждой оконной функции в запросе могут быть разделены по различным колонкам таблицы.

Множество оконных функций можно разделять на 3 группы:

- Агрегирующие
    
    sum
    
    avg
    
    count
    
    min
    
    max
    
    ```sql
    select journalid, initialpayment, journal.clientid,
    sum(initialpayment) over (partition by clientid) as sum_pay,
    avg(initialpayment) over (partition by clientid) as avg_pay,
    count(initialpayment) over (partition by clientid) as count_pay,
    min(initialpayment) over (partition by clientid) as min_pay,
    max(initialpayment) over (partition by clientid) as max_pay
    from contract
    join journal on journal.id = contract.journalid
    ```
    
- Ранжирующие
    
    dense_rank()
    
    ntile()
    
    rank()
    
    row_number()
    
    cume_dist()
    
    ```sql
    select journalid, initialpayment, journal.clientid,
    row_number() over (partition by clientid order by initialpayment) as func_row_number,
    rank() over (partition by clientid order by initialpayment) as func_rank,
    dense_rank() over (partition by clientid order by initialpayment) as func_dense_rank,
    ntile(2) over (partition by clientid order by initialpayment) as func_ntile,
    cume_dist() over (partition by clientid order by initialpayment) as func_cume_dist
    from contract
    join journal on journal.id = contract.journalid
    ```
    
- Функции смещения
    
    first_value()
    
    last_value()
    
    lag()
    
    lead()
    
    nth_value()
    
    ```sql
    select journalid, initialpayment, journal.clientid,
    lag(initialpayment) over (order by journal.clientid) as previous_rate,
    lead(initialpayment) over (order by journal.clientid) as next_rate,
    first_value(initialpayment) over (order by journalid) as first_value_rate,
    last_value(initialpayment) over (order by journalid) as last_value_rate
    from contract
    join journal on journal.id = contract.journalid
    ```
    

---

### HAVING

```sql
select
    user.name as clientname,
    count(contract.id) as contractcount
from user
left join client on user.id = client.userid
left join journal on client.id = journal.clientid
left join contract on journal.id = contract.journalid
where user.status = 'Client'
group by user.id, user.name
having count(*) > 1
```

---

### UNION

```sql
select title as instypename, description
from insurancetype
union select title, description from category
order by instypename
```

```sql
select id
from client
union all select id from admin
```

```sql
select title, description, rate + rate*0.1 as small
from insurancetype
where rate < 0.5
union select title, description, rate + rate*0.3 as small
from insurancetype
where rate > 0.5
```

---

## Пул запросов для сложных операций с данными

---

### EXISTS

```sql
select * from insuranceoffice
where exists
(select * from insuranceagent where insuranceoffice.id = insuranceagent.insuranceofficeid)
```

```sql
select * from insuranceoffice
where not exists
(select * from insuranceagent where insuranceoffice.id = insuranceagent.insuranceofficeid)
```

```sql
select * from post
where exists
(select * from insuranceagent where post.id = insuranceagent.postid)
```

```sql
select * from category
where exists
(select * from insurancetype where insurancetype.categoryid = category.id)
```

```sql
select * from insuranceobject
where exists
(select * from insurancetype where insurancetype.insuranceobjectid = insuranceobject.id)
```

****IN****

```sql
select * from insuranceoffice
where id in (select insuranceofficeid from insuranceagent)
```

---

### INSERT INTO SELECT

```sql
INSERT IGNORE INTO Client (UserId) SELECT Id FROM User WHERE Status = 'Client';
```

```sql
INSERT IGNORE INTO Admin (UserId) SELECT Id FROM User WHERE Status = 'Admin';
```

```sql
INSERT IGNORE INTO InsuranceAgent (UserId) SELECT Id FROM User WHERE Status = 'Agent';
```

---

### CASE

```sql
select title, rate,
case
	when rate < 0.5
		then 'little'
	when rate = 0.5
		then 'middle'
	else 'big'
end as category
from insurancetype;
```

```sql
update journal
set 
	insuranceagentid = case
		when id = 2 then 1
        when id = 3 then 1
        when id = 4 then 3
        when id = 5 then 3
        when id = 6 then 6
        else insuranceagentid
	end,
    isapproved = case
		when id = 2 then 1
        when id = 3 then 1
        when id = 4 then 1
        when id = 5 then 1
        when id = 6 then 1
		else isapproved
	end
where id in (2, 3, 4, 5, 6)
```

---

### EXPLAIN
```sql
explain select * from client
inner join user on user.id = client.userid
```

```sql
explain select * from user where id > 5
```

ЗАПРОС ОТ ПРЕПОДАВАТЕЛЯ 
```sql
select
	user.name, user.surname,
    insurancetype.title,
    count(insurancetype.id) as count_type,
    rank() over (partition by insuranceagent.id order by count(insurancetype.id) desc) as rnk
from insuranceagent
left join user on user.id = insuranceagent.userid
left join journal on journal.insuranceagentid = insuranceagent.id
left join insurancetype on insurancetype.id = journal.insurancetypeid
group by insuranceagent.id, insurancetype.id
```