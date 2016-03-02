//
//  TodaySalesTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodaySalesTableViewCell.h"
#define HalfScreenWidth ((KScreenWidth - 80) / 2.0)
@implementation TodaySalesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 40, 20)];
        [self.contentView addSubview:_titleLabel];
        
        for (int i = 0; i < 4; i++) {
            int myX = i / 2;
            int myY = i % 2;
            _Label = [[UILabel alloc] initWithFrame:CGRectMake(80 + HalfScreenWidth * myY, 25 + 15 * myX, HalfScreenWidth, 15)];
            _Label.font = [UIFont systemFontOfSize:14];
            _Label.textColor = [UIColor grayColor];
            _Label.tag = 4310 + i;
            [self.contentView addSubview:_Label];
        }
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.image = [UIImage imageNamed:@"btn_mendian_h"];
    
    _titleLabel.text = [_dic valueForKey:@"col0"];
    
    long long junmao = [[_dic valueForKey:@"col3"] longLongValue] / [[_dic valueForKey:@"col1"] longLongValue];
    
    for (int i = 0; i < 4; i++) {
        _Label = [self.contentView viewWithTag:4310 + i];
        if (i == 0) {
            _Label.text = [NSString stringWithFormat:@"数量:%@",[_dic valueForKey:@"col1"]];
        } else if (i == 1) {
            _Label.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@"col2"]];
        } else if (i == 2) {
            _Label.text = [NSString stringWithFormat:@"均毛:%lld",junmao];
        } else{
            _Label.text = [NSString stringWithFormat:@"毛利:%@",[_dic valueForKey:@"col3"]];
        }
    }
}
@end
