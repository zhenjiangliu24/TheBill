//
//  Constants.h
//  ThatDayUniversal
//
//  Created by Zhenjiang Liu on 16/4/29.
//  Copyright © 2016年 Zhenjiang Liu. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
//banner height

/* Constants.h */
#define APP_MAIN_COLOR [UIColor colorWithRed:224.0/255.0 green:102.0/255.0 blue:84.0/255.0 alpha:1.0]
extern float const HeadImgHeight;
//banner title
extern float const TITLE_WIDTH;
extern float const TITLE_HEIGHT;
//banner total cost icon
extern float const TOTAL_OUT_WIDTH;
extern float const TOTAL_OUT_HEIGHT;
//banner month icon and detail
extern float const MONTH_ICON_BOTTOM_MARGIN;
extern float const MONTH_DETAIL_BOTTOM_MARGIN;
//banner flexible distance
extern float const BANNER_FLEXIBLE_LENGTH;

extern NSString *const FONT_NAME;

//core data
extern NSString *const MODEL_HAS_PREFILL_DATA;

extern NSString *const SORT_USER_KEY;
extern NSString *const SORT_USER_BY_NAME;

extern NSString *const SORT_RECORD_KEY;
extern NSString *const SORT_RECORD_BY_COST;
extern NSString *const SORT_RECORD_BY_NAME;
extern NSString *const SORT_RECORD_BY_DATE;

extern float const RECORD_CELL_ICON_WIDTH;
extern float const RECORD_CELL_ICON_HEIGHT;

//main tool bar add record button
extern float const ADD_RECORD_BUTTON_WIDTH;
extern float const ADD_RECORD_BUTTON_HEIGHT;

//side bar
extern float const SIDE_USER_IMG_WIDTH;
extern float const SIDE_USER_IMG_HEIGHT;

//statistic
extern float const STA_CELL_HEIGHT;

extern float const STA_MONTH_WIDTH;
extern float const STA_MONTH_HEIGHT;

extern float const STA_IN_WIDTH;
extern float const STA_IN_HEIGHT;

extern float const STA_NUM_WIDTH;
extern float const STA_NUM_HEIGHT;

#endif /* Constants_h */
typedef NS_ENUM(NSInteger,RECORD_TYPE)
{
    BILL,SHOPPING,LUNCH,COSMETICS,CLOTHES,ACCOMMODATION,DRINK,TRANSPORTATION,
    CAR,MEDICAL,PHONE,EAT,EDUCATION,BREAKFAST,FRUIT,INTERNET,PETS,DINNER,SALARY
};

typedef NS_ENUM(NSInteger, GENDER){
    MALE,FEMALE
};

typedef NS_ENUM(NSInteger,IN_OIT_RECORD){
    INRECORD,OUTRECORD
};

typedef NS_ENUM(NSInteger,TagStateType){
    
    //正常状态（不可点击，单单显示）
    TagStateNormal = 0,
    
    //编辑转态
    TagStateEdit,
    
    //选择状态
    TagStateSelect
    
};