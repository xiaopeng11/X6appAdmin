//
//  OldlibrarydetailViewController.m
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibrarydetailViewController.h"

#import "OldlibraryDetailModel.h"
#import "NoDataView.h"

#import "OldlibrarydetailTableViewCell.h"
@interface OldlibrarydetailViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *_OldlibrarydetailDatalist;
    
    UITableView *_OldlibrarydetailTableview;
    NoDataView *_noOldlibrarydetailView;
    double _OldlibrarydetailPage;
    double _OldlibrarydetailPages;

}

@end

@implementation OldlibrarydetailViewController

- (void)dealloc
{
    _OldlibrarydetailDatalist = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"逾期明细"];
    
    [self initOldlibrarydetailUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getOldlibrarydetailDataWithPage:1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _OldlibrarydetailDatalist = nil;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _OldlibrarydetailDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Oldlibrarydetailidnet = @"Oldlibrarydetailidnet";
    OldlibrarydetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Oldlibrarydetailidnet];
    if (cell == nil) {
        cell = [[OldlibrarydetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Oldlibrarydetailidnet];
    }
    cell.dic = _OldlibrarydetailDatalist[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ((KScreenWidth - 20) * 2 )/ 5, 30)];
    label1.text = @"串号";
    label1.font = [UIFont systemFontOfSize:18];
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10 + (KScreenWidth - 20) * 2 / 5 , 5, (KScreenWidth - 20) * 3 / 10, 30)];
    label2.text = @"仓库";
    label2.font = [UIFont systemFontOfSize:18];
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10 + (KScreenWidth - 20) * 2 / 5 + ((KScreenWidth - 20) * 3 / 10), 5, (KScreenWidth - 20) * 3 / 10, 30)];
    label3.text = @"预期";
    label3.font = [UIFont systemFontOfSize:18];
    label3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label3];
    
    return view;
}

#pragma mark - 绘制ui
- (void)initOldlibrarydetailUI
{
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 21 + 30 * i, 24, 18)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 20 + 30 * i, KScreenWidth - 60 - 40, 20)];
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"btn_gys_h"];
            label.text = [NSString stringWithFormat:@"供应商:%@",_gysName];
        } else {
            imageView.image = [UIImage imageNamed:@"btn_huopin_h"];
            label.text = [NSString stringWithFormat:@"货  品:%@",_hpName];
        }
        [self.view addSubview:imageView];
        [self.view addSubview:label];
    }
    
    
    _OldlibrarydetailTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, KScreenHeight - 80 - 64) style:UITableViewStylePlain];
    _OldlibrarydetailTableview.delegate = self;
    _OldlibrarydetailTableview.dataSource = self;
    _OldlibrarydetailTableview.hidden = YES;
    _OldlibrarydetailTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_OldlibrarydetailTableview addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(OldlibrarydetailheaderAction)];
    [_OldlibrarydetailTableview addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(OldlibrarydetailfooterAction)];
    [self.view addSubview:_OldlibrarydetailTableview];
    
    
    
    _noOldlibrarydetailView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 80, KScreenWidth, KScreenHeight - 80 - 64)];
    _noOldlibrarydetailView.text = @"没有数据";
    _noOldlibrarydetailView.hidden = YES;
    [self.view addSubview:_noOldlibrarydetailView];
}

#pragma mark - 加载更多和刷新
- (void)OldlibrarydetailheaderAction
{
    [self getOldlibrarydetailrefreshdataWithHead:YES];
}

- (void)OldlibrarydetailfooterAction
{
    [self getOldlibrarydetailrefreshdataWithHead:NO];
}

- (void)getOldlibrarydetailrefreshdataWithHead:(BOOL)head
{
    if (head == YES) {
        [self getOldlibrarydetailDataWithPage:1];
    } else {
        if (_OldlibrarydetailPage < _OldlibrarydetailPages) {
            [self getOldlibrarydetailDataWithPage:(_OldlibrarydetailPage + 1)];
        } else {
            [_OldlibrarydetailTableview.footer noticeNoMoreData];
        }
    }
}

- (void)endgetOldlibrarydetailrefresh
{
    if (_OldlibrarydetailTableview.header.isRefreshing) {
        [_OldlibrarydetailTableview.header endRefreshing];
        [_OldlibrarydetailTableview.footer resetNoMoreData];
    } else {
        [_OldlibrarydetailTableview.footer endRefreshing];
    }
}

#pragma mark - 获取数据
- (void)getOldlibrarydetailDataWithPage:(NSInteger)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *OldlibrarydetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Oldlibrarydetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_gysdm forKey:@"gysdm"];
    [params setObject:_spdm forKey:@"spdm"];
    [params setObject:_kl forKey:@"kl"];
    [params setObject:@(50) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"col0" forKey:@"sidx"];
    [params setObject:@"asc" forKey:@"sord"];
    if (!_OldlibrarydetailTableview.header.isRefreshing && !_OldlibrarydetailTableview.footer.isRefreshing) {
        [self showProgress];
    }
    [XPHTTPRequestTool requestMothedWithPost:OldlibrarydetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        if (_OldlibrarydetailDatalist.count == 0 || _OldlibrarydetailTableview.header.isRefreshing) {
            _OldlibrarydetailDatalist = [OldlibraryDetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        } else {
            _OldlibrarydetailDatalist = [_OldlibrarydetailDatalist arrayByAddingObjectsFromArray:[OldlibraryDetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]]];
        }
        
        if (_OldlibrarydetailTableview.header.isRefreshing || _OldlibrarydetailTableview.footer.isRefreshing) {
            [self endgetOldlibrarydetailrefresh];
        }
        if ([responseObject[@"rows"] count] < 50) {
            [_OldlibrarydetailTableview.footer noticeNoMoreData];
        }
        
        
        if (_OldlibrarydetailDatalist.count == 0) {
            _OldlibrarydetailTableview.hidden = YES;
            _noOldlibrarydetailView.hidden = NO;
        } else {
            _noOldlibrarydetailView.hidden = YES;
            _OldlibrarydetailTableview.hidden = NO;
            [_OldlibrarydetailTableview reloadData];
            _OldlibrarydetailPages = [responseObject[@"pages"] doubleValue];
            _OldlibrarydetailPage = [responseObject[@"page"] doubleValue];
        }
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"库龄预警失败");
    }];
}


@end
