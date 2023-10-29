---

### Создание БД и таблиц БД

1. Создание БД, при условии, что БД с таким именем еще не существует

```sql
CREATE DATABASE IF NOT EXISTS InsuranceCompany;
```

2. Установка данной БД в качестве используемой

```sql
USE InsuranceCompany;
```

3. Применяем удаление таблиц из БД

```sql
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Client;
DROP TABLE IF EXISTS Post;
DROP TABLE IF EXISTS InsuranceAgent;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS InsuranceObject;
DROP TABLE IF EXISTS InsuranceType;
DROP TABLE IF EXISTS InsuranceOffice;
DROP TABLE IF EXISTS Journal;
DROP TABLE IF EXISTS Conract;
```

4. Создание таблицы User

```sql
CREATE TABLE User
(
Id INT PRIMARY KEY AUTO_INCREMENT,
Username VARCHAR (50) NOT NULL,
Email VARCHAR (50) NOT NULL,
Password VARCHAR (50) NOT NULL,
Name VARCHAR (50) NOT NULL,
Surname VARCHAR (50) NOT NULL,
Status ENUM('Admin', 'Agent', 'Client') DEFAULT 'Client',

UNIQUE(Username, Email),
CONSTRAINT min_password_length CHECK (char_length(Password) >= 8)
);
```

5. Создание таблицы Admin

```sql
CREATE TABLE Admin
(
Id INT PRIMARY KEY AUTO_INCREMENT,
UserId INT UNIQUE,

CONSTRAINT admin_user_fk FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE
);
```

6. Создание таблицы Client

```sql
CREATE TABLE Client
(
Id INT PRIMARY KEY AUTO_INCREMENT,
UserId INT UNIQUE,

CONSTRAINT client_user_fk FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE
);
```

7. Создание таблицы Post

```sql
CREATE TABLE Post
(
Id INT PRIMARY KEY AUTO_INCREMENT,
Title VARCHAR (50) NOT NULL UNIQUE,
Description TEXT NOT NULL
);
```

8. Создание таблицы InsuranceOffice

```sql
CREATE TABLE InsuranceOffice
(
Id INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR (50) NOT NULL,
Address VARCHAR (50) NOT NULL,
PhoneNumber VARCHAR (12) NOT NULL,

UNIQUE(Name, Address, PhoneNumber),

CONSTRAINT insurance_address_uq UNIQUE(Name, Address, PhoneNumber),
CONSTRAINT check_length_phone_number CHECK (char_length(PhoneNumber) >= 12)
);
```

9. Создание таблицы InsuranceAgent

```sql
CREATE TABLE InsuranceAgent
(
Id INT PRIMARY KEY AUTO_INCREMENT,
PostId INT,
InsuranceOfficeId INT,
UserId INT UNIQUE,

CONSTRAINT agent_user_fk FOREIGN KEY (UserId) REFERENCES User(Id) ON DELETE CASCADE,
CONSTRAINT agent_post_fk FOREIGN KEY (PostId) REFERENCES Post(Id) ON DELETE SET NULL,
CONSTRAINT agent_office_fk FOREIGN KEY (InsuranceOfficeId) REFERENCES InsuranceOffice(Id) ON DELETE SET NULL
);
```

10. Создание таблицы Feedback

```sql
CREATE TABLE Feedback
(
Id INT PRIMARY KEY AUTO_INCREMENT,
Rating INT NOT NULL,
Feedback TEXT,
ClientId INT,

CONSTRAINT user_rating CHECK(Rating >= 1 AND Rating <= 5),

CONSTRAINT feedback_client_fk FOREIGN KEY (ClientId) REFERENCES Client(Id) ON DELETE SET NULL
);
```

11. Создание таблицы Category

```sql
CREATE TABLE Category
(
Id INT PRIMARY KEY AUTO_INCREMENT,
Title VARCHAR (50) NOT NULL UNIQUE,
Description TEXT NOT NULL
);
```

12. Создание таблицы InsuranceObject

```sql
CREATE TABLE InsuranceObject
(
Id INT PRIMARY KEY AUTO_INCREMENT,
Title VARCHAR (50) NOT NULL UNIQUE,
Description TEXT NOT NULL
);
```

13. Создание таблицы InsuranceType

