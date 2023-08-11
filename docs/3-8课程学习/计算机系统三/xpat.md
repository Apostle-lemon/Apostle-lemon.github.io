# Xpat

mem_valid 会检查当前是否是mem的读写信号. 如果是的话, 那么就输出为 1, 如果不是的话, 那么就输出为 0.

## 1 Work List

① 修改 ram，使其默认是 64 位的地址。 √  
② 增加 addw 指令

## 2 实录

### 仿真时有些地方会出现红色

正常，原先在 RAM 中是直接 assign 输出，现在的话则是在 posdge 才会对输出进行赋值。而且在 ram 中 posedge 正好是 scpu 中的 negdge，因此我们可以看到一个时钟周期的前半部分是错误的，后半部分则是恢复正常的情况。

### 开始增加指令

- addw 指令

原先的 ADD 指令是这样的

![](img/a3f191f52f58b08ae034d4480934252e_MD5.png)

而 ADDW 指令是这样的

![](img/5d53609a0d202346468d446030e49d3f_MD5.png)

我们可以看到对应的 opcode 都是不一样的，因此我们需要在 control 模块中添加这一部分的控制信号。

这里的 func （inst14~12）是000。

在原先的 riscv32 中，我们是这样定义运算的符号的。

![](img/36e9c69b5848afa2173485d533ae4bfc_MD5.png)

而在我们的 ALU 中，会对 ALUOP 进行判断，因此我们可以设置一种新的符号，鉴于我们总共需要添加 addw, addiw, slliw, srli 4种指令，因此我们可以简单设置为 1000。后面的 000 正好与 func3 相一致。

![](img/29f5d24cda93d43795f3f5fcb40ed651_MD5.png)

- ADDIW

![](img/86528bfc957e0bc360774e9228b1c472_MD5.png)

可以看到 opcode 是 0011011，这个在 control 中一样是找不到的。同时这里的 fun3 也一样是 000，因此我们同样可以将其 alu_op 设置为 1000。

同时我们这里需要增加 immediate_gen 模块的功能。

- SLLIW

![](img/34720971bdc0f93d8e2f532991de64a5_MD5.png)

OPCODE 是 0011011，但是 func3 变成了 001。

这里有些难以判断，因此我们偷懒，在 ALU 里边进行判断……

当然，对应的控制信号还是要去设置的

- srli

![](img/d48affb29e7c7115c9d647cd496aa031_MD5.png)

这个和 ADDI 的 opcode 是一样的，但是产生的 alu_op 会有所不同。

在这种情况下，我们会产生 0101 这样的 alu_op，但是我们在 0110011 这样的情况下的 srl 也会产生 0101 这样的这样的 alu_op。

我们为了兼容，解决办法是，ex 内部执行一遍后，对这种情况进行一个特殊判断，然后将 result 修改为对应的值。

【笑死】发现了之前 sra 的判断是不正确的，因此进行修改先。

因此我们在 control 内修改最终写到 reg 的 source 来自哪这个控制信号。

- bge

首先我们需要看看原来我们是怎么实现分支的。

我们有两个 pc_branch_mux。

第一个 mux 的作用是：如果当前 mem 阶段是一个 branch_jump 指令，那么就根据 sel 信号，从 pcbranchmuxin_mem_pc_addr0（也即 branch_jump 的下一条指令） 和 pcbranchmuxin_pc_addr1 （也即要跳转的指令） 中选择一条。如果当前 mem 阶段不是一个 branch_jump 指令，那么就将 pc+4 生成为 pc_new

![](img/b6beeff76435a87a29d8a4ffb15147ba_MD5.png)

第二个 mux 的作用是：选择从 pc_new 还是从 pc_addr1 中进行选择。  
为什么会产生这个区别呢？我觉得就是设计的时候脑子少了根筋。

但是我们的 jal 这样的 j-type 和 b-type 产生 target addr 的逻辑是不同的呀，是怎么通过一个 addr1 得到的呢？

我们可以看到这个 target addr 来自于 ex_add_result。我们的确可以看到我们是在 ex_add 模块内对指令进行了特殊判断。

【但是我们现在的地址还没修改，不应该是32 位的么，有 warning 么】并没有，在模块内部将 64 位赋值给 32 位并不会触发 warning。

![](img/3b2c82b277c6d72feb4af4095c630218_MD5.png)

这样一来，我们的思路就很清晰了，我们只需要增加 branch 控制信号模块的内容就可以了。

然后我们打开了 pc_src1_gen 这个模块，发现我们在上学期就做过了这里要求的指令。

![](img/efa59a45aef2a4e9aa817f462f776260_MD5.png)

### 开始修改特权态代码

本次实验需要将原来M态的寄存器（mtvec, mepc, mstatus），改为S态的寄存器（stvec, sepc, sstatus）。

我们可以看到，我们只需要修改 source/dest 部分的描述即可，这部分描述放在 csr_name 之中。

![](img/27218c594ba7d90dbc5a70c5e8b25630_MD5.png)

同时我们可以通过上次的 kernel 的 dump 文件得出，此刻 opcode即SYSTEM 是 1110011。

![](img/649a1d69974d69a619c2649c54d9face_MD5.png)

我们为了使得上次的程序仍然能跑，因此 m 态的寄存器并没有删除，我们在此基础上增加了 s 态的寄存器。

![](img/8174e5ba6c76c6c6888f4a9ceb48c7f8_MD5.png)

emmm，我们还是来分析一下吧

我们已经有的 M 态寄存器

- mtvec

这里保存了 m 态的中断向量表基地址

- mepc

保存了触发了 m 态异常的地址

- mstatus

在 mstatus 中，存放了 status

- mcause

记录了 m 态异常发生的原因

我们现在需要加的：  
stvec = 0x105  
sepc = 0x141  
sstatus = 0x100  
scause = 0x142  
satp = 0x180

![](img/a0b828c73d46878fa2e969576f6d9d6c_MD5.png)

我们首先在头文件和 csr_unit 中执行，然后放几个这几个 csr 寄存器的总线 bus。

在读 csr_unit 模块之前自己完成的代码时，产生了疑问，不过之后又没有了。

![](img/a08ef2bb5d240fbbcf1e0ad80c680cc4_MD5.png)

然后控制流的转换，我们重新去写。

## 引脚约束文件的学习

PACKAGE_PIN 物理引脚  
-dict 设置多个内容  
IOSTANDARD 电气标准  
get_ports 获得文件中的内容
