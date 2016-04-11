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
    
    
    NSArray *mess = @[@{@"title":@"出库异常",@"image":@"btn_chukuyichang_h"},
                      @{@"title":@"库龄预警",@"image":@"btn_kulingyuqi_h"},
                      @{@"title":@"采购异常",@"image":@"btn_caigou_h"},
                      @{@"title":@"零售异常",@"image":@"btn_lingshou_h"}];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in mess) {
        NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:dic];
        [array addObject:diced];
    }
    datalist = array;
    
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableview];
    
    for (int i = 0; i < 4; i++) {
        _wraningView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth - 130) / 2.0 + 105, 15 + 60 * i, 20, 20)];
        _wraningView.backgroundColor = [UIColor redColor];
        _wraningView.clipsToBounds = YES;
        _wraningView.layer.cornerRadius = 10;
        _wraningView.hidden = YES;
        _wraningView.tag = 60010 + i;
        [_tableview addSubview:_wraningView];
        
        _wraningNumLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 130) / 2.0 + 105, 15 + 60 * i, 20, 20)];
        _wraningNumLabel.textColor = [UIColor whiteColor];
        _wraningNumLabel.textAlignment = NSTextAlignmentCenter;
        _wraningNumLabel.font = [UIFont systemFontOfSize:10];
        _wraningNumLabel.tag = 60020 + i;
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
    if (indexPath.row == 0) {
        //出库异常
        OutboundDetailViewController *outboundVC = [[OutboundDetailViewController alloc] init];
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

- (void)getwarningMessages
{
    
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *EarlyWarningNumURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_EarlyWarningNumber];

    dispatch_group_t warninggroup = dispatch_group_create();
    NSArray *txlx = @[@"CKYC",@"KLYJ",@"CGYC",@"LSYC"];
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
