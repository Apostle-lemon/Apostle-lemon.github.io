# Chap9.1_file_system_imple

Layered File System: Device drivers manage I/O devices at the I/O control layer; Basic file system given command like “retrieve block 123” translates to device driver; File organization module understands files, logical address, and physical blocks, manages free space, disk allocation; Logical file system manages metadata information.

File-system needs to maintain on-disk and in-memory structures. On-disk structure has several control blocks, boot control block, volume control block contain metadata of filesystem, directory structure A list of {file names and associated inode numbers}, per-file file control block contains many details inode fcb about the file per file.

In-Memory File System Structures. In-memory structures reflects and extends on-disk structures, system-wide open-file table contain inode, per-process open-file table fd->system-wide entry, Mount table, I/O Memory Buffers.

Mounting File Systems, Boot Block. Superblock contain file system metadata.

Virtual File Systems.

Directory Implementation. Linear list of file names, Hash table.

Disk Block Allocation. 一个文件中的 datablock 是如何分配的。Contiguous Allocation, extent-based contiguous allocation（一部分连续）, Linked Allocation, Indexed Allocation, each file has its own index blocks of pointers to its data blocks, 存放一个 index block.

Indexed Allocation: multiple-level index blocks. 一个 index block 存在 direct blocks, single indirect 和 double indirect. 最大文件大小 = 12xD+D/SIZExD（一级索引）+ …

Free-Space Management. Bitmap. Linked Free Space.

这里的 read 其实两层含义都存在，一个是将 incode 加载到 system wide openfile table，另一个是读取 inode 的内容。
