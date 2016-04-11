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
    UILabel *_messageLabel;       //主题
    
    UILabel *_acountLabel;        //帐户
    UILabel *_moneyTitleLabel;    //金额标题
    UILabel *_moneyLabel;         //金额
    UILabel *_totalTitleLabel;    //总金额标题
    UILabel *_totalMoney;         //总金额

}

@property(nonatomic,copy)NSDictionary *dic;
@end
