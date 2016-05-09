//
//  OutboundDetailTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OutboundDetailTableViewCell.h"

@implementation OutboundDetailTableViewCell

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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        [self.contentView addSubview:_imageView];
        
        _cornView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        [self.contentView addSubview:_cornView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, KScreenWidth - 200, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_nameLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 130, 20, 120, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_dateLabel];
        
        for (int i = 0; i < 4; i++) {
            _fourlabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50 + 30 * i, KScreenWidth - 60, 25)];
            _fourlabel.tag = 4610 + i;
            _fourlabel.font = [UIFont systemFontOfSize:17];
            [self.contentView addSubview:_fourlabel];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    NSString *headerURL = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[_dic objectForKey:@"col5"]];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    
    _cornView.image = [UIImage imageNamed:@"corner_circle"];
    
    _nameLabel.text = [_dic valueForKey:@"col4"];
    
    _dateLabel.text = [NSString stringWithFormat:@"日期:%@",[_dic valueForKey:@"col2"]];
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [self.contentView viewWithTag:4610 + i];
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"出库单号:%@",[_dic valueForKey:@"col1"]];
        } else if (i == 1) {
            label.text = [NSString stringWithFormat:@"仓库:%@",[_dic valueForKey:@"col3"]];
        } else if (i == 2) {
            label.text = [NSString stringWithFormat:@"串号:%@",[_dic valueForKey:@"col6"]];
        } else {
            label.text = [NSString stringWithFormat:@"机型:%@",[_dic valueForKey:@"col7"]];
        }
    }
    
}




@end
