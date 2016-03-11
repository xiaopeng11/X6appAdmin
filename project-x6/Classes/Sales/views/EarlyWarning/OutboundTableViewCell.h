//
//  OutboundTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutboundTableViewCell : UITableViewCell

{
    UIImageView *_cornView;
    UIImageView *_headerImageView;
    UILabel *_label;
}
@property(nonatomic,copy)NSDictionary *dic;
@end
