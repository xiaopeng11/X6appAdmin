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
#import "AdvancePaymentViewController.h"
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
    
    NSArray *arrayimage = @[@{@"title":@"供应商",@"image":@"btn_gongying_h"},
                            @{@"title":@"客户",@"image":@"btn_kehu_h"},
                            @{@"title":@"订单",@"image":@"btn_dingdan_h"},
                            @{@"title":@"预付款",@"image":@"btn_yufukuan_h"},
                            @{@"title":@"付款",@"image":@"btn_fukuan_h1"},
                            @{@"title":@"银行存款",@"image":@"btn_cunkuan_h"},
                            @{@"title":@"设置考核价",@"image":@"btn_shezhi_h1"},
                             ];
    NSArray *names = @[@"供应商",@"客户",@"订单审核",@"预付款",@"付款",@"银行存款",@"设置考核价"];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    for (int i = 0; i < arrayimage.count; i++) {
        NSDictionary *dic = qxList[i];
        NSString *name = names[i];
        if ([[dic valueForKey:@"name"] isEqualToString:name]) {
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                [_busDatalist addObject:arrayimage[i]];
            }
        }
    }
    
    
//    _busDatalist = arrayimage;
    
    UIScrollView *bussScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    bussScrollView.showsVerticalScrollIndicator = NO;
    bussScrollView.showsHorizontalScrollIndicator = NO;
    bussScrollView.contentSize = CGSizeMake(KScreenWidth, 550);
    [self.view addSubview:bussScrollView];
    
    for (int i = 0; i < _busDatalist.count; i++) {
        int bus_X = i % 2;
        int bus_Y = i / 2;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(imageWidth + (imageWidth * 2 + 80) * bus_X, 10 + 110 * bus_Y, 80, 80);
        [button setImage:[UIImage imageNamed:[_busDatalist[i] valueForKey:@"image"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 3000 + i;
        [bussScrollView addSubview:button];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth - 10 + (imageWidth  * 2 + 80) * bus_X, 90 + 110 * bus_Y, 100, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [_busDatalist[i] valueForKey:@"title"];
        [bussScrollView addSubview:label];
    
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
        NSLog(@"供应商");
        SupplierViewController *supplierVC = [[SupplierViewController alloc] init];
        supplierVC.issupplier = YES;
        [self.navigationController pushViewController:supplierVC animated:YES];
    } else if (button.tag == 3001) {
        NSLog(@"客户");
        SupplierViewController *supplierVC = [[SupplierViewController alloc] init];
        supplierVC.issupplier = NO;
        [self.navigationController pushViewController:supplierVC animated:YES];
    } else if (button.tag == 3002) {
        NSLog(@"订单");
        OrderreviewViewController *orderreviewVC = [[OrderreviewViewController alloc] init];
        [self.navigationController pushViewController:orderreviewVC animated:YES];
    } else if (button.tag == 3003) {
        NSLog(@"预付款");
        [self writeWithName:@"该功能还没有开通"];
//
//        AdvancePaymentViewController *advancePaymentVC = [[AdvancePaymentViewController alloc] init];
//        [self.navigationController pushViewController:advancePaymentVC animated:YES];
    } else if (button.tag == 3004) {
        NSLog(@"付款");
        [self writeWithName:@"该功能还没有开通"];
    } else if (button.tag == 3005) {
        NSLog(@"银行存款");
        DepositViewController *depositVC = [[DepositViewController alloc] init];
        [self.navigationController pushViewController:depositVC animated:YES];
    } else if (button.tag == 3006) {
        NSLog(@"设置考核价");
        SettingPriceViewController *settingPriceVC = [[SettingPriceViewController alloc] init];
        [self.navigationController pushViewController:settingPriceVC animated:YES];
    }
}


@end
