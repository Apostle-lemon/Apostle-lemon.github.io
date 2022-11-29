# Scrapy

scrapy 是一套爬虫的框架，我们需要做基本只有两大步：从 response 里提取数据和后续 url，处理数据。

![](https://lemonapostlepicgo.oss-cn-hangzhou.aliyuncs.com/img/202211291220917.png)

## 安装

略过

## 基本使用步骤

新建立一个 scrapy 项目

```shell
scrapy startproject <your_project_name>
```

生成一个爬虫

```
scrapy genspider <your_crawl_name> <crawl_url>
```

运行爬虫

```
scrapy crawl <your_crawl_name>
```

注意在 scrapy 中 Spider 爬虫的概念为：处理所有 Responses,从中分析提取数据，获取 Item 字段需要的数据，并将需要跟进的 URL 提交给引擎，再次进入 Scheduler(调度器).

## item.py

item.py 是想要爬取到的内容。可以通过创建一个 scrapy.Item 类，并且定义类型为 scrapy.Field 的类属性来定义一个 Item（可以理解成类似于 ORM 的映射关系）。这里在括号内写入 scrapy.Item，代表 LemonItem 继承自 scrapy.Item。

```python
import scrapy

class LemonItem(scrapy.Item):
   name = scrapy.Field()
   title = scrapy.Field()
   info = scrapy.Field()
```

## pipelines.py

pipelines.py 是持久化存储 item。

## spiders/LemonSpider.py

我们在命令行通过 `scrapy genspider <spider_name> <spider_url>` 即可创建一个爬取目标 url 的爬虫。我们可以在 spiders 文件下找到对应的爬虫。当然我们也可以手动新建这么一个文件。

```python
import scrapy  

class LemonspiderSpider(scrapy.Spider):
    name = 'LemonSpider'
    allowed_domains = ['www.lemon.com']
    start_urls = ['http://www.lemon.com/']

    def parse(self, response):
        pass
```

parse 方法会在得到 response 后进行执行。我们可以直接看 response.body 来看返回了什么内容。

可以通过 `scrapy crawl <your_spider_name>` 进行爬虫的执行。parse 当中可以由 Item 组成一个数组，最后 return 这个 ItemList。当然最开始需要 `from <your_project_name>.items import <your_item_name>`
