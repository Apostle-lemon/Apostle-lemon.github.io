# Chap5.1 main_memory

## 为什么 32 位系统有 4G 内存限制

2^32 Byte = 2^22 KB = 2^12 MB = 2^2 GB = 4 GB

## PAE 如何摆脱 4G 内存限制

为什么变成 9 了呢。因为物理地址的大小变大了，所以 page table entry 的大小变成了 8 个字节。这时候，4KB 的 page，4K/8 = 2^9 = 512，因此只需要 9 个 bit 就可以表示在一个 page table 内的 offset。

原先的情况下使用的是 4 个字节，因此一个 page table 可以有 1024 个 entry。
