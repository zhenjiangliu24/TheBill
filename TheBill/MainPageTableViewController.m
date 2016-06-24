//
//  MainPageTableViewController.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/12.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "MainPageTableViewController.h"
#import "RecordTableViewCell.h"
#import "AddRecordViewController.h"
#import "DetailViewController.h"
#import "SideBarTableViewController.h"
#import "StatisticTableViewController.h"
#import "MapViewController.h"
#import "LineGraphViewController.h"
#import "MainPageViewModel.h"
#import "Banner.h"

@interface MainPageTableViewController ()
@property (nonatomic, strong) Banner *banner;

@property (nonatomic, strong) MainPageViewModel *viewModel;
@end

@implementation MainPageTableViewController
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    //add table header view
    self.banner = [[Banner alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeadImgHeight)];
    self.banner.offsetPoint = CGPointMake(ScreenWidth/2, HeadImgHeight-20);
    self.tableView.tableHeaderView = self.banner;
    //add tool bar button
    [self addBarButtonItem];
    [self.banner.menuButton addTarget:self action:@selector(revealToggleToSideBar) forControlEvents:UIControlEventTouchUpInside];
    [self.banner.calendarButton addTarget:self action:@selector(calendarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    SWRevealViewController *revealVC = self.revealViewController;
    if (revealVC) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setToolbarHidden:NO];
    [self fetchUser];
    self.viewModel = [[MainPageViewModel alloc] initWithUser:self.user];
    //[self fetchRecords];
    [self updateBannerUI];
    [self.tableView reloadData];
}

- (void)updateBannerUI
{
    [self.banner setLabel:self.banner.titleLabel WithTitle:self.user.name];
    double total = [self.viewModel getTotalCost];////////////////
    NSNumber *num = [NSNumber numberWithDouble:total];
    [self.banner setLabel:self.banner.TotalOutLabel WithTitle:[NSString stringWithFormat:@"Total cost: %@",[num stringValue]]];
    
    double monthcost = [self.viewModel getThisMonthTotalCost];//////////////
    double monthSalary = [self.viewModel getThisMonthTotalSalary];///////////////
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSString *monthName = [[format monthSymbols] objectAtIndex:[components month]-1];
    [self.banner setLabel:self.banner.MonthOutComeLabel WithTitle:[[NSNumber numberWithDouble:monthcost] stringValue]];
    [self.banner setLabel:self.banner.MonthInComeLabel WithTitle:[[NSNumber numberWithDouble:monthSalary] stringValue]];
    [self.banner setLabel:self.banner.MonthOutDetailLabel WithTitle:[NSString stringWithFormat:@"%@ cost",monthName]];
    [self.banner setLabel:self.banner.MonthInDetailLabel WithTitle:[NSString stringWithFormat:@"%@ salary",monthName]];

}


- (void)fetchUser
{
    NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey:SORT_USER_KEY];
    NSArray *temp = [User MR_findAllSortedBy:sortKey ascending:YES];
    if (!self.user) {
        self.user = [temp firstObject];
    }
}



