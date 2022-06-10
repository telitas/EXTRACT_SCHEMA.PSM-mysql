CREATE DATABASE test;
CREATE DATABASE mtr;
CREATE DATABASE mydb;
CREATE DATABASE otherdb;

CREATE USER myuser IDENTIFIED BY 'my-secret-pw';
GRANT ALL PRIVILEGES ON mysql.* TO myuser@'%';
GRANT ALL PRIVILEGES ON test.* TO myuser@'%';
GRANT ALL PRIVILEGES ON mtr.* TO myuser@'%';
GRANT ALL PRIVILEGES ON mydb.* TO myuser@'%';
GRANT ALL PRIVILEGES ON otherdb.accessible_table TO myuser@'%';
