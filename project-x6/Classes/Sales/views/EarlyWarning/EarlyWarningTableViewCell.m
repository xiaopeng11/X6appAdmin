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
        
//        _warningView = [[UIView alloc] initWithFrame:CGRectMake(_label.right - 25, _label.top - 8, 20, 20)];
//        _warningView.clipsToBounds = YES;
//        _warningView.layer.cornerRadius = 10;
//        _warningView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.5];
//        _warningView.hidden = YES;
//        [self.contentView addSubview:_warningView];
//        
//        _warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        _warningLabel.font = [UIFont systemFontOfSize:10];
//        _warningLabel.textColor = [UIColor whiteColor];
//        _warningLabel.textAlignment = NSTextAlignmentCenter;
//        [_warningView addSubview:_warningLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _image.image = [UIImage imageNamed:[_dic valueForKey:@"image"]];
    
    _label.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"title"]];
    
//    if ([[_dic valueForKey:@"ycNum"] isEqualToString:@"no"]) {
//        _warningView.hidden = YES;
//        
//    } else {
//        _warningView.hidden = NO;
//        if ([[_dic valueForKey:@"ycNum"] doubleValue] > 99) {
//            _warningLabel.text = @"99+";
//        } else {
//            _warningLabel.text = [_dic valueForKey:@"ycNum"];
//        }
//    }
}

@end
