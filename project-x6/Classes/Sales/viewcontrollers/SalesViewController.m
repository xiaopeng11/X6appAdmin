//
//  SalesViewController.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SalesViewController.h"
#import "TodayinventoryViewController.h"
#import "MySalesViewController.h"
#import "AllSalesViewController.h"
#import "SalesTableViewCell.h"
@interface SalesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSArray *datalist;
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

#pragma mark - initWithSubViews
- (void)initWithSubViews
{
    _datalist = @[@{@"text":@"今日库存",@"image":@"btn_kucun_n"},
                  @{@"text":@"我的销量",@"image":@"btn_xiaoliang_n"},
                  @{@"text":@"我的排名",@"image":@"btn_paiming_n"}];
 
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80 * _datalist.count) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];


}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"SalesID";
    SalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[SalesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.dic = _datalist[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",(long)indexPath.row);
    if (indexPath.row == 0) {
        TodayinventoryViewController *todayVC = [[TodayinventoryViewController alloc] init];
        [self.navigationController pushViewController:todayVC animated:YES];
    } else if (indexPath.row == 1) {
        MySalesViewController *mySalesVC = [[MySalesViewController alloc] init];
        [self.navigationController pushViewController:mySalesVC animated:YES];
    } else {
        AllSalesViewController *allSalesVC = [[AllSalesViewController alloc] init];
        [self.navigationController pushViewController:allSalesVC animated:YES];
    }
    
}


@end
