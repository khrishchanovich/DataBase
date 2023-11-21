# Пул триггеров

---

Триггер, который при добавлении нового пользователя, обращается к его статусу и добавляет его в соответствующую таблицу

```sql
CREATE DEFINER=`root`@`localhost` TRIGGER `user_AFTER_INSERT` AFTER INSERT ON `user` FOR EACH ROW BEGIN
    IF NEW.Status = 'Admin' THEN
        INSERT IGNORE INTO admin (UserId) VALUES (NEW.Id);
    ELSEIF NEW.Status = 'Agent' THEN
        INSERT IGNORE INTO insuranceagent (UserId) VALUES (NEW.Id);
    ELSEIF NEW.Status = 'Client' THEN
        INSERT IGNORE INTO client (UserId) VALUES (NEW.Id);
    END IF;
END
```

Триггер, который обновляет поле isApproved в строке, если заявку пользователя принимает агент

```sql
CREATE DEFINER=`root`@`localhost` TRIGGER `journal_BEFORE_UPDATE` BEFORE UPDATE ON `journal` FOR EACH ROW BEGIN
	IF NEW.InsuranceAgentId IS NOT NULL THEN
        SET New.IsApproved = 1;
    END IF;
END
```

Триггер, который добавляет контракт взависимости от значений в журнале

```sql
CREATE DEFINER=`root`@`localhost` TRIGGER `journal_AFTER_UPDATE` AFTER UPDATE ON `journal` FOR EACH ROW BEGIN
    IF NEW.InsuranceAgentId IS NOT NULL THEN
         INSERT INTO Contract (JournalId) VALUES (NEW.Id);
    END IF;
END
```

Триггер, вызывающийся при удалении пользователя

```sql
CREATE DEFINER=`root`@`localhost` TRIGGER `user_BEFORE_DELETE` BEFORE DELETE ON `user` FOR EACH ROW BEGIN
	DELETE FROM admin WHERE UserId = OLD.Id;
  	DELETE FROM insuranceagent WHERE UserId = OLD.Id;
  	DELETE FROM client WHERE UserId = OLD.Id;
END
```

# Пул хранимых процедур

---

Процедура создания пользователя

```sql
CREATE PROCEDURE `create_user` (
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_password VARCHAR(50),
    IN p_name VARCHAR(50),
    IN p_surname VARCHAR(50),
    IN p_status ENUM('Admin', 'Agent', 'Client')
)
BEGIN
	INSERT INTO User (Username, Email, Password, Name, Surname, Status)
    VALUES (p_Username, p_Email, p_Password, p_Name, p_Surname, p_Status);
	IF p_status IS NULL THEN
        SET p_status = 'Client';
    END IF;
END;
```

Процедура получения информации о пользователе по id

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_id`(
	in p_userid int
)
BEGIN
	select * from user where id = p_userid;
END
```

Процедура, обновляющая данные об агенте страхования

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_insuranceagent`(
    IN p_AgentId INT,
    IN p_PostId INT,
    IN p_InsuranceOfficeId INT
)
BEGIN
    UPDATE InsuranceAgent
		SET PostId = p_PostId, InsuranceOfficeId = p_InsuranceOfficeId
		WHERE Id = p_AgentId;
END
```

Процедура, обновляющая данные в журнале об агенте

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_agent_in_journal`(
	IN p_JournalId INT,
    IN p_InsuranceAgentId INT
)
BEGIN
	UPDATE Journal
		SET InsuranceAgentId = p_InsuranceAgentId
		WHERE Id = p_JournalId;
END
```

Процедура добавления категории

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_category`(
    IN p_Title VARCHAR(50),
    IN p_Description TEXT
)
BEGIN
    INSERT INTO Category (Title, Description)
    VALUES (p_Title, p_Description);
END
```

Процедура добавления объекта страхования

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_insuranceobject`(
    IN p_Title VARCHAR(50),
    IN p_Description TEXT
)
BEGIN
    INSERT INTO InsuranceObject (Title, Description)
    VALUES (p_Title, p_Description);
END
```

Процедура добавления отзыва от клиента

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_feedback`(
    IN p_Rating INT,
    IN p_Feedback TEXT,
    IN p_ClientId INT
)
BEGIN
    INSERT INTO Feedback (Rating, Feedback, ClientId)
    VALUES (p_Rating, p_Feedback, p_ClientId);
END
```

Процедура добавления записи в журнал
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_journal`(
    IN p_ClientId INT,
    IN p_InsuranceTypeId INT,
    IN p_InitialPayment DECIMAL(5, 2),
    IN p_InsuranceObjectId INT,
    IN p_Description TEXT
)
BEGIN
    INSERT INTO Journal (ClientId, InsuranceTypeId, InitialPayment, InsuranceObjectId, Description)
    VALUES (p_ClientId, p_InsuranceTypeId, p_InitialPayment, p_InsuranceObjectId, p_Description);
END