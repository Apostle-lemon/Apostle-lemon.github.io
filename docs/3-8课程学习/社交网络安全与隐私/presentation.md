# Presentation

2.2 我们在爬取过程中遇到的苦难

4.2 公开 ip camera 站点

6.1 对爬取可以改进的地方

Project 7 Finding vulnerable webcams across the globe

collect as many as possible

<http://insecam.org>

我们发现我们访问的网站的格式是

<http://insecam.org/cn/view/1005794/> 这样的，

改变这里的 1005794 数据就可以了

但是我们发现我们不能乱填，因为可能会访问到 Page not found

另外一个原因是即便不是 Page not found，它给了你所有的信息，但是唯独最重要的信息：摄像头拍摄得到的视频内容没有了。【这里或许我们可以比较与正常的差异，得出一些结论】

![](img/cafe19d56a79214a2c54df155be67cff_MD5.png)

对于不同国家，它的界面是这样的。

<http://insecam.org/cn/bycountry/CN/>

会在每一个 column 下边含有一个 href。

![](img/b9e075d649cda829c62c755a64e1aa79_MD5.png)

翻到第二页了之后，会是这样的 <http://insecam.org/cn/bycountry/CN/?page=2>

于是我们尝试将 2 改成 1，发现依然是可行的

OK 理论可行，我们开始添加代码

我们用以下三个 xpath

/html/body/div[5]/div[2]  
/html/body/div[5]  
/html/body/div[4]  
/html/body/div[5]/div[2]

做爬虫的主要问题