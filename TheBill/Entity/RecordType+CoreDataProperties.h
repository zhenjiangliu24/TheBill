//
//  RecordType+CoreDataProperties.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RecordType.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) ListRecordType *list;
@property (nullable, nonatomic, retain) Record *record;

@end

NS_ASSUME_NONNULL_END
