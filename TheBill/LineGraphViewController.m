//
//  LineGraphViewController.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/20.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "LineGraphViewController.h"
#import "LineView.h"
@interface LineGraphViewController()
@property (nonatomic, strong) NSMutableArray *lastWeekArray;
@property (nonatomic, copy) NSArray *lastSevenMonth;
@end

@implementation LineGraphViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self prepareDataForLineGraph];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Last week cost";
    self.navigationController.navigationBar.barTintColor = APP_MAIN_COLOR;
}

- (void)prepareDataForLineGraph
{
    NSArray *arr = [PublicFunction getLastWeekDates:[NSDate date]];
    self.lastWeekArray = [NSMutableArray new];
    int index = 0;
    NSDate *lastDate = [NSDate date];
    for (NSString *dateString in arr) {
        NSDate *date = [LineGraphViewController convertToDateWithString:dateString];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(user == %@) AND (date >= %@) AND (date <= %@)",self.user,date,lastDate];
        
        NSArray *dayRecords = [Record MR_findAllWithPredicate:predicate];
        [self.lastWeekArray addObject:dayRecords];
        lastDate = date;
        index++;
    }
    self.lastWeekArray = [[[self.lastWeekArray reverseObjectEnumerator] allObjects] mutableCopy];
    NSMutableArray *weekCost = [NSMutableArray new];
    index = 1;
    for (NSArray *array in self.lastWeekArray) {
        double cost = [self calculateCost:array];
        NSValue *value = [self valueX:index Y:cost];
        [weekCost addObject:value];
        index++;
    }
    LineView *line = [[LineView alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 200)];
    line.dataArray = [weekCost copy];
    line.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:line];
}

- (NSValue *)valueX:(CGFloat)x Y:(CGFloat)y {
    return [NSValue valueWithCGPoint:CGPointMake(x, y)];
}

- (double)calculateCost:(NSArray *)records
{
    double total = 0;
    for (Record *record in records) {
        if ([record isKindOfClass:[OutRecord class]]) {
            total += [record.amount doubleValue];
        }
    }
    return total;
}

+ (NSDate *)convertToDateWithString:(NSString *)dateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:dateString];
    return date;
}
@end
