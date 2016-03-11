//
//  OldlibraryTabelView.h
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OldlibraryTabelView : UITableViewCell

{
    UIImageView *_headerView;
    UILabel *_gysLabel;
    UILabel *_hpLabel;
    UILabel *_messageLabel;
    
    UIButton *_button;
}

@property(nonatomic,copy)NSDictionary *dic;
@end
