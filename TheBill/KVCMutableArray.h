//
//  KVCMutableArray.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/24.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVCMutableArray : NSObject
@property (nonatomic, strong) NSMutableArray *array;
- (NSUInteger)countOfArray;
- (id)objectInArrayAtIndex:(NSUInteger)index;
- (void)insertObject:(id)object inArrayAtIndex:(NSUInteger)index;
- (void)removeObjectFromArrayAtIndex:(NSUInteger)index;
- (void)replaceObjectInArrayAtIndex:(NSUInteger)index withObject:(id)object;
@end
