//
//  StatisticTableViewCell.h
//  TheBill
//
//  Created by Zhenjiang Liu on 16/5/17.
//  Copyright © 2016年 Zhenjiang Liu. All rights reserved.
//

@interface StatisticTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *inComeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outComeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
