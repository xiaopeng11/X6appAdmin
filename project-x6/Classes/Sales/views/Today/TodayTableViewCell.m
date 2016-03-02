//
//  TodayTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayTableViewCell.h"

@implementation TodayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        [self.contentView addSubview:_imageView];
        
        _headerViewbg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        [self.contentView addSubview:_headerViewbg];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, KScreenWidth - 50, 30)];
        [self.contentView addSubview:_titleLabel];
        
        for (int i = 0; i < 3; i++) {
            
            _label = [[UILabel alloc] initWithFrame:CGRectMake(50 + ((KScreenWidth - 50) / 3.0) * i, 30, (KScreenWidth - 50) / 3.0, 20)];
            _label.font = [UIFont systemFontOfSize:14];
            _label.textColor = [UIColor grayColor];
            _label.tag = 4210 + i;
       
            [self.contentView addSubview:_label];
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
        UILabel *label = (UILabel *)[self.contentView viewWithTag:4210 + i];
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"数量:%@",[_dic valueForKey:@"col3"]];
        } else if (i == 1) {
            label.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@"col4"]];
        } else if (i == 2) {
            label.text = [NSString stringWithFormat:@"毛利:%@",[_dic valueForKey:@"col5"]];
        }
    }
    
}
@end
