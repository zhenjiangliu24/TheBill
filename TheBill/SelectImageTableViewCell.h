//
//  SelectImageTableViewCell.h
//  TheBill
//
//  Created by ZhongZhongzhong on 16/5/22.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

@interface SelectImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end
