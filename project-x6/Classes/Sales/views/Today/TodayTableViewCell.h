//
//  TodayTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTableViewCell : UITableViewCell

{
    UIImageView *_headerViewbg;
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_label;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
