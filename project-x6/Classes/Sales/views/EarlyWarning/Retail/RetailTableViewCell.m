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
        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _dhImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 16)];
        [_bgView addSubview:_dhImageView];
        
        _dhLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, KScreenWidth - 40 - 130, 20)];
        _dhLabel.font = [UIFont systemFontOfSize:14];
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
        
        _chuanhaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 80, 40, 20)];
        _chuanhaoLabel.font = [UIFont systemFontOfSize:13];
        [_bgView addSubview:_chuanhaoLabel];
        
        for (int i = 0; i < 5; i++) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            if (i == 0) {
                _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
                _messageLabel.textAlignment = NSTextAlignmentLeft;
                _messageLabel.numberOfLines = 0;
            } else if ( i == 2 || i == 3) {
                _messageLabel.textColor = [UIColor redColor];
            } else if (i == 4) {
                _messageLabel.textColor = Mycolor;
            }
            _messageLabel.tag = 4640 + i;
            _nameLabel.tag = 4680 + i;
            _nameLabel.font = [UIFont systemFontOfSize:13];
            _messageLabel.font = [UIFont systemFontOfSize:13];
            [_bgView addSubview:_messageLabel];
            [_bgView addSubview:_nameLabel];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgView.frame = CGRectMake(0, 0, KScreenWidth, self.frame.size.height - 10);
    
    _dhImageView.image = [UIImage imageNamed:@"bth_danhao_n"];
    
    _dhLabel.text = [NSString stringWithFormat:@"单号:%@",[_dic valueForKey:@"col1"]];
    
    _dateLabel.text = [NSString stringWithFormat:@"日期:%@",[_dic valueForKey:@"col2"]];
    
    _mdImageView.image = [UIImage imageNamed:@"btn_mendian_h"];
    
    _mdLabel.text = [NSString stringWithFormat:@"门店:%@",[_dic valueForKey:@"col3"]];
    
    _yyyLabel.text = [NSString stringWithFormat:@"营业员:%@",[_dic valueForKey:@"col4"]];
    
    _chuanhaoLabel.text = @"串号:";
    
    for (int i = 0; i < 5; i++) {
        _messageLabel = (UILabel *)[_bgView viewWithTag:4640 + i];
        _nameLabel = (UILabel *)[_bgView viewWithTag:4680 + i];
        double lowPrice = [[_dic valueForKey:@"col9"] doubleValue] - [[_dic valueForKey:@"col8"] doubleValue];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
        CGRect rect = [[_dic valueForKey:@"col6"] boundingRectWithSize:CGSizeMake(KScreenWidth - 120, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        if (rect.size.height > 20) {
            if (i == 0) {
                _nameLabel.frame = CGRectMake(50, 80, 30, 20);
                _messageLabel.frame = CGRectMake(80, 80, KScreenWidth - 120, 40);
            } else  if (i == 4){
                _nameLabel.frame = CGRectMake(50, 100 + 20 * i, 90, 20);
                _messageLabel.frame = CGRectMake(140, 100 + 20 * i, KScreenWidth - 150, 20);
            } else {
                _nameLabel.frame = CGRectMake(50, 100 + 20 * i, 30, 20);
                _messageLabel.frame = CGRectMake(80, 100 + 20 * i, KScreenWidth - 100, 20);
            }
        } else {
            if (i == 0) {
                _nameLabel.frame = CGRectMake(50, 80, 30, 20);
                _messageLabel.frame = CGRectMake(80, 80, KScreenWidth - 120, 20);
            } else if (i == 4){
                _nameLabel.frame = CGRectMake(50, 80 + 20 * i, 90, 20);
                _messageLabel.frame = CGRectMake(140, 80 + 20 * i, KScreenWidth - 150, 20);
            } else {
                _nameLabel.frame = CGRectMake(50, 80 + 20 * i, 30, 20);
                _messageLabel.frame = CGRectMake(80, 80 + 20 * i, KScreenWidth - 120, 20);
            }
        }
        
        if (i == 0) {
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col6"]];
        } else if (i == 1) {
            _nameLabel.text = @"货品:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col7"]];
        } else if (i == 2) {
            _nameLabel.text = @"单价:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col8"]];
        } else if (i == 3) {
            _nameLabel.text = @"限价:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col9"]];
        } else if (i == 4) {
            _nameLabel.text = @"低于最低限价:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%.0f",lowPrice];
        }
    }
}
@end
