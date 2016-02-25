//
//  SalesTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SalesTableViewCell.h"

@implementation SalesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子视图
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20 + (KScreenWidth - 90) / 2.0, 15, 90, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:_label];
        
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(_label.left - 50, 10, 40, 40)];
        [self.contentView addSubview:_imageview];
    }
    return self;
}

- (void)layoutSubviews

{
    [super layoutSubviews];
    _label.text = [_dic valueForKey:@"text"];
    
    _imageview.image = [UIImage imageNamed:[_dic valueForKey:@"image"]];
}

@end
