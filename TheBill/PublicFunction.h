//
//  PublicFunction.h
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/12.
//  Copyright © 2016年 Zhenjiang Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+CoreDataProperties.h"
#import "User.h"

@interface PublicFunction : NSObject
+ (UIImage *)imageResize :(UIImage*)img resizeTo:(CGSize)newSize;
+ (NSString *)genderTypeToString:(GENDER)genderType;
+ (NSString *)recordTypeToString:(RECORD_TYPE)recordType;
+ (NSString *)convertToStringWithDate:(NSDate *)date;
+ (NSDate *)convertToDateWithString:(NSString *)dateString;
+ (NSString *)convertToMonthAndDateWith:(NSDate *)date;
+ (NSDate *)getDayFromDate:(NSDate *)date;
+ (NSDate *)getFirstDayInMonthByDate:(NSDate *)date;
+ (NSDate *)getLastDayInMonthByDate:(NSDate *)date;
+ (NSString *)getDayString:(NSDate *)date;
+ (UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius;
+ (BOOL)sameYear:(NSDate *)date1 date:(NSDate *)date2;
+ (BOOL)sameMonth:(NSDate *)date1 date:(NSDate *)date2;
+ (BOOL)sameDay:(NSDate *)date1 date:(NSDate *)date2;
+ (NSString *)getMonthNameWith:(NSDate *)date;
+ (NSMutableArray *)filterOutRecords:(NSMutableArray *)inputArray;
+ (NSMutableArray *)filterInRecords:(NSMutableArray *)inputArray;
+ (NSMutableArray *)prepareYearMonthDayDataWithYearArray:(NSMutableArray *)yearArray;
+ (NSMutableArray *)prepareYearArrayWith:(User *)user;
+ (NSMutableArray *)getLastWeekDates:(NSDate *)aDate;
@end
