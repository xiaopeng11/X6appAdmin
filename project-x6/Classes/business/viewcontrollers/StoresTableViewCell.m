//
//  StoresTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "StoresTableViewCell.h"

@implementation StoresTableViewCell

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
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 24, 20)];
        [self.contentView addSubview:_imageview];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, KScreenWidth - 100, 30)];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isStore) {
        _imageview.image = [UIImage imageNamed:@"btn_mendian_h"];
    } else {
        _imageview.image = [UIImage imageNamed:@"bth_ren_h"];
    }
    
    _label.text = [_dic valueForKey:@"name"];
}
@end