- (void)addBarButtonItem
{
    UIImage *img = [PublicFunction imageResize:[UIImage imageNamed:@"clock"] resizeTo:CGSizeMake(30, 30)];
    
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *historyButton=[[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(historybarButtonPressed)];
    historyButton.tintColor = [UIColor blackColor];
    [buttonsArray addObject:historyButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((ScreenWidth-ADD_RECORD_BUTTON_WIDTH)/2, 5, ADD_RECORD_BUTTON_WIDTH, ADD_RECORD_BUTTON_HEIGHT)];
    [button setBackgroundColor:[UIColor colorWithRed:255/255 green:165/255 blue:0 alpha:1]];
    [button setTitle:@"New record" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 6;
    [button addTarget:self action:@selector(addRecordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addRecordButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttonsArray addObject:flexibleSpace];
    [buttonsArray addObject:addRecordButton];
    [buttonsArray addObject:flexibleSpace];
    
    UIImage *locationImg = [PublicFunction imageResize:[UIImage imageNamed:@"location"] resizeTo:CGSizeMake(30, 30)];
    UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithImage:locationImg style:UIBarButtonItemStylePlain target:self action:@selector(locationButtonPressed)];
    locationButton.tintColor = [UIColor blackColor];
    [buttonsArray addObject:locationButton];
    [self setToolbarItems:buttonsArray animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {//scroll down
        self.banner.frame = CGRectMake(0, 0, ScreenWidth, HeadImgHeight);
        self.banner.offsetPoint = CGPointMake(ScreenWidth/2, self.banner.frame.size.height-20);
        
        [self.banner.MonthInComeLabel setFrame:CGRectMake(ScreenWidth/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_ICON_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
        [self.banner.MonthOutComeLabel setFrame:CGRectMake(ScreenWidth*3/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_ICON_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
        [self.banner.MonthInDetailLabel setFrame:CGRectMake(ScreenWidth/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_DETAIL_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
        [self.banner.MonthOutDetailLabel setFrame:CGRectMake(ScreenWidth*3/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_DETAIL_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    }else{
        if (offsetY<=30) {
            self.banner.frame = CGRectMake(0, self.tableView.contentOffset.y, ScreenWidth, HeadImgHeight-offsetY);
            self.banner.offsetPoint = CGPointMake(ScreenWidth/2, self.banner.frame.size.height-20);
            
            [self.banner.MonthInComeLabel setFrame:CGRectMake(ScreenWidth/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_ICON_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT-offsetY, TITLE_WIDTH, TITLE_HEIGHT)];
            [self.banner.MonthOutComeLabel setFrame:CGRectMake(ScreenWidth*3/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_ICON_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT-offsetY, TITLE_WIDTH, TITLE_HEIGHT)];
            [self.banner.MonthInDetailLabel setFrame:CGRectMake(ScreenWidth/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_DETAIL_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT-offsetY, TITLE_WIDTH, TITLE_HEIGHT)];
            [self.banner.MonthOutDetailLabel setFrame:CGRectMake(ScreenWidth*3/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_DETAIL_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT-offsetY, TITLE_WIDTH, TITLE_HEIGHT)];
        }else{
            self.banner.frame = CGRectMake(0, self.tableView.contentOffset.y, ScreenWidth, HeadImgHeight-BANNER_FLEXIBLE_LENGTH);
            self.banner.offsetPoint = CGPointMake(ScreenWidth/2, self.banner.frame.size.height-20);
            
            [self.banner.MonthInComeLabel setFrame:CGRectMake(ScreenWidth/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_ICON_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT-BANNER_FLEXIBLE_LENGTH, TITLE_WIDTH, TITLE_HEIGHT)];
            [self.banner.MonthOutComeLabel setFrame:CGRectMake(ScreenWidth*3/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_ICON_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT-BANNER_FLEXIBLE_LENGTH, TITLE_WIDTH, TITLE_HEIGHT)];
            [self.banner.MonthInDetailLabel setFrame:CGRectMake(ScreenWidth/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_DETAIL_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT-BANNER_FLEXIBLE_LENGTH, TITLE_WIDTH, TITLE_HEIGHT)];
            [self.banner.MonthOutDetailLabel setFrame:CGRectMake(ScreenWidth*3/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_DETAIL_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT-BANNER_FLEXIBLE_LENGTH, TITLE_WIDTH, TITLE_HEIGHT)];
        }
        
    }
}

#pragma mark - main page button clicked

- (void)addRecordButtonPressed
{
    [self performSegueWithIdentifier:@"addRecordSegue" sender:self];
}

- (void)historybarButtonPressed
{
    UINavigationController *navi = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"lineNaviID"];
    LineGraphViewController *lineVC = (LineGraphViewController *)navi.topViewController;
    lineVC.user = self.user;
    [self.navigationController pushViewController:lineVC animated:YES];
}

- (void)locationButtonPressed
{
    MapViewController *mapVC = (MapViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mapID"];
    mapVC.records = self.viewModel.records;/////////////////
    mapVC.user = self.user;
    mapVC.title = self.user.name;
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)revealToggleToSideBar
{
    SideBarTableViewController *sideVC;
    if ([self.revealViewController.rearViewController isKindOfClass:[SideBarTableViewController class]]) {
        sideVC = (SideBarTableViewController *)self.revealViewController.rearViewController;
    }else if ([self.revealViewController.rearViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navi = (UINavigationController *)self.revealViewController.rearViewController;
        sideVC = (SideBarTableViewController *)navi.topViewController;
    }
    
    sideVC.user = self.user;
    [self.revealViewController revealToggleAnimated:YES];
}
//click calendar button
- (void)calendarButtonAction
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *root = [window rootViewController];
    UIStoryboard *storyboard = root.storyboard;
    StatisticTableViewController *statisticVC = (StatisticTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StatisticID"];
    statisticVC.user = self.user;
    [self.navigationController pushViewController:statisticVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sectionArray.count;/////////////
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = self.viewModel.sectionArray[section];//////////
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"record_cell";
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSUInteger section = [indexPath section];
    NSMutableArray *array = self.viewModel.sectionArray[section];
    Record *record;
    if ([array[indexPath.row] isKindOfClass:[InRecord class]]) {
        record = (InRecord *)array[indexPath.row];
        cell.recordAmountLabel.textColor = [UIColor colorWithRed:204/255 green:255/255 blue:255/255 alpha:1];
    }else if ([self.viewModel.records[indexPath.row] isKindOfClass:[OutRecord class]]){//////////////
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
    NSMutableArray *array = self.viewModel.sectionArray[section];//////////////
    detailVC.myRecord = array[indexPath.row];
    detailVC.user = self.user;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = self.viewModel.sectionArray[section];/////////////
    Record *record = [array firstObject];
    return [PublicFunction getDayString:record.date];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addRecordSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)segue.destinationViewController;
            AddRecordViewController *addVC = (AddRecordViewController *)navi.topViewController;
            addVC.user = self.user;
            addVC.isOutRecord = YES;
        }
    }
}




@end
