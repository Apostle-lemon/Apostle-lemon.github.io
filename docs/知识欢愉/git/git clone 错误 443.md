# Git Clone 错误 443

执行 git clone 时，报错

```shell
Failed to connect to github.com port 443: Connection timed out
```

可以通过重设代理解决

```shell
git config --global http.proxy ""
```
