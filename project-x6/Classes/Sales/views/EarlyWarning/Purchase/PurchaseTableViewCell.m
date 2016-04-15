//
//  PurchaseTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PurchaseTableViewCell.h"

@implementation PurchaseTableViewCell

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
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 190)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _rkdhImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 16)];
        [_bgView addSubview:_rkdhImageView];
        
        _rkdhLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, KScreenWidth - 40 - 130, 20)];
        _rkdhLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_rkdhLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 120, 10, 100, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_dateLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth, 1)];
        _lineView.backgroundColor = LineColor;
        [_bgView addSubview:_lineView];
        
        _gysImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 51, 20, 16)];
        [_bgView addSubview:_gysImageView];
        
        _gysLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, KScreenWidth - 60, 20)];
        _gysLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_gysLabel];
        
        for (int i = 0; i < 5; i++) {
            _messageLabel = [[UILabel alloc] init];
            if (i < 4) {
                _nameLabel = [[UILabel alloc] init];
                _nameLabel.font = [UIFont systemFontOfSize:13];
                _nameLabel.frame = CGRectMake(50, 80 + 20 * i, 30, 20);
                _messageLabel.frame = CGRectMake(80, 80 + 20 * i, KScreenWidth - 100, 20);
                _nameLabel.tag = 4660 + i;
                [_bgView addSubview:_nameLabel];
            } else {
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 80 + 20 * i, KScreenWidth - 120, 20)];
            }
            if (i == 2 || i == 3) {
                _messageLabel.textColor = [UIColor redColor];
            } else if (i == 1) {
                _messageLabel.textColor = Mycolor;
            }
            _messageLabel.tag = 4650 + i;
            _messageLabel.font = [UIFont systemFontOfSize:13];
            [_bgView addSubview:_messageLabel];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _rkdhImageView.image = [UIImage imageNamed:@"bth_danhao_n"];
    
    _rkdhLabel.text = [NSString stringWithFormat:@"单号:%@",[_dic valueForKey:@"col1"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"日期:%@",[_dic valueForKey:@"col2"]];
    
    _gysImageView.image = [UIImage imageNamed:@"btn_mendian_h"];
    
    _gysLabel.text = [NSString stringWithFormat:@"供应商:%@",[_dic valueForKey:@"col3"]];
    
    double pencet;
    double higherLastPrice = [[_dic valueForKey:@"col8"] doubleValue] - [[_dic valueForKey:@"col6"] doubleValue];
    if (higherLastPrice > 0) {
        pencet =  ((higherLastPrice / [[_dic valueForKey:@"col8"] doubleValue]) * 100);
    } else {
        pencet =  - ((higherLastPrice / [[_dic valueForKey:@"col8"] doubleValue]) * 100);
    }
    
    for (int i = 0; i < 5; i++) {
        _messageLabel = (UILabel *)[_bgView viewWithTag:4650 + i];
        _nameLabel = (UILabel *)[_bgView viewWithTag:4660 + i];

        if (i == 0) {
            _nameLabel.text = @"商品:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col4"]];
        } else if (i == 1) {
            _nameLabel.text = @"数量:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col5"]];
        } else if (i == 2) {
            _nameLabel.text = @"单价:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col6"]];
        } else if (i == 3) {
            _nameLabel.text = @"金额:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col7"]];
        } else if (i == 4) {
            _messageLabel.text = [NSString stringWithFormat:@"高于最近进价:￥%.0f％",pencet];
        }
    }
    
}

@end
