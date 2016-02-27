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

#import "MykucunViewController.h"
#import "TodayViewController.h"


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
    _datalist = @[@{@"text":@"我的库存",@"image":@"btn_kucun_n"},
                  @{@"text":@"今日战报",@"image":@"btn_xiaoliang_n"},
                  @{@"text":@"今日销量",@"image":@"btn_xiaoliang_n"},
                  @{@"text":@"今日营业款",@"image":@"btn_xiaoliang_n"},
                  @{@"text":@"今日付款",@"image":@"btn_xiaoliang_n"},
                  @{@"text":@"我的提醒",@"image":@"btn_xiaoliang_n"},
                  @{@"text":@"我的帐户",@"image":@"btn_xiaoliang_n"}];
 
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60 * (_datalist.count - 1) + 80) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];


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
        return 80;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MykucunViewController *mykucunVC = [[MykucunViewController alloc] init];
        [self.navigationController pushViewController:mykucunVC animated:YES];
    } else if (indexPath.row == 1) {
        TodayViewController *todayVC = [[TodayViewController alloc] init];
        [self.navigationController pushViewController:todayVC animated:YES];
    } else {

    }
    
}


@end
