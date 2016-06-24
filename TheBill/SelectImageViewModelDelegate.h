//
//  SelectImageViewModelDelegate.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/29.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

@class SelectImageViewModel;
@protocol SelectImageViewModelDelegate;

@protocol SelectImageViewModelProtocol <NSObject>
@property (nonatomic, weak) id<SelectImageViewModelDelegate> delegate;
@end

@protocol SelectImageViewModelDelegate <NSObject>
@optional
- (void)selectImageViewModel:(id<SelectImageViewModelProtocol>)model didReceivePhotos:(NSArray *)photos;
@end
