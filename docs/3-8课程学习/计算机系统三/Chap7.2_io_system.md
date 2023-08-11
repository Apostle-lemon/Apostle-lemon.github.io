# Chap7.2_io_system

Some CPU architecture has dedicated I/O instructions. memory-mapped I/O.

Synchronous I/O includes blocking and non-blocking I/O. blocking I/O: process suspended until I/O completed, non-blocking I/O: I/O calls return as much data as available. Asynchronous I/O: process runs while I/O executes, I/O subsystem signals process when I/O completed via signal or callback - data is already in the buffer, no need to use read() to get the data.

 
