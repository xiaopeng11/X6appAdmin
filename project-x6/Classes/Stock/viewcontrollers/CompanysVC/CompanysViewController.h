//
//  CompanysViewController.h
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface CompanysViewController : BaseViewController

@property(nonatomic,copy)NSArray *datalist;  //联系人数据
@property(nonatomic,copy)NSMutableArray *kuangjiadatalist;  //框架数据
@property(nonatomic,assign)BOOL type;       //判断当前页面的来源
@property(nonatomic,assign)BOOL replytype;       //判断当前页面的来源
@end
