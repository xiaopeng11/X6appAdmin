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
            _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17 + 30 * i, 20, 16)];
            _headerView.tag = 3610 + i;
            [self.contentView addSubview:_headerView];
            _messageLabel = [[UILabel alloc] init];
            _messageLabel.frame = CGRectMake(40, 10 + 30 * i, KScreenWidth - 60, 30);
            _messageLabel.tag = 3630 + i;
            _messageLabel.font = [UIFont systemFontOfSize:15];
            [self.contentView addSubview:_messageLabel];
        }
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
        
        NSArray *array = [dic valueForKey:@"rows"];
        long long totolNum = 0;
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dic = array[i];
            _acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 130 + 30 * i, (KScreenWidth - 60) / 2.0 + 40, 30)];
            _acountLabel.font = [UIFont systemFontOfSize:15];
            _acountLabel.text = [NSString stringWithFormat:@"帐户:%@",[dic valueForKey:@"zhname"]];
            [self.contentView addSubview:_acountLabel];
            _moneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + (KScreenWidth - 60) / 2.0, 130 + 30 * i, 40, 30)];
            _moneyTitleLabel.text = @"金额:";
            _moneyTitleLabel.font = [UIFont systemFontOfSize:15];
            [self.contentView addSubview:_moneyTitleLabel];
            _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 + (KScreenWidth - 60) / 2.0, 130 + 30 * i, (KScreenWidth - 60) / 2.0 - 80, 30)];
            _moneyLabel.font = [UIFont systemFontOfSize:15];
            _moneyLabel.text = [NSString stringWithFormat:@"￥%@",[dic valueForKey:@"je"]];
            _moneyLabel.textColor = Mycolor;
            [self.contentView addSubview:_moneyLabel];
            totolNum += [[dic valueForKey:@"je"] longLongValue];
        }
        
        _totalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 130 + array.count * 30, 50, 30)];
        _totalTitleLabel.font = [UIFont systemFontOfSize:15];
        _totalTitleLabel.text = @"总金额:";
        [self.contentView addSubview:_totalTitleLabel];
        
        _totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(90, 130 + array.count * 30, KScreenWidth - 110, 30)];
        _totalMoney.font = [UIFont systemFontOfSize:15];
        _totalMoney.textColor = Mycolor;
        _totalMoney.text = [NSString stringWithFormat:@"￥%lld",totolNum];
        [self.contentView addSubview:_totalMoney];

    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 4; i++) {
        _headerView = (UIImageView *)[self.contentView viewWithTag:3610 + i];
        _messageLabel = (UILabel *)[self.contentView viewWithTag:3630 + i];
        if (i == 0) {
            _headerView.image = [UIImage imageNamed:@"btn_riqi_h"];
            _messageLabel.text = [NSString stringWithFormat:@"日期:%@",[_dic valueForKey:@"fsrq"]];
        }  else if (i == 1) {
            _headerView.image = [UIImage imageNamed:@"btn_dingdanhao_h"];
            _messageLabel.text = [NSString stringWithFormat:@"单号:%@",[_dic valueForKey:@"djh"]];
        }  else if (i == 2) {
            _headerView.image = [UIImage imageNamed:@"btn_mendian_h"];
            _messageLabel.text = [NSString stringWithFormat:@"门店:%@",[_dic valueForKey:@"ssgsname"]];
        }  else if (i == 3) {
            _headerView.image = [UIImage imageNamed:@"btn_lianxirenren_h"];
            _messageLabel.text = [NSString stringWithFormat:@"经办人:%@",[_dic valueForKey:@"zdrmc"]];
        }
    }   
}
@end
