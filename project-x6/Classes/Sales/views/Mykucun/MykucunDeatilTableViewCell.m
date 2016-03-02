//
//  MykucunDeatilTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MykucunDeatilTableViewCell.h"

#define KucunScreenWith (KScreenWidth - 20)
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
                _label.textAlignment = NSTextAlignmentCenter;
                _label.font = [UIFont systemFontOfSize:18];
               _label.frame = CGRectMake(((KScreenWidth / 2.0 - 150) / 2.0) + (i * (KScreenWidth / 2.0)), 5, 150, 20);
            } else {
                _label.font = [UIFont systemFontOfSize:14];
                int withnum = (i - 2) / 3;
                int lonnum = (i - 2) % 3;
//                _label.backgroundColor = [UIColor yellowColor];
                _label.frame = CGRectMake(20 + ((KucunScreenWith / 3.0 - 100) / 2.0) + (lonnum * (KucunScreenWith / 3.0)),  30 + 30 * withnum, 100, 20);
            } 
            [self.contentView addSubview:_label];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < 8; i++) {
        UILabel *label = [self.contentView viewWithTag:4100 + i];
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"均价:%@",[_dic valueForKey:@"zongjunjia"]];
        } else if (i == 1) {
            label.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@"zongjine"]];
        } else if (i == 2) {
            label.text = [NSString stringWithFormat:@"最高进价:%@",[_dic valueForKey:@"zgcbdj"]];
        } else if (i == 3) {
            label.text = [NSString stringWithFormat:@"数量:%@",[_dic valueForKey:@"zgsl"]];
        } else if (i == 4) {
            label.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@"zgje"]];
        } else if (i == 5) {
            label.text = [NSString stringWithFormat:@"最低进价:%@",[_dic valueForKey:@"zdcbdj"]];
        } else if (i == 6) {
            label.text = [NSString stringWithFormat:@"数量:%@",[_dic valueForKey:@"zdsl"]];
        } else if (i == 7) {
            label.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@"zdje"]];
        }
    }
   
}

@end
