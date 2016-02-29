//
//  TodayMoneyTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayMoneyTableViewCell.h"
#define HalfScreenWidth ((KScreenWidth - 80) / 2.0)
@implementation TodayMoneyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i = 0; i < 8; i++) {
            int MyMoneyX = i / 2;
            int MyMoneyY = i % 2;
            _label = [[UILabel alloc] initWithFrame:CGRectMake(80 + HalfScreenWidth * MyMoneyY, 5 + 15 * MyMoneyX, HalfScreenWidth, 15)];
            _label.tag = 4410 + i;
            _label.textColor = [UIColor grayColor];
            _label.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_label];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 8; i++) {
        _label = (UILabel *)[self.contentView viewWithTag:4410 + i];
        if (i == 0) {
            _label.text = [NSString stringWithFormat:@"昨日余额:%@",[_dic valueForKey:@"zrye"]];
        } else if (i == 1) {
            _label.text = [NSString stringWithFormat:@"现       金:%@",[_dic valueForKey:@"xjje"]];
        } else if (i == 2) {
            _label.text = [NSString stringWithFormat:@"刷       卡:%@",[_dic valueForKey:@"skje"]];
        } else if (i == 3) {
            _label.text = [NSString stringWithFormat:@"抵  价  券:%@",[_dic valueForKey:@"djqje"]];
        } else if (i == 4) {
            _label.text = [NSString stringWithFormat:@"门店费用:%@",[_dic valueForKey:@"mdzc"]];
        } else if (i == 5) {
            _label.text = [NSString stringWithFormat:@"银行打款:%@",[_dic valueForKey:@"yhdk"]];
        } else if (i == 6) {
            _label.text = [NSString stringWithFormat:@"交运营商:%@",[_dic valueForKey:@"jyys"]];
        } else if (i == 7) {
            _label.text = [NSString stringWithFormat:@"今日余额:%@",[_dic valueForKey:@"jrye"]];
        }
    }
}

@end
