//
//  User+CoreDataProperties.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Record *> *record;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRecordObject:(Record *)value;
- (void)removeRecordObject:(Record *)value;
- (void)addRecord:(NSSet<Record *> *)values;
- (void)removeRecord:(NSSet<Record *> *)values;

@end

NS_ASSUME_NONNULL_END
