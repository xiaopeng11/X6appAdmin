//
//  DepositTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DepositTableViewCell.h"

@implementation DepositTableViewCell

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
        
        for (int i = 0; i < 4; i++) {
            _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 27 + 30 * i, 20, 16)];
            _headerView.tag = 3610 + i;
            [self.contentView addSubview:_headerView];
            
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20 + 30 * i, 40, 30)];
            _titleLabel.tag = 3620 + i;
            [self.contentView addSubview:_titleLabel];
            
            if (i == 3) {
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 110, KScreenWidth - 100, 30)];
            } else {
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20 + 30 * i, KScreenWidth - 210, 30)];
            }
            _messageLabel.tag = 3630 + i;
            _messageLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_messageLabel];
            
            
        }
        
        _userLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 120, 20, 100, 30)];
        _userLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_userLabel];
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        
        NSArray *array = [dic valueForKey:@"rows"];
        for (int i = 0; i < array.count; i++) {
            _acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 140 + 30 * i, (KScreenWidth - 60) / 2.0 + 40, 30)];
            _acountLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_acountLabel];
            NSDictionary *dic = array[i];
            _acountLabel.text = [NSString stringWithFormat:@"帐户:%@",[dic valueForKey:@"zhname"]];
            _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + (KScreenWidth - 60) / 2.0, 140 + 30 * i, (KScreenWidth - 60) / 2.0 - 40, 30)];
            [self.contentView addSubview:_moneyLabel];
            _moneyLabel.font = [UIFont systemFontOfSize:14];
            _moneyLabel.text = [NSString stringWithFormat:@"金额:%@",[dic valueForKey:@"je"]];
        }
        
//        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 150 + 30 * array.count, KScreenWidth, 10)];
//        _bottomView.backgroundColor = GrayColor;
//        [self.contentView addSubview:_bottomView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 6; i++) {
        _headerView = (UIImageView *)[self.contentView viewWithTag:3610 + i];
        _titleLabel = (UILabel *)[self.contentView viewWithTag:3620 + i];
        _messageLabel = (UILabel *)[self.contentView viewWithTag:3630 + i];
        if (i == 0) {
            _headerView.image = [UIImage imageNamed:@"btn_dingdanhao_h"];
            _titleLabel.text = @"单号:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"djh"]];
        } else if (i == 1) {
            _headerView.image = [UIImage imageNamed:@"btn_riqi_h"];
            _titleLabel.text = @"日期:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"fsrq"]];
        } else if (i == 2) {
            _headerView.image = [UIImage imageNamed:@"btn_mendian_h"];
            _titleLabel.text = @"门店:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"ssgsname"]];
        } else if (i == 3) {
            _headerView.image = [UIImage imageNamed:@"btn_beizhu_h"];
            _titleLabel.text = @"备注:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"comments"]];
        }
    }
    
    _userLabel.text = [NSString stringWithFormat:@"经办人:%@",[_dic valueForKey:@"jsrmc"]];
    
    
}
@end
