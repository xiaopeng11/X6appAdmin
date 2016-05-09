//
//  BusinessViewController.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BusinessViewController.h"

#import "SupplierViewController.h"
#import "OrderreviewViewController.h"
#import "DepositViewController.h"


#import "SettingPriceViewController.h"
#import "JPUSHService.h"


#define imageWidth  (((KScreenWidth / 2.0) - 80) / 2.0)
@interface BusinessViewController ()

{
    NSMutableArray *_busDatalist;
}

@property(nonatomic,strong)NSTimer *Usertimer;

@end

@implementation BusinessViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GrayColor;
    [self naviTitleWhiteColorWithText:@"业务"];
    
    _busDatalist = [NSMutableArray array];
    
    [self intBusinessUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBusinessList) name:@"changeQXList" object:nil];
    
    
    _Usertimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(getBusinessMessage) userInfo:nil repeats:YES];
    [_Usertimer setFireDate:[NSDate distantPast]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",_busDatalist);

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_Usertimer invalidate];
}

//权限改变
- (void)changeBusinessList
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self intBusinessUI];
}

//定时器方法
- (void)getBusinessMessage
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *userQXchange = [NSString stringWithFormat:@"%@%@",baseURL,X6_userQXchange];
    [XPHTTPRequestTool requestMothedWithPost:userQXchange params:nil success:^(id responseObject) {
        if ([responseObject[@"type"] isEqualToString:@"error"]) {
            [self writeWithName:[responseObject valueForKey:@"message"]];
        } else {
            if ([responseObject[@"message"] isEqualToString:@"Y"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeQXList" object:nil];
                
                NSString *QXhadchangeList = [NSString stringWithFormat:@"%@%@",baseURL,X6_hadChangeQX];
                [XPHTTPRequestTool requestMothedWithPost:QXhadchangeList params:nil success:^(id responseObject) {
                    [userdefaluts setObject:[responseObject valueForKey:@"qxlist"] forKey:X6_UserQXList];
                    [userdefaluts synchronize];
                    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                    [self intBusinessUI];
                    
                    
                    //设置极光tags
                    NSMutableDictionary *loaddictionary = [userdefaluts valueForKey:X6_UserMessage];
                    NSString *ssgs = [loaddictionary valueForKey:@"ssgs"];
                    NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:ssgs, nil];
                    for (NSDictionary *dic in [responseObject valueForKey:@"qxlist"]) {
                        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
                            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                [set addObject:@"XJXC"];
                            }
                        } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]){
                            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                [set addObject:@"CGJJ"];
                            }
                        } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]){
                            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                [set addObject:@"LSXJ"];
                            }
                        }
                    }
                    
                    [JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"极光的tags：%@,返回的状态吗：%d",iTags,iResCode);
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"全此案列表失败");
                }];
                
                
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"获取权限失败");
    }];

}

- (void)intBusinessUI
{
    NSArray *arrayimage = @[@{@"title":@"sz_gys",@"image":@"btn_gongyingshan"},
                            @{@"title":@"sz_kh",@"image":@"btn_kehu"},
                            @{@"title":@"cz_cgddsh",@"image":@"btn_dingdan"},
                            @{@"title":@"cz_ywkdk",@"image":@"btn_cunkuan"},
                            @{@"title":@"sz_yjszkhj",@"image":@"btn_shezhi"},
                            ];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:arrayimage];
    for (int i = 0; i < mutableArray.count; i++) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:mutableArray[i]];
        for (NSDictionary *diced in qxList) {
            if ([[diced valueForKey:@"qxid"] isEqualToString:[mutableDic valueForKey:@"title"]]) {
                if ([[diced valueForKey:@"qxid"] isEqualToString:@"sz_gys"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"0" forKey:@"buttonTag"];
                        [_busDatalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"sz_kh"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"1" forKey:@"buttonTag"];
                        [_busDatalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"cz_cgddsh"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"2" forKey:@"buttonTag"];
                        [_busDatalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"cz_ywkdk"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"3" forKey:@"buttonTag"];
                        [_busDatalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"sz_yjszkhj"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"4" forKey:@"buttonTag"];
                        [_busDatalist addObject:mutableDic];
                    }
                }
                break;
            }
            
        }
    }
    
    NSArray *titleNames = @[@"供应商",@"客户",@"订单审核",@"银行存款",@"设置考核价"];
    for (int i = 0; i < _busDatalist.count; i++) {
        NSInteger num = [[_busDatalist[i] valueForKey:@"buttonTag"] integerValue];
        int bus_X = i % 2;
        int bus_Y = i / 2;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(imageWidth + (imageWidth * 2 + 80) * bus_X, 10 + 110 * bus_Y, 80, 80);
        [button setImage:[UIImage imageNamed:[_busDatalist[i] valueForKey:@"image"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 3000 + [[_busDatalist[i] valueForKey:@"buttonTag"] integerValue];
        [self.view addSubview:button];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth - 10 + (imageWidth  * 2 + 80) * bus_X, 90 + 110 * bus_Y, 100, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titleNames[num];
        [self.view addSubview:label];
    }

}


#pragma mark - 按钮事件
- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 3000) {
        SupplierViewController *supplierVC = [[SupplierViewController alloc] init];
        supplierVC.issupplier = YES;
        [self.navigationController pushViewController:supplierVC animated:YES];
    } else if (button.tag == 3001) {
        SupplierViewController *supplierVC = [[SupplierViewController alloc] init];
        supplierVC.issupplier = NO;
        [self.navigationController pushViewController:supplierVC animated:YES];
    } else if (button.tag == 3002) {
        OrderreviewViewController *orderreviewVC = [[OrderreviewViewController alloc] init];
        [self.navigationController pushViewController:orderreviewVC animated:YES];
    } else if (button.tag == 3003) {
        DepositViewController *depositVC = [[DepositViewController alloc] init];
        depositVC.isBusiness = YES;
        [self.navigationController pushViewController:depositVC animated:YES];
    } else if (button.tag == 3004) {
        SettingPriceViewController *settingPriceVC = [[SettingPriceViewController alloc] init];
        [self.navigationController pushViewController:settingPriceVC animated:YES];
    }
}


@end
