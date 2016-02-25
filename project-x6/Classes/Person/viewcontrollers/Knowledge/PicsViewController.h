//
//  PicsViewController.h
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface PicsViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>

{
    UICollectionView *_picCollectionViews;
}

@end
