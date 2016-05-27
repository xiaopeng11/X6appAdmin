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
#import "WholesaleViewController.h"
#import "MissyReceivableViewController.h"

#import "JPUSHService.h"
#define imageWidth (KScreenWidth / 12.0)
@interface SalesViewController ()
{
    NSMutableArray *_datalist;
    UIView *_wraningNumberView;
    UIScrollView *_bussScrollView;
}

@end

@implementation SalesViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"报表"];
    //初始化子视图
    [self initWithSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qxlisthadchanged) name:@"changeQXList" object:nil];
    

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
   
}

- (void)qxlisthadchanged
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        }
//    }
    [self initWithSubViews];
    
    [self getEarlyWraningNumber];
}

#pragma mark - initWithSubViews
- (void)initWithSubViews
{
    
    _datalist = [NSMutableArray array];
    
    NSArray *arrayimage = @[@{@"title":@"bb_mykc",@"image":@"btn_kucun"},
                            @{@"title":@"bb_jrzb",@"image":@"btn_zhanbao"},
                            @{@"title":@"bb_jrxs",@"image":@"btn_xiaoliang"},
                            @{@"title":@"bb_jryyk",@"image":@"btn_yingyekuan"},
                            @{@"title":@"bb_jrcwfk",@"image":@"btn_fukuan"},
                            @{@"title":@"bb_myzh",@"image":@"btn_zhanghu"},
                            @{@"title":@"bb_jryhdk",@"image":@"btn_jinricunkuan_h"},
                            @{@"title":@"bb_pfzb",@"image":@"btn_pifazhanbao_h"},
                            @{@"title":@"bb_pfxl",@"image":@"btn_pifaxiaoliang_h"},
                            @{@"title":@"bb_pfhz",@"image":@"btn_pifahuizong_h"},
                            @{@"title":@"bb_pfysmx",@"image":@"btn_yingshoumingxi_h"},
                            @{@"title":@"bb_jrsk",@"image":@"btn_jinricunkuan_h"}
                            ];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:arrayimage];
    for (int i = 0; i < mutableArray.count; i++) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:mutableArray[i]];
        for (NSDictionary *diced in qxList) {
            if ([[diced valueForKey:@"qxid"] isEqualToString:[mutableDic valueForKey:@"title"]]) {
                if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_mykc"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"0" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jrzb"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"01" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jrxs"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"02" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jryyk"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"03" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                }  else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_pfzb"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"04" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_pfxl"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"05" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_pfhz"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"06" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jrcwfk"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"07" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jryhdk"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"08" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jrsk"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"09" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_pfysmx"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"10" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_myzh"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"12" forKey:@"buttonTag"];
                        [_datalist addObject:mutableDic];
                    }
                }
                
                break;
            }
            
        }
    }
    
    
    NSMutableArray *pcs = [NSMutableArray array];
    for (NSDictionary *diced in qxList) {
        if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
            [pcs addObject:[diced valueForKey:@"pc"]];
        } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_klyj"]) {
            [pcs addObject:[diced valueForKey:@"pc"]];
        } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]) {
            [pcs addObject:[diced valueForKey:@"pc"]];
        } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]) {
            [pcs addObject:[diced valueForKey:@"pc"]];
        } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_yskyj"]) {
            [pcs addObject:[diced valueForKey:@"pc"]];
        }
    }

    _bussScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _bussScrollView.alwaysBounceVertical = YES;
    _bussScrollView.showsHorizontalScrollIndicator = NO;
    _bussScrollView.contentSize = CGSizeMake(KScreenWidth, 200 + ((_datalist.count / 4) + 1) * (KScreenWidth / 4.0 + 20) + 20);
    [self.view addSubview:_bussScrollView];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    imageview.image = [UIImage imageNamed:@"btn_yun-baobiao_h"];
    [_bussScrollView addSubview:imageview];
    
    if ([pcs containsObject:@(1)]) {
        NSMutableDictionary *diced = [NSMutableDictionary dictionary];
        [diced setObject:@"btn_yujingtixing" forKey:@"image"];
        [diced setObject:@"11" forKey:@"buttonTag"];
        [_datalist addObject:diced];    
        
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"buttonTag" ascending:YES]];
        [_datalist sortUsingDescriptors:sortDescriptors];
        
        NSUInteger indec = [_datalist indexOfObject:diced];
        
        NSUInteger warn_x = indec / 4;
        NSUInteger warn_y = indec % 4;
        _wraningNumberView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth / 4.0) * (warn_y + 1) - 40, 200 + (KScreenWidth / 4.0 + 20) * warn_x + 10, 20, 20)];
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
        
        [_bussScrollView addSubview:_wraningNumberView];
        
    }
    
    NSArray *titleNames = @[@"我的库存",@"今日战报",@"今日销量",@"营业款",@"批发战报",@"批发销量",@"批发汇总",@"今日付款",@"今日存款",@"今日收款",@"应收明细",@"提醒",@"我的帐户"];
    for (int i = 0; i < _datalist.count; i++) {
        NSInteger num = [[_datalist[i] valueForKey:@"buttonTag"] integerValue];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        int sales_x = i / 4;
        int sales_y = i % 4;
        button.frame = CGRectMake((KScreenWidth / 4.0) * sales_y, 200 + (KScreenWidth / 4.0 + 20) * sales_x, KScreenWidth / 4.0, KScreenWidth / 4.0);
        button.tag = 4000 + num;
        imageView.frame = CGRectMake(imageWidth, imageWidth - 10, imageWidth - 3, imageWidth);
        imageView.image = [UIImage imageNamed:[_datalist[i] valueForKey:@"image"]];
        label.frame = CGRectMake(0, imageWidth * 2, KScreenWidth / 4.0, 20);
        label.text = titleNames[num];
        label.textColor = [UIColor colorWithRed:127 / 255 green:136 / 255 blue:148 / 255 alpha:1];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:imageView];
        [button addSubview:label];
        [button addTarget:self action:@selector(salesDetailChoose:) forControlEvents:UIControlEventTouchUpInside];
        [_bussScrollView addSubview:button];
    }
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
        WholesaleViewController *wholesalesVC = [[WholesaleViewController alloc] init];
        wholesalesVC.Viewtitle = X6_WholesaleUnits;
        [self.navigationController pushViewController:wholesalesVC animated:YES];
    } else if (button.tag == 4005) {
        WholesaleViewController *wholesalesVC = [[WholesaleViewController alloc] init];
        wholesalesVC.Viewtitle = X6_WholesaleSales;
        [self.navigationController pushViewController:wholesalesVC animated:YES];
    } else if (button.tag == 4006) {
        WholesaleViewController *wholesalesVC = [[WholesaleViewController alloc] init];
        wholesalesVC.Viewtitle = X6_WholesaleSummary;
        [self.navigationController pushViewController:wholesalesVC animated:YES];
    } else if (button.tag == 4007) {
        TodayPayViewController *todayPayVC = [[TodayPayViewController alloc] init];
        todayPayVC.titletext = X6_todayPay;
        [self.navigationController pushViewController:todayPayVC animated:YES];
    } else if (button.tag == 4008) {
        DepositViewController *depositVC = [[DepositViewController alloc] init];
        depositVC.isBusiness = NO;
        [self.navigationController pushViewController:depositVC animated:YES];
    } else if (button.tag == 4009) {
        TodayPayViewController *todayPayVC = [[TodayPayViewController alloc] init];
        todayPayVC.titletext = X6_todayReceivable;
        [self.navigationController pushViewController:todayPayVC animated:YES];
    } else if (button.tag == 4010) {
        MissyReceivableViewController *missyReceivableVC = [[MissyReceivableViewController alloc] init];
        [self.navigationController pushViewController:missyReceivableVC animated:YES];
    } else if (button.tag == 4011) {
        EarlyWarningViewController *earlyWarningVC = [[EarlyWarningViewController alloc] init];
        [self.navigationController pushViewController:earlyWarningVC animated:YES];
    } else if (button.tag == 4012) {
        MyacountViewController *myacountVC = [[MyacountViewController alloc] init];
        [self.navigationController pushViewController:myacountVC animated:YES];
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