```sql
CREATE TABLE InsuranceType
(
Id INT PRIMARY KEY AUTO_INCREMENT,
Title VARCHAR (50) NOT NULL UNIQUE,
Description TEXT NOT NULL,
Rate DECIMAL(2,2) NOT NULL,
CategoryId INT NOT NULL,
InsuranceObjectId INT,

CONSTRAINT type_category_fk FOREIGN KEY (CategoryId) REFERENCES Category(Id) ON DELETE CASCADE,
CONSTRAINT type_object_fk FOREIGN KEY (InsuranceObjectId) REFERENCES InsuranceObject(Id) ON DELETE SET NULL
);
```

14. Создание таблицы Journal

```sql
CREATE TABLE Journal
(
Id INT PRIMARY KEY AUTO_INCREMENT,
InsuranceAgentId INT,
ClientId INT NOT NULL,
InsuranceTypeId INT NOT NULL,
InsuranceObjectId INT NOT NULL,
Description TEXT NOT NULL,
TimeCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
IsApproved BOOL DEFAULT 0,

CONSTRAINT journal_agent_fk FOREIGN KEY (InsuranceAgentId) REFERENCES InsuranceAgent(Id) ON DELETE SET NULL,
CONSTRAINT journal_client_fk FOREIGN KEY (ClientId) REFERENCES Client(Id) ON DELETE CASCADE,
CONSTRAINT journal_type_fk FOREIGN KEY (InsuranceTypeId) REFERENCES InsuranceType(Id) ON DELETE CASCADE,
CONSTRAINT journal_object_fk FOREIGN KEY (InsuranceObjectId) REFERENCES InsuranceObject(Id) ON DELETE CASCADE
);
```

15. Создание таблицы Contract

```sql
CREATE TABLE Contract
(
Id INT PRIMARY KEY AUTO_INCREMENT,
InitialPayment DECIMAL(5,2) NOT NULL CHECK (InitialPayment >= 10),
TimeCreate DATETIME DEFAULT CURRENT_TIMESTAMP,
JournalId INT,

CONSTRAINT contract_journal_fk FOREIGN KEY (JournalId) REFERENCES Journal(Id) ON DELETE SET NULL
);
```

16. Создание индексов:

```sql
CREATE INDEX idx_client_user ON Client (UserId);
CREATE INDEX idx_agent_user ON InsuranceAgent (UserId);
CREATE INDEX idx_insurance_type_category ON InsuranceType (CategoryId);
CREATE INDEX idx_insurance_type_object ON InsuranceType (InsuranceObjectId);
CREATE INDEX idx_journal_agent ON Journal (InsuranceAgentId);
CREATE INDEX idx_journal_client ON Journal (ClientId);
CREATE INDEX idx_journal_type ON Journal (InsuranceTypeId);
CREATE INDEX idx_journal_object ON Journal (InsuranceObjectId);
```

---

### Заполнение таблиц значениями

1. Вставка значений в таблицу User

```sql
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user1', 'user1@example.com', '5BAA61E4', 'John', 'Doe', 'Admin');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user2', 'user2@example.com', 'D53C0AD6', 'Alice', 'Johnson', 'Agent');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user3', 'user3@example.com', 'E9B671D2', 'Bob', 'Smith', 'Client');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user4', 'user4@example.com', '47B12325', 'Emma', 'Williams', 'Admin');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user5', 'user5@example.com', 'F3D812E6', 'James', 'Brown', 'Agent');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user6', 'user6@example.com', '155A79C7', 'Olivia', 'Davis', 'Client');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user7', 'user7@example.com', '7C74AC12', 'William', 'Taylor', 'Admin');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user8', 'user8@example.com', 'F33C250A', 'Sophia', 'Miller', 'Agent');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user9', 'user9@example.com', '2E548AF6', 'Liam', 'Anderson', 'Client');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user10', 'user10@example.com', '23A97373', 'Ava', 'White', 'Client');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user11', 'user11@example.com', 'FC5F2FF0', 'Noah', 'Harris', 'Agent');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user12', 'user12@example.com', '1DA6487A', 'Mia', 'Clark', 'Client');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user13', 'user13@example.com', '0E2EF6D6', 'Ethan', 'Turner', 'Agent');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user14', 'user14@example.com', '03663B9B', 'Isabella', 'Moore', 'Agent');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user15', 'user15@example.com', 'F0C77E3F', 'Aiden', 'Wilson', 'Client');
INSERT INTO User (Username, Email, Password, Name, Surname, Status) VALUES ('user16', 'user16@example.com', 'F0C77E3F', 'Aiden', 'Wilson', 'Client');
```

