//
//  RetailTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RetailTableViewCell.h"

@implementation RetailTableViewCell

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
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 210)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _dhImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 16)];
        [_bgView addSubview:_dhImageView];
        
        _dhLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, KScreenWidth - 40 - 130 - 30, 20)];
        _dhLabel.font = [UIFont systemFontOfSize:16];
        [_bgView addSubview:_dhLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 120, 10, 100, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_dateLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth, 1)];
        _lineView.backgroundColor = LineColor;
        [_bgView addSubview:_lineView];
        
        _mdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 51, 20, 16)];
        [_bgView addSubview:_mdImageView];
        
        _mdLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, (KScreenWidth - 80) / 2.0, 20)];
        _mdLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_mdLabel];
        
        _yyyLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 + ((KScreenWidth - 60) / 2.0), 50, (KScreenWidth - 80) / 2.0, 20)];
        _yyyLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_yyyLabel];
        
        _chuanhaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 40, 20)];
        _chuanhaoLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_chuanhaoLabel];
        
        for (int i = 0; i < 5; i++) {
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            if (i == 0) {
                _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
                _messageLabel.numberOfLines = 0;
            }
            _messageLabel.tag = 4640 + i;
            _messageLabel.font = [UIFont systemFontOfSize:14];
            [_bgView addSubview:_messageLabel];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    _dhImageView.image = [UIImage imageNamed:@"bth_danhao_n"];
    
    _dhLabel.text = [NSString stringWithFormat:@"出库单号:%@",[_dic valueForKey:@"col1"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"日期:%@",[_dic valueForKey:@"col2"]];
    
    _mdImageView.image = [UIImage imageNamed:@"btn_mendian_h"];
    
    _mdLabel.text = [NSString stringWithFormat:@"门店:%@",[_dic valueForKey:@"col3"]];
    
    _yyyLabel.text = [NSString stringWithFormat:@"营业员:%@",[_dic valueForKey:@"col4"]];
    
    _chuanhaoLabel.text = @"串号:";
    
    for (int i = 0; i < 5; i++) {
        _messageLabel = [self.contentView viewWithTag:4640 + i];
        double lowPrice = [[_dic valueForKey:@"col9"] doubleValue] - [[_dic valueForKey:@"col8"] doubleValue];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect rect = [[_dic valueForKey:@"col6"] boundingRectWithSize:CGSizeMake(KScreenWidth - 120, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        if (rect.size.height > 20) {
            if (i == 0) {
                _messageLabel.frame = CGRectMake(100, 80, KScreenWidth - 120, 40);
            } else if (i == 1) {
                _messageLabel.frame = CGRectMake(60, 120, KScreenWidth - 120, 20);
            } else if (i == 2) {
                _messageLabel.frame = CGRectMake(60, 140, KScreenWidth - 120, 20);
            } else if (i == 3) {
                _messageLabel.frame = CGRectMake(60, 160, KScreenWidth - 120, 20);
            } else if (i == 4) {
                _messageLabel.frame = CGRectMake(60, 180, KScreenWidth - 120, 20);
            }
        } else {
            if (i == 0) {
                _messageLabel.frame = CGRectMake(100, 80, KScreenWidth - 120, 20);
            } else if (i == 1) {
                _messageLabel.frame = CGRectMake(60, 100, KScreenWidth - 120, 20);
            } else if (i == 2) {
                _messageLabel.frame = CGRectMake(60, 120, KScreenWidth - 120, 20);
            } else if (i == 3) {
                _messageLabel.frame = CGRectMake(60, 140, KScreenWidth - 120, 20);
            } else if (i == 4) {
                _messageLabel.frame = CGRectMake(60, 160, KScreenWidth - 120, 20);
            }
        }
        
        if (i == 0) {
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col6"]];
        } else if (i == 1) {
            _messageLabel.text = [NSString stringWithFormat:@"货品:%@",[_dic valueForKey:@"col7"]];
        } else if (i == 2) {
            _messageLabel.text = [NSString stringWithFormat:@"单价:%@",[_dic valueForKey:@"col8"]];
        } else if (i == 3) {
            _messageLabel.text = [NSString stringWithFormat:@"限价:%@",[_dic valueForKey:@"col9"]];
        } else if (i == 4) {
            _messageLabel.text = [NSString stringWithFormat:@"限价:%.0f",lowPrice];
        }
    }
}
@end
