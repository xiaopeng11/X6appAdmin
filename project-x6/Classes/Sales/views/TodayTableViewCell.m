//
//  TodayTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TodayTableViewCell.h"

@implementation TodayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子视图
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] init];
            if (i == 0) {
               label.frame = CGRectMake(10, 0, (KScreenWidth - 10) / 2.0, 60);
                label.textAlignment = NSTextAlignmentLeft;
            } else {
               label.frame = CGRectMake(10 + (KScreenWidth - 10) / 2.0 + (KScreenWidth / 4.0) * (i - 1), 0, (KScreenWidth - 10) / 4.0, 60);
                label.textAlignment = NSTextAlignmentCenter;
            }
            label.font = [UIFont boldSystemFontOfSize:16];
            label.tag = 900 + i;
            [self.contentView addSubview:label];
        }
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 3; i++) {
        UILabel *labeled = (UILabel *)[self.contentView viewWithTag:900 + i];
        if (i == 0) {
            labeled.text = [_dic valueForKey:@"col1"];
        } else if (i == 1) {
            labeled.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
        } else {
            labeled.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
        }
    }
    
}

@end
