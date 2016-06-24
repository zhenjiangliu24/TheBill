//
//  MainPageViewModel.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/24.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "BaseViewModel.h"
#import "User.h"

@interface MainPageViewModel : BaseViewModel
@property (nonatomic, readonly, copy) NSArray *records;
@property (nonatomic, readonly, copy) NSArray *sectionArray;

- (instancetype)initWithUser:(User *)user;
- (void)updateRecords;
- (double)getThisMonthTotalCost;
- (double)getThisMonthTotalSalary;
- (double)getTotalCost;
@end
