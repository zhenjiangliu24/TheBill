//
//  AddRecordViewController.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/13.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "AddRecordViewController.h"
#import "DetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "ZJLTagListView.h"
#import "ZJLConstants.h"

@interface AddRecordViewController ()<UIScrollViewDelegate,CLLocationManagerDelegate,ZJLTagListViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainRecordImage;
@property (weak, nonatomic) IBOutlet UILabel *mainRecordTitleLabel;
//@property (weak, nonatomic) IBOutlet JFTagListView *tagListView;
@property (weak, nonatomic) IBOutlet UIScrollView *tagScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mainRecordAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *showDatePickerButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inOrOutSegment;
@property (weak, nonatomic) IBOutlet UISwitch *locationSW;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locationActivity;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet ZJLTagListView *ZJLTagView;

@property (nonatomic, strong) NSMutableArray *recordTypeList;
@property (nonatomic, assign) TagStateType tagStateType;


@property (nonatomic, strong) UIDatePicker *picker;
@property (nonatomic, strong) NSDate *recordDate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableString *locationString;
@end

@implementation AddRecordViewController
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagScrollView.delegate = self;
    self.tagScrollView.scrollEnabled = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    [self initialDatePickerButtonAndNote];
    ListRecordType *listObject = [ListRecordType MR_findFirstByAttribute:@"isOut" withValue:[NSNumber numberWithBool:YES]];
    self.recordTypeList = [NSMutableArray arrayWithArray:listObject.recordType.allObjects];
    [self initialNavigationBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [tap setNumberOfTapsRequired:1];
    [tap cancelsTouchesInView];
    [self.view addGestureRecognizer:tap];
    if ([self.record.recordType.name isEqualToString:@"Salary"]) {
        [self.inOrOutSegment setSelectedSegmentIndex:1];
    }else{
        [self.inOrOutSegment setSelectedSegmentIndex:0];
    }
    [self changeRecordType];
    [self initialTagView];
    [self.inOrOutSegment addTarget:self action:@selector(changeRecordType) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.locationActivity.hidden = YES;
    self.locationLabel.hidden = YES;
    self.navigationController.navigationBar.barTintColor = APP_MAIN_COLOR;
    self.inOrOutSegment.layer.borderColor = [UIColor colorWithRed:255/255 green:43/255 blue:37/255 alpha:1.0].CGColor;
    [self setButtonImage];
}

- (void)setButtonImage
{
    CGSize size = CGSizeMake(self.deleteButton.frame.size.height, self.deleteButton.frame.size.height);
    UIImage *image = [PublicFunction imageResize:[UIImage imageNamed:@"backspace"] resizeTo:size];
    [self.deleteButton setImage:image forState:UIControlStateNormal];
    self.deleteButton.tintColor = [UIColor whiteColor];
}

- (void)changeRecordType
{
    NSInteger selected = self.inOrOutSegment.selectedSegmentIndex;
    ListRecordType *listObject;
    if (selected == 0) {
        listObject = [ListRecordType MR_findFirstByAttribute:@"isOut" withValue:[NSNumber numberWithBool:YES]];
        self.recordTypeList = [NSMutableArray arrayWithArray:listObject.recordType.allObjects];
        self.isOutRecord = YES;
    }else if (selected == 1){
        listObject = [ListRecordType MR_findFirstByAttribute:@"isOut" withValue:[NSNumber numberWithBool:NO]];
        self.recordTypeList = [NSMutableArray arrayWithArray:listObject.recordType.allObjects];
        self.isOutRecord = NO;
    }
    [self.ZJLTagView reloadData:[self.recordTypeList copy] andTime:0];
    [self initialMainLabel];
}

- (void)dismissDatePicker:(UITapGestureRecognizer *)sender
{
    [self.picker resignFirstResponder];
    [self.picker removeFromSuperview];
    self.recordDate = [self.picker date];
    [self updateDateLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tagScrollView.contentSize = CGSizeMake(ScreenWidth, 400);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - ZJL tag view delegate
- (void)tagView:(ZJLTagListView *)tagView clickedTagAtIndex:(NSInteger)index
{
    if(self.ZJLTagView.tagViewType == ZJLTAGNORMAL){
        if(index!=self.recordTypeList.count){
            RecordType *type = self.recordTypeList[index];
            self.mainRecordImage.image = [PublicFunction imageResize:[UIImage imageNamed:type.icon] resizeTo:CGSizeMake(RECORD_CELL_ICON_WIDTH, RECORD_CELL_ICON_HEIGHT)];
            self.mainRecordTitleLabel.text = type.name;
        }else{//normal state to edit
            self.ZJLTagView.tagViewType = ZJLTAGEDIT;
        }
    }else if(self.ZJLTagView.tagViewType == ZJLTAGEDIT){
        if(index!=self.recordTypeList.count){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete this tag?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //[self dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *deleteActon = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                RecordType *recordType = self.recordTypeList[index];
                [self.recordTypeList removeObject:recordType];
                [recordType MR_deleteEntity];
                [self.ZJLTagView reloadData:[self.recordTypeList copy] andTime:0];
                //[self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cancelAction];
            [alert addAction:deleteActon];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            self.ZJLTagView.tagViewType = ZJLTAGNORMAL;
        }
    }
}

- (void)tagViewDidChangeType
{
    [self.ZJLTagView reloadData:[self.recordTypeList copy] andTime:0];
}

- (void)initialTagView
{
    self.ZJLTagView.tagViewType = ZJLTAGNORMAL;
    self.ZJLTagView.delegate = self;
    self.ZJLTagView.is_can_add = NO;
    [self.ZJLTagView createTagViewWith:[self.recordTypeList copy]];
    [self.ZJLTagView reloadData:[self.recordTypeList copy] andTime:0];
}

- (void)updateDateLabel
{
    if (self.record) {
        self.recordDate = self.recordDate?self.recordDate:self.record.date;
    }else if (!self.recordDate){
        self.recordDate = [NSDate date];
    }
    [self.showDatePickerButton setTitle:[PublicFunction convertToMonthAndDateWith:self.recordDate] forState:UIControlStateNormal];
}

- (void)initialDatePickerButtonAndNote
{
    [self updateDateLabel];
    self.showDatePickerButton.layer.cornerRadius = 10;
    self.showDatePickerButton.layer.borderWidth = 1;
    self.showDatePickerButton.layer.borderColor = [UIColor colorWithRed:255/255 green:165/255 blue:0 alpha:1].CGColor;
    self.showDatePickerButton.tintColor = [UIColor colorWithRed:255/255 green:165/255 blue:0 alpha:1];
    
}

- (void)initialNavigationBar
{
    if (self.record) {
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.toolbarHidden = YES;
    }else{
        UIImage *img = [PublicFunction imageResize:[UIImage imageNamed:@"close"] resizeTo:CGSizeMake(30, 30)];
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 0, 30, 30);
        [cancel addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [cancel setBackgroundColor:[UIColor clearColor]];
        [cancel setOpaque:YES];
        [cancel setBackgroundImage:img forState:UIControlStateNormal];
        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithCustomView:cancel];
        self.navigationItem.rightBarButtonItem = cancelButton;
    }
}

- (void)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)initialMainLabel
{
    RecordType *type;
    NSString *imageString;
    [self.record class];
    if (self.record) {//edit out record
        if ([self.record isKindOfClass:[OutRecord class]]) {
            if (!self.isOutRecord) {//salary
                type = [self.recordTypeList firstObject];
            }else{//cost
                type = self.record.recordType;
            }
        }else{
            type = [self.recordTypeList firstObject];
        }
        
        self.mainRecordAmountLabel.text = [self.record.amount stringValue];
        imageString = [type.name lowercaseString];
    }else{
        
        type = [self.recordTypeList firstObject];
        
        imageString = [type.name lowercaseString];
        self.mainRecordAmountLabel.text = @"0";
    }
    self.mainRecordImage.image = [PublicFunction imageResize:[UIImage imageNamed:imageString] resizeTo:CGSizeMake(RECORD_CELL_ICON_WIDTH, RECORD_CELL_ICON_HEIGHT)];
    self.mainRecordTitleLabel.text = type.name;
    
}



- (IBAction)locationSwitchChanged:(id)sender {
    UISwitch *locationSwitch = (UISwitch *)sender;
    if (locationSwitch.isOn) {
        self.locationLabel.hidden = NO;
        self.locationActivity.hidden = NO;
        [self.locationActivity startAnimating];
        if (!self.currentLocation) {
            [self.locationManager startUpdatingLocation];
        }
    }else{
        [self.locationManager stopUpdatingLocation];
        self.locationLabel.hidden = YES;
        self.locationActivity.hidden = YES;
    }
}

- (void)updateLocationString
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:self.currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if ([placemarks count] > 0) {
                           
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =  placemark.addressDictionary;
                           
                           NSString *address = [addressDictionary
                                                objectForKey:@"Street"];
                           address = address == nil ? @"": address;
                           
                           NSString *state = [addressDictionary
                                              objectForKey:@"State"];
                           state = state == nil ? @"": state;
                           
                           NSString *city = [addressDictionary
                                             objectForKey:@"City"];
                           city = city == nil ? @"": city;
                           
                           self.locationString = [NSMutableString stringWithFormat:@"%@, %@, %@", address,city,state];
                           self.locationActivity.hidden = YES;
                       }
                       
                   }];
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    self.currentLocation = locations.lastObject;
    [self updateLocationString];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.image = [UIImage imageNamed:@"get-location"];
    [self.locationLabel addSubview:view];
    self.locationLabel.hidden = NO;
}


