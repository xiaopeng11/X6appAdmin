//
//  MissyReceivableCell.m
//  project-x6
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MissyReceivableCell.h"

@implementation MissyReceivableCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 85)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        [_bgView addSubview:_imageView];
        
        _customerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, KScreenWidth - 60, 30)];
        [_bgView addSubview:_customerLabel];
        
        for (int i = 0; i < 2; i++) {
            _textLabel = [[UILabel alloc] init];
            _messageLabel = [[UILabel alloc] init];
            if (i == 0) {
                _textLabel.frame = CGRectMake(50, 37, 40, 20);
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 37, KScreenWidth - 100, 20)];
            } else if (i == 1) {
                _textLabel.frame = CGRectMake(50, 60, 40, 20);
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 60, KScreenWidth - 100, 20)];
                _messageLabel.textColor = Mycolor;
            }
            _textLabel.tag = 48720 + i;
            _messageLabel.tag = 48710 + i;
            _messageLabel.font = [UIFont systemFontOfSize:14];
            _textLabel.font = [UIFont systemFontOfSize:14];
            [_bgView addSubview:_messageLabel];
            [_bgView addSubview:_textLabel];
        }
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 30, 80, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_dateLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.image = [UIImage imageNamed:@"btn_kehu_h"];
    
    _customerLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
    
    for (int i = 0; i < 3; i++) {
        _textLabel = (UILabel *)[self.contentView viewWithTag:48720 + i];
        _messageLabel = (UILabel *)[self.contentView viewWithTag:48710 + i];
        if (i == 0) {
            _textLabel.text = @"单号:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col1"]];
        } else if (i == 1) {
            _textLabel.text = @"未收:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col4"]];
        }
    }
    
    _dateLabel.text = [_dic valueForKey:@"col0"];
}

@end
