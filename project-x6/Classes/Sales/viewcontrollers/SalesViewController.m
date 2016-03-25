//
//  SalesViewController.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SalesViewController.h"

#import "SalesTableViewCell.h"
#import "SpeSalesTableViewCell.h"

#import "MyKucunViewController.h"
#import "TodayViewController.h"
#import "TodaySalesViewController.h"
#import "TodayMoneyViewController.h"
#import "TodayPayViewController.h"
#import "EarlyWarningViewController.h"
#import "MyacountViewController.h"

@interface SalesViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_datalist;
    UIView *_wraningNumberView;
}
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
}

#pragma mark - initWithSubViews
- (void)initWithSubViews
{
    _datalist = @[@{@"text":@"我的库存",@"image":@"btn_kucun_n"},
                  @{@"text":@"今日战报",@"image":@"btn_zhanbao_h"},
                  @{@"text":@"今日销量",@"image":@"btn_xiaoliang_n"},
                  @{@"text":@"今日营业款",@"image":@"btn_yingyekuan_h"},
                  @{@"text":@"今日付款",@"image":@"btn_fukuan_n"},
                  @{@"text":@"我的提醒",@"image":@"btn_yujingtixing_h"},
                  @{@"text":@"我的帐户",@"image":@"btn_zhanghu_h"}];
 
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    _wraningNumberView = [[UIView alloc] initWithFrame:CGRectMake(95 + (KScreenWidth - 90) / 2.0, 300 + 10, 26, 26)];
    _wraningNumberView.clipsToBounds = YES;
    _wraningNumberView.layer.cornerRadius = 13;
    _wraningNumberView.backgroundColor = [UIColor redColor];
    _wraningNumberView.hidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    label.tag = 10001;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_wraningNumberView addSubview:label];
    
    [tableView addSubview:_wraningNumberView];
    


}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        static NSString *specident = @"SpecSalesID";
        SpeSalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:specident];
        if (cell == nil) {
            cell = [[SpeSalesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specident];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.dic = _datalist[indexPath.row];
        return cell;
    } else {
        static NSString *ident = @"SalesID";
        SalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
        if (cell == nil) {
            cell = [[SalesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        }
        cell.dic = _datalist[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 70;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyKucunViewController *mykucunVC = [[MyKucunViewController alloc] init];
        [self.navigationController pushViewController:mykucunVC animated:YES];
    } else if (indexPath.row == 1) {
        TodayViewController *todayVC = [[TodayViewController alloc] init];
        [self.navigationController pushViewController:todayVC animated:YES];
    } else if (indexPath.row == 2) {
        TodaySalesViewController *todaySalesVC = [[TodaySalesViewController alloc] init];
        [self.navigationController pushViewController:todaySalesVC animated:YES];
    } else if (indexPath.row == 3) {
        TodayMoneyViewController *todayMoneyVC = [[TodayMoneyViewController alloc] init];
        [self.navigationController pushViewController:todayMoneyVC animated:YES];
    } else if (indexPath.row == 4) {
        TodayPayViewController *todayPayVC = [[TodayPayViewController alloc] init];
        [self.navigationController pushViewController:todayPayVC animated:YES];
    } else if (indexPath.row == 5) {
        EarlyWarningViewController *earlyWarningVC = [[EarlyWarningViewController alloc] init];
        [self.navigationController pushViewController:earlyWarningVC animated:YES];
    } else {
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
        NSLog(@"%@",responseObject);
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
