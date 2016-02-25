//
//  MykucunTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MykucunTableViewCell : UITableViewCell

{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_numberLabel;
    UIImageView *_leadView;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
