//
//  DepositTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepositTableViewCell : UITableViewCell

{
    UIImageView *_headerView;     //图片
    UILabel *_titleLabel;         //标题
    UILabel *_messageLabel;       //主题
    UILabel *_userLabel;          //经办人
    
    UILabel *_acountLabel;        //帐户
    UILabel *_moneyLabel;         //金额
    
//    UIView *_bottomView;          //底部试图
    
}

@property(nonatomic,copy)NSDictionary *dic;
@end
