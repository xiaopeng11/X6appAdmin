//
//  StoresTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoresTableViewCell : UITableViewCell
{
    UIImageView *_imageview;
    UILabel *_label;
}
@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,assign)BOOL isStore;
@end
