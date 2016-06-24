//
//  SelectImageModelTest.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/6/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SelectImageViewModel.h"

@interface SelectImageModelTest : XCTestCase
@property (nonatomic, strong) SelectImageViewModel *selectModel;
@end

@implementation SelectImageModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.selectModel = [[SelectImageViewModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadPicture
{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Long method"];
    [self.selectModel loadPhotos:0 completionHandler:^{
        XCTAssertNotNil(self.selectModel.photos,@"photo nil");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testPerformanceLoadPhoto
{
    [self measureBlock:^{
        [self.selectModel loadPhotos:0 completionHandler:^{
            
        }];
    }];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
