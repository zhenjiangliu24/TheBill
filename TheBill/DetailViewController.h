//
//  DetailViewController.h
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) Record *myRecord;
@property (nonatomic, strong) User *user;
@end
