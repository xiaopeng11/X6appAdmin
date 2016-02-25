//
//  AllSalesCollectionView.h
//  project-x6
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllSalesCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>


@property(nonatomic,copy)NSArray *datalist;
@end
