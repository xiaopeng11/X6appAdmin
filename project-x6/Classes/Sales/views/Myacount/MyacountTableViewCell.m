//
//  MyacountTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyacountTableViewCell.h"

@implementation MyacountTableViewCell

#define myacountwidth ((KScreenWidth - 165) / 2.0)
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
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 79)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        [_bgView addSubview:_imageView];
        
        _bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, KScreenWidth - 45, 29)];
        [_bgView addSubview:_bankLabel];
        
        for (int i = 0; i < 3; i++) {
            _acountNameLabel = [[UILabel alloc] init];
            _myacountLabel = [[UILabel alloc] init];
            if (i == 0) {
                _acountNameLabel.frame = CGRectMake(35, 32, 60, 20);
                _myacountLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 32, myacountwidth, 20)];
            } else if (i == 1) {
                _acountNameLabel.frame = CGRectMake(95 + myacountwidth, 32, 60, 20);
                _myacountLabel = [[UILabel alloc] initWithFrame:CGRectMake(155 + myacountwidth, 32, myacountwidth, 20)];
                _myacountLabel.textColor = Mycolor;
            } else {
                _acountNameLabel.frame = CGRectMake(95 + myacountwidth, 54, 30, 20);
                _myacountLabel = [[UILabel alloc] initWithFrame:CGRectMake(125 + myacountwidth, 54, KScreenWidth - (125 + myacountwidth + 10), 20)];
                _myacountLabel.textColor = [UIColor redColor];
            }
            _acountNameLabel.tag = 4720 + i;
            _myacountLabel.tag = 4710 + i;
            _myacountLabel.font = [UIFont systemFontOfSize:13];
            _acountNameLabel.font = [UIFont systemFontOfSize:13];
            [_bgView addSubview:_myacountLabel];
            [_bgView addSubview:_acountNameLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.image = [UIImage imageNamed:@"btn_tongqian_h"];
    
    _bankLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col0"]];
    
    for (int i = 0; i < 3; i++) {
        _myacountLabel = (UILabel *)[self.contentView viewWithTag:4710 + i];
        _acountNameLabel = (UILabel *)[self.contentView viewWithTag:4720 + i];
        if (i == 0) {
            _acountNameLabel.text = @"本期收入:";
            _myacountLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_dic valueForKey:@"col2"] floatValue]];
        } else if (i == 1) {
            _acountNameLabel.text = @"本期支出:";
            _myacountLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_dic valueForKey:@"col3"] floatValue]];
        } else if (i == 2) {
            _acountNameLabel.text = @"余额:";
            _myacountLabel.text = [NSString stringWithFormat:@"￥%.2f",[[_dic valueForKey:@"col4"] floatValue]];
        }
    }
}
@end
