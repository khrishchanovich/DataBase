INSERT IGNORE INTO Client (UserId) SELECT Id FROM User WHERE Status = 'Client';
