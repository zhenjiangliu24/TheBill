//
//  Record+Annotation.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "Record+Annotation.h"

@interface Record()
@property (nonatomic, readwrite, copy) NSString *title;
@end

@implementation Record (Annotation)
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

- (id)initWithTitle:(NSString *)title Location:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
        self.title = [title copy];
        self.coordinate = location;
    }
    return self;
}

- (NSString *)title
{
    return [NSString stringWithFormat:@"%@ %.f",self.recordType.name,[self.amount doubleValue]];
}


@end
