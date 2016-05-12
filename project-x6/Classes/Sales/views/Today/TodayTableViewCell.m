//
//  TodayTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayTableViewCell.h"

#define todaywidth ((KScreenWidth - 135) / 5.0)
@implementation TodayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 0, 25, 25)];
        [self.contentView addSubview:_imageView];
        
        _headerViewbg = [[UIImageView alloc] initWithFrame:CGRectMake(35, 0, 25, 25)];
        [self.contentView addSubview:_headerViewbg];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, KScreenWidth - 100, 25)];
        [self.contentView addSubview:_titleLabel];
        
        for (int i = 0; i < 3; i++) {
            _nameLabel = [[UILabel alloc] init];
            _label = [[UILabel alloc] init];
            if (i == 0) {
                _nameLabel.frame = CGRectMake(35, 30, 30, 20);
                _label.frame = CGRectMake(65, 30, todaywidth, 20);
                _label.textColor = [UIColor grayColor];
            } else if (i == 1) {
                _nameLabel.frame = CGRectMake(65 + todaywidth, 30, 30, 20);
                _label.frame = CGRectMake(95 + todaywidth, 30, todaywidth * 2, 20);
                _label.textColor = [UIColor redColor];
            } else {
                _nameLabel.frame = CGRectMake(95 + todaywidth * 3, 30, 30, 20);
                _label.frame = CGRectMake(125 + todaywidth * 3, 30, todaywidth * 2, 20);
                _label.textColor = Mycolor;
            }
            _label.font = [UIFont systemFontOfSize:13];
            _nameLabel.font = [UIFont systemFontOfSize:13];
            _nameLabel.textColor = [UIColor grayColor];
            _label.tag = 4210 + i;
            _nameLabel.tag = 4220 + i;
            [self.contentView addSubview:_label];
            [self.contentView addSubview:_nameLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerViewbg.image = [UIImage imageNamed:@"corner_circle"];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    NSString *headerURL = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[_dic objectForKey:@"col2"]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    
    _titleLabel.text = [_dic valueForKey:@"col1"];
    
    for (int i = 0; i < 3; i++) {
        _label = (UILabel *)[self.contentView viewWithTag:4210 + i];
        _nameLabel = (UILabel *)[self.contentView viewWithTag:4220 + i];
        if (i == 0) {
            _nameLabel.text = @"数量:";
            _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
        } else if (i == 1) {
            _nameLabel.text = @"金额:";
            _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col4"]];
        } else if (i == 2) {
            _nameLabel.text = @"毛利:";
            if ([[_dic allKeys] containsObject:@"col5"]) {
                _label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col5"]];
            } else {
                _label.text = [NSString stringWithFormat:@"￥****"];
            }
        }
    }
    
}
@end
