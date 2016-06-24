//
//  ZJLTagListView.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/6/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLTagListView.h"
#import "UIView+ZJLTagView.h"


@interface ZJLTagListView(){
    CGRect previousFrame;
    CGFloat viewHeight;
    NSUInteger tagIndex;
}
@end

@implementation ZJLTagListView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        self.frame = frame;
    }
    return self;
}

- (void)createTagViewWith:(NSArray *)tagList
{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:tagList];
    if(self.tagViewType == ZJLTAGNORMAL){
        [temp addObject:@"Edit"];
    }else if (self.tagViewType == ZJLTAGEDIT){
        [temp addObject:@"Done"];
    }
    self.tagList = [temp copy];
    self.backgroundColor = self.tagViewBackgroundColor?self.tagViewBackgroundColor:[UIColor whiteColor];
    
    viewHeight = 0;
    previousFrame = CGRectZero;
    [self.tagList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableString *title = [NSMutableString stringWithString:self.tagViewType==ZJLTAGEDIT?@"  ":@""];
        if([obj conformsToProtocol:@protocol(ZJLTagListViewObject)]){
            if([obj respondsToSelector:@selector(tagName)]){
                [title appendString:[obj tagName]];
            }
        }else if ([obj isKindOfClass:[NSString class]]){
            [title appendString:obj];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        [self initializeUIWithLabel:label];
        label.text = title;
        label.tag = k_ZJLTag_LabelTag + idx;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:self.tagFont?self.tagFont:k_ZJLTag_Default_TagTextFont]};
        CGSize size = [title sizeWithAttributes:attributes];
        size.width += k_ZJLTag_Margin_Horizontal*2;
        size.height += k_ZJLTag_Margin_Vertical*2;
        
        CGRect labelRect = CGRectZero;
        labelRect.size = size;
        
        if(previousFrame.origin.x+previousFrame.size.width+k_ZJLTag_Padding_Horizontal+size.width>ZJL_ScreenWidth){
            labelRect.origin.x = k_ZJLTag_Margin_Horizontal;
            labelRect.origin.y = previousFrame.origin.y+previousFrame.size.height+k_ZJLTag_Padding_Vertical;
            viewHeight += size.height+k_ZJLTag_Padding_Vertical;
        }else{
            labelRect.origin.x = previousFrame.origin.x+previousFrame.size.width+k_ZJLTag_Padding_Horizontal;
            labelRect.origin.y = previousFrame.origin.y;
        }
        [label setFrame:labelRect];
        previousFrame = labelRect;
        
        if (idx == self.tagList.count-1) {
            __weak ZJLTagListView *weakSelf = self;
            [UIView animateWithDuration:0.0 animations:^{
                CGRect temp = weakSelf.frame;
                temp.size.height += labelRect.size.height+k_ZJLTag_Padding_Vertical;
                weakSelf.frame = temp;
            }];
        }
        [self addSubview:label];
        
        
        if (self.tagViewType==ZJLTAGEDIT&&idx!=self.tagList.count-1) {
            UIImageView *deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(label.ZJL_Right-k_ZJLTag_DeleteImageWidth*1.5, label.ZJL_Top+(label.ZJL_Height-k_ZJLTag_DeleteImageWidth)/2, k_ZJLTag_DeleteImageWidth, k_ZJLTag_DeleteImageWidth)];
            deleteImageView.image = [UIImage imageNamed:@"zjl_removeButton"];
            [self addSubview:deleteImageView];
        }
        
        
        UIButton *labelButton = [[UIButton alloc]initWithFrame:labelRect];
        [labelButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        labelButton.tag = k_ZJLTag_ButtonTag + idx;
        [self addSubview:labelButton];
    }];
    
}

- (void)initializeUIWithLabel:(UILabel *)label
{
    label.backgroundColor = self.tagLabelBackgroundColor?self.tagLabelBackgroundColor:[UIColor whiteColor];
    label.textColor = self.tagTextColor?self.tagTextColor:[UIColor blackColor];
    label.layer.borderColor = self.tagLabelBorderColor?self.tagLabelBorderColor.CGColor:[UIColor blackColor].CGColor;
    label.font = [UIFont systemFontOfSize:self.tagFont?self.tagFont:k_ZJLTag_Default_TagTextFont];
    label.layer.cornerRadius = self.tagCornerRadius?self.tagCornerRadius:k_ZJLTag_Default_TagCornerRadius;
    label.layer.borderWidth = self.tagBorderWidth?self.tagBorderWidth:1.0;
    label.textAlignment = self.tagViewType==ZJLTAGEDIT?NSTextAlignmentLeft:NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.clipsToBounds = YES;
}

- (void)clickButton:(UIButton *)button
{
    tagIndex = button.tag - k_ZJLTag_ButtonTag;
    if(tagIndex == self.tagList.count-1){
        if([self.delegate respondsToSelector:@selector(tagViewDidChangeType)]){
            if(self.tagViewType == ZJLTAGNORMAL){
                self.tagViewType = ZJLTAGEDIT;
            }else{
                self.tagViewType = ZJLTAGNORMAL;
            }
            [self.delegate tagViewDidChangeType];
        }
    }else{
        if(self.tagViewType == ZJLTAGNORMAL){
            if([self.delegate respondsToSelector:@selector(tagView:clickedTagAtIndex:)]){
                [self.delegate tagView:self clickedTagAtIndex:tagIndex];
            }
        }else if(self.tagViewType == ZJLTAGEDIT){
            if([self.delegate respondsToSelector:@selector(tagView:clickedTagAtIndex:)]){
                [self.delegate tagView:self clickedTagAtIndex:tagIndex];
            }
        }
    }
    
}

- (void)reloadData:(NSArray *)array andTime:(float)time
{
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [UIView animateWithDuration:time animations:^{
            self.alpha = 1;
            [self createTagViewWith:array];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [self createTagViewWith:array];
            //            });
        }];
    }];
}
@end
