//
//  HeaderView.m
//  project-x6
//
//  Created by Apple on 15/11/28.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HeaderView.h"
#import "ChangeHeaderViewViewController.h"
#import "BaseNavigationController.h"
@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化子视图
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    //取出个人数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    //公司代码
    NSString *gsdm = [userInformation objectForKey:@"gsdm"];
    //员工头像地址
    NSString *ygImageUrl = [userdefaults objectForKey:X6_UserHeaderView];
    NSString *info_imageURL = [userInformation objectForKey:@"userpic"];
    //员工姓名
    NSString *ygName = [userInformation objectForKey:@"name"];
    //所属公司
    NSString *companyName = [userInformation objectForKey:@"ssgsname"];
    //岗位
    NSString *gw = [userInformation objectForKey:@"gw"];
    
    //头像
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _headerView.layer.cornerRadius = 30;
    _headerView.clipsToBounds = YES;
    if ([userdefaults objectForKey:X6_UserHeaderView] != nil) {
         [_headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_czyURL,gsdm,ygImageUrl]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    } else {
        [_headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_czyURL,gsdm,info_imageURL]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    }
    
    _headerView.userInteractionEnabled = YES;
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
    [_headerView addGestureRecognizer:tap];
    
    [self addSubview:_headerView];
    

    
    NSArray *informations = @[ygName,companyName,gw];
    //姓名
    for (int i = 0; i < informations.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(_headerView.right + 10, _headerView.top, KScreenWidth - 10 - 60 - 15, 30);
            label.font = [UIFont boldSystemFontOfSize:18];
        } else {
            label.frame = CGRectMake(_headerView.right + 10, _headerView.top + 30 + 20 * (i - 1), KScreenWidth - 10 - 60 - 5 - 10, 20);
            label.font = [UIFont systemFontOfSize:15];
            if (i == 1) {
                label.textColor = Mycolor;
            } else {
                label.textColor = Mycolor;
            }
        }
        label.text = informations[i];
        [self addSubview:label];
    }
  

}

#pragma mark -  点击事件
- (void)buttonAction:(UITapGestureRecognizer *)tap
{
    //跳转到修改图片界面
    NSLog(@"修改图片");
    ChangeHeaderViewViewController *changeHeaderViewVC = [[ChangeHeaderViewViewController alloc] init];

    [self.ViewController.navigationController pushViewController:changeHeaderViewVC animated:YES];
    
}


@end
