//
//  EarlyWarningViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EarlyWarningViewController.h"

#import "EarlyWarningTableViewCell.h"

#import "OutboundViewController.h"
#import "OldlibraryViewController.h"
#import "PurchaseViewController.h"
#import "RetailViewController.h"

@interface EarlyWarningViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datalist;
}

@end

@implementation EarlyWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"我的提醒"];
    
    datalist = @[@{@"title":@"出库异常",@"image":@"btn_chukuyichang_h"},
                 @{@"title":@"库龄预警",@"image":@"btn_kulingyuqi_h"},
                 @{@"title":@"采购异常",@"image":@"btn_caigou_h"},
                 @{@"title":@"零售异常",@"image":@"btn_lingshou_h"}];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableview];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *earlyWarningCell = @"EarlyWarningCell";
    EarlyWarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:earlyWarningCell];
    if (cell == nil) {
        cell = [[EarlyWarningTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:earlyWarningCell];
        
    }
    cell.dic = datalist[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //出库异常
        OutboundViewController *outboundVC = [[OutboundViewController alloc] init];
        [self.navigationController pushViewController:outboundVC animated:YES];
    } else if (indexPath.row == 1) {
        //库龄预警
        OldlibraryViewController *oldlibraryVC = [[OldlibraryViewController alloc] init];
        [self.navigationController pushViewController:oldlibraryVC animated:YES];
    } else if (indexPath.row == 2) {
        //采购异常
        PurchaseViewController *purchaseVC = [[PurchaseViewController alloc] init];
        [self.navigationController pushViewController:purchaseVC animated:YES];
    } else {
        //零售异常
        RetailViewController *retailVC = [[RetailViewController alloc] init];
        [self.navigationController pushViewController:retailVC animated:YES];
    }
    
}

@end