/*
 1000->0
 1001->1
 1002->2
 1003->3
 1004->4
 1005->5
 1006->6
 1007->7
 1008->8
 1009->9
 1010->.
 1011->delete
 1012->+
 1013->-
 1014->OK
 */
- (IBAction)keyboardViewAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    switch (tag)
    {
        case 1010:
        {
            // .
            if(self.mainRecordAmountLabel.text.length > 0 && ![self.mainRecordAmountLabel.text containsString:@"."]){
                self.mainRecordAmountLabel.text = [NSString stringWithFormat:@"%@.",self.mainRecordAmountLabel.text];
            }
            
        }
            break;
        case 1011:
        {
            // delete
            if (self.mainRecordAmountLabel.text.length>0) {
                self.mainRecordAmountLabel.text = [self.mainRecordAmountLabel.text substringToIndex:self.mainRecordAmountLabel.text.length-1];
            }
            if (self.mainRecordAmountLabel.text.length == 0) {
                self.mainRecordAmountLabel.text = @"0";
            }
        }
            break;
        case 1012:
        {
            // re-enter
            self.mainRecordAmountLabel.text = @"0";
            
        }
            break;
        case 1014:
        {
            //OK
            if ([self.mainRecordAmountLabel.text doubleValue]>0){
                OutRecord *newRecord;
                InRecord *newIn;
                if (self.isOutRecord) {
                    newRecord = [OutRecord MR_createEntity];
                    newRecord.amount = [NSNumber numberWithDouble:[self.mainRecordAmountLabel.text doubleValue]];
                    newRecord.date = self.recordDate;
                    newRecord.note = self.locationString?self.locationString:@"Location not activated";
                    newRecord.user = self.user;
                    newRecord.recordType = [RecordType MR_createEntity];
                    newRecord.recordType.name = self.mainRecordTitleLabel.text;
                    newRecord.recordType.icon = [self.mainRecordTitleLabel.text lowercaseString];
                    newRecord.isOutCome = @YES;
                    if (self.locationSW.isOn) {
                        newRecord.latitude = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
                        newRecord.longitude = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
                    }
                    [self.user addRecordObject:newRecord];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }else{
                    newIn = [InRecord MR_createEntity];
                    newIn.amount = [NSNumber numberWithDouble:[self.mainRecordAmountLabel.text doubleValue]];
                    newIn.date = self.recordDate;
                    newIn.note = self.locationString?self.locationString:@"Location not activated";
                    newIn.user = self.user;
                    newIn.recordType = [RecordType MR_createEntity];
                    newIn.recordType.name = self.mainRecordTitleLabel.text;
                    newIn.recordType.icon = [self.mainRecordTitleLabel.text lowercaseString];
                    newIn.isInCome = @YES;
                    if (self.locationSW.isOn) {
                        newIn.latitude = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
                        newIn.longitude = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
                    }
                    [self.user addRecordObject:newIn];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
                if (self.record) {
                    [self.record MR_deleteEntity];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                    DetailViewController *detailVC = (DetailViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                    detailVC.myRecord = newRecord?newRecord:newIn;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
            
        }
            break;
        default:
        {
            if([self.mainRecordAmountLabel.text containsString:@"."]){
                NSRange ran = [self.mainRecordAmountLabel.text rangeOfString:@"."];
                if (self.mainRecordAmountLabel.text.length - ran.location <= 2) {
                    NSString *text = [NSString stringWithFormat:@"%ld",(long)sender.tag - 1000];
                    //[self.tempText insertText:text];
                    self.mainRecordAmountLabel.text = [NSString stringWithFormat:@"%@%@",self.mainRecordAmountLabel.text,text];
                }
            }else{
                NSString *text = [NSString stringWithFormat:@"%ld",(long)sender.tag - 1000];
                //[self.tempText insertText:text];
                if ([self.mainRecordAmountLabel.text doubleValue]==0) {
                    self.mainRecordAmountLabel.text = [NSString stringWithFormat:@"%@",text];
                }else{
                    self.mainRecordAmountLabel.text = [NSString stringWithFormat:@"%@%@",self.mainRecordAmountLabel.text,text];
                }
            }
            //self.mainRecordAmountLabel.text = self.tempText.text;
        }
            break;
    }
}

-(IBAction)showDatePicker:(id)sender
{
    
    self.picker = [[UIDatePicker alloc] init];
    self.picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.picker setDate:self.recordDate];
    [self.picker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
    self.picker.frame = CGRectMake(0.0,ScreenHeight - 250, pickerSize.width, 250);
    self.picker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.picker];
    [self.picker becomeFirstResponder];
}

-(void)dueDateChanged:(UIDatePicker *)sender {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
