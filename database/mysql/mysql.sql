-- [ Conectar no MySQL ]
-- $ mysql -uroot -p
-- $ mysql -h127.0.0.1 -uroot -p
-- $ mysql -hlocalhost -uroot -p


-- MySQL

-- Explo 01.

CREATE DATABASE IF NOT EXISTS db_teste;

USE db_teste;

CREATE TABLE IF NOT EXISTS products (
    id int(11) AUTO_INCREMENT,
    name VARCHAR(255),
    price DECIMAL(10,2),
    PRIMARY KEY (id)
);

INSERT INTO products VALUES (0, 'Curso Front-End Especialista', 2500);
INSERT INTO products VALUES (0, 'Curso JS FullStack', 900);


-- Criar usuário da aplicação e conceder privilégios
CREATE USER 'usr_teste'@'%' IDENTIFIED BY 'usrteste';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_teste.* TO 'usr_teste'@'%';
--GRANT ALL PRIVILEGES ON db_teste.* TO 'usr_teste'@'%';
FLUSH PRIVILEGES;
-- Devido problemas do drive no mysql na biblioteca 'mysql' do 'NodeJS', precisamos efetuar
-- a alteração abaixo no MySQL. Esta necessidade surgiu apartir do MySQL 8.
ALTER USER 'usr_teste'@'%' IDENTIFIED WITH mysql_native_password BY 'usrteste';
--CREATE USER 'usr_teste'@'%' IDENTIFIED WITH mysql_native_password BY 'usrteste';
--SELECT User, Db, Host FROM mysql.db;
--SHOW GRANTS FOR


-- Explo 02.
create user 'usr_teste'@'%' identified with mysql_native_password by 'usrteste';
flush privileges;
select User, Db, Host from mysql.db;


-- Explo 03.

CREATE DATABASE sitepoint CHARACTER SET utf8 COLLATE utf8_general_ci;
USE sitepoint;

CREATE TABLE authors (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(50),
  city varchar(50),
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

INSERT INTO authors (id, name, city) VALUES
(1, 'Michaela Lehr', 'Berlin'),
(2, 'Michael Wanyoike', 'Nairobi'),
(3, 'James Hibbard', 'Munich'),
(4, 'Karolina Gawron', 'Wrocław');


-- Explo 04.

-- Privilégios

CREATE USER u1;
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO u1;
REVOKE INSERT, UPDATE ON schema1.* FROM u1;
REVOKE SELECT ON schema2.* FROM u1;

-- Also create a role r1 that lifts some of the privilege restrictions and grant the role to u1:

CREATE ROLE r1;
GRANT INSERT ON schema1.* TO r1;
GRANT SELECT ON schema2.* TO r1;
GRANT r1 TO u1;

-- Now, using an account that has no privilege restrictions of its own, grant to multiple users the same set of global privileges, but each with different restrictions imposed by the AS clause, and check which privileges are actually granted.

-- The GRANT statement here has no AS clause, so the privileges granted are exactly those specified:

mysql> CREATE USER u2;
mysql> GRANT SELECT, INSERT, UPDATE ON *.* TO u2;
mysql> SHOW GRANTS FOR u2;
+-------------------------------------------------+
| Grants for u2@%                                 |
+-------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE ON *.* TO `u2`@`%` |
+-------------------------------------------------+

The GRANT statement here has an AS clause, so the privileges granted are those specified but with the restrictions from u1 applied:

mysql> CREATE USER u3;
mysql> GRANT SELECT, INSERT, UPDATE ON *.* TO u3 AS u1;
mysql> SHOW GRANTS FOR u3;
+----------------------------------------------------+
| Grants for u3@%                                    |
+----------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE ON *.* TO `u3`@`%`    |
| REVOKE INSERT, UPDATE ON `schema1`.* FROM `u3`@`%` |
| REVOKE SELECT ON `schema2`.* FROM `u3`@`%`         |
+----------------------------------------------------+


-- Explo:



-- [ Grant ]

-- Database Privileges
-- Database privileges apply to all objects in a given database. To assign database-level privileges, use ON db_name.* syntax:

GRANT ALL ON mydb.* TO 'someuser'@'somehost';
GRANT SELECT, INSERT ON mydb.* TO 'someuser'@'somehost';

-- Table Privileges
-- Table privileges apply to all columns in a given table. To assign table-level privileges, use ON db_name.tbl_name syntax:


GRANT ALL ON mydb.mytbl TO 'someuser'@'somehost';
GRANT SELECT, INSERT ON mydb.mytbl TO 'someuser'@'somehost';


GRANT 'role1', 'role2' TO 'user1'@'localhost', 'user2'@'localhost';

-- The following example illustrates the effect of the AS clause. Create a user u1 that has some global privileges, as well as restrictions on those privileges:

CREATE USER u1;
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO u1;
REVOKE INSERT, UPDATE ON schema1.* FROM u1;
REVOKE SELECT ON schema2.* FROM u1;

-- Also create a role r1 that lifts some of the privilege restrictions and grant the role to u1:

CREATE ROLE r1;
GRANT INSERT ON schema1.* TO r1;
GRANT SELECT ON schema2.* TO r1;
GRANT r1 TO u1;

-- Now, using an account that has no privilege restrictions of its own, grant to multiple users the same set of global privileges, but each with different restrictions imposed by the AS clause, and check which privileges are actually granted.

-- The GRANT statement here has no AS clause, so the privileges granted are exactly those specified:

mysql> CREATE USER u2;
mysql> GRANT SELECT, INSERT, UPDATE ON *.* TO u2;
mysql> SHOW GRANTS FOR u2;
+-------------------------------------------------+
| Grants for u2@%                                 |
+-------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE ON *.* TO `u2`@`%` |
+-------------------------------------------------+
-- The GRANT statement here has an AS clause, so the privileges granted are those specified but with the restrictions from u1 applied:


mysql> CREATE USER u3;
mysql> GRANT SELECT, INSERT, UPDATE ON *.* TO u3 AS u1;
mysql> SHOW GRANTS FOR u3;
+----------------------------------------------------+
| Grants for u3@%                                    |
+----------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE ON *.* TO `u3`@`%`    |
| REVOKE INSERT, UPDATE ON `schema1`.* FROM `u3`@`%` |
| REVOKE SELECT ON `schema2`.* FROM `u3`@`%`         |
+----------------------------------------------------+

-- The AS clause for the GRANT statement here makes the role r1 active for u1. That role lifts some of the restrictions on u1. Consequently, the privileges granted have some restrictions, but not so many as for the previous GRANT statement:

mysql> CREATE USER u4;
mysql> GRANT SELECT, INSERT, UPDATE ON *.* TO u4 AS u1 WITH ROLE r1;
mysql> SHOW GRANTS FOR u4;
+-------------------------------------------------+
| Grants for u4@%                                 |
+-------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE ON *.* TO `u4`@`%` |
| REVOKE UPDATE ON `schema1`.* FROM `u4`@`%`      |
+-------------------------------------------------+
