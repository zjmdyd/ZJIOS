//
//  ZJAlgorithm.m
//  ZJIOS
//
//  Created by Zengjian on 2025/6/24.
//

#import "ZJAlgorithm.h"
#include <malloc/malloc.h>
#include <stdlib.h>

//设置一个数组分配空间大小
#define HASHSIZE 10

//设置最小int用于初始化
#define NULLKey -32768

int m = 10;

typedef struct {
    int *elem;
    int count;
}HashTable;

// 初始化哈希表
int Init(HashTable *H) {
    m = HASHSIZE;
    H->count = m;
    H->elem = malloc(sizeof(int) * m);
    
    if (H->elem == NULL) {
        printf("动态内存分配失败!\n");
        exit(-1);
    }
    
    for (int i = 0; i < m; i++) {
        H->elem[i] = NULLKey;
    }
    
    return 1;
}

// 遍历哈希表
void Result(HashTable *H) {
    for (int i = 0; i < H->count; i++) {
        printf("%d\n", H->elem[i]);
    }
}

// 哈希函数
int Hash(int k) {
    return k % m;
}

// 根据k插入元素
void Insert(HashTable *H, int k) {
    int addr = Hash(k);
    while (H->elem[addr] != NULLKey) {
        // 开放地址法
        addr = (addr + 1) % m;
    }
    H->elem[addr] = k;
}

// 查找某个元素位置
int Search(HashTable *H, int k) {
    int addr = Hash(k);
    while (H->elem[addr] != k) {
        // 开放地址法
        addr = (addr + 1) % m;
        printf("%d==%d\n", addr, Hash(k));
        // addr == Hash(k) 当再一次相等，说明已经全部遍历了一遍
        if (H->elem[addr] == NULLKey || addr == Hash(k)) {
            return -1;
        }
    }
    
    return addr;
}

@implementation ZJAlgorithm

- (void)testHash {
    int i, j, addr;
    HashTable H;
    int arr[HASHSIZE] = {12, 33, 22, 19, 56, 98, 76, 45, 66, 88};
    Init(&H);
    for (i = 0; i < HASHSIZE; i++) {
        Insert(&H, arr[i]);
    }
    Result(&H);
    j = 29;
    addr = Search(&H, j);
    if (addr == -1) {
        printf("元素不存在\n");
    }else {
        printf("%d元素在表中的位置是:%d\n", j, addr);
    }
}

@end
