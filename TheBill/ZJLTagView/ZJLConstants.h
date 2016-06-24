//
//  ZJLConstants.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/6/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#ifndef ZJLConstants_h
#define ZJLConstants_h
typedef NS_ENUM(NSInteger, ZJLTAGTYPE){
    ZJLTAGNORMAL,
    ZJLTAGEDIT,
    ZJLTAGSELECT
};

extern float const k_ZJLTag_Padding_Vertical;
extern float const k_ZJLTag_Padding_Horizontal;

extern float const k_ZJLTag_Margin_Vertical;
extern float const k_ZJLTag_Margin_Horizontal;

extern NSUInteger const k_ZJLTag_LabelTag;
extern NSUInteger const k_ZJLTag_ButtonTag;

extern float const k_ZJLTag_Default_TagCornerRadius;
extern float const k_ZJLTag_Default_TagTextFont;

extern float const k_ZJLTag_DeleteImageWidth;

#define ZJL_ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ZJL_ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#endif /* ZJLConstants_h */
