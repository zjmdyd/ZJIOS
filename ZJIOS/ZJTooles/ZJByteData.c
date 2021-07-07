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
