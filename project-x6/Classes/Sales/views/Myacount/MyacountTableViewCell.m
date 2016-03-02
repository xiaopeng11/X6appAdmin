//
//  MyacountTableViewCell.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyacountTableViewCell.h"

@implementation MyacountTableViewCell

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
        
        self.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        [_bgView addSubview:_imageView];
        
        _bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, KScreenWidth - 40, 29)];
        [_bgView addSubview:_bankLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, KScreenWidth, 1)];
        _lineView.backgroundColor = LineColor;
        [_bgView addSubview:_lineView];
        
        for (int i = 0; i < 6; i++) {
            int myacountX = i / 2;
            int myacountY = i % 2;
            _myacountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 + 85 * myacountY, 32 + 22 * myacountX, 80, 20)];
            if (myacountY == 0) {
                _myacountLabel.textAlignment = NSTextAlignmentRight;
            } else {
                _myacountLabel.textAlignment = NSTextAlignmentLeft;
            }
            _myacountLabel.tag = 4710 + i;
            _myacountLabel.font = [UIFont systemFontOfSize:15];
            [_bgView addSubview:_myacountLabel];
        }
        
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.image = [UIImage imageNamed:@""];
    
    _bankLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col0"]];
    
    for (int i = 0; i < 6; i++) {
        _myacountLabel = (UILabel *)[self.contentView viewWithTag:4710 + i];
        if (i == 0) {
            _myacountLabel.text = @"本期收入: ";
        } else if (i == 2) {
            _myacountLabel.text = @"本期支出: ";
        } else if (i == 4) {
            _myacountLabel.text = @"余额: ";
        } else if (i == 1) {
            _myacountLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col2"]];
        } else if (i == 3) {
            _myacountLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col3"]];
        } else if (i == 5) {
            _myacountLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col4"]];
        }
    }
}
@end
