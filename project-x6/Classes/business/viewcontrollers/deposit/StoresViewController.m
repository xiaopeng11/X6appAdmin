//
//  StoresViewController.m
//  project-x6
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "StoresViewController.h"

#import "StoreModel.h"
#import "StoresTableViewCell.h"

@interface StoresViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NoDataView *_nostoreView;
    UITableView *_storeTableView;
    NSArray *_storesdatalist;
    NSMutableArray *_newstoresdatalist;
}

@property(nonatomic,copy)NSMutableArray *storesNames;

@property(nonatomic,strong)NSMutableArray *searchstoresNames;
@property(nonatomic,strong)UISearchController *storeSearchViewcontroller;

@end

@implementation StoresViewController

- (void)dealloc
{
    
    _searchstoresNames = nil;
    _storesNames = nil;
    _newstoresdatalist = nil;
    _storesdatalist = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self naviTitleWhiteColorWithText:@"门店选择"];
    
    
    _searchstoresNames = [NSMutableArray array];
    _storesNames = [NSMutableArray array];
    _newstoresdatalist = [NSMutableArray array];
    
    [self initStoreUI];
    
    [self getstoreDataWithIsStore];
    
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

#pragma mark - 绘制UI
- (void)initStoreUI
{
    //搜索框
    _storeSearchViewcontroller = [[UISearchController alloc] initWithSearchResultsController:nil];
    _storeSearchViewcontroller.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _storeSearchViewcontroller.searchResultsUpdater = self;
    _storeSearchViewcontroller.searchBar.delegate = self;
    _storeSearchViewcontroller.dimsBackgroundDuringPresentation = NO;
    _storeSearchViewcontroller.hidesNavigationBarDuringPresentation = NO;
    _storeSearchViewcontroller.searchBar.placeholder = @"搜索";
    [_storeSearchViewcontroller.searchBar sizeToFit];
    _storeSearchViewcontroller.searchBar.hidden = YES;
    [self.view addSubview:_storeSearchViewcontroller.searchBar];
    
    
    _storeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _storeTableView.delegate = self;
    _storeTableView.dataSource = self;
    _storeTableView.hidden = YES;
    _storeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_storeTableView];
    
    _nostoreView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _nostoreView.text = @"没有门店数据";
    _nostoreView.hidden = YES;
    [self.view addSubview:_nostoreView];
}

#pragma mark - 获取数据
- (void)getstoreDataWithIsStore
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *storeURL;
    storeURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_storesList];
 
    
    [XPHTTPRequestTool requestMothedWithPost:storeURL params:nil success:^(id responseObject) {
        _storesdatalist = [StoreModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_storesdatalist.count == 0) {
            _storeTableView.hidden = YES;
            _storeSearchViewcontroller.searchBar.hidden = YES;
            _nostoreView.hidden = NO;
        } else {
            _nostoreView.hidden = YES;
            _storeTableView.hidden = NO;
            _storeSearchViewcontroller.searchBar.hidden = NO;
            [_storeTableView reloadData];
        }
        for (NSDictionary *dic in _storesNames) {
            [_storesNames addObject:[dic valueForKey:@"name"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"银行存款");
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_storeSearchViewcontroller.active) {
        return _newstoresdatalist.count;
    } else {
        return _storesdatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *storecellID = @"storecellID";
    StoresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storecellID];
    if (cell == nil) {
        cell = [[StoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storecellID];
        
    }
    
    if (_storeSearchViewcontroller.active) {
        cell.dic = _newstoresdatalist[indexPath.row];
    } else {
        cell.dic = _storesdatalist[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic;
    if (_storeSearchViewcontroller.active) {
        dic = _newstoresdatalist[indexPath.row];
    } else {
        dic = _storesdatalist[indexPath.row];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"storeChange" object:dic];
  
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchstoresNames removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.storeSearchViewcontroller.searchBar.text];
    self.searchstoresNames = [[self.storesNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.searchstoresNames) {
        for (NSDictionary *dic in _storesdatalist) {
            if ([title isEqualToString:[dic valueForKey:@"name"]]) {
                [_newstoresdatalist addObject:dic];
            }
        }
    }
    
    [_storeTableView reloadData];
    
}

@end