2. Вставка значений в таблицу Client

```sql
INSERT IGNORE INTO Client (UserId) SELECT Id FROM User WHERE Status = 'Client';
```

3. Вставка значений в таблицу Admin

```sql
INSERT IGNORE INTO Admin (UserId) SELECT Id FROM User WHERE Status = 'Admin';
```

4. Вставка значений в таблицу Post

```sql
INSERT INTO Post (Title, Description) VALUES ('Real Estate Insurance Agent', 'Insurance for your real estate: houses, apartments, land plots');
INSERT INTO Post (Title, Description) VALUES ('Life Insurance Agent', 'Life insurance for you and your loved ones');
INSERT INTO Post (Title, Description) VALUES ('Auto Insurance Agent', 'Transport insurance: cars, motorcycles, trucks');
INSERT INTO Post (Title, Description) VALUES ('Business Insurance Agent', 'Business insurance for your enterprise: sole proprietorships, companies, offices');
```

5. Вставка значений в таблицу InsuranceOffice

```sql
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 1', '123 Main St', '123-456-7890');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 2', '456 Elm St', '234-567-8901');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 3', '789 Oak St', '345-678-9012');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 4', '321 Maple St', '456-789-0123');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 5', '654 Birch St', '567-890-1234');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 6', '987 Pine St', '678-901-2345');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 7', '135 Cedar St', '789-012-3456');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 8', '246 Spruce St', '890-123-4567');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 9', '357 Redwood St', '901-234-5678');
INSERT INTO InsuranceOffice (Name, Address, PhoneNumber) VALUES ('Insurance Office 10', '468 Sequoia St', '012-345-6789');
```

6. Вставка значений в таблицу InsuranceAgent

```sql
INSERT IGNORE INTO InsuranceAgent (UserId) SELECT Id FROM User WHERE Status = 'Agent';
```

7. Обновление значений в таблице InsuranceAgent и установка атрибутов в кортежах в нужные значения

```sql
UPDATE InsuranceAgent SET PostId = 1, InsuranceOfficeId = 1 WHERE Id = 1;
UPDATE InsuranceAgent SET PostId = 2, InsuranceOfficeId = 3 WHERE Id = 2;
UPDATE InsuranceAgent SET PostId = 3, InsuranceOfficeId = 5 WHERE Id = 3;
UPDATE InsuranceAgent SET PostId = 4, InsuranceOfficeId = 6 WHERE Id = 4;
UPDATE InsuranceAgent SET PostId = 3, InsuranceOfficeId = 7 WHERE Id = 5;
UPDATE InsuranceAgent SET PostId = 2, InsuranceOfficeId = 9 WHERE Id = 6;
```

8. Вставка значений в таблицу Feedback

```sql
INSERT INTO Feedback (Rating, Feedback, ClientId) VALUES (5, 'Excelent!', 3);
INSERT INTO Feedback (Rating, Feedback, ClientId) VALUES (2, 'You can do better.', 6);
INSERT INTO Feedback (Rating, Feedback, ClientId) VALUES (4, 'I liked everything!', 10);
INSERT INTO Feedback (Rating, Feedback, ClientId) VALUES (1, 'What a horror...', 12);
INSERT INTO Feedback (Rating, Feedback, ClientId) VALUES (5, 'I love this company.', 15);
```

9. Вставка значений в таблицу Category

```sql
INSERT INTO Category (Title, Description) VALUES ('Life Insurance', 'Insure your life.');
INSERT INTO Category (Title, Description) VALUES ('Property Insurance', 'Insure your real estate.');
INSERT INTO Category (Title, Description) VALUES ('Auto Insurance', 'Insure your vehicle.');
INSERT INTO Category (Title, Description) VALUES ('Business Insurance', 'Insure your business.');
INSERT INTO Category (Title, Description) VALUES ('Item Insurance', 'Insure what is valuable to you.');
```

1. Вставка значений в таблицу InsuranceObject

