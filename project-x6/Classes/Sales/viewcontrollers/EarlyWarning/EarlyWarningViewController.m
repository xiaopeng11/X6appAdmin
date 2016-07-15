//
//  EarlyWarningViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EarlyWarningViewController.h"

#import "EarlyWarningTableViewCell.h"

#import "OutboundDetailViewController.h"
#import "OldlibraryViewController.h"
#import "PurchaseViewController.h"
#import "RetailViewController.h"
#import "OverduereceivablesViewController.h"
@interface EarlyWarningViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *datalist;
    UITableView *_tableview;
    
    UIView *_wraningView;
    UILabel *_wraningNumLabel;
}

@end

@implementation EarlyWarningViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"我的提醒"];
    
    datalist = [NSMutableArray array];
    
    NSArray *mess = @[@{@"title":@"bb_jxc_cgyc",@"image":@"btn_caigou_h",@"text":@"采购异常"},
                      @{@"title":@"bb_jxc_ckyc",@"image":@"btn_chukuyichang_h",@"text":@"出库异常"},
                      @{@"title":@"bb_jxc_lsyc",@"image":@"btn_lingshou_h",@"text":@"零售异常"},
                      @{@"title":@"bb_jxc_klyj",@"image":@"btn_kulingyuqi_h",@"text":@"库龄预警"},
                      @{@"title":@"bb_jxc_yskyj",@"image":@"btn_yuqishoukuan",@"text":@"应收逾期"}];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:mess];
    for (int i = 0; i < mess.count; i++) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:mutableArray[i]];
        for (NSDictionary *diced in qxList) {
            if ([[diced valueForKey:@"qxid"] isEqualToString:[mutableDic valueForKey:@"title"]]) {
                if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"0" forKey:@"buttonTag"];
                        [datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"1" forKey:@"buttonTag"];
                        [datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"2" forKey:@"buttonTag"];
                        [datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_klyj"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"3" forKey:@"buttonTag"];
                        [datalist addObject:mutableDic];
                    }
                } else if ([[diced valueForKey:@"qxid"] isEqualToString:@"bb_jxc_yskyj"]) {
                    if ([[diced valueForKey:@"pc"] integerValue] == 1) {
                        [mutableDic setObject:@"4" forKey:@"buttonTag"];
                        [datalist addObject:mutableDic];
                    }
                }
                break;
            }
            
        }
    }

    
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableview];
    
    for (int i = 0; i < datalist.count; i++) {
        NSInteger num = [[datalist[i] valueForKey:@"buttonTag"] integerValue];
        _wraningView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 130) / 2.0 + 105, 5 + 60 * i, 25, 25)];
        _wraningView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.7];
        _wraningView.clipsToBounds = YES;
        _wraningView.layer.cornerRadius = 12.5;
        _wraningView.hidden = YES;
        _wraningView.tag = 60010 + num;
        [_tableview addSubview:_wraningView];
        
        _wraningNumLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 130) / 2.0 + 105, 5 + 60 * i, 25, 25)];
        _wraningNumLabel.textColor = [UIColor whiteColor];
        _wraningNumLabel.textAlignment = NSTextAlignmentCenter;
        _wraningNumLabel.font = [UIFont systemFontOfSize:12.5];
        _wraningNumLabel.tag = 60020 + num;
        _wraningNumLabel.hidden = YES;
        [_tableview addSubview:_wraningNumLabel];
    }
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getwarningMessages];
    
    
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
    NSInteger num = [[datalist[indexPath.row] valueForKey:@"buttonTag"] integerValue];

    if (num == 0) {
        //采购异常
        PurchaseViewController *purchaseVC = [[PurchaseViewController alloc] init];
        [self.navigationController pushViewController:purchaseVC animated:YES];
    } else if (num == 1) {
        //出库异常
        OutboundDetailViewController *outboundVC = [[OutboundDetailViewController alloc] init];
        [self.navigationController pushViewController:outboundVC animated:YES];
    } else if (num == 2) {
        //零售异常
        RetailViewController *retailVC = [[RetailViewController alloc] init];
        [self.navigationController pushViewController:retailVC animated:YES];
    } else if (num == 3){
        //库龄预警
        OldlibraryViewController *oldlibraryVC = [[OldlibraryViewController alloc] init];
        [self.navigationController pushViewController:oldlibraryVC animated:YES];
    } else {
        //应收款逾期
        OverduereceivablesViewController *overdueVC = [[OverduereceivablesViewController alloc] init];
        [self.navigationController pushViewController:overdueVC animated:YES];
    }
    
}

- (void)getwarningMessages
{
    
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *EarlyWarningNumURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_EarlyWarningNumber];

    dispatch_group_t warninggroup = dispatch_group_create();
    
    NSMutableArray *txlx = [NSMutableArray array];
    for (NSDictionary *dic in datalist) {
        if ([[dic valueForKey:@"buttonTag"] integerValue] == 0) {
            [txlx addObject:@"CGYC"];
        } else if ([[dic valueForKey:@"buttonTag"] integerValue] == 1){
            [txlx addObject:@"CKYC"];
        } else if ([[dic valueForKey:@"buttonTag"] integerValue] == 2){
            [txlx addObject:@"LSYC"];
        } else if ([[dic valueForKey:@"buttonTag"] integerValue] == 3){
            [txlx addObject:@"KLYJ"];
        } else if ([[dic valueForKey:@"buttonTag"] integerValue] == 4){
            [txlx addObject:@"YSKYJ"];
        }
    }
    for (int i = 0; i < txlx.count; i++) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:txlx[i] forKey:@"txlx"];
        dispatch_group_enter(warninggroup);
        [XPHTTPRequestTool requestMothedWithPost:EarlyWarningNumURL params:params success:^(id responseObject) {
            if ([responseObject[@"type"] isEqualToString:@"success"]) {
                _wraningView = (UIView *)[_tableview viewWithTag:60010 + i];
                _wraningNumLabel = (UILabel *)[_tableview viewWithTag:60020 + i];
                if ([responseObject[@"message"] integerValue] == 0) {
                    _wraningNumLabel.hidden = YES;
                    _wraningView.hidden = YES;
                } else {
                    NSString *num = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
                    _wraningNumLabel.hidden = NO;
                    _wraningView.hidden = NO;
                    if ([num longLongValue] > 99) {
                        _wraningNumLabel.text = @"99+";
                    } else {
                        _wraningNumLabel.text = num;
                    }
                }
            }
            dispatch_group_leave(warninggroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(warninggroup);
        }];
    }
   
    dispatch_group_notify(warninggroup, dispatch_get_main_queue(), ^{
        [_tableview reloadData];
    });
    
}

@end
