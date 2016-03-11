//
//  OldlibrarydetailViewController.h
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface OldlibrarydetailViewController : BaseViewController

@property(nonatomic,copy)NSNumber *gysdm;  //供应商代码
@property(nonatomic,copy)NSNumber *spdm;   //商品代码

@property(nonatomic,copy)NSString *gysName; //供应商名称
@property(nonatomic,copy)NSString *hpName; //供应商名称

@property(nonatomic,copy)NSNumber *kl;     //库龄
@end
