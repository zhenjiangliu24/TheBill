//
//  RecordType.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZJLTagListView.h"

@class ListRecordType, Record;

NS_ASSUME_NONNULL_BEGIN

@interface RecordType : NSManagedObject<ZJLTagListViewObject>

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "RecordType+CoreDataProperties.h"
