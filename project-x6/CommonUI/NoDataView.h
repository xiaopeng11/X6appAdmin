//
//  NoDataView.h
//  project-x6
//
//  Created by Apple on 16/1/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataView : UIView
{
    UIImageView *_imageview;
    UILabel *_label;
}
@property(nonatomic,copy)NSString *text;
@end
