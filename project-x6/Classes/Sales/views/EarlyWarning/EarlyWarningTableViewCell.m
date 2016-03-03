//
//  EarlyWarningTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EarlyWarningTableViewCell.h"

@implementation EarlyWarningTableViewCell

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
        _image = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 130) / 2.0, 15, 30, 30)];
        [self.contentView addSubview:_image];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 130) / 2.0 + 40, 15, 90, 30)];
        _label.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _image.image = [UIImage imageNamed:[_dic valueForKey:@"image"]];
    
    _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"title"]];
}

@end
