//
//  ZJLTagListView.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/6/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ZJLConstants.h"
@class ZJLTagListView;
@protocol ZJLTagListViewDelegate <NSObject>
@required
- (void)tagView:(ZJLTagListView *)tagView clickedTagAtIndex:(NSInteger)index;
@optional
- (void)tagViewDidChangeType;
@end

@protocol ZJLTagListViewObject<NSObject>
- (NSString *)tagName;
@end

@interface ZJLTagListView : UIView
@property (nonatomic, weak) id<ZJLTagListViewDelegate> delegate;
@property (assign) float tagFont;
@property (nonatomic, assign) float tagCornerRadius;
@property (nonatomic, assign) float tagBorderWidth;

@property (nonatomic, strong) UIColor *tagViewBackgroundColor;
@property (nonatomic, strong) UIColor *tagLabelBackgroundColor;
@property (nonatomic, strong) UIColor *tagLabelBorderColor;
@property (nonatomic, strong) UIColor *tagTextColor;

@property (nonatomic) NSTextAlignment tagTextAlign;
@property (nonatomic, assign) ZJLTAGTYPE tagViewType;
@property (nonatomic, assign) BOOL is_can_add;

@property (nonatomic, copy) NSArray *tagList;

- (void)reloadData:(NSArray *)array andTime:(float)time;
- (void)createTagViewWith:(NSArray *)tagList;
@end
