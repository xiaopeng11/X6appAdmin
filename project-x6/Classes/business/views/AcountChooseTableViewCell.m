//
//  AcountChooseTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AcountChooseTableViewCell.h"

@implementation AcountChooseTableViewCell

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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 22, 20)];
        [self.contentView addSubview:_imageView];
        
        _bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 10, KScreenWidth - 150, 30)];
        _bankLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_bankLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 10, 100, 30)];
        _moneyLabel.hidden = YES;
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_moneyLabel];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.image = [UIImage imageNamed:@"btn_zhanghu_h"];
    
    _bankLabel.text = [_dic valueForKey:@"name"];
    
    if (![[_dic valueForKey:@"choose"] isEqualToString:@""]) {
        _moneyLabel.hidden = NO;
        _moneyLabel.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@"choose"]];
    } else {
        _moneyLabel.hidden = YES;
    }
}
@end
