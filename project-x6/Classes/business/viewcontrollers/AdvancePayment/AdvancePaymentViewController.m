//
//  AdvancePaymentViewController.m
//  project-x6
//
//  Created by Apple on 16/3/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AdvancePaymentViewController.h"

#import "AdvancePaymentTableViewCell.h"

#import "AddadvancePaymentViewController.h"
@interface AdvancePaymentViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NSMutableArray *_AdvancePaymentDatalist;
}

@property(nonatomic,strong)UITableView *AdvancePaymentTableView;
@property(nonatomic,strong)NoDataView *noAdvancePaymentView;

@property(nonatomic,copy)NSMutableArray *AdvancePaymentNames;                    //供应商名的集合
@property(nonatomic,strong)NSMutableArray *AdvancePaymentSearchNames;
@property(nonatomic,copy)NSMutableArray *newadvancePaymentDatalist;
@property(nonatomic, strong)UISearchController *AdvancePaymentSearchController;

@end

@implementation AdvancePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"预付款"];
    
    [self initAdvancePaymentUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _AdvancePaymentSearchController.searchBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_AdvancePaymentSearchController.active) {
        [_AdvancePaymentSearchController resignFirstResponder];
    }
    _AdvancePaymentSearchController.searchBar.hidden = YES;
}
#pragma mark - 绘制UI
- (void)initAdvancePaymentUI
{
    //导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_tianjia_h" highImageName:nil target:self action:@selector(addAdvancePayment)];
    
    
    //搜索框
    _AdvancePaymentSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _AdvancePaymentSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _AdvancePaymentSearchController.searchResultsUpdater = self;
    _AdvancePaymentSearchController.searchBar.delegate = self;
    _AdvancePaymentSearchController.dimsBackgroundDuringPresentation = NO;
    _AdvancePaymentSearchController.hidesNavigationBarDuringPresentation = NO;
    _AdvancePaymentSearchController.searchBar.placeholder = @"搜索";
    [_AdvancePaymentSearchController.searchBar sizeToFit];
    [self.view addSubview:_AdvancePaymentSearchController.searchBar];
    
    //表示图
    [self AdvancePaymentTableview];
    [self NoAdvancePaymentView];
    
}

- (UITableView *)AdvancePaymentTableview
{
    if (_AdvancePaymentTableView == nil) {
        _AdvancePaymentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64) style:UITableViewStylePlain];
        _AdvancePaymentTableView.hidden = YES;
        _AdvancePaymentTableView.delegate = self;
        _AdvancePaymentTableView.dataSource = self;
        [self.view addSubview:_AdvancePaymentTableView];
    }
    return _AdvancePaymentTableView;
}

- (NoDataView *)NoAdvancePaymentView

{
    if (_noAdvancePaymentView == nil) {
        _noAdvancePaymentView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _noAdvancePaymentView.hidden = YES;
        _noAdvancePaymentView.text = @"没有预付款信息";
        [self.view addSubview:_noAdvancePaymentView];
    }
    
    return _noAdvancePaymentView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _AdvancePaymentDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AdvancePaymentcellid = @"AdvancePaymentcellid";
    AdvancePaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AdvancePaymentcellid];
    if (cell == nil) {
        cell = [[AdvancePaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AdvancePaymentcellid];
    }
    cell.dic = _AdvancePaymentDatalist[indexPath.row];
    return cell;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.AdvancePaymentSearchNames removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.AdvancePaymentSearchController.searchBar.text];
    self.AdvancePaymentSearchNames = [[self.AdvancePaymentNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.AdvancePaymentSearchNames) {
        for (NSDictionary *dic in _AdvancePaymentDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_newadvancePaymentDatalist addObject:dic];
            }
        }
    }
    
    [_AdvancePaymentTableView reloadData];
    
}

#pragma mark - 获取数据
/**
 *  获取审核／撤审数据
 *
 *  @param AdvancePayment 是审核
 */
- (void)getAdvancePaymentDataWithAdvancePayment:(BOOL)AdvancePayment
{
    
}

- (void)addAdvancePayment
{
    AddadvancePaymentViewController *addadvancePaymentVC = [[AddadvancePaymentViewController alloc] init];
    [self.navigationController pushViewController:addadvancePaymentVC animated:YES];
}


@end
