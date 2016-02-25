//
//  AllSalesCollectionViewCell.h
//  project-x6
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllSalesCollectionViewCell : UICollectionViewCell

{
    UIView *_view;
    UIImageView *_headerView;  //头像
    UILabel *_name;            //名字
}

@property(nonatomic,strong)NSDictionary *dic;
@end
