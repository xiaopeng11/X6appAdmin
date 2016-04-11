
//
//  AcuntAndMoneyTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AcuntAndMoneyTableViewCell.h"

@implementation AcuntAndMoneyTableViewCell

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
        
        self.backgroundColor = [UIColor clearColor];
        _acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 145 - 40, 30)];
        _acountLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_acountLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 185, 0, 90, 30)];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_moneyLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _acountLabel.text = [_dic valueForKey:@"acount"];
    
    _moneyLabel.text = [_dic valueForKey:@"money"];
}

@end
