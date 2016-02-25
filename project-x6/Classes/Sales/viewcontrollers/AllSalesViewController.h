//
//  AllSalesViewController.h
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "WJItemsControlView.h"
#import "AllSalesCollectionView.h"

@interface AllSalesViewController : BaseViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;               //滑动式图
    WJItemsControlView *_itemsControlView;   //眉头试图
    NSInteger _index;                        //选择控制器选中位置
    UIView *_bgView;                         //头视图背景
}

@property(nonatomic,strong)NSArray *datalist;//数据


@end
