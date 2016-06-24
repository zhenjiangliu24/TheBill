//
//  PublicFunction.m
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/12.
//  Copyright © 2016年 Zhenjiang Liu. All rights reserved.
//

#import "PublicFunction.h"

@implementation PublicFunction
+(UIImage *)imageResize :(UIImage*)img resizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)genderTypeToString:(GENDER)genderType
{
    NSString *genderString = nil;
    switch (genderType) {
        case MALE:
            genderString = @"MALE";
            break;
        case FEMALE:
            genderString = @"FEMALE";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected GenderType."];
            break;
    }
    return genderString;
}

+ (NSString *)convertToStringWithDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *string = [format stringFromDate:date];
    return string;
}

+ (NSDate *)convertToDateWithString:(NSString *)dateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [format dateFromString:dateString];
    return date;
}

+ (NSString *)getDayString:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [format stringFromDate:date];
    return string;
}

+ (NSDate *)getDayFromDate:(NSDate *)date
{
    NSString *dateString = [PublicFunction getDayString:date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *dayDate = [format dateFromString:dateString];
    return dayDate;
}

+ (NSString *)getMonthNameWith:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSString *monthName = [[format monthSymbols] objectAtIndex:[components month]-1];
    return monthName;
}

+ (NSDate *)getFirstDayInMonthByDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    components.day = 1;
    NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: components];
    return firstDayOfMonthDate;
}

+ (NSDate *)getLastDayInMonthByDate:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:date]; // Get necessary date components
    
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *lastDateMonth = [calendar dateFromComponents:comps];
    return lastDateMonth;
}

+ (BOOL)sameYear:(NSDate *)date1 date:(NSDate *)date2
{
    NSDateComponents *first = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
    NSDateComponents *second = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
    if([first year] == [second year]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)sameMonth:(NSDate *)date1 date:(NSDate *)date2
{
    NSDateComponents *first = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
    NSDateComponents *second = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
    if([first year] == [second year] && [first month] == [second month]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)sameDay:(NSDate *)date1 date:(NSDate *)date2
{
    NSDateComponents *first = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
    NSDateComponents *second = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
    if([first year] == [second year] && [first month] == [second month] && [first day] == [second day]) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)convertToMonthAndDateWith:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd"];
    NSString *string = [format stringFromDate:date];
    return string;
}

+ (UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    imageLayer.borderWidth = 2.0;
    imageLayer.borderColor = APP_MAIN_COLOR.CGColor;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

+ (NSMutableArray *)filterOutRecords:(NSMutableArray *)inputArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Record *record in inputArray) {
        if ([record isKindOfClass:[OutRecord class]]) {
            [array addObject:record];
        }
    }
    return array;
}

+ (NSMutableArray *)prepareYearArrayWith:(User *)user
{
    NSArray *recordsTemp = [user.record allObjects];
    if (recordsTemp.count == 0) {
        return [NSMutableArray array];
    }
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptor = [NSArray arrayWithObject:sort];
    NSArray *sorted = [recordsTemp sortedArrayUsingDescriptors:sortDescriptor];
    NSMutableArray *records = [NSMutableArray arrayWithArray:sorted];
    NSMutableArray *yearArray;
    int section = 0;
    yearArray = [[NSMutableArray alloc] initWithObjects:[NSMutableArray new], nil];
    if (records.count == 1) {
        NSMutableArray *firstY = yearArray.firstObject;
        [firstY addObject:records.firstObject];
    }else if(records.count>1){
        for (int index = 0; index<records.count-1; index++) {
            Record *firstR = records[index];
            Record *secondR = records[index+1];
            NSMutableArray *year = yearArray[section];
            if (![year containsObject:firstR]) {
                [year addObject:firstR];
            }
            if ([PublicFunction sameYear:firstR.date date:secondR.date]) {
                [year addObject:secondR];
            }else{
                NSMutableArray *newArray = [NSMutableArray arrayWithObject:secondR];
                [yearArray addObject:newArray];
                section++;
            }
        }
    }
    return yearArray;
}

