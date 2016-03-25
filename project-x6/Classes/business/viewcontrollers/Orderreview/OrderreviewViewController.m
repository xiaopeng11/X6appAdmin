//
//  OrderreviewViewController.m
//  project-x6
//
//  Created by Apple on 16/3/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OrderreviewViewController.h"

#import "OrderreviewModel.h"
#import "OrderReviewTableViewCell.h"

@interface OrderreviewViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NSMutableArray *_OrderreviewDatalist;
    NSInteger _number;
    
    UIButton *_button;
    
    double _page;
    double _pages;
}

@property(nonatomic,strong)UITableView *OrderreviewTableView;
@property(nonatomic,strong)NoDataView *noOrderreviewView;

@property(nonatomic,copy)NSMutableArray *OrderreviewNames;                    //供应商名的集合
@property(nonatomic,strong)NSMutableArray *OrderreviewSearchNames;
@property(nonatomic,copy)NSMutableArray *neworderreviewDatalist;
@property(nonatomic, strong)UISearchController *OrderreviewSearchController;

@end

@implementation OrderreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"订单审核"];
    
    [self initOrderreviewUI];
    
    _OrderreviewNames = [NSMutableArray array];
    _OrderreviewSearchNames = [NSMutableArray array];
    _neworderreviewDatalist = [NSMutableArray array];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"revokeAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderAction" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _OrderreviewSearchController.searchBar.hidden = NO;
    
    _number = 0;
    [self getOrderreviewDataWithOrderreview:YES Page:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_OrderreviewSearchController.active) {
        [_OrderreviewSearchController resignFirstResponder];
    }
    _OrderreviewSearchController.searchBar.hidden = YES;
}
#pragma mark - 绘制UI
- (void)initOrderreviewUI
{
    //导航栏右侧按钮
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 40, 30);
    [_button setTitle:@"撤审" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(getrevokeorderdata) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
    
    
    //搜索框
    _OrderreviewSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _OrderreviewSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _OrderreviewSearchController.searchResultsUpdater = self;
    _OrderreviewSearchController.searchBar.delegate = self;
    _OrderreviewSearchController.dimsBackgroundDuringPresentation = NO;
    _OrderreviewSearchController.hidesNavigationBarDuringPresentation = NO;
    _OrderreviewSearchController.searchBar.placeholder = @"搜索";
    [_OrderreviewSearchController.searchBar sizeToFit];
    _OrderreviewSearchController.searchBar.hidden = YES;
    [self.view addSubview:_OrderreviewSearchController.searchBar];
    
    //表示图
    [self OrderreviewTableview];
    [self NoOrderreviewView];
    
}

- (UITableView *)OrderreviewTableview
{
    if (_OrderreviewTableView == nil) {
        _OrderreviewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
        _OrderreviewTableView.hidden = YES;
        _OrderreviewTableView.delegate = self;
        _OrderreviewTableView.dataSource = self;
        _OrderreviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_OrderreviewTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getmoreOrderDatalist)];
    
        [self.view addSubview:_OrderreviewTableView];
    }
    return _OrderreviewTableView;
}

- (NoDataView *)NoOrderreviewView

{
    if (_noOrderreviewView == nil) {
        _noOrderreviewView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _noOrderreviewView.hidden = YES;
        _noOrderreviewView.text = @"没有需要审核的订单信息";
        [self.view addSubview:_noOrderreviewView];
    }
    
    return _noOrderreviewView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_OrderreviewSearchController.active) {
        return _neworderreviewDatalist.count;
    } else {
        return _OrderreviewDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Orderreviewcellid = @"Orderreviewcellid";
    OrderReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Orderreviewcellid];
    if (cell == nil) {
        cell = [[OrderReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Orderreviewcellid];
    }
    if (_OrderreviewSearchController.active) {
        cell.dic = _neworderreviewDatalist[indexPath.row];
    } else {
        cell.dic = _OrderreviewDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.OrderreviewSearchNames removeAllObjects];
    [_neworderreviewDatalist removeAllObjects];
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.OrderreviewSearchController.searchBar.text];
    self.OrderreviewSearchNames = [[self.OrderreviewNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.OrderreviewSearchNames) {
        for (NSDictionary *dic in _OrderreviewDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col3"]] || [title isEqualToString:[dic valueForKey:@"col4"]]) {
                [_neworderreviewDatalist addObject:dic];
            }
        }
    }
    
    [_OrderreviewTableView reloadData];
    
}

#pragma mark - 导航栏点击事件
- (void)getrevokeorderdata
{
    if (_number % 2 == 0) {
        [self naviTitleWhiteColorWithText:@"撤审列表"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderAction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revokeAction:) name:@"revokeAction" object:nil];
        [_button setTitle:@"审核" forState:UIControlStateNormal];
        _number++;
        [self getOrderreviewDataWithOrderreview:NO Page:1];
    } else {
        [self naviTitleWhiteColorWithText:@"订单审核"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"revokeAction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderAction:) name:@"orderAction" object:nil];
        [_button setTitle:@"撤审" forState:UIControlStateNormal];
        _number--;
        [self getOrderreviewDataWithOrderreview:YES Page:1];

    }
}

#pragma mark - 通知时间
/**
 *  审核
 */
