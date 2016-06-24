//
//  Banner.m
//  TabViewHeader
//
//  Created by Zhenjiang Liu on 16/5/11.
//  Copyright © 2016年 oubuy·luo. All rights reserved.
//

#import "Banner.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define HeadImgHeight 180
//title icon
//float const TITLE_WIDTH = 100;
//float const TITLE_HEIGHT = 30;
float const TITLE_TOP_MARGIN = 15;
//total cost icon
//float const TOTAL_OUT_WIDTH = 50;
//float const TOTAL_OUT_HEIGHT = 40;
float const TOTAL_OUT_TOP_MARGIN = 40;
//calendar icon
float const CALENDAR_RIGHT_MARGIN = 35;
float const CALENDAR_TOP_MARGIN = 15;
float const CALENDAR_WIDTH = 25;
float const CALENDAR_HEIGHT = 25;



//center line length
float const LINE_LENGTH = 50;
@interface Banner()


@end

@implementation Banner
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = APP_MAIN_COLOR;
    
    self.menuButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.menuButton.frame= CGRectMake(15, 15, 30, 30);
    UIImage *img = [PublicFunction imageResize:[UIImage imageNamed:@"user"] resizeTo:CGSizeMake(30, 30)];
    [self.menuButton setTintColor:[UIColor whiteColor]];
    [self.menuButton setImage:img forState:UIControlStateNormal];
    [self.menuButton setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:self.menuButton];
    
    self.calendarButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.calendarButton.frame= CGRectMake(ScreenWidth - CALENDAR_RIGHT_MARGIN,CALENDAR_TOP_MARGIN, CALENDAR_WIDTH, CALENDAR_HEIGHT);
    UIImage *img2 = [PublicFunction imageResize:[UIImage imageNamed:@"calendar"] resizeTo:CGSizeMake(CALENDAR_WIDTH, CALENDAR_HEIGHT)];
    [self.calendarButton setTintColor:[UIColor whiteColor]];
    [self.calendarButton setImage:img2 forState:UIControlStateNormal];
    [self.calendarButton setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:self.calendarButton];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.TotalOutLabel];
    
    self.MonthInComeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_ICON_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    self.MonthInComeLabel.textAlignment = NSTextAlignmentCenter;
    [self setLabel:self.MonthInComeLabel WithTitle:@"Month in"];
    [self addSubview:self.MonthInComeLabel];
    
    self.MonthInDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_DETAIL_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    self.MonthInDetailLabel.textAlignment = NSTextAlignmentCenter;
    [self setLabel:self.MonthInDetailLabel WithTitle:@"Month detail"];
    [self addSubview:self.MonthInDetailLabel];
    
    self.MonthOutComeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*3/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_ICON_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    self.MonthOutComeLabel.textAlignment = NSTextAlignmentCenter;
    [self setLabel:self.MonthOutComeLabel WithTitle:@"Month out"];
    [self addSubview:self.MonthOutComeLabel];
    
    self.MonthOutDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*3/4 - TITLE_WIDTH/2, HeadImgHeight-MONTH_DETAIL_BOTTOM_MARGIN-TOTAL_OUT_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    self.MonthOutDetailLabel.textAlignment = NSTextAlignmentCenter;
    [self setLabel:self.MonthOutDetailLabel WithTitle:@"Month detail"];
    [self addSubview:self.MonthOutDetailLabel];
    
    return self;
}

- (UILabel *)TotalOutLabel
{
    if (!_TotalOutLabel) {
        _TotalOutLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-TOTAL_OUT_WIDTH)/2, TOTAL_OUT_TOP_MARGIN, TOTAL_OUT_WIDTH, TOTAL_OUT_HEIGHT)];
        _TotalOutLabel.textAlignment = NSTextAlignmentCenter;
        if ([_TotalOutLabel respondsToSelector:@selector(setAttributedText:)]) {
            NSString *string = @"0";
            [self setTotalOutLabelWithTitle:string];
        }
    }
    
    return _TotalOutLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-TITLE_WIDTH)/2, TITLE_TOP_MARGIN, TITLE_WIDTH, TITLE_HEIGHT)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([_titleLabel respondsToSelector:@selector(setAttributedText:)]) {
            NSString *string = @"User";
            [self setLabel:_titleLabel WithTitle:string];
        }
    }
    
    return _titleLabel;
}

- (NSAttributedString *)getAttributeStringWith:(NSString *)string andSize:(float)size
{
    UIFont *boldFont = [UIFont fontWithName:FONT_NAME size:size];
    // Define your regular font
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrString setAttributes:@{ NSFontAttributeName: boldFont } range:NSMakeRange(0, [string length])];
    
    // Sets the font color of last four characters to green.
    [attrString addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0, [string length])];
    return attrString;
}


- (void)setLabel:(UILabel *)label WithTitle:(NSString *)string
{
    if ([label respondsToSelector:@selector(setAttributedText:)]){
        [label setAttributedText:[self getAttributeStringWith:string andSize:15.0]];
    }else{
        label.text = string;
    }
}

- (void)setTotalOutLabelWithTitle:(NSString *)string
{
    if ([self.TotalOutLabel respondsToSelector:@selector(setAttributedText:)]) {
        [self.TotalOutLabel setAttributedText:[self getAttributeStringWith:string andSize:30.0]];
    }else{
        self.TotalOutLabel.text = string;
    }
}

- (void)userInfoButtonAction
{
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextMoveToPoint(context, self.offsetPoint.x, self.offsetPoint.y); //start at this point
    
    CGContextAddLineToPoint(context, self.offsetPoint.x, self.offsetPoint.y-LINE_LENGTH); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
    
    
}

@end
