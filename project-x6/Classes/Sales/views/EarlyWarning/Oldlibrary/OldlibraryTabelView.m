//
//  OldlibraryTabelView.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibraryTabelView.h"

#import "OldlibrarydetailViewController.h"

#define oldlibraryWidth ((KScreenWidth - 150) / 3.0)
@implementation OldlibraryTabelView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 24, 18)];
        [self.contentView addSubview:_headerView];
        
        _gysLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, KScreenWidth - 60 - 40, 30)];
        _gysLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_gysLabel];
        
        _hpLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, KScreenWidth - 70 - 10, 20)];
        _hpLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_hpLabel];
        
        for (int i = 0; i < 4; i++) {
            int OldlibraryX = i / 2;
            int OldlibraryY = i % 2;
            
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60 + OldlibraryY * (oldlibraryWidth + 40), 75 + 25 * OldlibraryX, 40, 20)];
            if (OldlibraryY == 0) {
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 75 + 25 * OldlibraryX, oldlibraryWidth, 20)];
            } else {
                _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 + (oldlibraryWidth + 40) , 75 + 25 * OldlibraryX, oldlibraryWidth * 2, 20)];
            }            
            _nameLabel.tag = 4630 + i;
            _messageLabel.tag = 4620 + i;
            [self.contentView addSubview:_messageLabel];
            [self.contentView addSubview:_nameLabel];
            
            if (i == 1) {
                _messageLabel.textColor = [UIColor redColor];
            } else {
                _messageLabel.textColor = Mycolor;
            }
            
        }
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(KScreenWidth - 100, 130, 90, 30);
        [_button addTarget:self action:@selector(moreData) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"详情" forState:UIControlStateNormal];
        _button.backgroundColor = Mycolor;
        _button.clipsToBounds = YES;
        _button.layer.cornerRadius = 5;
        [self.contentView addSubview:_button];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerView.image = [UIImage imageNamed:@"btn_gys_h"];
    
    _gysLabel.text = [NSString stringWithFormat:@"供应商:%@",[_dic valueForKey:@"col1"]];
    
    _hpLabel.text = [NSString stringWithFormat:@"货品:%@",[_dic valueForKey:@"col3"]];
    
    for (int i = 0; i < 4; i++) {
        _messageLabel = (UILabel *)[self.contentView viewWithTag:4620 + i];
        _nameLabel = (UILabel *)[self.contentView viewWithTag:4630 + i];

        if (i == 0) {
            _nameLabel.text = @"数量:";
            _messageLabel.text = [NSString stringWithFormat:@"%@",[_dic valueForKey:@"col6"]];
        } else if (i == 1) {
            _nameLabel.text = @"金额:";
            _messageLabel.text = [NSString stringWithFormat:@"￥%@",[_dic valueForKey:@"col7"]];
        } else if (i == 2) {
            _nameLabel.text = @"库龄:";
            _messageLabel.text = [NSString stringWithFormat:@"%@天",[_dic valueForKey:@"col4"]];
        } else {
            _nameLabel.text = @"逾期:";
            _messageLabel.text = [NSString stringWithFormat:@"%@天",[_dic valueForKey:@"col5"]];
        }
    }
}

- (void)moreData
{
    
    OldlibrarydetailViewController *OldlibrarydetailVC = [[OldlibrarydetailViewController alloc] init];
    OldlibrarydetailVC.gysdm = [_dic valueForKey:@"col0"];
    OldlibrarydetailVC.gysName = [_dic valueForKey:@"col1"];
    OldlibrarydetailVC.hpName = [_dic valueForKey:@"col3"];
    OldlibrarydetailVC.spdm = [_dic valueForKey:@"col2"];
    OldlibrarydetailVC.kl = [_dic valueForKey:@"col4"];
    [self.ViewController.navigationController pushViewController:OldlibrarydetailVC animated:YES];
}
@end
