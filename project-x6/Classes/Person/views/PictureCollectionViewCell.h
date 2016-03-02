//
//  PictureCollectionViewCell.h
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FocusModel.h"
#import "X6ImageView.h"
@interface PictureCollectionViewCell : UICollectionViewCell
{
    UIView *_view;
    UIImageView *_imageView;
    UILabel *_title;
}

@property(nonatomic,strong)FocusModel *model;
@end
