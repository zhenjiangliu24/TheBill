//
//  ListRecordType+CoreDataProperties.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ListRecordType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListRecordType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isOut;
@property (nullable, nonatomic, retain) NSSet<RecordType *> *recordType;

@end

@interface ListRecordType (CoreDataGeneratedAccessors)

- (void)addRecordTypeObject:(RecordType *)value;
- (void)removeRecordTypeObject:(RecordType *)value;
- (void)addRecordType:(NSSet<RecordType *> *)values;
- (void)removeRecordType:(NSSet<RecordType *> *)values;

@end

NS_ASSUME_NONNULL_END
