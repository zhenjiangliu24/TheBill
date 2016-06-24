//
//  AppDelegate.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/10.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPageTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"TheBill"];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MODEL_HAS_PREFILL_DATA]) {
        
        [self initialModel];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MODEL_HAS_PREFILL_DATA];
        [[NSUserDefaults standardUserDefaults] setObject:SORT_USER_BY_NAME forKey:SORT_USER_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *root = [window rootViewController];
    
    UIStoryboard *storyboard = root.storyboard;
    MainPageTableViewController *mainVC =(MainPageTableViewController *) [storyboard instantiateViewControllerWithIdentifier:@"MainPage"];
    NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey:SORT_USER_KEY];
    NSArray *temp = [User MR_findAllSortedBy:sortKey ascending:YES];
    mainVC.user = [temp firstObject];
    
    return YES;
}

- (void)initialModel
{
    User *defaultUser = [User MR_createEntity];
    defaultUser.name = [[UIDevice currentDevice] name]?[[UIDevice currentDevice] name]:@"Default User";
    defaultUser.gender = [PublicFunction genderTypeToString:MALE];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"user-icon"]);
    defaultUser.image = imageData;
    
    OutRecord *cost1 = [OutRecord MR_createEntity];
    cost1.amount = @10;
    cost1.date = [NSDate date];
    cost1.note = @"Location not activated";
    cost1.user = defaultUser;
    cost1.recordType = [RecordTypeClothes MR_createEntity];
    cost1.recordType.name = [PublicFunction recordTypeToString:CLOTHES];
    cost1.recordType.icon = @"clothes";
    cost1.isOutCome = [NSNumber numberWithBool:YES];
    defaultUser.record = [NSSet setWithObject:cost1];
    
    ListRecordType *typeListOut = [ListRecordType MR_createEntity];
    typeListOut.isOut = [NSNumber numberWithBool:YES];
    RecordTypeAccommodation *accommodation = [RecordTypeAccommodation MR_createEntity];
    accommodation.name = [PublicFunction recordTypeToString:ACCOMMODATION];
    accommodation.icon = @"accommodation";
    RecordTypeBill *bill = [RecordTypeBill MR_createEntity];
    bill.name = [PublicFunction recordTypeToString:BILL];
    bill.icon = @"bill";
    RecordTypeBreakfast *breakfast = [RecordTypeBreakfast MR_createEntity];
    breakfast.name = [PublicFunction recordTypeToString:BREAKFAST];
    breakfast.icon = @"breakfast";
    RecordTypeCar *car = [RecordTypeCar MR_createEntity];
    car.name = [PublicFunction recordTypeToString:CAR];
    car.icon = @"car";
    RecordTypeClothes *clothes = [RecordTypeClothes MR_createEntity];
    clothes.name = [PublicFunction recordTypeToString:CLOTHES];
    clothes.icon = @"clothes";
    RecordTypeCosmetics *cosmetics = [RecordTypeCosmetics MR_createEntity];
    cosmetics.name = [PublicFunction recordTypeToString:COSMETICS];
    cosmetics.icon = @"cosmetics";
    RecordTypeDinner *dinner = [RecordTypeDinner MR_createEntity];
    dinner.name = [PublicFunction recordTypeToString:DINNER];
    dinner.icon = @"dinner";
    RecordTypeDrinks *drinks = [RecordTypeDrinks MR_createEntity];
    drinks.name = [PublicFunction recordTypeToString:DRINK];
    drinks.icon = @"drink";
    RecordTypeEat *eat = [RecordTypeEat MR_createEntity];
    eat.name = [PublicFunction recordTypeToString:EAT];
    eat.icon = @"eat";
    RecordTypeEducation *education = [RecordTypeEducation MR_createEntity];
    education.name = [PublicFunction recordTypeToString:EDUCATION];
    education.icon = @"education";
    RecordTypeFruit *fruit = [RecordTypeFruit MR_createEntity];
    fruit.name = [PublicFunction recordTypeToString:FRUIT];
    fruit.icon = @"fruit";
    RecordTypeInternet *internet = [RecordTypeInternet MR_createEntity];
    internet.name = [PublicFunction recordTypeToString:INTERNET];
    internet.icon = @"internet";
    RecordTypeLunch *lunch = [RecordTypeLunch MR_createEntity];
    lunch.name = [PublicFunction recordTypeToString:LUNCH];
    lunch.icon = @"lunch";
    RecordTypeMedical *medical = [RecordTypeMedical MR_createEntity];
    medical.name = [PublicFunction recordTypeToString:MEDICAL];
    medical.icon = @"medical";
    RecordTypePets *pets = [RecordTypePets MR_createEntity];
    pets.name = [PublicFunction recordTypeToString:PETS];
    pets.icon = @"pets";
    RecordTypePhone *phone = [RecordTypePhone MR_createEntity];
    phone.name = [PublicFunction recordTypeToString:PHONE];
    phone.icon = @"phone";
    RecordTypeShopping *shopping = [RecordTypeShopping MR_createEntity];
    shopping.name = [PublicFunction recordTypeToString:SHOPPING];
    shopping.icon = @"shopping";
    RecordTypeTransportation *transportation = [RecordTypeTransportation MR_createEntity];
    transportation.name = [PublicFunction recordTypeToString:TRANSPORTATION];
    transportation.icon = @"transportation";
    NSArray *array = @[accommodation,bill,breakfast,car,clothes,cosmetics,drinks,dinner,eat,education,fruit,internet,lunch,medical,pets,phone,shopping,transportation];
    typeListOut.recordType = [NSSet setWithArray:array];
    
    ListRecordType *typeListIn = [ListRecordType MR_createEntity];
    typeListIn.isOut = @NO;
    RecordTypeSalary *salary = [RecordTypeSalary MR_createEntity];
    salary.name = [PublicFunction recordTypeToString:SALARY];
    salary.icon = @"salary";
    NSArray *inArray = @[salary];
    typeListIn.recordType = [NSSet setWithArray:inArray];
    
    //save to data base
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearDisk];
    [imageCache clearMemory];
}

@end
