//
//  GwsViewController.h
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"



@interface GwsViewController : BaseViewController

@property(nonatomic,copy)NSArray *datalist;     //联系人数据
@property(nonatomic,copy)NSArray *gwdatalist;     //岗位数据
@property(nonatomic,copy)NSArray *comdatalist;
@property(nonatomic,assign)BOOL type;       //判断当前页面的来源
@property(nonatomic,assign)BOOL replytype;       //判断当前页面的来源
@end
