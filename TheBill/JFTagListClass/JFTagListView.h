//
//  JFTagListView.h
//  JFTagListView
//
//  Created by Zhenjiang Liu on 15/11/30.
//  Copyright © 2015年 Zhenjiang Liu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JFTagListView;



@protocol JFTagListDelegate <NSObject>

@optional

-(void)tagList:(JFTagListView *)taglist heightForView:(float)listHeight;

-(void)showAddTagView;

@required

-(void)tagList:(JFTagListView *)taglist clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface JFTagListView : UIView



@property (nonatomic, strong) UIColor *tagViewBackgroundColor;

@property (nonatomic, strong) NSMutableArray *tagArr;

@property (nonatomic, strong) NSString *tagArrkey;

@property (nonatomic, assign) float tagFont;

@property (nonatomic, strong) UIColor *tagTextColor;

@property (nonatomic, strong) UIColor *tagBackgroundColor;

@property (nonatomic) NSTextAlignment tagTextAlignment;

@property (nonatomic, assign) float tagCornerRadius;

@property (nonatomic, assign) float tagBorderWidth;

@property (nonatomic, strong) UIColor *tagBorderColor;

@property (nonatomic, assign) TagStateType tagStateType;

@property (nonatomic, assign) BOOL is_can_addTag;

@property (nonatomic, strong) NSString *addTagStr;


@property (nonatomic, strong) id<JFTagListDelegate>delegate;

- (void)creatUI:(NSMutableArray *)tagArr;

- (void)reloadData:(NSMutableArray *)newTagArr;

- (void)reloadData:(NSMutableArray *)newTagArr andTime:(float)time;


@end

