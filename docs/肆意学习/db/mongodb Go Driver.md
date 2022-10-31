# Mongodb Go Driver

官方文档 [MongoDB Go Driver — Go](https://www.mongodb.com/docs/drivers/go/current/)

## 文章需求分析

可以很快地再次上手，无需再看官方文档  
对疑惑的内容加以注释

## 如何使用 Go 连接远程 Linux-mongodb

首先远程服务器必然需要安装 mongodb，具体安装过程请看官方 tutorial

我们采用如下的代码检测连通性。在代码中我们要变动的内容为 uri，修改为 linux 服务器对应的 ip 地址，端口等信息，即可完成连接。

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

更详细的内容请见 [Use SCRAM to Authenticate Clients — MongoDB Manual](https://www.mongodb.com/docs/manual/tutorial/configure-scram-client-authentication/)

### 创建用户及密码

远程连接必定需要账户密码进行验证。

创建用户

```
db.createUser({
	user: "userName",
	pwd: "password",
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

更详细的内容请见 [MongoDB Users and Authentication - Create, List, and Delete (prisma.io)](https://www.prisma.io/dataguide/mongodb/configuring-mongodb-user-accounts-and-authentication)

### bindIP

如果我们是在默认情况下启动，那么我们的 bindIP 会被设置为 127.0.0.1 这会使得只有在相同机器上跑的客户端才能得到响应。我们可以通过 config 文件，或者是通过命令行参数 --bind_ip 来设置。

【注】这可能会带来安全风险。可以查看 Security Checklist 来对照。[Security Checklist — MongoDB Manual](https://www.mongodb.com/docs/manual/administration/security-checklist/)
