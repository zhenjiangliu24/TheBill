//
//  UIView+ZJLTagView.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/6/3.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "UIView+ZJLTagView.h"

@implementation UIView (ZJLTagView)
- (CGFloat)ZJL_Left
{
    return CGRectGetMinX(self.frame);
}

- (void)setZJL_Left:(CGFloat)ZJL_Left
{
    CGRect frame = self.frame;
    frame.origin.x = ZJL_Left;
    frame.size.width = MAX(self.ZJL_Right-ZJL_Left, 0);
    self.frame = frame;
}

- (CGFloat)ZJL_Top
{
    return CGRectGetMinY(self.frame);
}

- (void)setZJL_Top:(CGFloat)ZJL_Top
{
    CGRect frame = self.frame;
    frame.origin.y = ZJL_Top;
    frame.size.height = MAX(self.ZJL_Top-ZJL_Top, 0);
    self.frame = frame;
}

- (CGFloat)ZJL_Right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setZJL_Right:(CGFloat)ZJL_Right
{
    CGRect frame = self.frame;
    frame.size.width = MAX(ZJL_Right-self.ZJL_Left, 0);
    self.frame = frame;
}

- (CGFloat)ZJL_Bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setZJL_Bottom:(CGFloat)ZJL_Bottom
{
    CGRect frame = self.frame;
    frame.size.height = MAX(ZJL_Bottom-self.ZJL_Top, 0);
    self.frame = frame;
}

- (CGFloat)ZJL_Width
{
    return self.frame.size.width;
}

- (void)setZJL_Width:(CGFloat)ZJL_Width
{
    CGRect frame = self.frame;
    frame.size.width = ZJL_Width;
    self.frame = frame;
}

- (CGFloat)ZJL_Height
{
    return self.frame.size.height;
}

- (void)setZJL_Height:(CGFloat)ZJL_Height
{
    CGRect frame = self.frame;
    frame.size.height = ZJL_Height;
    self.frame = frame;
}
@end