```sql
INSERT INTO InsuranceObject (Title, Description) VALUES ('Human', 'Infant, child, young, adult, elderly.');
INSERT INTO InsuranceObject (Title, Description) VALUES ('Real Estate', 'House, apartment.');
INSERT INTO InsuranceObject (Title, Description) VALUES ('Transportation', 'Car, motorcycle, truck.');
INSERT INTO InsuranceObject (Title, Description) VALUES ('Business', 'Sole proprietorship.');
INSERT INTO InsuranceObject (Title, Description) VALUES ('Valuables', 'Precious items.');
```

10. Вставка значений в таблицу InsuranceType

```sql
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Children in Safety', 'Insure during pregnancy.', 0.5, 1, 1);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Time for School', 'Secure your childs future.', 0.08, 1, 1);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Cozy at Home', 'Insure your real estate.', 0.08, 2, 2);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Open Doors', 'Insure your apartment.', 0.5, 2, 2);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Speed', 'Ensure peaceful city rides on a motorcycle.', 0.45, 3, 3);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Abroad Bound', 'Insure your truck.', 0.9, 3, 3);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('My First Company', 'Do not fear for your business.', 0.05, 4, 4);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Only Upward', 'Let troubles pass by your business.', 0.6, 4, 4);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Sparkle and Clank', 'You can also insure precious gems.', 0.5, 5, 5);
INSERT INTO InsuranceType (Title, Description, Rate, CategoryId, InsuranceObjectId) VALUES ('Tick-Tock', 'Insure your watches.', 0.54, 5, 5);
```

11. Вставка значений в таблицу Journal

```sql
INSERT INTO Journal (ClientId, InsuranceTypeId, InsuranceObjectId, Description)
VALUES (3, 2, 1, 'I need to insure my child');
```

12. Обновление таблицы Journal и установка атрибутов в нужное значение

```sql
UPDATE Journal
SET InsuranceAgentId = 2, IsApproved = 1 WHERE Id = 1;
```

13. Вставка значений в таблицу Contract

```sql
INSERT INTO Contract (InitialPayment, JournalId) VALUES (500, 1);
```

---

### Пул запросов

1. Использование БД

```sql
USE InsuranceCompany;
```

2. Вставка в таблицу с ипользованием значения DEFAULT (можно не указывать)

```sql
INSERT INTO User (Username, Email, Password, Name, Surname)
VALUES ('username17', 'username17@ins.com', '5SGFF89S', 'Jack', 'King');
```

3. Вставка таблицу

```sql
INSERT INTO User(Username, Email, Password, Name, Surname, Status)
VALUES ('username18', 'username18@ins.com', 'NS5L0XBJ', 'Olivia', 'Smith', 'Agent');
```

4. Вставка в таблицу с выборкой необходимых элементов

```sql
INSERT INTO Client (Id) SELECT Id FROM User WHERE Status = 'Client';
```

INSERT INTO Agent (Id) SELECT Id FROM User WHERE Status = 'Agent';

5. Обновление значений в таблице

```sql
UPDATE InsuranceAgent SET PostId = 1, InsuranceOfficeId = 2 WHERE Id = 8;
```

6. Множественная вставка

```sql
INSERT INTO Feedback (Rating, Feedback, ClientId)
VALUES
(5, 'Cool', 3),
(2, 'Bad', 5);
```

7. Получение всех объектов из таблицы

```sql
SELECT * FROM Post;
```

8. Получение данных из конкретных столбцов таблицы

```sql
SELECT Name, Surname FROM User;
```

SELECT Title, Description FROM InsuranceType;

9. Изменение название столбца (определение псевдонима)

```sql
SELECT InsuranceOfficeId AS Office, PostId AS Positions FROM InsuranceAgent;
```

10. Выборка с условием

```sql
SELECT * FROM InsuranceType
WHERE Rate > 0.5;
```

11. Выборка одного столбца с указанным условием

```sql
SELECT Title FROM InsuranceType
WHERE CategoryId = 1;
```

12. Использование логического оператора AND

```sql
SELECT * FROM InsuranceType
WHERE Rate <= 0.5 AND InsuranceObjectId = 2;
```

13. Использование логического оператора OR 

```sql
SELECT * FROM InsuranceType
WHERE Rate <= 0.5 OR InsuranceObjectId = 2;
```

