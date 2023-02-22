# 如何使用 Go 连接远程 Linux-mongodb

官方文档 [MongoDB Go Driver — Go](https://www.mongodb.com/docs/drivers/go/current/)

## 文章需求分析

可以很快地再次上手，无需再看官方文档  
对疑惑的内容加以注释

## 如何使用 Go 连接远程 Linux-mongodb

首先远程服务器必然需要安装 mongodb，具体安装过程请看官方 tutorial

我们采用如下的代码检测连通性。在代码中我们要变动的内容为 uri，修改为 linux 服务器对应的 ip 地址，端口等信息，即可完成连接。

【注】如果密码中含有@字符，在 Connect 中加入 uri_decode_auth: true

```Go
package main

import (
    "context"
    "fmt"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
    "go.mongodb.org/mongo-driver/mongo/readpref"
)

// Connection URI
const uri = "mongodb://user:pwd@ip:port/?connect=direct&authSource=admin&authMechanism=SCRAM-SHA-1"

func main() {
    // Create a new client and connect to the server
    client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI(uri))
    if err != nil {
        panic(err)
    }
    defer func() {
        if err = client.Disconnect(context.TODO()); err != nil {
            panic(err)
        }
    }()
    
    // Ping the primary
    if err := client.Ping(context.TODO(), readpref.Primary()); err != nil {
        panic(err)
    }
    fmt.Println("Successfully connected and pinged.")
}
```

### Enable Access Control

当我们启动了 access control 的时候，user 必须要验证身份后才能执行操作。默认的做法是使用 SCRAM 进行验证。

启动 mongod `mongod --port 27017 --dbpath /var/lib/mongodb`  
本地连接 `mongosh --port 27017`  
创建用户，分配权限

```
use admin
db.createUser(
  {
    user: "myUserAdmin",
    pwd: passwordPrompt(), // or cleartext password
    roles: [
      { role: "userAdminAnyDatabase", db: "admin" },
      { role: "readWriteAnyDatabase", db: "admin" }
    ]
  }
)
```

用 mongosh 退出当前 mongod `db.adminCommand( { shutdown: 1 } )`  
退出 mongod  
修改配置文件，默认地址为 /etc/mongod.conf

```
security:
	authorization: enabled
```

这样我们就成功启动了 auth，之后再连接之后则需要进行验证

```
use admin
db.auth("myUserAdmin", passwordPrompt()) // or cleartext password
```

更详细的内容请见 [Use SCRAM to Authenticate Clients — MongoDB Manual](https://www.mongodb.com/docs/manual/tutorial/configure-scram-client-authentication/)

【注】我们可以在之后会遇到 `sudo systemctl start mongod` 不能正确启动 (exitcode=14) 的情况，这是由于当我们执行 mongod 命令时，会创建一些 system files，这些 system files 的 owner 是 root 而不是 mongod。而我们的 systemctl 则会以 mongod 用户运行，这遵循了 least privilege 原则。可以通过改变 owner 来修复问题。

```
sudo chown -R mongodb:mongodb /var/lib/mongodb
sudo chown mongodb:mongodb /tmp/mongodb-27017.sock
```

之后我们执行 sudo service mongod restart 即可启动服务。

### 创建用户及密码

远程连接必定需要账户密码进行验证。

创建用户

```
db.createUser({
	user: "userName",
	pwd: passwordPrompt(),
	roles: []
})
```

查看用户

```
db.getUsers()
```

删除用户

```
db.dropUser("tom")
```

更详细的内容请见 [MongoDB Users and Authentication - Create, List, and Delete (prisma.io)](https://www.prisma.io/dataguide/mongodb/configuring-mongodb-user-accounts-and-authentication)。关于 roles 的相关内容移步官方文档 [Built-In Roles — MongoDB Manual](https://www.mongodb.com/docs/manual/reference/built-in-roles/#std-label-built-in-roles)。

### bindIP

如果我们是在默认情况下启动，那么我们的 bindIP 会被设置为 127.0.0.1 这会使得只有在相同机器上跑的客户端才能得到响应。我们可以通过 config 文件，或者是通过命令行参数 --bind_ip 来设置。

注意在修改配置文件后需要执行 `sudo systemctl restart mongod` 加载配置文件

【注】这可能会带来安全风险。可以查看 Security Checklist 来对照。[Security Checklist — MongoDB Manual](https://www.mongodb.com/docs/manual/administration/security-checklist/)
