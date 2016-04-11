//
//  TodaySalesTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodaySalesTableViewCell.h"
#define HalfScreenWidth ((KScreenWidth - 126) / 2.0)
@implementation TodaySalesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 7, 16, 16)];
        [self.contentView addSubview:_titleImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 5, 40, 20)];
        [self.contentView addSubview:_titleLabel];
        
        for (int i = 0; i < 4; i++) {
            _nameLabel = [[UILabel alloc] init];
            _Label = [[UILabel alloc] init];
            _nameLabel.font = [UIFont systemFontOfSize:13];
            _Label.font = [UIFont systemFontOfSize:13];
            _nameLabel.tag = 4320 + i;
            _Label.tag = 4310 + i;
            _nameLabel.textColor = [UIColor grayColor];
            if (i == 0) {
                _nameLabel.frame = CGRectMake(56, 30, 30, 15);
                _Label.frame = CGRectMake(86, 30, HalfScreenWidth, 15);
            } else if (i == 1) {
                _nameLabel.frame = CGRectMake(86 + HalfScreenWidth, 30, 30, 15);
                _Label.frame = CGRectMake(116 + HalfScreenWidth, 30, HalfScreenWidth, 15);
                _Label.textColor = [UIColor redColor];
            } else if (i == 2) {
                _nameLabel.frame = CGRectMake(56, 50, 30, 15);
                _Label.frame = CGRectMake(86, 50, HalfScreenWidth, 15);
                _Label.textColor = Mycolor;
            } else {
                _nameLabel.frame = CGRectMake(86 + HalfScreenWidth, 50, 30, 15);
                _Label.frame = CGRectMake(116 + HalfScreenWidth, 50, HalfScreenWidth, 15);
                _Label.textColor = Mycolor;
            }
            [self.contentView addSubview:_Label];
            [self.contentView addSubview:_nameLabel];
        }
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleImageView.image = [UIImage imageNamed:@"btn_peijian_h"];
        
    _titleLabel.text = [_dic valueForKey:@"col0"];
    
    long long junmao = [[_dic valueForKey:@"col3"] longLongValue] / [[_dic valueForKey:@"col1"] longLongValue];
    
    for (int i = 0; i < 4; i++) {
        _Label = (UILabel *)[self.contentView viewWithTag:4310 + i];
        _nameLabel = (UILabel *)[self.contentView viewWithTag:4320 + i];
        if (i == 0) {
            _nameLabel.text = @"数量:";
            _Label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col1"]];
        } else if (i == 1) {
            _nameLabel.text = @"金额:";
            _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col2"]];
        } else if (i == 2) {
            _nameLabel.text = @"均毛:";
            _Label.text = [NSString stringWithFormat:@"￥%lld",junmao];
        } else{
            _nameLabel.text = @"毛利:";
            _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col3"]];
        }
    }
}
@end
