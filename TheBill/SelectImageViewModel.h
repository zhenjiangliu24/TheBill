//
//  SelectImageViewModel.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/25.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "BaseViewModel.h"
#import "SelectImageViewModelDelegate.h"

static NSString *const CUSTOMER_KEY = @"LwZJMoTshZ8frYTpxrdScE1wbThBibCs8HjKR32I";

@interface SelectImageViewModel : BaseViewModel<SelectImageViewModelProtocol>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, assign) NSInteger maxPages;

@property (nonatomic, readonly, copy) NSArray *photos;

@property (nonatomic, assign) NSNumber *selected;

@property (nonatomic, weak) id<SelectImageViewModelDelegate> delegate;

- (void)loadPhotos:(NSInteger)page completionHandler:(void(^)())completion;
- (NSInteger)getTableViewCellsNumber;
@end
