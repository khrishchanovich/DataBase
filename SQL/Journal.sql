INSERT INTO Journal (ClientId, InsuranceTypeId, InsuranceObjectId, Description)
VALUES (3, 2, 1, 'I need to insure my child');

UPDATE Journal
SET InsuranceAgentId = 2, IsApproved = 1 WHERE Id = 1;
