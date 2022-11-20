# Docker

docker 官网  
[Docker: Accelerated, Containerized Application Development](https://www.docker.com/)

docker docs 里边的内容非常全面。

## 安装

### Linux 系统中的安装

安装 docker desktop：
[Install on Linux | Docker Documentation](https://docs.docker.com/desktop/install/linux-install/)

安装 docker engine：
[Docker Engine installation overview | Docker Documentation](https://docs.docker.com/engine/install/)

注意两者是不同的。

## Dockerfile

我们现在给出一个 docker file 的内容，随后逐行对 docker file 进行解释

```dockerfile
FROM golang:1.18 AS builder

ENV GOPROXY=https://goproxy.cn,direct \

    GO111MODULE=on

RUN mkdir -p /tmp/app

WORKDIR /tmp/app

COPY . .

RUN go mod download all && go build -tags netgo -o /projrob

FROM alpine:3.13.1

COPY config.yaml /etc/xlab-project-robot/config.yaml

COPY --from=builder /projrob /projrob

RUN mkdir -p /log

ENTRYPOINT ["/projrob"]
```

FROM：基础镜像  
ENV：设置环境变量  
RUN：构建镜像的时候需要执行的命令。例如这里的 `go mod downlowd all` 就是将依赖下载到本地。`go build -tags netgo -o /projrob`  
COPY：拷贝文件  
ENTRYPOINT：指定镜像的默认入口命令，该入口命令会在启动容器时作为根命令执行，所有其他传入值作为该命令的参数

关于 golang 的 docker file 还可以看下面一篇博客  
[go项目dockerfile最佳实践 - 宝树呐 - 博客园 (cnblogs.com)](https://www.cnblogs.com/baoshu/p/13399780.html)  
我们之所以需要 alpine，是因为 golang 包太大了。某些第三方库需要 CGO，因此我们选择了 alpine 镜像。

需要注意的是 CGO 就是代表存在 libc 及一些库，但是动态链接库可能存在 CGO 并不能提供的情况，这种情况我们需要手动增加这个库。

## 存在 Dockerfile 后，如何运行

采用 `docker build -t <name> <path>` 可以创建镜像

采用 `docker run -d <IMGname>` 可以启动容器 -d 表示容器在后台运行。

![](https://lemonapostlepicgo.oss-cn-hangzhou.aliyuncs.com/img/202211131752661.png)

删除容器

```sh
docker rm < container ID >
```

删除镜像

```sh
docker rmi < image ID >
```

查看所有容器

```sh
docker ps -a
```

查看所有镜像

```sh
docker images
```

进入后台运行的容器的命令行：

```sh
docker exec -it  <containerName> /bin/bash
```

## Docker Compose

如果我们每次都需要在 docker run 的时候输入端口映射，-it /bin/sh 之类的信息，倒不是累人，但是挺烦人的。
