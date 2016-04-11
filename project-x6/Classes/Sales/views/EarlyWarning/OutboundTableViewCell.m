//
//  OutboundTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OutboundTableViewCell.h"

@implementation OutboundTableViewCell

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
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_headerImageView];
        
        _cornView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_cornView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    NSString *headerURL = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[_dic objectForKey:@"col1"]];
    _headerImageView.frame = CGRectMake(20, 5, 30, 30);
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    
    _cornView.frame = CGRectMake(20, 5, 30, 30);
    _cornView.image = [UIImage imageNamed:@"corner_circle"];
    
    _label.frame = CGRectMake(70, 10, KScreenWidth - 70 - 10, 20);
    _label.text = [NSString stringWithFormat:@"%@:异常%@次",[_dic valueForKey:@"col0"],[_dic valueForKey:@"col2"]];
}
@end
