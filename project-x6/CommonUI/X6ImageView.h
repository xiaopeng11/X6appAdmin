//
//  X6ImageView.h
//  project-x6
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface X6ImageView : UIImageView<UIActionSheetDelegate>
{
    UIScrollView *_scrollView;    //图片滑动式图
    UIImageView *_orginImageView;  //放大后的图片
    UIProgressView *_progressView;  //图片下载进度条
}

@property(nonatomic,copy)NSString *bgImageURL;
@end
