//
//  MainVCTest.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/6/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MagicalRecord/MagicalRecord.h>


#import "MainPageViewModel.h"
#import "User.h"


@interface MainVCTest : XCTestCase
@property (nonatomic, strong) MainPageViewModel *mainModel;
@end

@interface MainPageViewModel (Test)
- (void)getRecordsFromUser:(User *)user;
@end

@implementation MainVCTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord cleanUp];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    User *user1 = [User MR_findFirstByAttribute:@"name" withValue:@"iPhone Simulator"];
    self.mainModel = [[MainPageViewModel alloc] initWithUser:user1];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [MagicalRecord cleanUp];
}

- (void)testUpdateRecord
{
    
    XCTAssertNotNil(self.mainModel.records,@"records not exist");
}

- (void)testSectionArray
{
    XCTAssertNotNil(self.mainModel.sectionArray,@"records section array not exist");
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
