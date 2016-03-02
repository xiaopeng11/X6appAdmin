//
//  SelectTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SelectTableViewCell.h"

@implementation SelectTableViewCell

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
        //
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
        [self.contentView addSubview:imageView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, KScreenWidth - 80 - 60, 40)];
        label.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:label];
        
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_button];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_iscompany) {
        imageView.image = [UIImage imageNamed:@"btn_kuangjia_h"];
    } else {
        imageView.image = [UIImage imageNamed:@"btn_gangwei_h"];
    }
    
    label.text = self.model.name;
    
    if (_type == YES) {
        _button.frame = CGRectMake(KScreenWidth - 60, 10, 40, 40);
        if (self.model.check == NO) {
            [_button setImage:[UIImage imageNamed:@"icon_image_no"] forState:UIControlStateNormal];
        } else {
            [_button setImage:[UIImage imageNamed:@"icon_image_yes"] forState:UIControlStateNormal];
        }
    }
   
}


@end
