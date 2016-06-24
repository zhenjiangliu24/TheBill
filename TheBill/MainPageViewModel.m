//
//  MainPageViewModel.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/24.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "MainPageViewModel.h"

@interface MainPageViewModel()
@property (nonatomic, strong) User *user;
@property (nonatomic, readwrite, copy) NSArray *records;
@property (nonatomic, readwrite, copy) NSArray *sectionArray;
@property (nonatomic, readwrite, strong) NSMutableArray *mutableSectionArray;
@end

@implementation MainPageViewModel
//designated instantializer
- (instancetype)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        _user = user;
        [self updateRecords];
        [self updateSectionArray];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithUser:nil];
}


- (void)updateSectionArray
{
    int section = 0;
    _mutableSectionArray = [[NSMutableArray alloc] initWithObjects:[NSMutableArray new], nil];
    if (_records.count == 1) {
        NSMutableArray *array1 = [_mutableSectionArray firstObject];
        [array1 addObject:_records.firstObject];
    }else if(_records.count>1){
        for (int index = 0; index<_records.count-1; index++) {
            Record *first = _records[index];
            Record *second = _records[index+1];
            NSDate *date1 = [PublicFunction getDayFromDate:first.date];
            NSDate *date2 = [PublicFunction getDayFromDate:second.date];
            NSMutableArray *sectionTemp = _mutableSectionArray[section];
            if (![sectionTemp containsObject:first]) {
                [sectionTemp addObject:first];
            }
            if ([date1 compare:date2] == NSOrderedSame) {
                [sectionTemp addObject:second];
            }else{
                NSMutableArray *newArray = [NSMutableArray arrayWithObject:second];
                [_mutableSectionArray addObject:newArray];
                section++;
            }
        }
    }else{
        _sectionArray = [NSMutableArray array];
    }
    _sectionArray = [_mutableSectionArray copy];
}

- (void)updateRecords
{
    [self getRecordsFromUser:self.user];
}

- (void)getRecordsFromUser:(User *)user
{
    NSMutableArray *records = [NSMutableArray new];
    if (user) {
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(user == %@)",user];
        NSArray *temp = [Record MR_findAllWithPredicate:predicate];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        NSArray *sortDescriptor = [NSArray arrayWithObject:sort];
        NSArray *sorted = [temp sortedArrayUsingDescriptors:sortDescriptor];
        records = [NSMutableArray arrayWithArray:sorted];
    }
    _records = [records copy];
}

- (double)getThisMonthTotalCost
{
    double total = 0;
    total = [self calculateAllCost:[PublicFunction filterOutRecords:[self getThisMonthRecords]]];
    return total;
}

- (double)getThisMonthTotalSalary
{
    double total = 0;
    total = [self calculateAllCost:[PublicFunction filterInRecords:[self getThisMonthRecords]]];
    return total;
}

- (double)getTotalCost
{
    double total = 0;
    NSMutableArray *tempRecords = [NSMutableArray arrayWithArray:_records];
    total = [self calculateAllCost:[PublicFunction filterOutRecords:tempRecords]];
    return total;
}

- (NSMutableArray *)getThisMonthRecords
{
    NSDate *first = [PublicFunction getFirstDayInMonthByDate:[NSDate date]];
    NSDate *last = [PublicFunction getLastDayInMonthByDate:[NSDate date]];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"(SELF.date>=%@) AND (SELF.date<=%@)",first,last];
    NSMutableArray *array = [[self.records filteredArrayUsingPredicate:filter] mutableCopy];
    return array;
}

- (double)calculateAllCost:(NSMutableArray *)array
{
    double sum = 0;
    for (Record *outrecord in array) {
        sum += [outrecord.amount doubleValue];
    }
    return sum;
}



@end
