//
//  MykucunDeatilTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MykucunDeatilTableViewCell.h"

@implementation MykucunDeatilTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i = 0; i < 8; i++) {
            _label = [[UILabel alloc] init];
            _label.textColor = [UIColor grayColor];
            _label.font = [UIFont systemFontOfSize:16];
            _label.tag = 4100 + i;
            if (i < 2) {
               _label.frame = CGRectMake(((KScreenWidth / 2.0 - 100) / 2.0) * (i + 1), 5, (KScreenWidth / 2.0 - 100) / 2.0, 20);
                _label.backgroundColor = [UIColor yellowColor];
            } else {
                int withnum = (i - 2) / 3;
                int lonnum = (i - 2) % 3;
                _label.frame = CGRectMake(((KScreenWidth / 3.0 - 100) / 2.0) * lonnum, 30 * withnum, (KScreenWidth / 3.0 - 100) / 2.0, 20);
                _label.backgroundColor = [UIColor greenColor];
            }
            
            
            [self.contentView addSubview:_label];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UILabel *label = (UILabel *)self.contentView.subviews;
    if (label.tag == 4100) {
        label.text = @"均价：";
    } else if (label.tag == 4101){
        label.text = @"金额：";
    } else if (label.tag == 4102) {
        label.text = @"最高进价：";
    } else if (label.tag == 4103) {
        label.text = @"数量：";
    } else if (label.tag == 4104) {
        label.text = @"金额：";
    } else if (label.tag == 4105) {
        label.text = @"最低进价：";
    } else if (label.tag == 4106) {
        label.text = @"数量：";
    } else {
        label.text = @"金额：";
    }
}

@end
