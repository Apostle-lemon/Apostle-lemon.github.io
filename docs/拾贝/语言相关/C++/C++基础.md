# C++ 基础

## size_t

这是一个与机器相关的无符号整数类型。

## uint32_t

表示 32 位无符号整数

## 右值引用

<http://thbecker.net/articles/rvalue_references/section_08.html>

右值引用主要有两个场景  
① std::move() 转换为右值，是为了配合 移动构造函数 而出现的。这样可以由 拷贝构造函数 变为 移动构造函数。防止了临时对象的二次拷贝。
② 原先的 `foo(T& A)` 并不能传入右值，如传入 foo(3) 则会发生错误。
采用模板中采用 `foo(T&& A)` 则可以既能传入左值，又可以传入右值。
![](img/8a6b25365c6572ca3b4f1cdd2003ad04_MD5.png)

## 遍历 Map

![](img/acd93360eb1eb4307d22367bde07cc77_MD5.png)

```C++
void NetworkInterface::cleanUnvalidCache() {
    for (auto it = _arp_cache.begin(); it != _arp_cache.end();) {
        if (it->second.ttl < _timer) {
            it = _arp_cache.erase(it);
        } else {
            it++;
        }
    }
}
```

或者采用这样的方式

## 左移不能移动 32 位

## CMakeLists

`if(TARGET target-name) `  
判断 target-name 是否存在。target-name 主要是通过 add_executable(), add_library(), or add_custom_target() 这 3 个命令执行输出的目标。

target_link_libraries

### 添加头文件目录 INCLUDE_DIRECTORIES

### 添加需要链接的库文件目录 LINK_DIRECTORIES

### 添加需要链接的库文件路径 LINK_LIBRARIES

### 查找库所在目录 FIND_LIBRARY

### 设置要链接的库文件的名称 TARGET_LINK_LIBRARIES

## Windows 当中如何 Make

cmake -G "MinGW Makefiles" .  
mingw32-make

## 编译器

GCC 是 GNU 编译器集合，GNU Compiler Collection  
gcc 是 GCC 中的 GUN C Compiler（C 编译器）
g++ 是 GCC 中的 GUN C++ Compiler（C++ 编译器）
MinGW，Minimalist GNU for Windows

## Linux 如何编译

用 `g++ 文件名` 就好了

如果存在头文件，是需要这样编译链接  
![](img/275b4e1036b07a9791e20efd5d4ab4c1_MD5.png)

**库** 放在 /lib 和 /usr/lib 和 /usr/local/lib 里的库可直接用 -l 参数就能链接了。但如果库文件没放在这三个目录里，而是放在其他目录里，这时我们只用 -l 参数的话，链接还是会出错，出错信息大概是：“/usr/bin/ld:cannot find -lxxx”，也就是链接程序 ld 在那 3 个目录里找不到 libxxx.so，这时另外一个参数 -L 就派上用场了，比如常用的 X11 的库，它放在/usr/X11R6/lib 目录下，我们编译时就要用 -L/usr/X11R6/lib -lX11 参数，-L 参数跟着的是库文件所在的目录名。再比如我们把 libtest.so 放在/aaa/bbb/ccc 目录下，那链接参数就是 -L/aaa/bbb/ccc -ltest。

**头文件** -I 参数是用来指定头文件目录，/usr/include 目录一般是不用指定的，gcc 知道去那里找，但是如果头文件不在 /usr/include 里我们就要用 -I 参数指定了，比如头文件放在 /myinclude 目录里，那编译命令行就要加上 -I/myinclude 参数了，如果不加你会得到一个 "xxxx.h: No such file or directory" 的错误。-I 参数可以用相对路径，比如头文件在当前目录，可以用 -I.来指定。

## 头文件与库文件的区别

头文件一般而言，是申明和定义。

库文件是已经编译好的二进制代码。这个二进制代码可以是动态的，如 .so；也可以是静态的，如 .a。如果是动态的，则最后生成的程序文件在运行时，需要这个动态库的支持；如果是静态的，则最后生成的可执行程序文件运行时可以脱离这个库文件而独立运行。

## 如何关闭 -Werror=effc++ 报错

找到对应的 cmake 文件下面的 -Werror，删掉即可  
![](img/1aa65f818fa653b723e64452a9612162_MD5.png)

Werror : 它要求 GCC 将所有的警告当成错误进行处理

		经常我们在工程中，会使用别人的既有代码。假设我们使用了一个人的代码A目录，里面有一个-Werror的选项，把所有的警告当做错误；又使用了另一个人的代码B目录，里面存在一堆Warning。这样，当我们把它们合在一起编译的时候，A中的-Werror选项会导致B的代码编译不过。但我们又不想去修改B的代码，怎么办?
		方法是，先add_subdirectory(A)，之后，加上一句 
		set(CMAK_CXX_FLAGS "${CMAK_CXX_FLAGS} -Wno-error")  
		-Wno-这个前缀，就是用来取消一个编译选项的  
		然后，再add_subdirectory(B)_

## 如何使用 Spdlog

方法一：通过包管理器下载使用

方法二：通过将 include 文件夹下边的内容放置到 include 目录，在 Cmakelist 里边添加 类似于 `include_directories ("${PROJECT_SOURCE_DIR}")` 的话语。

    spdlog::set_level(spdlog::level::err);  
    spdlog::info("Welcome to spdlog!");

![](img/e8e114b01ea86e1f54e809d6b5c0d2e7_MD5.png)
