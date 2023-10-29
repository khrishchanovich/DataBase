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
- CROSS
- SELF

---

## Пул запросов для получения сгруппированных данных

---

### GROUP BY + агрегирующие функции

---

### PARTITION

---

### PARTITION OVER + оконные функции

---

### HAVING

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

---

### EXPLAIN