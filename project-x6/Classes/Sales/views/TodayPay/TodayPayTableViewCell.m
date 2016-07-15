//
//  TodayPayTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayPayTableViewCell.h"

@implementation TodayPayTableViewCell

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
        
        self.backgroundColor = GrayColor;
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        [_bgView addSubview:_headerView];
        
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, KScreenWidth - 50 - 20, 20)];
        [_bgView addSubview:_headerLabel];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 41, 20, 18)];
        [_bgView addSubview:_imageView];

        _label = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, (KScreenWidth - 80) / 2.0, 20)];
        _label.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_label];

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 + ((KScreenWidth - 70) / 2.0), 40, 40, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_nameLabel];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 + ((KScreenWidth - 70) / 2.0) + 40, 40, KScreenWidth - (50 + ((KScreenWidth - 70) / 2.0) + 40), 20)];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor redColor];
        [_bgView addSubview:_textLabel];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.source isEqualToString:X6_todayPay]) {
        _headerView.image = [UIImage imageNamed:@"btn_gys_h"];
        _headerLabel.text = [NSString stringWithFormat:@"供应商:%@",[_dic valueForKey:@"col2"]];
    } else {
        _headerView.image = [UIImage imageNamed:@"btn_kehu_h"];
        _headerLabel.text = [NSString stringWithFormat:@"客户:%@",[_dic valueForKey:@"col2"]];
    }
    _imageView.image = [UIImage imageNamed:@"btn_zhanghu_h"];
    _label.text = [NSString stringWithFormat:@"帐户:%@",[_dic valueForKey:@"col1"]];
    _nameLabel.text = @"金额:";
    _textLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col3"]];
    

    
}
@end
