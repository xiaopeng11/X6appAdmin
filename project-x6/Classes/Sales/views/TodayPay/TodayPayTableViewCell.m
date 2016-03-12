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
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [_bgView addSubview:_headerView];
        
        for (int i = 0; i < 2; i++) {
            if (i == 0) {
                _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 60, 20)];
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 20, 20)];
                _label = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 50, 20)];
                _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, KScreenWidth - 100, 20)];
            } else {
                _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, KScreenWidth - 80, 20)];
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 65, 20, 20)];
                _label = [[UILabel alloc] initWithFrame:CGRectMake(50, 65, 50, 20)];
                _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, KScreenWidth - 100, 20)];
            }
            _headerLabel.tag = 4510 + i;
            _imageView.tag = 4520 + i;
            _label.tag = 4530 + i;
            _textLabel.tag = 4540 + i;
            [_bgView addSubview:_headerLabel];
            [_bgView addSubview:_imageView];
            [_bgView addSubview:_label];
            [_bgView addSubview:_textLabel];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerView.image = [UIImage imageNamed:@"btn_mendian_h"];
    
    for (int i = 0 ; i < 2; i++) {
        _headerLabel = (UILabel *)[self.contentView viewWithTag:4510 + i];
        _imageView = (UIImageView *)[self.contentView viewWithTag:4520 + i];
        _label = (UILabel *)[self.contentView viewWithTag:4530 + i];
        _textLabel = (UILabel *)[self.contentView viewWithTag:4540 + i];
        
        if (i == 0) {
            _headerLabel.text = @"供应商:";
            _imageView.image = [UIImage imageNamed:@"btn_zhanghu_n"];
            _label.text = @" 帐户:";
            _textLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col1"]];
            
        } else {
            _headerLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
            _imageView.image = [UIImage imageNamed:@"btn_jinee_h"];
            _label.text = @" 金额:";
            _textLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
        }
    }
}
@end
