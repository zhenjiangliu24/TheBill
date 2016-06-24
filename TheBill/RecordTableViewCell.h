//
//  RecordTableViewCell.h
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/12.
//  Copyright © 2016年 Zhenjiang Liu. All rights reserved.
//

@interface RecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recordImageView;
@property (weak, nonatomic) IBOutlet UILabel *recordTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordAmountLabel;

@end
