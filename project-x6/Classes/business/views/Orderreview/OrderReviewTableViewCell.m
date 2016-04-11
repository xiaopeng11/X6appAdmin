
//
//  OrderReviewTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OrderReviewTableViewCell.h"

@implementation OrderReviewTableViewCell

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

        
        //背景
        _OrderbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        _OrderbgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_OrderbgView];
        
        //订单号
        _ddhImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 16)];
        [_OrderbgView addSubview:_ddhImageView];
        _ddhLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, KScreenWidth - 40 - 130, 20)];
        _ddhLabel.font = [UIFont systemFontOfSize:14];
        [_OrderbgView addSubview:_ddhLabel];
        
        //日期
        _dateImageview = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 130, 11, 20, 16)];
        [_OrderbgView addSubview:_dateImageview];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 10, 100, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        [_OrderbgView addSubview:_dateLabel];
        
        //间隔
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth, 1)];
        _lineView.backgroundColor = LineColor;
        [_OrderbgView addSubview:_lineView];
        
        //供应商
        _gysImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 51, 20, 16)];
        [_OrderbgView addSubview:_gysImageView];
        _gysLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, KScreenWidth - 80 - 20, 20)];
        _gysLabel.font = [UIFont systemFontOfSize:15];
        [_OrderbgView addSubview:_gysLabel];
        
        //货品
        _huopiImageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 20, 16)];
        [_OrderbgView addSubview:_huopiImageview];
        _huopinLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 80, KScreenWidth - 80 - 20, 20)];
        _huopinLabel.font = [UIFont systemFontOfSize:15];
        [_OrderbgView addSubview:_huopinLabel];
        
        //详情
        for (int i = 0; i < 4; i++) {
            int order_X = i / 2;
            int order_Y = i % 2;
            
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 + ((KScreenWidth - 50) / 2.0) * order_Y, 110 + 25 * order_X, ((KScreenWidth - 50) / 2.0), 20)];
            _messageLabel.tag = 3300 + i;
            _messageLabel.font = [UIFont systemFontOfSize:14];
            [_OrderbgView addSubview:_messageLabel];
        }

        _orderButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 165, 80, 30)];
        [_orderButton setBackgroundColor:Mycolor];
        [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_OrderbgView addSubview:_orderButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _ddhImageView.image = [UIImage imageNamed:@"btn_dingdanhao_h"];
    _ddhLabel.text = [NSString stringWithFormat:@"订单号:%@",[_dic valueForKey:@"col1"]];
    
    _dateImageview.image = [UIImage imageNamed:@"btn_riqi_h"];
    _dateLabel.text = [NSString stringWithFormat:@"日期:%@",[_dic valueForKey:@"col2"]];
    
    _gysLabel.text = [NSString stringWithFormat:@"供应商:%@",[_dic valueForKey:@"col3"]];
    
    _huopinLabel.text = [NSString stringWithFormat:@"货品:%@",[_dic valueForKey:@"col4"]];
    
    if ([[_dic valueForKey:@"isexam"] boolValue] == 1) {
        _gysImageView.image = [UIImage imageNamed:@"btn_gys_h"];
        _huopiImageview.image = [UIImage imageNamed:@"btn_huopin_h"];
        [_orderButton addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
        [_orderButton setTitle:@"审核" forState:UIControlStateNormal];
    } else {
        _gysImageView.image = [UIImage imageNamed:@"btn_gys_h2"];
        _huopiImageview.image = [UIImage imageNamed:@"btn_huopin_h2"];
        [_orderButton addTarget:self action:@selector(revokeorderAction) forControlEvents:UIControlEventTouchUpInside];
        [_orderButton setTitle:@"撤审" forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < 4; i++) {
        _messageLabel = [self.contentView viewWithTag:3300 + i];
        if (i == 0) {
            _messageLabel.text = [NSString stringWithFormat:@"数量:%@台",[_dic valueForKey:@"col5"]];
        } else if (i == 1) {
            _messageLabel.text = [NSString stringWithFormat:@"单价:￥%@",[_dic valueForKey:@"col6"]];
        } else if (i == 2) {
            _messageLabel.text = [NSString stringWithFormat:@"单台返利:￥%@",[_dic valueForKey:@"col7"]];
        } else if (i == 3) {
            _messageLabel.text = [NSString stringWithFormat:@"金额:￥%@",[_dic valueForKey:@"col8"]];
        }
    }
    
    
}

- (void)orderAction
{
    NSLog(@"点击了审核按钮");
//    [_orderButton respondsToSelector:@selector(revokeorderAction)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderAction" object:[_dic valueForKey:@"col0"]];
    
}

- (void)revokeorderAction
{
    NSLog(@"点击了撤销审核按钮");
    [_orderButton respondsToSelector:@selector(orderAction)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"revokeAction" object:[_dic valueForKey:@"col0"]];
}

@end
