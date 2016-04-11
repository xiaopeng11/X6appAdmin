//
//  PersonTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

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
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
        [self.contentView addSubview:_titleLabel];
        
        _leadView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 15, 20, 20)];
        [self.contentView addSubview:_leadView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.image = [UIImage imageNamed:[_dic valueForKey:@"ImageName"]];
    
    _titleLabel.text = [_dic valueForKey:@"Title"];
    
    _leadView.image = [UIImage imageNamed:@"btn_jiantou_h"];
}
@end
