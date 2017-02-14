
DROP USER IF EXISTS 'quotr'@'localhost';
GRANT SELECT, USAGE, INSERT, UPDATE, DELETE ON quotr.* TO 'quotr'@'localhost' IDENTIFIED BY 'Qu0+3r';
GRANT ALL ON quotr_test.* TO 'quotr'@'localhost' IDENTIFIED BY 'Qu0+3r';
FLUSH PRIVILEGES;
