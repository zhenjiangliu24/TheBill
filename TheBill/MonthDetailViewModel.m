//
//  MonthDetailViewModel.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/25.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "MonthDetailViewModel.h"
@interface MonthDetailViewModel()
@property (nonatomic, readwrite, copy) NSArray *data;
@property (nonatomic, strong) NSMutableArray *mutableData;
@end

@implementation MonthDetailViewModel

//designated instantializer
- (instancetype)initWithMonthArray:(NSArray *)monthArray
{
    if (self = [super init]) {
        _data = [NSMutableArray array];
        [self prepareData:monthArray];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithMonthArray:[NSMutableArray array]];
}

- (void)prepareData:(NSArray *)monthArray
{
    int section = 0;
    _mutableData = [[NSMutableArray alloc] initWithObjects:[NSMutableArray new], nil];
    if (monthArray.count == 1) {
        NSMutableArray *firstM = _mutableData.firstObject;
        [firstM addObject:monthArray.firstObject];
    }else{
        for (int index = 0; index<monthArray.count-1; index++) {
            Record *firstR = monthArray[index];
            Record *secondR =monthArray[index+1];
            NSMutableArray *day = _mutableData[section];
            if (![day containsObject:firstR]) {
                [day addObject:firstR];
            }
            if ([PublicFunction sameDay:firstR.date date:secondR.date]) {
                [day addObject:secondR];
            }else{
                NSMutableArray *newDay = [NSMutableArray arrayWithObject:secondR];
                [_mutableData addObject:newDay];
                section++;
            }
        }
    }
    _data = [_mutableData copy];
}
@end