14. Использование логического оператора NOT

```sql
SELECT * FROM Category
WHERE NOT Title = 'Item Insurance';
```

15. Приоритет операций

```sql
SELECT * FROM InsuranceType
WHERE CategoryId >= 3 OR NOT Rate < 0.4 AND InsuranceObjectId >=2;
```

16. Обновление данных

```sql
UPDATE InsuranceType
SET Rate = Rate - 0.01;
```

17. Обновление данных с ипользованием условия для поиска нужного кортежа

```sql
UPDATE InsuranceType
SET 	CategoryId = 2,
InsuranceObjectId = 3
WHERE Title = 'Children in Safety';
```

18. Обновление данных (установка в DEFAULT)

```sql
UPDATE User
SET Status = DEFAULT
WHERE Username = 'username19';
```

19. Удаление данных из БД

```sql
DELETE FROM InsuranceAgent
WHERE Id = 9;
```

20. Выборка уникальных данных из столбца

```sql
SELECT DISTINCT CategoryId FROM InsuranceType;
```

21. Выборка уникальных данных из столбцов

```sql
SELECT DISTINCT CategoryId, InsuranceObjectId FROM InsuranceType;
```

22. Определение набора значения, которые должен иметь столбец (выбираем агентов, у которых офис либо 1, либо 2, либо 3)

```sql
SELECT * FROM InsuranceAgent
WHERE InsuranceOfficeId IN (1, 3, 2);
```

23. Определение набора значения, которые должен иметь столбец (выбираем агентов, у которых офис не 1, не 2 и не 3)

```sql
SELECT * FROM InsuranceAgent
WHERE InsuranceOfficeId NOT IN (1, 3, 2);
```

24. Определение диапазона значений

```sql
SELECT * FROM User
WHERE Id BETWEEN 3 AND 6;
```

25. Определение диапазона значений, который не отобразиться

```sql
SELECT * FROM User
WHERE Id NOT BETWEEN 3 AND 6;
```

26. Использование шаблона строки, которые могут содержать символ

```sql
SELECT * FROM User
WHERE Name LIKE 'A%';
```

27. Использование шаблона строки, которые не содержат символа

```sql
SELECT * FROM User
WHERE Name NOT LIKE 'A%';
```

28. Использование шаблона строки, где _ соответствует любому одиночному символу

```sql
SELECT * FROM User
WHERE Name LIKE 'Olivi_';
```

29. Задается регулярной выражение (строка должна оканчиваться на…)

```sql
SELECT * FROM User
WHERE Email REGEXP 'ins.com$;
```

30. Задается регулярное выражение (строка должна содержать …)

```sql
SELECT * FROM User
WHERE Name REGEXP '[l]';
```

31. Задается регулярное выражение (строка должна содержать элементы лежащие между [ - ] …)

```sql
SELECT * FROM InsuranceOffice
WHERE PhoneNumber REGEXP '[1-3]';
```

32. Выборка строк, столбцы которых не имеют значение NULL

```sql
SELECT * FROM InsuranceAgent
WHERE PostId IS NOT NULL;
```

33. Сортировка по столбцам

```sql
SELECT * FROM User
ORDER BY Name, Surname;
```

34. Сортировка по одному столбцу

```sql
SELECT Rate, Title FROM InsuranceType
ORDER BY Rate;
```

35. Комбинация

```sql
SELECT Rate * 0.3 AS MinRate, Title FROM InsuranceType
ORDER BY Rate;
```

36. Сортировка по убыванию

```sql
SELECT Rate * 0.3 AS MinRate, Title FROM InsuranceType
ORDER BY Rate DESC;
```

37. Сортировка по возрастанию (ASC можно не прописывать)

```sql
SELECT Rate * 0.3 AS MinRate, Title FROM InsuranceType
ORDER BY Rate ASC;
```

38. Комбинация сортировок

```sql
SELECT Rate, Title FROM InsuranceType
ORDER BY Rate ASC, Title DESC;
```

39. Извлекаем 2 строки

```sql
SELECT * FROM Post
LIMIT 2;
```

40. Пропускаем 2 строки, после чего извлекаем две последующие

```sql
SELECT * FROM Post
LIMIT 2, 2;
```

