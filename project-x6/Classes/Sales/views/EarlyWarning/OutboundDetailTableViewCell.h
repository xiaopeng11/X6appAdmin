//
//  OutboundDetailTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutboundDetailTableViewCell : UITableViewCell
{
    UIImageView *_imageView;
    UIImageView *_cornView;
    UILabel *_dateLabel;
    
    UILabel *_nameLabel;
    UILabel *_fourlabel;
}


@property(nonatomic,copy)NSDictionary *dic;
@end
