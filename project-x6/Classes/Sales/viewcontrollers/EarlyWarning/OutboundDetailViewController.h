//
//  OutboundDetailViewController.h
//  project-x6
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface OutboundDetailViewController : BaseViewController

@property(nonatomic,strong)NSString *dateString;  //年月
@property(nonatomic,strong)NSString *ssgs;        //门店代码
@property(nonatomic,copy)NSString *ssgsName;      //门店名
@end