41. Сортируем по возрастанию и убыванию, а после извлекаем 4 строки со смещением равным 2

```sql
SELECT Rate * 0.3 AS MinRate, Title FROM InsuranceType
ORDER BY Rate ASC, Title DESC
LIMIT 2, 4; - 2 строки пропускаем, 4
```

42. Вычисление среднего значение с указанием условия выборки

```sql
SELECT AVG(Rate) AS AverageRate FROM InsuranceType
WHERE CategoryId = '2';
```

43. Комбинация

```sql
SELECT AVG(Rate) AS AverageRate FROM InsuranceType
WHERE CategoryId = '2' AND InsuranceObjectId = '2';
```

44. Комбинация

```sql
SELECT AVG(Rate * 5) AS AverageRate FROM InsuranceType
WHERE CategoryId = '2' AND InsuranceObjectId = '2';
```

45. Вычисление количества строк в выборке

```sql
SELECT COUNT(*) FROM InsuranceType;
```

46. Вычисление количества строк по определенному столбцу (NULL игнорируется)

```sql
SELECT COUNT(Title) FROM InsuranceType;
```

47. Вычисление количества строк столбца после уникальной выборки из таблицы

```sql
SELECT COUNT(DISTINCT CategoryId) FROM InsuranceType;
```

48. Тоже самое, что и п.46 (ALL можно не прописывать)

```sql
SELECT COUNT(ALL CategoryId) FROM InsuranceType;
```

49. Выборка максимального и минимальных значений

```sql
SELECT MAX(Rate) AS Max, MIN(RATE) AS Min FROM InsuranceType;
```

50. Подсчет суммы значений столбца

```sql
SELECT SUM(Rate) FROM InsuranceType;
```

51. Подсчет суммы уникальных значений столбца

```sql
SELECT SUM(DISTINCT Rate) FROM InsuranceType;
```

52. Комбинация

```sql
SELECT COUNT(DISTINCT CategoryId) AS CategoryId,
SUM(Rate),
MIN(Rate) AS Min,
MAX(Rate) AS Max,
AVG(Rate) AS Average
FROM InsuranceType;
```

53. Группировка данных

```sql
SELECT PostId, COUNT(*) AS CountAgent
FROM InsuranceAgent
GROUP BY PostId;
```

54. Комбинация

```sql
SELECT PostId, COUNT(*) AS CountAgent
FROM InsuranceAgent
WHERE InsuranceOfficeId > 3
GROUP BY PostId
ORDER BY CountAgent DESC;
```

55. Фильтрация групп

```sql
SELECT PostId, COUNT(*) AS CountAgent
**FROM InsuranceAgent
WHERE InsuranceOfficeId > 3
GROUP BY PostId
HAVING COUNT(*) > 1;
```

56. Выборка с указанием выборки в условии

```sql
SELECT * FROM InsuranceType
WHERE Rate = (SELECT MIN(Rate) FROM InsuranceType);
```

57. Выборка с указанием выборки в условии

```sql
SELECT * FROM InsuranceType
WHERE Rate < (SELECT AVG(Rate) FROM InsuranceType);
```

58. Работа между двумя таблицами

Мы выбираем Наименование, Описание, а также выбираем Id Объектов Страхования равные внешнему ключу в таблице Типов Страхования, указываем псевдоним этого столбца и делаем выборку из таблицы Типов Страхования

```sql
SELECT Title, Description,
(SELECT Title FROM InsuranceObject
WHERE InsuranceObject.Id = InsuranceType.InsuranceObjectId) AS Object
FROM InsuranceType;

UPDATE InsuranceAgent SET PostId = 1, InsuranceOfficeId = 1 WHERE Id = 1;
UPDATE InsuranceAgent SET PostId = 2, InsuranceOfficeId = 3 WHERE Id = 2;
UPDATE InsuranceAgent SET PostId = 3, InsuranceOfficeId = 5 WHERE Id = 3;
UPDATE InsuranceAgent SET PostId = 4, InsuranceOfficeId = 6 WHERE Id = 4;
UPDATE InsuranceAgent SET PostId = 3, InsuranceOfficeId = 7 WHERE Id = 5;
UPDATE InsuranceAgent SET PostId = 2, InsuranceOfficeId = 9 WHERE Id = 6;
```