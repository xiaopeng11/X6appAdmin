//
//  SpeSalesTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeSalesTableViewCell : UITableViewCell

{
    UIView *_bgview;
    UILabel *_label;
    UIImageView *_imageview;
    
}

@property(nonatomic,strong)NSDictionary *dic;
@end
