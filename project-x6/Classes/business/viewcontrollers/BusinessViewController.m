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


#define imageWidth  (((KScreenWidth / 2.0) - 80) / 2.0)
@interface BusinessViewController ()

{
    NSMutableArray *_busDatalist;
}
@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GrayColor;
    [self naviTitleWhiteColorWithText:@"业务"];
    
    _busDatalist = [NSMutableArray array];
    
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
        label.text = titleNames[i];
        [self.view addSubview:label];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
