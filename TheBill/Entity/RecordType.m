//
//  RecordType.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "RecordType.h"
#import "ListRecordType.h"
#import "Record.h"

@implementation RecordType

// Insert code here to add functionality to your managed object subclass
- (NSString *)tagName
{
    return self.name;
}
@end
