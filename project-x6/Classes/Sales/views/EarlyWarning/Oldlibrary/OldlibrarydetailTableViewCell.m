//
//  OldlibrarydetailTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibrarydetailTableViewCell.h"

@implementation OldlibrarydetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i = 0; i < 3; i++) {
            if (i == 0) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (KScreenWidth - 20) * 2 / 5, 30)];
            } else {
                label = [[UILabel alloc] initWithFrame:CGRectMake(10 + (KScreenWidth - 20) * 2 / 5 + ((KScreenWidth - 20) * 3 / 10) * (i - 1), 0, (KScreenWidth - 20) * 3 / 10, 30)];
                label.textAlignment = NSTextAlignmentCenter;
            }
            label.tag = 4630 + i;
            label.font = [UIFont systemFontOfSize:14];\
            [self.contentView addSubview:label];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < 3; i++) {
        label = [self.contentView viewWithTag:4630 + i];
        if (i == 0) {
            label.text = [_dic valueForKey:@"col0"];
        } else if (i == 1) {
            label.text = [_dic valueForKey:@"col2"];
        } else {
            label.text = [NSString stringWithFormat:@"%@天",[_dic valueForKey:@"col4"]];
        }
    }
}
@end
