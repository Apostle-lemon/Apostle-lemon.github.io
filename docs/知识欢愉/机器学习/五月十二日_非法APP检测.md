# 五月十二日_非法APP检测

ODU HAO SHUAI老师

# 违法安卓APP检测

## 背景

移动 APP 成为违法活动的温床。安卓系统用户基数大；安卓APP聚合性高，转移难度低，查封难度高。

监管难点：1、传播渠道多，开发成本低 2、缺乏有效的技术检测手段。以往工作对恶意APP研究性强，但是违法APP往往不具有恶意 payload。 3、流动性强、打击难以落地

通常形式是加害者以短信等方式，让受害者下载私自研发的 APP。

课题主要研究的是黄，赌，诈骗

## 研究思路

### 构建早起线索发现系统：基于大规模 URL

### 基于多模态的数据构建 APP 分类器

### 探究基于签名的扩线方案

找到一个家族

![](https://apostle-lemon-1304725406.cos.ap-beijing.myqcloud.com/202305122212927.png)

## 研究现状

安卓恶意 APP 相关研究多，通过了各种 feature 可以检测出是否恶意。

相对而言，违法 APP 研究比较少

![](https://apostle-lemon-1304725406.cos.ap-beijing.myqcloud.com/202305122214206.png)

SP 上有一篇，复旦的论文，与上海公安有关。

## 该是什么小标题呢

安卓应用由许多 UI 组成，其服务以特定顺序通过多个 UI 呈现给用户，构成了 UI 转换图。相同类型的 APP 具有类似的 UI 转换图。但存在问题：① 相同不同。② 没有用到 APP 的其他差异性数据，例如图片，文本等。

合法 APP 样本的收集。通过常见的 APP 平台可以进行下载。  
违法 APP 样本的收集。主要是中国移动提供的数据，此外还有广告网页、论坛和私建分发平台，投诉平台潜在信息等等。

![](https://apostle-lemon-1304725406.cos.ap-beijing.myqcloud.com/202305122223513.png)

下面是一点违法样本的记录

![](https://apostle-lemon-1304725406.cos.ap-beijing.myqcloud.com/202305122226351.png)

groundTruth 应该是什么呢。

APP 下载地址，可以通过查询域名可以获得 IP。

### 分析思路

清单文件，代码，资源文件。

### 特征提取与分析

#### 权限相关的信息

各类 APP 声明全线统计数据。但是合规和非法难以区分。

组件功能  
设备兼容性  
签名

#### 代码

关于应用重打包的分析中涉及代码的相似性检测

关于恶意应用的分析中涉及代码的静态分析及动态分析。

#### 资源文件

icron 包含应用程序图标、布局文件及文本信息等。  
对于图标可以进行图片像素的颜色值分布，获取文字中图片，获取是否含有网址信息。

image 具有分类效果

#### APP 整体

整体文件的 HASH 值。如果两个相似的资源或者相似的模板，那么 APP 的 TLSH 值时基本相同的。

聚类和准确率存在关系。更能忍受假阴性还是假阳性。通过聚类可以实现家族、类的效果。

#### 动态分析

利用动态分析工具如 DroidBot、MobSF 等可以对 APP 进行分析

## 构建分类模型

基于图标的分类模型，转换为 48 维特征值，转换为颜色像素在全像素中占比，各通道分开统计，最终拼接。

预处理及拼接，训练了一个 CNN 模型

UI 转换图，构建 GAE 模型。思路是将一个 UI 具有的图片，文本，网络请求等。

多模态整合，继承学习。对多个模型得到的结果向量进行拼接，并作为新模型的输入。例如 boosting。

预处理：转换为皮

## 扩线可能性 - APP 签名

签名相当于开发者的唯一身份象征。

图片获取与处理相关

根据 VirusTotal 的返回结果，apk 中存在大量的图片资源。图标复用较为常见，

### 后续研究思路

研究非法APP在telegram上推广方式和推广话术

对比两年前后非法 APP 的特征分布的区别，研究非法 APP 的演变

案件描述中的统计概率和话术特征

推广至 IOS 的研究

## 郝老师的指导

Q：哪些 feature 最 significant，能起到决定性效果 ？  
A：APP 名称和包名效果明显。证书，证书主体，证书签名的作用较小。

Q：包名什么样的特征最为明显，feature 是哪些呢 ？  
A：用的是机器学习模型，解释性上不是很好。通过肉眼观察的话，非法应用的包名通常是无序信息，数字的频率比较高，长度也会比较高。  
Q：理解了，这个和解析 domain name 是很像的。

Q：转换为拼音会舍弃一些语义信息  
A：确实有可能，但是还有什么更好的方法呢

Q：hash 值的方法靠谱么  
A：在我们目前的数据集下，一旦被聚类，就可以被认为是正确的。  
Q：生成的 hash 会变化，dynamic 的 cf, resource 都可以进行一个 hash。将这些东西拼接成字符串，不同行为下会有 hash。动态分析是否也能获得好的结果。  
A：有道理。动态执行 API 序列等，也可以获得 HASH 值，也可以用来比较 APP 的相似性。

Q：  
A：我们的工作是动态分析，周亚金组做的是静态分析。如果不做污点分析，那么就无法确定在哪。  
Q：动态分析是静态分析的子集？  
A：不是，因为可能会存在网络信息。并且我们通过动态分析可以知道是在哪个地方用到了这个图片。

Q：有没有研究过 APP 在短信渠道的流通？  
A：可以研究下多少是通过短信 distribute。  
Q：但是好像也说不出什么比较。
