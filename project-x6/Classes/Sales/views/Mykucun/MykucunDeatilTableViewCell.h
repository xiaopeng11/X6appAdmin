//
//  MykucunDeatilTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MykucunDeatilTableViewCell : UITableViewCell

{
    UILabel *_titleLabel;
    UILabel *_label;
}

@property(nonatomic,copy)NSDictionary *dic;
@end

