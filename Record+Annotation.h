//
//  Record+Annotation.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "Record.h"
#import <MapKit/MapKit.h>

@interface Record (Annotation)<MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,readonly, copy) NSString *title;
- (id)initWithTitle:(NSString *)title Location:(CLLocationCoordinate2D)location;
@end
