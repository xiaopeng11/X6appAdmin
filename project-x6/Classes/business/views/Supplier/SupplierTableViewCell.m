//
//  SupplierTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SupplierTableViewCell.h"

@implementation SupplierTableViewCell

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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 23, 20)];
        [self.contentView addSubview:_imageView];
        
        _supplierName = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, KScreenWidth - 150 - 45, 20)];
        [self.contentView addSubview:_supplierName];
        
        _needPayMoney = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 150, 10, 130, 20)];
        _needPayMoney.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_needPayMoney];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 40, (KScreenWidth - 100) / 2.0, 15)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(45 + (KScreenWidth - 100) / 2.0, 40, (KScreenWidth - 100) / 2.0, 15)];
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_phoneLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.image = [UIImage imageNamed:@"btn_gys_h"];
    
    _supplierName.text = [_dic valueForKey:@"name"];
    
    if (_issupplier) {
        _needPayMoney.text = [NSString stringWithFormat:@"应付款:%@",[_dic valueForKey:@"yfje"]];
    } else {
        _needPayMoney.text = [NSString stringWithFormat:@"应收款:%@",[_dic valueForKey:@"ysje"]];
    }
    
  
    _nameLabel.text = [NSString stringWithFormat:@"联系人:%@",[_dic valueForKey:@"lxr"]];
    
    _phoneLabel.text = [NSString stringWithFormat:@"电话:%@",[_dic valueForKey:@"lxhm"]];
}
@end
