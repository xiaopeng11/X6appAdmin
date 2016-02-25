//
//  MykucunTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MykucunTableViewCell.h"

@implementation MykucunTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, KScreenWidth - 180, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_titleLabel];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 5, 60, 30)];
        _numberLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_numberLabel];
        
        _leadView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 12.5, 15, 15)];
        [self.contentView addSubview:_leadView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.image = [UIImage imageNamed:@"btn_zhankai-_h1"];
    
    _titleLabel.text =  [_dic valueForKey:@"col1"];
    
    _numberLabel.text = [NSString stringWithFormat:@"%@台",[_dic valueForKey:@"col2"]];
    
    
    BOOL isopen = [_dic valueForKey:@"isopen"];
    if (isopen) {
        _leadView.image = [UIImage imageNamed:@"btn_zhankai-_h1"];
    } else {
        _leadView.image = [UIImage imageNamed:@"btn_zhankai-_h1"];
    }
    
    
}

@end