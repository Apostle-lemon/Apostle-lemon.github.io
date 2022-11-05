# Mongodb

## 概述

Mongodb 是一种使用广泛的非关系型数据库。只需键值对，不需要设置相同的字段，相同的字段也不需要相同的数据类型，操作简单。

官方教程友好且全面 <https://www.mongodb.com/docs/v6.0/>

## 安装

### Windows 平台

<https://www.mongodb.com/docs/v6.0/tutorial/install-mongodb-on-windows/>

【注】mongo.exe 在 mongodb 6.0 之后不再随之安装。可以采用 mongodb shell, 这需要单独下载安装，之后的命令可以采用 mongosh 替代原来的 mongo 命令

### Linux 平台

<https://www.mongodb.com/docs/manual/administration/install-on-linux/>  
【注】config 默认存放路径 /etc/mongod.conf, 查看默认配置文件，即可发现  
默认 dbpath 路径 `/var/lib/mongodb`  
默认 log 文件路径 `/var/log/mongodb/mongod.log`

  

## 连接

<https://www.mongodb.com/docs/drivers/go/current/fundamentals/connection/>

mongoDB 的连接 url 格式如下所示

```Go
mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
```

这里的 host 可以有多个，以便于分布式存储。port 的默认值为 27017。

  

### 类型和绑定

之前以及提到过，MongoDB 可以通过 bson 非常方便地接轨各类语言。在 go 中，这主要就是使用 mongo-driver 的 `bson` 和 `options` 两个模块。

#### Bson

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

其中，`bson.D` 是有序表示的键值对，`bson.E` 就是其中的一对键值对，**`bson.D`****是支持 append 方法的**。`bson.M` 是无序的键值对，`bson.A` 就是 list。

除了用这些类型表示 bson 文档，还可以用 bson tag 将结构体绑定成 bson 格式，可以使用 `omitempty，-` 等参数，和 json tag 差不太多。不绑定的话默认是以 lowercase 当作字段名，并且参数的 **首字母必须大写** 才能被绑定。

因为 mongo 是 nosql，随便什么类型都可以往里面塞，但是如果类型不固定就只能用 interface 接。

```Go
type myStruct struct {
    Name         string                 `bson:"name,omitempty"`
    TestName     interface{}            `bson:"test_name"`
}
```

#### 一些特殊类型在 Go 中使用

##### ObjectID

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

##### Date&Timestamp

对应类型为 `time.Time`，存进数据库的所有日期都会被转成 UTC。

你也可以使用 `int64` 或者 `string` 来储存时间。

##### Undefined,Null

go 不支持这个，全是 0 值

  

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

### CRUD

CRUD 的相关文档可以在这儿看 <https://www.mongodb.com/docs/v6.0/crud/>

- insert
    

```Go
db.collection.insertOne(
   <document>,
   {
      writeConcern: <document>
   }
)
```

如果需要向集合中插入多个文档，语法格式如下

```Go
db.collection.insertMany(
   [ <document 1> , <document 2>, ... ],
   {
      writeConcern: <document>,
      ordered: <boolean>
   }
)
```

这里的插入是顺序插入，即第一个失败后，后面的插入都不会再执行。

documen 表示要写入的文档

writeConcern 写入策略，默认为 1，代表确认写操作

ordered 是否顺序写入

  

- update
    

```Go
db.collection.updateOne(
   <filter>,
   <update>,
   {
     upsert: <boolean>,
     collation: <document>,
     writeConcern: <document>,
     arrayFilters: [ <filterdocument1>, ... ],
     hint:  <document|string>       
   }
)
```

  

- delete
    

deleteOne

```Go
db.collection.deleteOne(
   <filter>,
   {
      writeConcern: <document>,
      collation: <document>,
      hint: <document|string> 
   }
)
```

deleteMany

```Go
db.collection.deleteMany(
   <filter>,
   {
      writeConcern: <document>,
      collation: <document>
   }
)
```

  

- Find
    

findOne

```Go
db.coll.findOne(query, projection)
```

find

```Go
db.collection.find(query, projection)
```

  

### Operator

#### $expr

大于 $gt，小于 $lt，大于等于 $gte，小于等于 $lte，等于 $eq

#### $in

表明字段值必须为列表中的任意一个值

```Go
{ field: { $in: [<value1>, <value2>, ... <valueN> ] } }
```

#### $elemMatch

```Go
{ arrayfield: { $elemMatch: { $gte: 80, $lt: 85 } } }
```

- sort
    

采用 sort 方法可以将获得到的数据进行排序，其中 1 代表升序排列，-1 则代表降序排列

```Go
db.COLLECTION_NAME.find().sort({KEY:1})
```

- 索引 index
    

createIndex

```Go
db.collection.createIndex(
  {
      key1: 1,        
      key2: 1        
  },
  {
      unique: true,                
      sparse: true,                
  }
)
```

dropIndex

```Go
db.collection.dropIndex(indexname)
```

getIndexes

```Go
db.collection.getIndexes()
```

  

### Aggregation

聚合 (aggregate) 主要用于处理数据 (诸如统计平均值，求和等)，并返回计算后的数据结果。

```Go
db.coll.aggregate(pipeline, options)
```

其中，pipeline 是一系列操作，聚合将文档依次进行一定操作然后返回（返回的是文档指针）。

示例

```Go
db.coll.insertMany([
    {_id:1,name:"qwq",num:1},
    {_id:2,name:"qwq",num:3},
    {_id:3,name:"qaq",num:2},
    {_id:4,name:"www",num:5},
])
db.coll.aggregate([
    {$match:{name:"qwq"}},
    {$set:{num:0}},
    {$project:{_id:0}}
])
/* result
{name:"qwq",num:0}
{name:"qwq",num:0}
*/
```

  

#### $project

可以用来重命名，删除，移动域。

```Go
db.article.aggregate(
    { $project : {
        _id : 0 ,
        title : 1 ,
        author : 1
    }});
```

在这种情况下我们舍弃了 \_id 字段

#### $unwind

将文档中的某一个数组类型字段拆分成多条，每条包含数组中的一个值。

```Go
db.coll.insertOne(
    { "_id" : 1, "item" : "ABC1", sizes: [ "S", "M", "L"] }
)
db.coll.aggregate( [ { $unwind : "$sizes" } ] )
/* result
{ "_id" : 1, "item" : "ABC1", "sizes" : "S" }
{ "_id" : 1, "item" : "ABC1", "sizes" : "M" }
{ "_id" : 1, "item" : "ABC1", "sizes" : "L" }
*/
```

#### $group

```Go
{$group: {
    _id: <identifier>,
    <field>: <accumulator:value>
    ...
}}
```

其中，`_id` 是分组条件，其可以是原来文档的字段，也可以是包含原文档属性的 operator 表达式。

#### $replaceRoot

一个更加彻底的改变文档结构的方法。

```Go
db.coll.insertOne(
    { _id : 1, sizes: [ {name:"qwq"}, {name:"qaq"}]}
)
db.coll.aggregate( [ 
    { $unwind : "$sizes" },
    { $replaceRoot: {newRoot:"$sizes"}}
] )
/* result
{ name: 'qwq' }
{ name: 'qaq' }
*/
```

当然还有很多的 aggregation

<https://www.mongodb.com/docs/v6.0/meta/aggregation-quick-reference/>

  

实习相关文档：[MongoDB](https://xn4zlkzg4p.feishu.cn/wiki/wikcnmbaUrMmraQp0uiILVXodRd)
