# Mongodb

## 概述

Mongodb 是一种使用广泛的非关系型数据库。只需键值对，不需要设置相同的字段，相同的字段也不需要相同的数据类型，操作简单。

mongodb 提供多种语言的官方驱动，在这篇文章中以 go 作为案例。

## 安装

### Windows 平台

- 预编译二进制包下载地址[Download MongoDB Community Server | MongoDB](https://www.mongodb.com/try/download/community)
【注】mongo.exe 在 mongodb 6.0 之后不再随之安装。可以采用 mongodb shell, 这需要单独下载安装，之后的命令可以采用 mongosh 替代原来的 mongo 命令

## 连接

mongoDB 的连接 url 格式如下所示

```
mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
```

这里的 host 可以有多个，以便于分布式存储。port 的默认值为 27017。

## 基础语法

- 创建数据库/切换数据库

```
use DATABASE_NAME
```

- 查看所有数据库

```
show dbs
```

注意在我们 use 了之后，用 `show dbs` 不能看见数据库列表中有对应数据库。需要我们在新建数据库中插入数据才可以显示。

- 删除数据库

```
db.dropDatabase()
```

- 删除集合

```
db.collection.drop()
```

- 创建集合

```
db.createCollection(name, options)
```

当我们向未创建的集合中插入文档的时候，其会自动创建。
