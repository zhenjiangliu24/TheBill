//
//  MonthDetailViewModel.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/25.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "BaseViewModel.h"

@interface MonthDetailViewModel : BaseViewModel
@property (nonatomic, readonly, copy) NSArray *data;
- (instancetype)initWithMonthArray:(NSArray *)monthArray;
@end
