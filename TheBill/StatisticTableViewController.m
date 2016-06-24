//
//  StatisticTableViewController.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/17.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "StatisticTableViewController.h"
#import "StatisticTableViewCell.h"
#import "MonthDetailTableViewController.h"
@interface StatisticTableViewController ()



@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *monthArray;
@end

@implementation StatisticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Statistics";
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBar.barTintColor = APP_MAIN_COLOR;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareData
{
    if (self.user) {
        self.yearArray = [PublicFunction prepareYearArrayWith:self.user];
        self.data = [PublicFunction prepareYearMonthDayDataWithYearArray:self.yearArray];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.yearArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *yearArray = self.data[section];
    return yearArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatisticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"year_cell" forIndexPath:indexPath];
    NSUInteger section = indexPath.section;
    NSMutableArray *yearArray = self.data[section];
    NSMutableArray *monthArray = yearArray[indexPath.row];
    Record *firstR = monthArray.firstObject;
    cell.monthLabel.text = [PublicFunction getMonthNameWith:firstR.date];
    double monthIn = [self calculateAllCost:[PublicFunction filterInRecords:monthArray]];
    double monthOut = [self calculateAllCost:[PublicFunction filterOutRecords:monthArray]];
    cell.inComeLabel.text = [NSString stringWithFormat:@"In:%.f",monthIn];
    cell.outComeLabel.text = [NSString stringWithFormat:@"Out:%.f",monthOut];
    double total = monthIn-monthOut;
    cell.numberLabel.text = [NSString stringWithFormat:@"%.f",total];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, STA_CELL_HEIGHT)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, STA_MONTH_WIDTH, STA_MONTH_HEIGHT)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    NSMutableArray *yearArray = self.data[section];
    NSMutableArray *monthArray = yearArray.firstObject;
    Record *firstR = monthArray.firstObject;
    label.text = [[PublicFunction getDayString:firstR.date] substringToIndex:4];
    
    [view addSubview:label];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2, 2, tableView.frame.size.width/2, 20)];
    [totalLabel setFont:[UIFont boldSystemFontOfSize:18]];
    double total = 0;
    for (int index = 0; index<yearArray.count; index++) {
        @autoreleasepool {
            NSMutableArray *month = yearArray[index];
            for (Record *record in month) {
                if ([record isKindOfClass:[OutRecord class]]) {
                    total += [record.amount doubleValue];
                }else if([record isKindOfClass:[InRecord class]]){
                    total -= [record.amount doubleValue];
                }
            }
        }
        
    }
    totalLabel.text = [NSString stringWithFormat:@"Total cost is:%.f",total];
    [view addSubview:totalLabel];
    [view setBackgroundColor:APP_MAIN_COLOR]; //your background color...
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSMutableArray *yearArray = self.data[section];
    self.monthArray = yearArray[indexPath.row];
    MonthDetailTableViewController *monthVC = [self.storyboard instantiateViewControllerWithIdentifier:@"monthVCID"];
    monthVC.monthArray = self.monthArray;
    monthVC.user = self.user;
    [self.navigationController pushViewController:monthVC animated:YES];
}

- (double)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

- (double)calculateAllCost:(NSMutableArray *)array
{
    double sum = 0;
    for (Record *outrecord in array) {
        sum += [outrecord.amount doubleValue];
    }
    return sum;
}


#pragma mark - Navigation




@end
