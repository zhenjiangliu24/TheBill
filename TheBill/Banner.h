//
//  Banner.h
//  TabViewHeader
//
//  Created by Zhenjiang Liu on 16/5/11.
//  Copyright © 2016年 oubuy·luo. All rights reserved.
//

@interface Banner : UIView
@property (assign, nonatomic) CGPoint offsetPoint;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *TotalOutLabel;
@property (nonatomic) UILabel *MonthInComeLabel;
@property (nonatomic) UILabel *MonthOutComeLabel;
@property (nonatomic) UILabel *MonthInDetailLabel;
@property (nonatomic) UILabel *MonthOutDetailLabel;

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *totalOutString;
@property (nonatomic, copy) NSString *monthInComeString;
@property (nonatomic, copy) NSString *monthInDetailString;
@property (nonatomic, copy) NSString *monthOutComeString;
@property (nonatomic, copy) NSString *monthOutDetailString;

@property (nonatomic) UIButton *menuButton;
@property (nonatomic) UIButton *calendarButton;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setLabel:(UILabel *)label WithTitle:(NSString *)string;
- (void)setTotalOutLabelWithTitle:(NSString *)string;
@end
