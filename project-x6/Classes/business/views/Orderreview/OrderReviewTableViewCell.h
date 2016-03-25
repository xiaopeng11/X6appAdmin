//
//  OrderReviewTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderReviewTableViewCell : UITableViewCell
{
    UIView *_OrderbgView;               //背景
    UIImageView *_ddhImageView;         //订单号图片
    UILabel *_ddhLabel;                 //订单号
    UIImageView *_dateImageview;        //日期图片
    UILabel *_dateLabel;                //日期
    UIView *_lineView;                  //间隔
    UIImageView *_gysImageView;         //供应商图片
    UILabel *_gysLabel;                 //供应商名
    UIImageView *_huopiImageview;       //货品图片
    UILabel *_huopinLabel;              //货品名
    UILabel *_messageLabel;             //详情
    
    UIButton *_orderButton;             //审核
}

@property(nonatomic,copy)NSDictionary *dic;
@end
