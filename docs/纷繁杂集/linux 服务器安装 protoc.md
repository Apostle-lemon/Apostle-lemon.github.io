# Linux 服务器安装 Protoc

```bash
# 第一步：安装 protobuf
$ cd /tmp/
$ git clone -b v3.21.1 --depth=1 https://github.com/protocolbuffers/protobuf
$ cd protobuf
$ ./autogen.sh
$ ./configure
$ make
$ sudo make install
$ protoc --version # 查看 protoc 版本，成功输出版本号，说明安装成功
libprotoc 3.21.1

# 第二步：安装 protoc-gen-go
$ go install github.com/golang/protobuf/protoc-gen-go@v1.5.2
```

安装的时候出现了如下错误

``` bash
configure.ac:109: error: possibly undefined macro: AC_PROG_LIBTOOL
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.
```

在安装了 libtool 之后，问题成功解决

```bash
sudo apt-get install libtool
```
