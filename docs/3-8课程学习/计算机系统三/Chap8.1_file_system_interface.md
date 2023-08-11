# Chap8.1 File_System_Interface

Per-process table: current location pointer, access rights  
System-wide table: location on the disk

Information with Open Files: file position: pointer to last read/write location. 因此 file position 是 per-process 的; file open count, disk location, access rights 访问模式 per-process.  

Two types of lock: Shared lock; Exclusive lock. Two locking mechanisms: mandatory lock 强制的; advisory lock 非强制的.

flock 上锁信息保存在 fd 相关数据结构。子进程的 fd 也是拷贝的父进程。因此子进程也持有同样的一把锁。

File Structure: no structure, simple record structure, complex structures. Access Methods: Sequential access, Direct access.

Directory Structure: Directory is a collection of nodes containing information about all files.

Disk can be subdivided into partitions分区, a partition containing file system is known as a volume卷.

Single-Level Directory, Two-Level Directory each user has his own user file directory (UFD).

Hardlink: 直接映射到底层的 inode。Softlink: 有自己的 inode，但 inode 中的 data block 会说自己是个链接文件，真正的路径是在 xxx/xxx，软链接可以跨文件系统。

mount table 有挂载表信息。

Three modes of access: read, write, execute. Three classes of users: owner, group, and others. 目录必须有 e 权限才能进入。ACL: Assign each file and directory with an access control list.
