//
//  SideBarTableViewController.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/12.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "SideBarTableViewController.h"
#import "MainPageTableViewController.h"
#import "SelectImageTableViewController.h"

@interface SideBarTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *userList;
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@end

@implementation SideBarTableViewController
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey:SORT_USER_KEY];
    NSArray *temp = [User MR_findAllSortedBy:sortKey ascending:YES];
    self.userList = [NSMutableArray arrayWithArray:temp];
    if (!self.user) {
        self.user = [self.userList firstObject];
    }
    
    self.userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewImage:)];
    tap.delegate = self;
    [self.userImageView addGestureRecognizer:tap];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    [self addToolBarAndButton];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self updateTableViewHeader];
    [super viewWillAppear:animated];
}

- (void)updateTableViewHeader
{
    UIImage *img = [PublicFunction imageResize:[UIImage imageWithData:self.user.image] resizeTo:CGSizeMake(SIDE_USER_IMG_WIDTH, SIDE_USER_IMG_HEIGHT)];
    self.userImageView.image = [PublicFunction makeRoundedImage:img radius:img.size.width/2];
    self.userNameLabel.text = self.user.name;
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
    return self.userList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user_cell" forIndexPath:indexPath];
    User *user = self.userList[indexPath.row];
    cell.textLabel.text = user.name;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.user = self.userList[indexPath.row];
    UIImage *img = [PublicFunction imageResize:[UIImage imageWithData:self.user.image] resizeTo:CGSizeMake(SIDE_USER_IMG_WIDTH, SIDE_USER_IMG_HEIGHT)];
    self.userImageView.image = [PublicFunction makeRoundedImage:img radius:img.size.width/2];
    self.userNameLabel.text = self.user.name;
}


#pragma mark - add tool bar
- (void)addToolBarAndButton
{
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((ScreenWidth-ADD_RECORD_BUTTON_WIDTH)/2, 5, ADD_RECORD_BUTTON_WIDTH, ADD_RECORD_BUTTON_HEIGHT)];
    [button setBackgroundColor:[UIColor colorWithRed:255/255 green:165/255 blue:0 alpha:1]];
    [button setTitle:@"New User" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 6;
    [button addTarget:self action:@selector(addUserButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addRecordButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [buttonsArray addObject:flexibleSpace];
    [buttonsArray addObject:addRecordButton];
    [buttonsArray addObject:flexibleSpace];
    [self setToolbarItems:buttonsArray animated:YES];
}

- (void)addUserButtonPressed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please input user name" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"User name";
        textField.delegate = self;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    __weak SideBarTableViewController *weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *text = alert.textFields.firstObject;
        SideBarTableViewController *strongSelf = weakSelf;
        if (text.text.length>0) {
            User *newUser = [User MR_createEntity];
            newUser.name = text.text;
            newUser.image = UIImagePNGRepresentation([UIImage imageNamed:@"user-icon"]);
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey:SORT_USER_KEY];
            NSArray *temp = [User MR_findAllSortedBy:sortKey ascending:YES];
            strongSelf.userList = [NSMutableArray arrayWithArray:temp];
            [strongSelf.tableView reloadData];
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }else{
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"toMainSegue"]) {
            MainPageTableViewController *mainVC = (MainPageTableViewController *)navi.childViewControllers.firstObject;
            NSIndexPath *index = [self.tableView indexPathForSelectedRow];
            User *user = self.userList[index.row];
            mainVC.user = user;
        }
    }
    
}

#pragma mark - tap user image view
- (void)addNewImage:(UITapGestureRecognizer *)tap
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Change your photo"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    __weak SideBarTableViewController *weakVC = self;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    UIAlertAction *pickFrom = [UIAlertAction actionWithTitle:@"Pick from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakVC presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *webPhoto = [UIAlertAction actionWithTitle:@"Web Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UINavigationController *navi = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"naviSelectID"];
        [self presentViewController:navi animated:YES completion:nil];
    }];
    [alert addAction:pickFrom];
    [alert addAction:takePhoto];
    [alert addAction:webPhoto];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.user.image = UIImagePNGRepresentation(image);
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)unwindFromModalViewController:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"saveWebImage"]) {
        if ([segue.sourceViewController isKindOfClass:[SelectImageTableViewController class]]) {
            SelectImageTableViewController *selectVC = (SelectImageTableViewController *)segue.sourceViewController;
            NSString *imageURLString = [selectVC.imageURL absoluteString];
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            UIImage *cachedImage = [imageCache imageFromMemoryCacheForKey:imageURLString];
            __weak SideBarTableViewController *weakSelf = self;
            if(cachedImage){
                self.user.image = UIImagePNGRepresentation(cachedImage);
            }else{
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:selectVC.imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    SideBarTableViewController *strongSelf = weakSelf;
                    strongSelf.user.image = UIImagePNGRepresentation(image);
                }];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    }
}


@end
