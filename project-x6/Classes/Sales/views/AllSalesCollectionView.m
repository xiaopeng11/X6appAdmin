//
//  AllSalesCollectionView.m
//  project-x6
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AllSalesCollectionView.h"
#import "AllSalesCollectionViewCell.h"
@implementation AllSalesCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        //注册
        [self registerClass:[AllSalesCollectionViewCell class] forCellWithReuseIdentifier:@"AllSalesCollection"];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllSalesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllSalesCollection" forIndexPath:indexPath];
    cell.dic = self.datalist[indexPath.item];
    [cell setNeedsLayout];
    return cell;
}




@end
