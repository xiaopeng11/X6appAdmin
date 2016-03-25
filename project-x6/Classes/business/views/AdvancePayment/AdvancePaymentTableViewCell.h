//
//  AdvancePaymentTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancePaymentTableViewCell : UITableViewCell

{
    
    UIView *_bgView;
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UIButton *_changeAdvancePayment;
}

@property(nonatomic,copy)NSDictionary *dic;

@end
