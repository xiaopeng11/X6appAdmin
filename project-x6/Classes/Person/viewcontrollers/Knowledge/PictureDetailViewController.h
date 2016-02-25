//
//  PictureDetailViewController.h
//  project-x6
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface PictureDetailViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
}

@property(nonatomic,strong)NSArray *imageDatalist;
@property(nonatomic,assign)int selectimage;

@end
