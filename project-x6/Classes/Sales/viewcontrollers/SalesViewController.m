//
//  SalesViewController.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SalesViewController.h"


#import "MyKucunViewController.h"
#import "TodayViewController.h"
#import "TodaySalesViewController.h"
#import "TodayMoneyViewController.h"
#import "TodayPayViewController.h"
#import "EarlyWarningViewController.h"
#import "MyacountViewController.h"
#import "DepositViewController.h"

#define imageWidth (KScreenWidth / 12.0)
@interface SalesViewController ()
{
    NSArray *_datalist;
    UIView *_wraningNumberView;
}

@property(nonatomic,strong)NSTimer *Usertimer;

@end

@implementation SalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"报表"];
    //初始化子视图
    [self initWithSubViews];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取异常条数
    [self getEarlyWraningNumber];
    
    _Usertimer = [NSTimer scheduledTimerWithTimeInterval:65 target:self selector:@selector(getPersonMessage) userInfo:nil repeats:YES];
    [_Usertimer setFireDate:[NSDate distantPast]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_Usertimer setFireDate:[NSDate distantFuture]];

}

- (void)getPersonMessage
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *userQXchange = [NSString stringWithFormat:@"%@%@",baseURL,X6_userQXchange];
    [XPHTTPRequestTool requestMothedWithPost:userQXchange params:nil success:^(id responseObject) {
        if ([responseObject[@"type"] isEqualToString:@"error"]) {
            [self writeWithName:[responseObject valueForKey:@"message"]];
        } else {
            if ([responseObject[@"message"] isEqualToString:@"Y"]) {
                NSString *QXhadchangeList = [NSString stringWithFormat:@"%@%@",baseURL,X6_hadChangeQX];
                [XPHTTPRequestTool requestMothedWithPost:QXhadchangeList params:nil success:^(id responseObject) {
                    [userdefaluts setObject:[responseObject valueForKey:@"qxlist"] forKey:X6_UserQXList];
                    [userdefaluts synchronize];
                } failure:^(NSError *error) {
                    NSLog(@"全此案列表失败");
                }];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"获取权限失败");
    }];
    
}

#pragma mark - initWithSubViews
- (void)initWithSubViews
{
    _datalist = @[@{@"text":@"库存",@"image":@"btn_kucun"},
                  @{@"text":@"战报",@"image":@"btn_zhanbao"},
                  @{@"text":@"销量",@"image":@"btn_xiaoliang"},
                  @{@"text":@"营业款",@"image":@"btn_yingyekuan"},
                  @{@"text":@"付款",@"image":@"btn_fukuan"},
                  @{@"text":@"提醒",@"image":@"btn_yujingtixing"},
                  @{@"text":@"帐户",@"image":@"btn_zhanghu"},
                  @{@"text":@"存款",@"image":@"btn_jinricunkuan_h"}];
 
    UIScrollView *bussScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    bussScrollView.showsVerticalScrollIndicator = NO;
    bussScrollView.showsHorizontalScrollIndicator = NO;
    bussScrollView.contentSize = CGSizeMake(KScreenWidth, 200 + (KScreenWidth / 2.0) + 20);
    [self.view addSubview:bussScrollView];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    imageview.image = [UIImage imageNamed:@"btn_yun-baobiao_h"];
    [bussScrollView addSubview:imageview];
    
    
    for (int i = 0; i < _datalist.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        int sales_x = i / 4;
        int sales_y = i % 4;
        button.frame = CGRectMake((KScreenWidth / 4.0) * sales_y, 200 + (KScreenWidth / 4.0 + 20) * sales_x, KScreenWidth / 4.0, KScreenWidth / 4.0);
        button.tag = 4000 + i;
        imageView.frame = CGRectMake(imageWidth, imageWidth - 10, imageWidth - 3, imageWidth);
        imageView.image = [UIImage imageNamed:[_datalist[i] valueForKey:@"image"]];
        label.frame = CGRectMake(0, imageWidth * 2, KScreenWidth / 4.0, 20);
        label.text = [_datalist[i] valueForKey:@"text"];
        label.textColor = [UIColor colorWithRed:127 / 255 green:136 / 255 blue:148 / 255 alpha:1];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:imageView];
        [button addSubview:label];
        [button addTarget:self action:@selector(salesDetailChoose:) forControlEvents:UIControlEventTouchUpInside];
        [bussScrollView addSubview:button];
    }
  
    _wraningNumberView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth / 2.0) - 40, 200 + (KScreenWidth / 4.0) + 30, 20, 20)];
    _wraningNumberView.clipsToBounds = YES;
    _wraningNumberView.layer.cornerRadius = 10;
    _wraningNumberView.backgroundColor = [UIColor redColor];
    _wraningNumberView.hidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.tag = 10001;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_wraningNumberView addSubview:label];
    
    [bussScrollView addSubview:_wraningNumberView];
}



- (void)salesDetailChoose:(UIButton *)button
{
    if (button.tag == 4000) {
        MyKucunViewController *mykucunVC = [[MyKucunViewController alloc] init];
        [self.navigationController pushViewController:mykucunVC animated:YES];
    } else if (button.tag == 4001) {
        TodayViewController *todayVC = [[TodayViewController alloc] init];
        [self.navigationController pushViewController:todayVC animated:YES];
    } else if (button.tag == 4002) {
        TodaySalesViewController *todaySalesVC = [[TodaySalesViewController alloc] init];
        [self.navigationController pushViewController:todaySalesVC animated:YES];
    } else if (button.tag == 4003) {
        TodayMoneyViewController *todayMoneyVC = [[TodayMoneyViewController alloc] init];
        [self.navigationController pushViewController:todayMoneyVC animated:YES];
    } else if (button.tag == 4004) {
        TodayPayViewController *todayPayVC = [[TodayPayViewController alloc] init];
        [self.navigationController pushViewController:todayPayVC animated:YES];
    } else if (button.tag == 4005) {
        EarlyWarningViewController *earlyWarningVC = [[EarlyWarningViewController alloc] init];
        [self.navigationController pushViewController:earlyWarningVC animated:YES];
    } else if (button.tag == 4006) {
        MyacountViewController *myacountVC = [[MyacountViewController alloc] init];
        [self.navigationController pushViewController:myacountVC animated:YES];
    }  else {
        DepositViewController *depositVC = [[DepositViewController alloc] init];
        depositVC.isBusiness = NO;
        [self.navigationController pushViewController:depositVC animated:YES];
    }
}

- (void)getEarlyWraningNumber
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *EarlyWarningNumURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_EarlyWarningNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"all" forKey:@"txlx"];
    [XPHTTPRequestTool requestMothedWithPost:EarlyWarningNumURL params:params success:^(id responseObject) {
        if ([responseObject[@"type"] isEqualToString:@"success"]) {
            if ([responseObject[@"message"] integerValue] == 0) {
                _wraningNumberView.hidden = YES;
            } else {
                _wraningNumberView.hidden = NO;
                UILabel *label = [_wraningNumberView viewWithTag:10001];
                label.text = responseObject[@"message"];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取条数失败");
    }];
    
}


@end
