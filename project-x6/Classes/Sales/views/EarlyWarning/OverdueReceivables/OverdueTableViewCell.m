//
//  OverdueTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OverdueTableViewCell.h"

@implementation OverdueTableViewCell

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
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 135)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _kehuImageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
        [_bgView addSubview:_kehuImageview];
        
        _kuhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, KScreenWidth - 45 - 80, 25)];
        [_bgView addSubview:_kuhuLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 90, 5, 80, 25)];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_dateLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(45, 31, KScreenWidth - 60, 1)];
        _lineView.backgroundColor = LineColor;
        [_bgView addSubview:_lineView];
        
        for (int i = 0; i < 8; i++) {
            _textLabel = [[UILabel alloc] init];
            _textLabel.font = [UIFont systemFontOfSize:14];
            if ((i % 2) == 0) {
                _textLabel.frame = CGRectMake(45, 35 + (i / 2) * 25, 40, 20);
            } else {
                _textLabel.frame = CGRectMake(45 + 40, 35 + (i / 2) * 25, KScreenWidth - 95, 20);
            }
            if (i == 5) {
                _textLabel.textColor = Mycolor;
            }
            _textLabel.tag = 12120 + i;
            [_bgView addSubview:_textLabel];
        }

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _kehuImageview.image = [UIImage imageNamed:@"btn_kehu_h"];
    
    _kuhuLabel.text = [_dic valueForKey:@"col4"];
    
    _dateLabel.text = [_dic valueForKey:@"col0"];
    
    for (int i = 0; i < 8; i++) {
        _textLabel = [_bgView viewWithTag:12120 + i];
        if (i == 0) {
            _textLabel.text = @"单号:";
        } else if (i == 1) {
            _textLabel.text = [_dic valueForKey:@"col1"];
        } else if (i == 2) {
            _textLabel.text = @"科目:";
        } else if (i == 3) {
            _textLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
        } else if (i == 4) {
            _textLabel.text = @"金额:";
        } else if (i == 5) {
            _textLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col5"]];
        } else if (i == 6) {
            _textLabel.text = @"逾期:";
        } else if (i == 7) {
            _textLabel.text = [NSString stringWithFormat:@"%@天",[_dic valueForKey:@"col6"]];
        }
    }

}

@end
