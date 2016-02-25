//
//  PictureDetailCollectionViewCell.h
//  project-x6
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FocusModel.h"
@interface PictureDetailCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_imageView;
}

@property(nonatomic,strong)FocusModel *model;
@property(nonatomic,assign)int imagepath;
@end