+ (NSMutableArray *)prepareYearMonthDayDataWithYearArray:(NSMutableArray *)yearArray
{
    int yearNumber = 0;
    NSMutableArray *data;
    data = [[NSMutableArray alloc] init];
    for (int yearIndex = 0; yearIndex<yearArray.count; yearIndex++) {
        NSMutableArray *array = yearArray[yearIndex];
        Record *only = array.firstObject;
        if (array.count == 1) {
            NSMutableArray *monthArray = [NSMutableArray arrayWithObject:only];
            data[yearNumber] = [NSMutableArray arrayWithObject:monthArray];
        }else{
            NSMutableArray *yearArray = [[NSMutableArray alloc]initWithObjects:[NSMutableArray new], nil];
            int monthCount = 0;
            for (int index = 0; index<array.count-1; index++) {
                Record *record1 = array[index];
                Record *record2 = array[index+1];
                NSMutableArray *mArray = yearArray[monthCount];
                if (![mArray containsObject:record1]) {
                    [mArray addObject:record1];
                }
                if ([PublicFunction sameMonth:record1.date date:record2.date]) {
                    [mArray addObject:record2];
                }else{
                    NSMutableArray *newArray = [NSMutableArray arrayWithObject:record2];
                    [yearArray addObject:newArray];
                    monthCount++;
                }
            }
            [data addObject:yearArray];
        }
        yearNumber++;
    }
    return data;
}

+ (NSMutableArray *)filterInRecords:(NSMutableArray *)inputArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Record *record in inputArray) {
        if ([record isKindOfClass:[InRecord class]]) {
            [array addObject:record];
        }
    }
    return array;
}

+ (NSMutableArray *)getLastWeekDates:(NSDate *)aDate
{
    NSMutableArray *returnArr = [NSMutableArray array];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componets = [gregorian components:NSCalendarUnitWeekOfMonth | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    NSDateFormatter *dateDay = [[NSDateFormatter alloc] init];
    [dateDay setDateFormat:@"yyyy-MM-dd"];
    for (int i = 1; i < 8; i++) {
        [componets setDay:([componets day])];
        NSDate *mydate = [gregorian dateFromComponents:componets];
        [returnArr addObject:[dateDay stringFromDate:mydate]];
        [componets setDay:([componets day] - 1)];
    }
    return returnArr;
}


+ (NSString *)recordTypeToString:(RECORD_TYPE)recordType
{
    NSString *recordString = nil;
    switch (recordType) {
        case BILL:
            recordString = @"Bill";
            break;
        case SHOPPING:
            recordString = @"Shopping";
            break;
        case LUNCH:
            recordString = @"Lunch";
            break;
        case COSMETICS:
            recordString = @"Cosmetics";
            break;
        case CLOTHES:
            recordString = @"Clothes";
            break;
        case ACCOMMODATION:
            recordString = @"Accommodation";
            break;
        case DRINK:
            recordString = @"Drink";
            break;
        case TRANSPORTATION:
            recordString = @"Transportation";
            break;
        case CAR:
            recordString = @"Car";
            break;
        case MEDICAL:
            recordString = @"Medical";
            break;
        case PHONE:
            recordString = @"Phone";
            break;
        case EAT:
            recordString = @"Eat";
            break;
        case EDUCATION:
            recordString = @"Education";
            break;
        case BREAKFAST:
            recordString = @"Breakfast";
            break;
        case FRUIT:
            recordString = @"Fruit";
            break;
        case INTERNET:
            recordString = @"Internet";
            break;
        case PETS:
            recordString = @"Pets";
            break;
        case DINNER:
            recordString = @"Dinner";
            break;
        case SALARY:
            recordString = @"Salary";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected RecordType."];
            break;
    }
    return recordString;
}
@end
