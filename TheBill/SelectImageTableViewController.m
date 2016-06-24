//
//  SelectImageTableViewController.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/22.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "SelectImageTableViewController.h"
#import "SelectImageTableViewCell.h"
#import "SelectImageViewModel.h"
#import "SelectImageViewModelDelegate.h"

@interface SelectImageTableViewController ()<SelectImageViewModelDelegate>


@property (nonatomic, copy) NSArray *photos;

@property (nonatomic, assign) NSNumber *selected;

@property (nonatomic, strong) SelectImageViewModel *viewModel;

@end

@implementation SelectImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"image_cell"];
    self.photos = [NSMutableArray array];
    self.viewModel = [[SelectImageViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self loadPhotos:self.currentPage];
    [self.viewModel loadPhotos:self.viewModel.currentPage completionHandler:^{
        
    }];
    [self showActivityIndicator];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setSelected:(NSNumber *)selected
{
    _selected = selected;
    NSIndexPath *oldPath = [NSIndexPath indexPathForRow:[_selected integerValue] inSection:0];
    NSDictionary *photoItem = _photos[oldPath.row];
    NSString *myCacheKey = [photoItem objectForKey:@"image_url"];
    NSURL *url = [NSURL URLWithString:myCacheKey];
    self.imageURL = url;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel getTableViewCellsNumber];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.photos.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"load_cell" forIndexPath:indexPath];
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [indicator startAnimating];
        return cell;
    }else{
        SelectImageTableViewCell *cell2;
        cell2 = [tableView dequeueReusableCellWithIdentifier:@"image_cell" forIndexPath:indexPath];
        NSDictionary *photoItem = self.photos[indexPath.row];
        cell2.titleLabel.text = [photoItem objectForKey:@"name"];
        if (![[photoItem objectForKey:@"description"] isEqual:[NSNull null]]) {
            cell2.descriptionLabel.text = [photoItem objectForKey:@"description"];
        }
        [cell2.imageView sd_setImageWithURL:[NSURL URLWithString:[photoItem objectForKey:@"image_url"]]
                           placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (error) {
                                          NSLog(@"Error occured : %@", [error description]);
                                      }
                                  }];
        NSNumber *num = [NSNumber numberWithInteger:indexPath.row];
        if ([self.selected isEqualToNumber:num]) {
            cell2.selectButton.selected = YES;
        }else{
            cell2.selectButton.selected = NO;
        }
        return cell2;
    }
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.currentPage != self.viewModel.maxPages && indexPath.row == self.photos.count - 1) {
        [self.viewModel loadPhotos:++self.viewModel.currentPage completionHandler:^{
            
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = [NSNumber numberWithInteger:indexPath.row];
    if (![self.selected isEqualToNumber:num]) {
        NSIndexPath *oldPath = [NSIndexPath indexPathForRow:[self.selected integerValue] inSection:0];
        self.selected = num;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath,oldPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        if (([self.selected isEqualToNumber:num])) {
            self.selected = nil;
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else{
            self.selected = num;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}



#pragma mark - cancel & save button action
- (IBAction)cancelSelect:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Select image model protocol
- (void)selectImageViewModel:(SelectImageViewModel *)model didReceivePhotos:(NSArray *)photos
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.photos = [photos copy];
        self.navigationItem.titleView = nil;
        self.navigationItem.prompt = nil;
        [self.tableView reloadData];
    });
}

#pragma mark - loading indicator

- (void)showActivityIndicator
{
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.titleView = aiView;
    [aiView startAnimating];
    self.navigationItem.prompt = @"Loading ...";
}


@end
