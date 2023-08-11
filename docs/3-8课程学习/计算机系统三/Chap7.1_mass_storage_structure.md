# Chap7.1_mass_storage_structure

Disk Structure track 轨道 sectors 最小单元 cylinder 层，盘片

Positioning time is time to move disk arm to desired sector, positioning time includes seek time and rotational latency

Average access time = average seek time + average latency. Average I/O time: average access time + (data to transfer / transfer rate) + controller overhead.

Disk Scheduling chooses which pending disk request to service next. 使得磁头移动的距离最短。FCFS: First-come first-served. SSTF: shortest seek time first. SCAN: SCAN algorithm sometimes is called the elevator algorithm, 沿着一个方向开始运动. Circular-SCAN is designed to provides a more uniform wait time，到头后马上回到原点。LOOK/C-LOOK, 磁头不会到最远处, 而是目前最远。

RAID – redundant array of inexpensive disks. RAID can only detect/recover from disk failures, it does not prevent or detect data corruption or other errors. File systems like Solaris ZFS add additional checks to detect errors.
