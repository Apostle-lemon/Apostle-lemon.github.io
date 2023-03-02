# Mongodb

## 概述

Mongodb 是一种使用广泛的非关系型数据库。只需键值对，不需要设置相同的字段，相同的字段也不需要相同的数据类型，操作简单。

官方教程友好且全面 <https://www.mongodb.com/docs/v6.0/>

## 安装

### Windows 平台

<https://www.mongodb.com/docs/v6.0/tutorial/install-mongodb-on-windows/>

【注】mongo.exe 在 mongodb 6.0 之后不再随之安装。可以采用 mongodb shell, 这需要单独下载安装，之后的命令可以采用 mongosh 替代原来的 mongo 命令。

### Linux 平台

<https://www.mongodb.com/docs/manual/administration/install-on-linux/>  

【注】config 默认存放路径 /etc/mongod.conf, 查看默认配置文件，即可发现  
默认 dbpath 路径 `/var/lib/mongodb`  
默认 log 文件路径 `/var/log/mongodb/mongod.log`

## 服务启动

查看 mongod 当前的状态

```shell
sudo systemctl status mongod
```

查看当前 mongod 中存在多少账户

```

```

## 基础语法

- 创建数据库/切换数据库

```Go
use DATABASE_NAME
```

- 查看所有数据库

```Go
show dbs
```

注意在我们 use 了之后，用 `show dbs` 不能看见数据库列表中有对应数据库。需要我们在新建数据库中插入数据才可以显示。

- 删除数据库

```Go
db.dropDatabase()
```

- 删除集合

```Go
db.collection.drop()
```

- 创建集合

```Go
db.createCollection(name, options)
```

当我们向未创建的集合中插入文档的时候，其会自动创建。

## CRUD

CRUD 的相关文档可以在这儿看 <https://www.mongodb.com/docs/v6.0/crud/>

## 远程连接

<https://www.mongodb.com/docs/drivers/go/current/fundamentals/connection/>

远程连接采用了如下的 url 格式。这里的 host 可以有多个，以便于分布式存储。port 的默认值为 27017。database 表明要连接的数据库。options 通常会指明认证源（authSource）是什么。

```Go
mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
```

## GO 类型和绑定

MongoDB 可以通过 bson 接轨各类语言。
在 go 中，是使用 mongo-driver 的 `bson` 和 `options` 两个模块。

### Bson

mongo 的 bson 类似于 json，是一种键值对格式：

```JSON
{
  "_id": {
    "$oid": "62e2db2cac21442171666923"
  },
  "name": "even",
  "tp": [
      {"qwq":1},
      {"qwq":2}
  ]
}
```

而在 go 中，bson 模块提供了四种类型：

```Go
import . "go.mongodb.org/mongo-driver/bson"

func main() {
    a := D{{"Key1", "Value1"}, {"Key2", "Value2"}}
        b := E{"Key3", "Value3"}
        a = append(a, b)
        c := M{"Key1": "Value1", "Key2": "Value2"}
        d := A{"A", "B"}
}
```

其中，`bson.D` 是有序表示的键值对，`bson.E` 就是其中的一对键值对，`bson.D` 是支持 append 方法的。`bson.M` 是无序的键值对，`bson.A` 就是 list。

除了用这些类型表示 bson 文档，还可以用 bson tag 将结构体绑定成 bson 格式，可以使用 `omitempty，-` 等参数，和 json tag 差不太多。不绑定的话默认是以 lowercase 当作字段名，并且参数的 **首字母必须大写** 才能被绑定。

因为 mongo 是 nosql，随便什么类型都可以往里面塞，但是如果类型不固定就只能用 interface 接。

```Go
type myStruct struct {
    Name         string                 `bson:"name,omitempty"`
    TestName     interface{}            `bson:"test_name"`
}
```

### ObjectID

mongo 的主键 `_id` 默认是其自带的 ObjectID 类型，本质上这是由日期，机器码，进程 id 和一个随机数生成的 uuid，这种 id 极大地方便了分布式的数据库系统。（虽然实际用时用字符串或者其他类型盖掉也完全没关系 x）

bson 包提供了一个类型与其对应，还可以从中提取时间信息，或与 16 进制串互相转换。

```Go
import (
        "go.mongodb.org/mongo-driver/bson"
        "go.mongodb.org/mongo-driver/bson/primitive"
)

func main {
    a := primitive.NewObjectID() //primitive.ObjectID
        b := primitive.NewObjectIDFromTimestamp(time.Now())
        fmt.Println(a.Hex(), b.Timestamp())
}
```

### Date&Timestamp

对应类型为 `time.Time`，存进数据库的所有日期都会被转成 UTC。

你也可以使用 `int64` 或者 `string` 来储存时间。

### Undefined,Null

go 不支持这个，全是 0 值

  
