# go_mysql

## Mysql 的安装

sudo apt-get install mysql-server

我在这里安装后莫名其妙 root 登录不进去，最后通过修改 /etc/mysql/mysql.conf.d/mysqld.cnf 文件，增加 `--skip-grant-tables`，进去后先 `flush privileges;` 而后 `mysql>create user 'username'@'%' identified by 'password';` 创建了一个用户，最后 `mysql> grant all on *.* to root@'%';` 给予了所有权限，最后 `flush privileges;`

### Mysql 登陆

`mysql -u<name> -p`

### Mysql Server 的启动

Once the installation is complete, you can start the MySQL server by running the following command:  
`sudo systemctl start mysql`

You can also configure the MySQL server to start automatically when the system boots by running the following command:  
`sudo systemctl enable mysql`

To verify that the MySQL server is running, you can use the following command:  
`sudo systemctl status mysql`

### Mysql 日常

`use <database_name>`

```
CREATE TABLE user_tbl (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(20),
  password VARCHAR(20)
);
```

```
Insert into user_tbl (username,password) values ("tom","123");
```

```
desc user_tbl;
```

## go_with_sql

```go
package main

import (
	_ "database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	fmt.Println("Hello, World!")
}

```
