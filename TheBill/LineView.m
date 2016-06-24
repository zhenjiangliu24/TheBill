//
//  LineView.m
//  Line
//
//  Created by Zhenjiang Liu on 16/4/20.
//  Copyright © 2016年 Zhenjiang Liu. All rights reserved.
//

#import "LineView.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface LineView(){
    CGFloat xWidth;
    CGFloat yHeight;
    double max_Y_value;
    double single_Y_value;
    
}

@end

@implementation LineView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        xWidth = self.bounds.size.width / 8;
        yHeight = self.bounds.size.height / 7;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self getMaxY];
    [self drawLine];
    [self drawCoordinate];
}

- (void)getMaxY
{
    double tempY = 0;
    for (NSValue *value in self.dataArray) {
        CGPoint point = [value CGPointValue];
        if (tempY<point.y) {
            tempY = point.y;
        }
    }
    max_Y_value = tempY;
    single_Y_value = floor(max_Y_value/4)+1 ;
}

- (void)drawCoordinate {
    CGContextRef currentCtx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentCtx, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(currentCtx, 0.5f);
    CGPoint points[] = {CGPointMake(20, 0),CGPointMake(20, self.bounds.size.height - 20),CGPointMake(self.bounds.size.width, self.bounds.size.height - 20)};
    CGContextAddLines(currentCtx, points, 3);
    CGContextStrokePath(currentCtx);
    
}


- (CGPoint)getPointWithPoint:(CGPoint)point {
    return  CGPointMake(20 + point.x * xWidth, self.bounds.size.height - 30 - point.y * 20/single_Y_value);/////yy  changed
}

- (void)drawLine {
    
    CGPoint points[20] = {0};
    for (int i = 0; i < self.dataArray.count; i++) {
        points[i] = [self getPointWithPoint:[self.dataArray[i] CGPointValue]];
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < self.dataArray.count; i++) {
        if (i == 0) {
            [path moveToPoint:points[0]];
        }
        else {
            [path addLineToPoint:points[i]];
        }
    }
    [self setXAndYValue];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 0.5f;
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = nil;
    [self.layer addSublayer:shapeLayer];
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.duration = 1.0;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    baseAnimation.fromValue = @0.0;
    baseAnimation.toValue = @1.0;
    [shapeLayer addAnimation:baseAnimation forKey:@"strokeEndAnimation"];
}

- (void)setXAndYValue {
    
    UILabel *baseLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 200, 20)];
    baseLabel.font = [UIFont systemFontOfSize:11.0f];
    baseLabel.text = @"Dollar";
    baseLabel.textColor = RGBA(171, 171, 171, 1.0);
    baseLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:baseLabel];
    
    //x
    NSArray *arr = [self getTodayAndTommorrowDay:[NSDate date]];
    for (int i = 0; i < 8; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.bounds = CGRectMake(0, 0, xWidth, 10);
        label.center = CGPointMake((7 - i) * xWidth + 20, 190);//point
        label.font = [UIFont systemFontOfSize:10.0];
        label.textColor = RGBA(171, 171, 171, 1.0);
        label.text = arr[i];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        //x aix mark
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20 + xWidth * i, 175,0.5, 5)];
        view.backgroundColor = RGBA(171, 171, 171, 1.0);
        [self addSubview:view];
    }
    
    //y
    for (int i = 0; i < 8; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.bounds = CGRectMake(0, 0, 20, 20);
        label.center = CGPointMake(10, self.bounds.size.height - 30 - 20 * i);
        label.font = [UIFont systemFontOfSize:10.0];
        label.textColor = RGBA(171, 171, 171, 1.0);
        label.textAlignment = NSTextAlignmentCenter;
        label.contentMode = UIViewContentModeCenter;
        label.text = [NSString stringWithFormat:@"%.f",i*single_Y_value];  ////changed
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, self.bounds.size.height - 30 - 20 * i, 5,0.5)];///////
        view.backgroundColor = RGBA(171, 171, 171, 1.0);
        [self addSubview:view];
        [self addSubview:label];
    }
}

- (NSMutableArray *)getTodayAndTommorrowDay:(NSDate *)aDate {
    NSMutableArray *returnArr = [NSMutableArray array];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componets = [gregorian components:NSCalendarUnitWeekOfMonth | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    NSDateFormatter *dateDay = [[NSDateFormatter alloc] init];
    [dateDay setDateFormat:@"MM-dd"];
    for (int i = 0; i < 8; i++) {
        [componets setDay:([componets day])];
        NSDate *mydate = [gregorian dateFromComponents:componets];
        [returnArr addObject:[dateDay stringFromDate:mydate]];
        [componets setDay:([componets day]-1)];
    }
    return returnArr;
}

@end
