//
//  TodayMoneyTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayMoneyTableViewCell.h"
#define HalfScreenWidth ((KScreenWidth - 140) / 2.0)
@implementation TodayMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i = 0; i < 8; i++) {
            int MyMoneyX = i / 2;
            int MyMoneyY = i % 2;
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (HalfScreenWidth + 80) * MyMoneyY, 5 + 20 * MyMoneyX, 60, 15)];
            _label = [[UILabel alloc] initWithFrame:CGRectMake(80 + (HalfScreenWidth + 80) * MyMoneyY, 5 + 20 * MyMoneyX, HalfScreenWidth, 15)];
            _label.tag = 4410 + i;
            _nameLabel.tag = 4420 + i;
            _label.textColor = [UIColor grayColor];
            if (i == 0 || i == 7) {
                _label.textColor = Mycolor;
            } else {
                _label.textColor = [UIColor redColor];
            }
            _label.font = [UIFont systemFontOfSize:13];
            _nameLabel.font = [UIFont systemFontOfSize:13];
            [self.contentView addSubview:_label];
            [self.contentView addSubview:_nameLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 8; i++) {
        _label = (UILabel *)[self.contentView viewWithTag:4410 + i];
        _nameLabel = (UILabel *)[self.contentView viewWithTag:4420 + i];
        if (i == 0) {
            _nameLabel.text = @"昨日余额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zrye"]];
        } else if (i == 1) {
            _nameLabel.text = @"现       金:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"xjje"]];
        } else if (i == 2) {
            _nameLabel.text = @"刷       卡:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"skje"]];
        } else if (i == 3) {
            _nameLabel.text = @"抵  价  券:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"djqje"]];
        } else if (i == 4) {
            _nameLabel.text = @"门店费用:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"mdzc"]];
        } else if (i == 5) {
            _nameLabel.text = @"银行打款:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"yhdk"]];
        } else if (i == 6) {
            _nameLabel.text = @"交运营商:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"jyys"]];
        } else if (i == 7) {
            _nameLabel.text = @"今日余额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"jrye"]];
        }
    }
}

@end
