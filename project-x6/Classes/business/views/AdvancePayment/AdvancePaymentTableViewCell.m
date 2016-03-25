//
//  AdvancePaymentTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AdvancePaymentTableViewCell.h"

@implementation AdvancePaymentTableViewCell

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
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 155)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        for (int i = 0; i < 6; i++) {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5 + 20 * i, 22, 20)];
            _imageView.tag = 3410 + i;
            [self.contentView addSubview:_imageView];
            
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 5 + 20 * i, KScreenWidth - 52 - 20, 20)];
            _nameLabel.tag = 3420 + i;
            [self.contentView addSubview:_nameLabel];
            
           
        }
        
        _changeAdvancePayment = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeAdvancePayment.frame = CGRectMake(KScreenWidth - 100, 115, 80, 30);
        [_changeAdvancePayment setTitle:@"修改" forState:UIControlStateNormal];
        [_changeAdvancePayment setBackgroundColor:Mycolor];
        [_changeAdvancePayment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeAdvancePayment addTarget:self action:@selector(changeAdvancePayment) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_changeAdvancePayment];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 6; i++) {
        _imageView = (UIImageView *)[self.contentView viewWithTag:3410 + i];
        _nameLabel = (UILabel *)[self.contentView viewWithTag:3420 + i];
        if (i == 0) {
            _imageView.image = [UIImage imageNamed:@"btn_riqi_h"];
            _nameLabel.text = [NSString stringWithFormat:@"日期:%@",[_dic valueForKey:@""]];
        } else if (i == 1) {
            _imageView.image = [UIImage imageNamed:@"btn_gongsi_h"];
            _nameLabel.text = [NSString stringWithFormat:@"公司:%@",[_dic valueForKey:@""]];
        } else if (i == 2) {
            _imageView.image = [UIImage imageNamed:@"btn_gys_h3"];
            _nameLabel.text = [NSString stringWithFormat:@"供应商:%@",[_dic valueForKey:@""]];
        } else if (i == 3) {
            _imageView.image = [UIImage imageNamed:@"btn_jine_h"];
            _nameLabel.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@""]];
        } else if (i == 4) {
            _imageView.image = [UIImage imageNamed:@"btn_zhanghu_h"];
            _nameLabel.text = [NSString stringWithFormat:@"帐户:%@",[_dic valueForKey:@""]];
        } else if (i == 5) {
            _imageView.image = [UIImage imageNamed:@"btn_beizhu_h"];
            _nameLabel.text = [NSString stringWithFormat:@"备注:%@",[_dic valueForKey:@""]];
        }
    }
    
}

- (void)changeAdvancePayment
{
    
}

@end
