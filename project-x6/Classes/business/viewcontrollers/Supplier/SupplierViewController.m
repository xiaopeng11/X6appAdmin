//
//  SupplierViewController.m
//  project-x6
//
//  Created by Apple on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SupplierViewController.h"

#import "AddsupplierViewController.h"

#import "SupplierTableViewCell.h"

#import "CustomerModel.h"
#import "SupplierModel.h"


@interface SupplierViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>
@property(nonatomic,strong)UITableView *SupplierTableview;                 //供应商表示图
@property(nonatomic,strong)NoDataView *NoSupplierView;                     //没有供应商


@property(nonatomic,copy)NSMutableArray *supplierDatalist;                  //供应商的集合


@property(nonatomic,copy)NSMutableArray *SupplierNames;                    //供应商名的集合
@property(nonatomic,strong)NSMutableArray *SupplierSearchNames;
@property(nonatomic,copy)NSMutableArray *newsupplierDatalist;
@property(nonatomic, strong)UISearchController *SupplierSearchController;
@end

@implementation SupplierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_issupplier) {
        [self naviTitleWhiteColorWithText:@"供应商"];
    } else {
        [self naviTitleWhiteColorWithText:@"客户"];
    }
    
    [self initsupplierUI];
    
    _SupplierNames = [NSMutableArray array];
    _SupplierSearchNames = [NSMutableArray array];
    _newsupplierDatalist = [NSMutableArray array];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _SupplierSearchController.searchBar.hidden = NO;
    
    [self getsupplierDataWithSupplier:_issupplier];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_SupplierSearchController.active) {
        [_SupplierSearchController resignFirstResponder];
    }
    _SupplierSearchController.searchBar.hidden = YES;
}
#pragma mark - 绘制UI
- (void)initsupplierUI
{
    //导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_tianjia_h" highImageName:nil target:self action:@selector(addsuppliers)];
    
    //搜索框
    _SupplierSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _SupplierSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _SupplierSearchController.searchResultsUpdater = self;
    _SupplierSearchController.searchBar.delegate = self;
    _SupplierSearchController.dimsBackgroundDuringPresentation = NO;
    _SupplierSearchController.hidesNavigationBarDuringPresentation = NO;
    _SupplierSearchController.searchBar.placeholder = @"搜索";
    [_SupplierSearchController.searchBar sizeToFit];
    _SupplierSearchController.searchBar.hidden = YES;
    [self.view addSubview:_SupplierSearchController.searchBar];
    
    //表示图
    [self SupplierTableview];
    [self NoSupplierView];
    
}

- (UITableView *)SupplierTableview
{
    if (_SupplierTableview == nil) {
        _SupplierTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
        _SupplierTableview.hidden = YES;
        _SupplierTableview.delegate = self;
        _SupplierTableview.dataSource = self;
        _SupplierTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_SupplierTableview];
    }
    return _SupplierTableview;
}

- (NoDataView *)NoSupplierView

{
    if (_NoSupplierView == nil) {
        _NoSupplierView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _NoSupplierView.hidden = YES;
        _NoSupplierView.text = @"没有信息";
        [self.view addSubview:_NoSupplierView];
    }
    
    return _NoSupplierView;
}

- (void)addsuppliers
{
    AddsupplierViewController *addsupplierVC = [[AddsupplierViewController alloc] init];
    addsupplierVC.issupplier = _issupplier;
    [self.navigationController pushViewController:addsupplierVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.SupplierSearchController.active) {
        return _newsupplierDatalist.count;
    } else {
        return _supplierDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *suppliercellid = @"suppliercellid";
    SupplierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:suppliercellid];
    if (cell == nil) {
        cell = [[SupplierTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suppliercellid];
    }
    if (self.SupplierSearchController.active) {
        cell.dic = _newsupplierDatalist[indexPath.row];
    } else {
        cell.dic = _supplierDatalist[indexPath.row];
    }
    cell.issupplier = _issupplier;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddsupplierViewController *addSupplier = [[AddsupplierViewController alloc] init];
    if (self.SupplierSearchController.active) {
        addSupplier.supplierdic = _newsupplierDatalist[indexPath.row];
    } else {
        addSupplier.supplierdic = _supplierDatalist[indexPath.row];
    }
    addSupplier.issupplier = _issupplier;
    [self.navigationController pushViewController:addSupplier animated:YES];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.SupplierSearchNames removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.SupplierSearchController.searchBar.text];
    self.SupplierSearchNames = [[self.SupplierNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.SupplierSearchNames) {
        for (NSDictionary *dic in self.supplierDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"name"]]) {
                [_newsupplierDatalist addObject:dic];
            }
        }
    }
    
    [_SupplierTableview reloadData];
    
}

#pragma mark - 获取数据
- (void)getsupplierDataWithSupplier:(BOOL)supplier
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *supplierORcostumerURL;
    if (supplier == YES) {
        supplierORcostumerURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_supplier];
    } else {
        supplierORcostumerURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_customer];
    }
    [XPHTTPRequestTool requestMothedWithPost:supplierORcostumerURL params:nil success:^(id responseObject) {
        if (_SupplierTableview.header.isRefreshing) {
            [_SupplierTableview.header endRefreshing];
        }
        if (supplier == YES) {
            NSLog(@"供应商数据获取%@",responseObject);
            _supplierDatalist = [SupplierModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        } else {
            NSLog(@"客户数据获取%@",responseObject);
            _supplierDatalist = [CustomerModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        }
        
        
        if (_supplierDatalist.count == 0) {
            _SupplierTableview.hidden = YES;
            _SupplierSearchController.searchBar.hidden = YES;
            _NoSupplierView.hidden = NO;
        } else {
            _NoSupplierView.hidden = YES;
            _SupplierTableview.hidden = NO;
            _SupplierSearchController.searchBar.hidden = NO;
            [_SupplierTableview reloadData];
            
            for (NSDictionary *dic in _supplierDatalist) {
                [_SupplierNames addObject:[dic valueForKey:@"name"]];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"数据失败");
    }];
    
}


@end
