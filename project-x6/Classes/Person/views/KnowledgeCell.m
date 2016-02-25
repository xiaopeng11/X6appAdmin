//
//  KnowledgeCell.m
//  project-x6
//
//  Created by Apple on 16/1/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "KnowledgeCell.h"

@implementation KnowledgeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = nil;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth / 2.0 - 55, 20, 45, 40)];
        [self.contentView addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 2.0, 20, 60, 40)];
        _label.font = [UIFont systemFontOfSize:20];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.image = [UIImage imageNamed:[_dic valueForKey:@"image"]];
    
    _label.text = [_dic valueForKey:@"title"];
    
}

@end
