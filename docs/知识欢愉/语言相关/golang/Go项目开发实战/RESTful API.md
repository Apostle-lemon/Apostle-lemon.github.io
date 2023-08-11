# RESTful API

业界常用的 API 风格有三种：REST、RPC、GraphQL。

## RESTful

REST 代表的是表现层状态转移 representational state transfer。以资源 (resource) 为中心，所有的东西都抽象成资源，所有的行为都应该是在资源上的  
CRUD 操作。

### RESTful API 设计原则

#### URI 设计

资源都是使用 URI 标识的。

资源名使用名词而不是动词，并且用名词复数表示。资源分为 Collection 和 Member 两种。
