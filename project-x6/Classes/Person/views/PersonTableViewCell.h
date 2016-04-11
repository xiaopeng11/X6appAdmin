//
//  PersonTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTableViewCell : UITableViewCell

{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIImageView *_leadView;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
