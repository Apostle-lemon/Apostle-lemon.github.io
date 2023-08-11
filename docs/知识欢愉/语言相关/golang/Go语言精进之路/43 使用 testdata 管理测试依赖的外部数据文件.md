# 43 使用 Testdata 管理测试依赖的外部数据文件

## Testdata 目录

Go 工具链将忽略名为 testdata 的目录。而 `go test` 命令在执行时会将被测试代码所在的目录作为其工作目录，这在 os.Open 等函数中展现出了优越性。

我们可以将执行的结果 want 与我们从文件中读入的结果 expect 进行比较，从而检查被测试代码是否正确实现了预期功能。

## Golden 文件惯用法

所谓的 golden 文件，就是代表了我们的预期结果。golded 文件通常会使用 .golden 作为拓展名，表明其使用了 golden 文件惯用法。

会采用命令行参数的方式传入我们是否需要更新 .golden files，例如，我们会在文件的第一行中，输入 `var update = flag.Bool("update", false, "update .golden files")`, 这样在 go test 命令时如果传入了 -update 参数，那么就可以更新我的 golden file。

注意 golden file 的行尾可能会因为操作系统的不同而有 LF 和 CRLF 两种可能。
