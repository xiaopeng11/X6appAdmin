//
//  RetailTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetailTableViewCell : UITableViewCell

{
    UIView *_bgView;               //背景
    UIImageView *_dhImageView;     //出库单号图片
    UILabel *_dhLabel;             //出库单号
    UILabel *_dateLabel;           //日期
    UIView *_lineView;             //间隔
    UIImageView *_mdImageView;     //门店图片
    UILabel *_mdLabel;             //门店名
    UILabel *_yyyLabel;            //营业员名
    UILabel *_messageLabel;        //详情信息
    UILabel *_chuanhaoLabel;
    
}

@property(nonatomic,copy)NSDictionary *dic;
@end
