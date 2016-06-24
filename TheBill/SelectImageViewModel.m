//
//  SelectImageViewModel.m
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/25.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "SelectImageViewModel.h"
@interface SelectImageViewModel()
@property (nonatomic, readwrite, copy) NSArray *photos;
@property (nonatomic, strong) NSMutableArray *mutablePhotos;

@end
struct{
    unsigned int didReceiveData:1;
}_delegateFlages;

@implementation SelectImageViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _photos = [[NSArray array] copy];
        _mutablePhotos = [NSMutableArray new];
    }
    return self;
}

- (void)setDelegate:(id<SelectImageViewModelDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlages.didReceiveData = [_delegate respondsToSelector:@selector(selectImageViewModel:didReceivePhotos:)];
    
}

- (NSInteger)getTableViewCellsNumber
{
    if (self.currentPage == self.totalPages
        || self.currentPage == self.maxPages
        || self.currentPage == self.totalItems) {
        return self.photos.count;
    }
    return self.photos.count+1;
}

- (void)loadPhotos:(NSInteger)page completionHandler:(void(^)())completion
{
    NSString *apiURL = [NSString stringWithFormat:@"https://api.500px.com/v1/photos?feature=editors&page=%ld&consumer_key=%@",(long)page,CUSTOMER_KEY];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:apiURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (!error) {
                    
                    NSError *jsonError = nil;
                    NSMutableDictionary *jsonObject = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                    NSLog(@"%@",jsonObject);
                    [_mutablePhotos addObjectsFromArray:[jsonObject objectForKey:@"photos"]];
                    
                    self.currentPage = [[jsonObject objectForKey:@"current_page"] integerValue];
                    self.totalPages  = [[jsonObject objectForKey:@"total_pages"] integerValue];
                    self.totalItems  = [[jsonObject objectForKey:@"total_items"] integerValue];
                    _photos = [_mutablePhotos copy];
                    if(_delegateFlages.didReceiveData){
                       [self.delegate selectImageViewModel:self didReceivePhotos:_photos];
                    }
                }
                if (completion) {
                    completion();
                }
            }] resume];
}
@end
