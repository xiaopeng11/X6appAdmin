//
//  SelectTableViewCell.h
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GwsModel.h"
@interface SelectTableViewCell : UITableViewCell
{
    UILabel *label;
}

@property(nonatomic,strong)GwsModel *model;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,assign)BOOL iscompany;
@property(nonatomic,assign)BOOL type;       //判断当前页面的来源

@end
