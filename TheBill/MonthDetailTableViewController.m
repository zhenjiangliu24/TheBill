//
//  MonthDetailTableViewController.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "MonthDetailTableViewController.h"
#import "RecordTableViewCell.h"
#import "DetailViewController.h"
#import "MonthDetailViewModel.h"

@interface MonthDetailTableViewController ()
@property (nonatomic, strong) MonthDetailViewModel *viewModel;
@end

@implementation MonthDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self prepareData];
    self.viewModel = [[MonthDetailViewModel alloc] initWithMonthArray:self.monthArray];
    Record *record = self.monthArray.firstObject;
    NSString *yearName = [[PublicFunction getDayString:record.date] substringToIndex:4];
    self.title = [NSString stringWithFormat:@"%@ %@",yearName, [PublicFunction getMonthNameWith:record.date]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *day = self.viewModel.data[section];
    return day.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"record_cell" forIndexPath:indexPath];
    NSUInteger section = [indexPath section];
    NSMutableArray *array = self.viewModel.data[section];
    
    Record *record;
    if ([array[indexPath.row] isKindOfClass:[InRecord class]]) {
        record = (InRecord *)array[indexPath.row];
        cell.recordAmountLabel.textColor = [UIColor colorWithRed:204/255 green:255/255 blue:255/255 alpha:1];
    }else if ([self.monthArray[indexPath.row] isKindOfClass:[OutRecord class]]){
        record = (OutRecord *)array[indexPath.row];
    }else{
        record = (Record *)array[indexPath.row];
    }
    cell.recordImageView.image = [PublicFunction imageResize:[UIImage imageNamed:record.recordType.icon] resizeTo:CGSizeMake(RECORD_CELL_ICON_WIDTH, RECORD_CELL_ICON_HEIGHT)];
    cell.recordTitleLabel.text = record.recordType.name;
    cell.recordAmountLabel.text = [record.amount stringValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"detail_navi"];
    DetailViewController *detailVC = (DetailViewController *)navi.topViewController;
    NSUInteger section = [indexPath section];
    NSMutableArray *array = self.viewModel.data[section];
    detailVC.myRecord = array[indexPath.row];
    detailVC.user = self.user;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = self.viewModel.data[section];
    Record *record = [array firstObject];
    return [PublicFunction getDayString:record.date];
}

@end
