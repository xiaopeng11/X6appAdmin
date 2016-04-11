//
//  PurchaseTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseTableViewCell : UITableViewCell

{
    UIView *_bgView;                 //背景
    UIImageView *_rkdhImageView;     //入库单号图片
    UILabel *_rkdhLabel;             //入库单号
    UILabel *_dateLabel;             //日期
    UIView *_lineView;               //间隔
    UIImageView *_gysImageView;      //供应商图片
    UILabel *_gysLabel;              //供应商名
    
    UILabel *_nameLabel;             //名称
    UILabel *_messageLabel;          //详情
}
@property(nonatomic,copy)NSDictionary *dic;
@end
