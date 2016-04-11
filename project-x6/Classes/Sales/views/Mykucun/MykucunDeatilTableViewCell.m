//
//  MykucunDeatilTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MykucunDeatilTableViewCell.h"

#define mukucunwidth ((KScreenWidth - 140) / 5.0)
@implementation MykucunDeatilTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i = 0; i < 8; i++) {
            _label = [[UILabel alloc] init];
            _titleLabel = [[UILabel alloc] init];
            _label.textColor = [UIColor grayColor];
            _titleLabel.textColor = [UIColor grayColor];
            _label.font = [UIFont systemFontOfSize:13];
            _titleLabel.font = [UIFont systemFontOfSize:13];
            _label.tag = 4110 + i;
            _titleLabel.tag = 4120 + i;
            if (i < 2) {
                _titleLabel.frame = CGRectMake(10 + (90 + (mukucunwidth * 3)) * i, 5, 30, 20);
                _label.frame = CGRectMake(40 + (90 + (mukucunwidth * 3)) * i, 5, mukucunwidth * 2, 20);
            } else {
                int withnum = (i - 2) / 3;
                int lonnum = (i - 2) % 3;
                if (lonnum == 0) {
                    _titleLabel.frame = CGRectMake(10, 30 + 30 * withnum, 60, 20);
                    _label.frame = CGRectMake(70,  30 + 30 * withnum, mukucunwidth * 2, 20);
                    
                } else if (lonnum == 1) {
                    _titleLabel.frame = CGRectMake(70 + (mukucunwidth * 2), 30 + 30 * withnum, 30, 20);
                    _label.frame = CGRectMake(100 + (mukucunwidth * 2),  30 + 30 * withnum, mukucunwidth, 20);
                } else {
                    _titleLabel.frame = CGRectMake(100 + (mukucunwidth * 3), 30 + 30 * withnum, 30, 20);
                    _label.frame = CGRectMake(130 + (mukucunwidth * 3),  30 + 30 * withnum, mukucunwidth * 2, 20);
                }
                if (withnum == 0) {
                    _label.textColor = [UIColor redColor];
                } else {
                    _label.textColor = Mycolor;
                }
                
            }
            [self.contentView addSubview:_label];
            [self.contentView addSubview:_titleLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < 8; i++) {
        _label = [self.contentView viewWithTag:4110 + i];
        _titleLabel = [self.contentView viewWithTag:4120 + i];
        if (i == 0) {
            _titleLabel.text = @"均价:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zongjunjia"]];
        } else if (i == 1) {
            _titleLabel.text = @"金额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zongjine"]];
        } else if (i == 2) {
            _titleLabel.text = @"最高进价:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zgcbdj"]];
        } else if (i == 3) {
            _titleLabel.text = @"数量:";
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"zgsl"]];
        } else if (i == 4) {
            _titleLabel.text = @"金额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zgje"]];
        } else if (i == 5) {
            _titleLabel.text = @"最低进价:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zdcbdj"]];
        } else if (i == 6) {
            _titleLabel.text = @"数量:";
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"zdsl"]];
        } else if (i == 7) {
            _titleLabel.text = @"金额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"zdje"]];
        }
    }
   
}

@end
