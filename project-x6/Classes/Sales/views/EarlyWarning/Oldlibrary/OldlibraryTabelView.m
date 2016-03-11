//
//  OldlibraryTabelView.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibraryTabelView.h"

#import "OldlibrarydetailViewController.h"
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
        
        _hpLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, KScreenWidth - 90 - 40, 20)];
        _hpLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_hpLabel];
        
        for (int i = 0; i < 4; i++) {
            int OldlibraryX = i / 2;
            int OldlibraryY = i % 2;
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 + ((KScreenWidth - 90) / 2.0) * OldlibraryY, 75 + 25 * OldlibraryX, (KScreenWidth - 90) / 2.0, 20)];
            _messageLabel.tag = 4620 + i;
            [self.contentView addSubview:_messageLabel];
            
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
    
    _headerView.image = [UIImage imageNamed:@"btn_gyschuanhao_h"];
    
    _gysLabel.text = [NSString stringWithFormat:@"供应商:%@",[_dic valueForKey:@"col1"]];
    
    _hpLabel.text = [NSString stringWithFormat:@"货品:%@",[_dic valueForKey:@"col3"]];
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [self.contentView viewWithTag:4620 + i];
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"数量:%@",[_dic valueForKey:@"col6"]];
        } else if (i == 1) {
            label.text = [NSString stringWithFormat:@"金额:%@",[_dic valueForKey:@"col7"]];
        } else if (i == 2) {
            label.text = [NSString stringWithFormat:@"库龄:%@天",[_dic valueForKey:@"col4"]];
        } else {
            label.text = [NSString stringWithFormat:@"预期:%@天",[_dic valueForKey:@"col5"]];
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
