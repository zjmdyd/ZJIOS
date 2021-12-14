//
//  ZJByteData.c
//  CanShengHealth
//
//  Created by ZJ on 26/03/2018.
//  Copyright © 2018 HY. All rights reserved.
//

#include "ZJByteData.h"

extern uint16_t bitReverse(uint16_t us_DataIn)
{
    uint16_t us_Data = us_DataIn;
    us_Data = ((us_Data & 0xFF00) >> 8) | ((us_Data & 0x00FF) << 8);
    us_Data = ((us_Data & 0xF0F0) >> 4) | ((us_Data & 0x0F0F) << 4);
    us_Data = ((us_Data & 0xCCCC) >> 2) | ((us_Data & 0x3333) << 2);
    us_Data = ((us_Data & 0xAAAA) >> 1) | ((us_Data & 0x5555) << 1);
    
    return (us_Data);
}

/*
 小端模式：是指数据的低字节保存在内存的低地址中，而数据的高字节保存在内存的高地址中。
 大端模式：是指低子节数据保存在内存的高地址中，而数据的高字节保存在内存的低地址中。
 */
bool isBigEndian() {
    short int a = 0x1122;       // 十进制为4386，其中11称为高子节(即15~8位)。
    char b = ((char *)&a)[0];   // 取变量a的低子节(即7~0位)
    printf("b = %x\n", b);      // 输出22代表编译器为小端模式
    if (b == 0x22) {
        return false;
    }
    
    return true;
}
