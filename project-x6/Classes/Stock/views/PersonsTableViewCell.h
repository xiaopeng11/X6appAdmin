//
//  PersonsTableViewCell.h
//  project-x6
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PersonsTableViewCell : UITableViewCell

{
    UILabel *_nameLabel;
    UIImageView *_imageView;
    UILabel *_companyLabel;
}
@property(nonatomic,strong)NSString *name;  //需要的数据
@property(nonatomic,strong)NSArray *datalist;     //所有的数据
@property(nonatomic,strong)NSArray *comdatalist;
@property(nonatomic,strong)NSArray *gwdatalist;  
@property(nonatomic,assign)BOOL type;       //判断当前页面的来源

@end
