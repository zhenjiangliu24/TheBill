//
//  DetailViewController.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"
#import "AddRecordViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//must be added, otherwise navigation bar not show
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 4;
            break;
        case 1:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = @"";
    if (section == 0) {
        header = @"Details";
    }else{
        header = @"Note";
    }
    return header;
}

- (BOOL)tableView:(UITableView *)tv shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Determine if row is selectable based on the NSIndexPath.
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"detail_cell"];
    RecordType *catalog = self.myRecord.recordType;
    NSUInteger section = [indexPath section];
    if (section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.leftLabel.text = @"Amount";
                cell.rightLabel.text = [self.myRecord.amount stringValue];
                break;
            case 1:
                cell.leftLabel.text = @"Record Type";
                cell.rightLabel.text = catalog.name;
                break;
            case 2:
                cell.leftLabel.text = @"User";
                cell.rightLabel.text = self.myRecord.user.name;
                break;
            case 3:
                cell.leftLabel.text = @"Date";
                cell.rightLabel.text = [PublicFunction convertToStringWithDate:self.myRecord.date];
            default:
                break;
        }
    }else{
        cell.leftLabel.text = @"Note";
        cell.rightLabel.text = self.myRecord.note;
    }
    return cell;
}

- (IBAction)EditButtonAction:(id)sender {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *root = [window rootViewController];
    UIStoryboard *storyboard = root.storyboard;
    AddRecordViewController *addVC = (AddRecordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"addVCID"];
    addVC.record = self.myRecord;
    addVC.user = self.user;
    if ([self.myRecord isKindOfClass:[OutRecord class]]) {
        addVC.isOutRecord = YES;
    }else{
        addVC.isOutRecord = NO;
    }
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)DeleteButtonAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to delete this record?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak DetailViewController *weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.myRecord MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
