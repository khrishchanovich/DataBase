INSERT IGNORE INTO InsuranceAgent (UserId) SELECT Id FROM User WHERE Status = 'Agent';

UPDATE InsuranceAgent SET PostId = 1, InsuranceOfficeId = 1 WHERE Id = 1;
UPDATE InsuranceAgent SET PostId = 2, InsuranceOfficeId = 3 WHERE Id = 2;
UPDATE InsuranceAgent SET PostId = 3, InsuranceOfficeId = 5 WHERE Id = 3;
UPDATE InsuranceAgent SET PostId = 4, InsuranceOfficeId = 6 WHERE Id = 4;
UPDATE InsuranceAgent SET PostId = 3, InsuranceOfficeId = 7 WHERE Id = 5;
UPDATE InsuranceAgent SET PostId = 2, InsuranceOfficeId = 9 WHERE Id = 6;
