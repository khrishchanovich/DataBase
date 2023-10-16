INSERT IGNORE INTO Admin (UserId) SELECT Id FROM User WHERE Status = 'Admin';
