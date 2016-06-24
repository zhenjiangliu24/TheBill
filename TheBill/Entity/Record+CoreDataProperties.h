//
//  Record+CoreDataProperties.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Record.h"

NS_ASSUME_NONNULL_BEGIN

@interface Record (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) RecordType *recordType;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
