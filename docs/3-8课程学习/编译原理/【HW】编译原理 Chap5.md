# 编译原理 Hw5

![](img/0b8557b50a1f24d1c4bdf3950815d52a_MD5.png)

![](img/5b375e910a2e1635baa2d40e631ad2c3_MD5.png)

改进散列表实现。

a．当散列链的平均长度大于 2 时，将散列数组增大一倍（因此, 现在 table 是指向动 态分配的数组的指针）。为了将数组增大一倍，在分配一个更大的数组时，要重新散列原数组中的内容，然后再释放原数组。

```c++
struct bucket {
    string key;
    void *binding;
    struct bucket *next;
};

#define SIZE 109

struct bucket *table[SIZE];
int count = 0;

unsigned int hash(char *s0) {
    unsigned int h = 0;
    char *s;
    for (s = s0; *s; s++) {
        h = h * 65599 + *s;
    }
    return h;
}

struct bucket *Bucket(std::string key, void *binding, struct bucket *next) {
    struct bucket *b = (struct bucket*) malloc(sizeof(struct bucket));
    b->key = key;
    b->binding = binding;
    b->next = next;
    return b;
}

void insert(std::string key, void *binding) {
    if ((double) count / SIZE > 2) {
        int oldSize = SIZE;
        SIZE *= 2;
        struct bucket **oldTable = table; 
        struct bucket *newTable[SIZE] = {NULL};
        table = newTable;
        count = 0;
		std::vector<struct bucket*> buckets;
        for (int i = 0; i < oldSize; i++) {
            struct bucket *b = oldTable[i];
            while (b != NULL) {
                buckets.push_back(b);
                b = b->next;
            }
        }
        for (int i = 0; i < buckets.size(); i++) {
            int index = hash(buckets[i]->key) % SIZE;
			table[index] = Bucket(buckets[i]->key,buckets[i]->binding, table[index]);
            count++;
        }
        free(oldTable);
    }
    int index = hash(key) % SIZE;
    table[index] = Bucket(key, binding, table[index]);
    count++;
}

void *lookup(string key) {
    int index = hash(key) % SIZE;
    struct bucket *b;
    for (b = table[index]; b; b = b->next) {
        if (0 == strcmp(b->key, key) {
            return b->binding;
        }
    }
    return NULL;
}

void pop(string key) {
    int index = hash(key % SIZE;
    table[index] = table[index]->next;
    count--;
}
```

b．给 insert 和 lookup 增加一个参数以允许使用多个表。

```c++
void insert(string key, void *binding, struct bucket **table) {
    int index = hash(key) % SIZE;
    table[index] = Bucket(key, binding, table[index]);
}

void *lookup(std::string key, struct bucket **table) {
    int index = hash(key) % size;
    struct bucket *b;
    for (b = table[index]; b; b = b->next) {
        if (0 == strcmp(b->key, key) {
            return b->binding;
        }
    }
    return NULL;
}
```

![](img/b6cedad1adead8066d362099d15b1a46_MD5.png)

变量 a 保存在寄存器当中，因为函数的参数默认通过寄存器进行传递。
变量 b 保存在存储器当中，因为该变量作为了传地址参数，因此它必须有一个存储器地址。
变量 c 保存在存储器当中，因为它是一个数组，为了计算数组中的元素，必须有对应的地址。
变量 d 和变量 e 保存在寄存器当中，因为他们都不是什么特殊情况，在这里看来寄存器也不会被全部用光。

![](img/6772b42ad6fcc2f1182d0046318caf37_MD5.png)

![](img/19a29c18181b09d2ddacd954fcd1153f_MD5.png)

a.  
根据 indent 的栈帧，和适当的偏移，找到 indent 栈帧中保存的静态链  
indent 根据栈帧中的静态链，找到调用它的函数 show 的栈帧  
根据 show 的栈帧，和适当的偏移，找到 show 栈帧中保存的静态链  
show 根据栈帧中的静态链，找到调用它的函数 prettyprint 的栈帧  
根据 prettyprint 的栈帧，和适当的偏移，找到 output 这个变量

b.  
indent 获得当前的深度，获得深度为 3  
访问 D\[2\] 函数栈帧声明的变量，此时 D2 函数为 show，并不存在 output 变量  
访问 D\[1\] 函数栈帧声明的变量，得到 output