- (void)orderAction:(NSNotification *)noti
{
    NSLog(@"%@",noti.object);
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *orderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_examineOrder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:noti.object forKey:@"id"];
    [XPHTTPRequestTool requestMothedWithPost:orderURL params:params success:^(id responseObject) {
        if ([responseObject[@"type"] isEqualToString:@"error"]) {
            [self writeWithName:responseObject[@"message"]];
        } else {
            NSMutableArray *deleteArray = [NSMutableArray array];
            for (NSDictionary *dic in _OrderreviewDatalist) {
                NSString *reviewID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col0"]];
                NSString *notiob = [NSString stringWithFormat:@"%@",noti.object];
                if ([reviewID isEqualToString:notiob]) {
                    [deleteArray addObject:dic];
                }
            }
            [_OrderreviewDatalist removeObjectsInArray:deleteArray];
            [_OrderreviewTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"审核失败");
    }];
}

/**
 *  撤审
 */
- (void)revokeAction:(NSNotification *)noti
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *orderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_revokeOrder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *shenheid = [NSString stringWithFormat:@"%@",noti.object];
    [params setObject:shenheid forKey:@"id"];
    [XPHTTPRequestTool requestMothedWithPost:orderURL params:params success:^(id responseObject) {
        if ([responseObject[@"type"] isEqualToString:@"error"]) {
            [self writeWithName:responseObject[@"message"]];
        } else {
            NSMutableArray *deleteArray = [NSMutableArray array];
            for (NSDictionary *dic in _OrderreviewDatalist) {
                NSString *reviewID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"col0"]];
                NSString *notiob = [NSString stringWithFormat:@"%@",noti.object];
                if ([reviewID isEqualToString:notiob]) {
                    [deleteArray addObject:dic];
                }
            }
            [_OrderreviewDatalist removeObjectsInArray:deleteArray];
            [_OrderreviewTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"审核失败");
    }];
    
   
}

#pragma mark - 获取数据
/**
 *  获取审核／撤审数据
 *
 *  @param Orderreview 是审核
 */
- (void)getOrderreviewDataWithOrderreview:(BOOL)Orderreview Page:(NSInteger)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *examOrderURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (Orderreview == YES) {
        examOrderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_orderreviewone];
        params = nil;
    } else {
        examOrderURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_orderreviewtwo];
        [params setObject:@(8) forKey:@"rows"];
        [params setObject:@(page) forKey:@"page"];
        [params setObject:@"zdrq" forKey:@"sidx"];
        [params setObject:@"desc" forKey:@"sord"];
    }
    [GiFHUD show];
    [XPHTTPRequestTool requestMothedWithPost:examOrderURL params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([_OrderreviewTableView.footer isRefreshing]) {
            [_OrderreviewTableView.footer endRefreshing];
            NSArray *array = [OrderreviewModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
            _OrderreviewDatalist = [[_OrderreviewDatalist arrayByAddingObjectsFromArray:array] mutableCopy];
            if ([[responseObject valueForKey:@"rows"] count] < 8 || [[responseObject valueForKey:@"page"] doubleValue] == [[responseObject valueForKey:@"pages"] doubleValue]) {
                [_OrderreviewTableView.footer noticeNoMoreData];
            }
        } else {
            _OrderreviewDatalist = [OrderreviewModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        }
        if (_OrderreviewDatalist.count == 0) {
            _noOrderreviewView.hidden = NO;
            _OrderreviewTableView.hidden = YES;
            _OrderreviewSearchController.searchBar.hidden = YES;
        } else {
            _OrderreviewTableView.hidden = NO;
            _OrderreviewSearchController.searchBar.hidden = NO;
            _noOrderreviewView.hidden = YES;
            if (Orderreview == YES) {
                for (int i = 0; i < _OrderreviewDatalist.count; i++) {
                    NSDictionary *dic = _OrderreviewDatalist[i];
                    NSMutableDictionary *adddic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [adddic setObject:@YES forKey:@"isexam"];
                    [_OrderreviewDatalist replaceObjectAtIndex:i withObject:adddic];
                }
            } else {
                for (int i = 0; i < _OrderreviewDatalist.count; i++) {
                    NSDictionary *dic = _OrderreviewDatalist[i];
                    NSMutableDictionary *adddic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [adddic setObject:@NO forKey:@"isexam"];
                    [_OrderreviewDatalist replaceObjectAtIndex:i withObject:adddic];
                }
                _page = [responseObject[@"page"] doubleValue];
                _pages = [responseObject[@"pages"] doubleValue];
            }
            [_OrderreviewTableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _OrderreviewDatalist) {
                    [_OrderreviewNames addObject:[dic valueForKey:@"col1"]];
                    [_OrderreviewNames addObject:[dic valueForKey:@"col3"]];
                    [_OrderreviewNames addObject:[dic valueForKey:@"col4"]];

                }
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"数据获取失败");
    }];
    
}


#pragma mark - 加载更多
- (void)getmoreOrderDatalist
{
    if (_page < _pages) {
        [self getOrderreviewDataWithOrderreview:NO Page:(_page + 1)];
    } else {
        [_OrderreviewTableView.footer noticeNoMoreData];
    }
}
@end
