//
//  SpeSalesTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SpeSalesTableViewCell.h"

@implementation SpeSalesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        //初始化子视图
        self.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
        
        _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 60)];
        _bgview.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgview];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20 + (KScreenWidth - 90) / 2.0, 15, 90, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:18];
        [_bgview addSubview:_label];
        
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(_label.left - 40, 15, 30, 30)];
        [_bgview addSubview:_imageview];
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
