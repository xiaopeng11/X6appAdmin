//
//  WholesaleTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/5/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "WholesaleTableViewCell.h"
#define HalfScreenWidth ((KScreenWidth - 130) / 2.0)

@implementation WholesaleTableViewCell

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
        
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
        [self.contentView addSubview:_titleImageView];
        
        _headerViewbg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
        _headerViewbg.hidden = YES;
        [self.contentView addSubview:_headerViewbg];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, KScreenWidth - 70, 20)];
        [self.contentView addSubview:_titleLabel];
        
        for (int i = 0; i < 4; i++) {
            _nameLabel = [[UILabel alloc] init];
            _Label = [[UILabel alloc] init];
            _nameLabel.font = [UIFont systemFontOfSize:13];
            _Label.font = [UIFont systemFontOfSize:13];
            _nameLabel.tag = 4320 + i;
            _Label.tag = 4310 + i;
            _nameLabel.textColor = [UIColor grayColor];
            if (i == 0) {
                _nameLabel.frame = CGRectMake(56, 30, 30, 15);
                _Label.frame = CGRectMake(86, 30, HalfScreenWidth, 15);
            } else if (i == 1) {
                _nameLabel.frame = CGRectMake(86 + HalfScreenWidth, 30, 30, 15);
                _Label.frame = CGRectMake(116 + HalfScreenWidth, 30, HalfScreenWidth, 15);
                _Label.textColor = [UIColor redColor];
            } else if (i == 2) {
                _nameLabel.frame = CGRectMake(56, 50, 30, 15);
                _Label.frame = CGRectMake(86, 50, HalfScreenWidth, 15);
                _Label.textColor = Mycolor;
            } else {
                _nameLabel.frame = CGRectMake(86 + HalfScreenWidth, 50, 30, 15);
                _Label.frame = CGRectMake(116 + HalfScreenWidth, 50, HalfScreenWidth, 15);
                _Label.textColor = Mycolor;
            }
            [self.contentView addSubview:_Label];
            [self.contentView addSubview:_nameLabel];
        }
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.soucre isEqualToString:X6_WholesaleUnits]) {
        _headerViewbg.hidden = NO;
        _headerViewbg.image = [UIImage imageNamed:@"corner_circle"];
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
        NSString *companyString = [dic objectForKey:@"gsdm"];
        NSString *headerURL = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[_dic objectForKey:@"col2"]];
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
        
        for (int i = 0; i < 4; i++) {
            _Label = (UILabel *)[self.contentView viewWithTag:4310 + i];
            _nameLabel = (UILabel *)[self.contentView viewWithTag:4320 + i];
            if (i == 0) {
                _nameLabel.text = @"数量:";
                _Label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
            } else if (i == 1) {
                _nameLabel.text = @"金额:";
                _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col4"]];
            } else if (i == 2) {
                _nameLabel.text = @"均毛:";
                if ([[_dic allKeys] containsObject:@"col5"]) {
                    long long junmao = [[_dic valueForKey:@"col5"] longLongValue] / [[_dic valueForKey:@"col3"] longLongValue];
                    _Label.text = [NSString stringWithFormat:@"￥%lld",junmao];
                } else {
                    _Label.text = [NSString stringWithFormat:@"￥****"];
                }
            } else{
                _nameLabel.text = @"利润:";
                if ([[_dic allKeys] containsObject:@"col5"]) {
                    _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col5"]];
                } else {
                    _Label.text = [NSString stringWithFormat:@"￥****"];
                }
            }
        }
    } else {
        if ([self.soucre isEqualToString:X6_WholesaleSales]) {
            _headerViewbg.hidden = YES;
            _titleImageView.image = [UIImage imageNamed:@"btn_kehu_h"];
        } else if ([self.soucre isEqualToString:X6_WholesaleSummary]) {
            _headerViewbg.hidden = YES;
            _titleImageView.image = [UIImage imageNamed:@"btn_shangpin_h"];
        }
        
        for (int i = 0; i < 4; i++) {
            _Label = (UILabel *)[self.contentView viewWithTag:4310 + i];
            _nameLabel = (UILabel *)[self.contentView viewWithTag:4320 + i];
            if (i == 0) {
                _nameLabel.text = @"数量:";
                _Label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
            } else if (i == 1) {
                _nameLabel.text = @"金额:";
                _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col3"]];
            } else if (i == 2) {
                _nameLabel.text = @"均毛:";
                if ([[_dic allKeys] containsObject:@"col4"]) {
                    long long junmao = [[_dic valueForKey:@"col4"] longLongValue] / [[_dic valueForKey:@"col2"] longLongValue];
                    _Label.text = [NSString stringWithFormat:@"￥%lld",junmao];
                } else {
                    _Label.text = [NSString stringWithFormat:@"￥****"];
                }
            } else{
                _nameLabel.text = @"利润:";
                if ([[_dic allKeys] containsObject:@"col4"]) {
                    _Label.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col4"]];
                } else {
                    _Label.text = [NSString stringWithFormat:@"￥****"];
                }
            }
        }
    }
    
    _titleLabel.text = [_dic valueForKey:@"col1"];
    
    
  
}
@end