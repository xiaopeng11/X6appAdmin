//
//  PurchaseViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PurchaseViewController.h"

#import "PurchaseModel.h"
#import "PurchaseTableViewCell.h"

@interface PurchaseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    UITableView *_PurchaseTabelView;
    NoDataView *_noPurchaseView;
    
    
    NSMutableArray *_PurchaseDatalist;
    
    NSInteger _yearString;
    NSInteger _monthString;
    
}

@property(nonatomic,copy)NSMutableArray *PurchaseNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *PurchaseSearchNames;
@property(nonatomic,copy)NSMutableArray *NewPurchaseDatalist;
@property(nonatomic, strong)UISearchController *PurchaseSearchController;
@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"采购异常"];
    
    NSDate *date = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%@",date];
    _yearString = [[dateString substringToIndex:4] doubleValue];
    _monthString = [[dateString substringWithRange:NSMakeRange(5, 2)] doubleValue];
    
    _PurchaseNames = [NSMutableArray array];
    _PurchaseSearchNames = [NSMutableArray array];
    _NewPurchaseDatalist = [NSMutableArray array];
    
    
    [self initPurchaseUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_PurchaseSearchController.searchBar setHidden:NO];
    
    
    [self getPurchaseDatalistWithYear:_yearString Month:_monthString];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_PurchaseSearchController.searchBar setHidden:YES];
    if ([_PurchaseSearchController.searchBar isFirstResponder]) {
        [_PurchaseSearchController.searchBar resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.PurchaseSearchController.active) {
        return _NewPurchaseDatalist.count;
    } else {
        return _PurchaseDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Purchaseident = @"Purchaseident";
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Purchaseident];
    if (cell == nil) {
        cell = [[PurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Purchaseident];
    }
    if (self.PurchaseSearchController.active) {
        cell.dic = _NewPurchaseDatalist[indexPath.row];
    } else {
        cell.dic = _PurchaseDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *ignore = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"忽略" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"确定忽略吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableArray *array = [NSMutableArray array];
            if (_PurchaseSearchController.active) {
                array = _NewPurchaseDatalist;
            } else {
                array = _PurchaseDatalist;
            }
            NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
            NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
            NSString *ignoreURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_ignore];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            NSNumber *djid = [array[indexPath.row] valueForKey:@"col0"];
            NSNumber *djh = [array[indexPath.row] valueForKey:@"col1"];
            [params setObject:djid forKey:@"djid"];
            [params setObject:djh forKey:@"djh"];
            [params setObject:@"CKYC" forKey:@"txlx"];
            [XPHTTPRequestTool requestMothedWithPost:ignoreURL params:params success:^(id responseObject) {
                NSLog(@"采购异常忽略成功");
            } failure:^(NSError *error) {
                NSLog(@"采购异常忽略失败");
            }];
            if (_PurchaseSearchController.active) {
                [_NewPurchaseDatalist removeObjectAtIndex:indexPath.row];
            } else {
                [_PurchaseDatalist removeObjectAtIndex:indexPath.row];
            }
            [_PurchaseTabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }];
        UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertcontroller addAction:okaction];
        [alertcontroller addAction:cancelaction];
        [self presentViewController:alertcontroller animated:YES completion:nil];
    }];
    return @[ignore];
}

#pragma mark - initPurchaseUI
- (void)initPurchaseUI
{
    //搜索框
    _PurchaseSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _PurchaseSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _PurchaseSearchController.searchResultsUpdater = self;
    _PurchaseSearchController.searchBar.delegate = self;
    _PurchaseSearchController.dimsBackgroundDuringPresentation = NO;
    _PurchaseSearchController.hidesNavigationBarDuringPresentation = NO;
    _PurchaseSearchController.searchBar.placeholder = @"搜索";
    [_PurchaseSearchController.searchBar sizeToFit];
    _PurchaseSearchController.searchBar.hidden = YES;
    [self.view addSubview:_PurchaseSearchController.searchBar];
    
    
    _PurchaseTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _PurchaseTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _PurchaseTabelView.delegate = self;
    _PurchaseTabelView.dataSource = self;
    _PurchaseTabelView.hidden = YES;
    _PurchaseTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_PurchaseTabelView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getLastMonthData)];
    [self.view addSubview:_PurchaseTabelView];
    
    _noPurchaseView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _noPurchaseView.text = @"当前月份无采购异常";
    _noPurchaseView.hidden = YES;
    [self.view addSubview:_noPurchaseView];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.PurchaseSearchNames removeAllObjects];
    [self.NewPurchaseDatalist removeAllObjects];
    
    NSPredicate *PurchasePredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.PurchaseSearchController.searchBar.text];
    self.PurchaseSearchNames = [[self.PurchaseNames filteredArrayUsingPredicate:PurchasePredicate] mutableCopy];
    
    for (NSString *title in self.PurchaseSearchNames) {
        for (NSDictionary *dic in _PurchaseDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col3"]]) {
                [_NewPurchaseDatalist addObject:dic];
            }
        }
    }
    
    [_PurchaseTabelView reloadData];
    
}


#pragma mark - 获取数据
- (void)getPurchaseDatalistWithYear:(NSInteger)year Month:(NSInteger)month
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *PurchaseURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Purchase];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(year) forKey:@"uyear"];
    [params setObject:@(month) forKey:@"accper"];
    if (!_PurchaseTabelView.footer.isRefreshing) {
        [GiFHUD show];
    }
    
    [XPHTTPRequestTool requestMothedWithPost:PurchaseURL params:params success:^(id responseObject) {
        NSLog(@"采购异常数据%@",responseObject);
        if (_PurchaseTabelView.footer.isRefreshing) {
            [_PurchaseTabelView.footer endRefreshing];
            _PurchaseDatalist = [[_PurchaseDatalist arrayByAddingObjectsFromArray:[PurchaseModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]]] mutableCopy];
            if ([responseObject[@"rows"] count] == 0) {
                [_PurchaseTabelView.footer noticeNoMoreData];
            }
        } else {
            _PurchaseDatalist = [PurchaseModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        }
        if (_PurchaseDatalist.count == 0) {
            _PurchaseTabelView.hidden = YES;
            _PurchaseSearchController.searchBar.hidden = YES;
            _noPurchaseView.hidden = NO;
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _PurchaseDatalist) {
                if ([[dic valueForKey:@"col10"] boolValue] == 1) {
                    [array addObject:dic];
                }
            }
            [_PurchaseDatalist removeObjectsInArray:array];
            
            _noPurchaseView.hidden = YES;
            _PurchaseTabelView.hidden = NO;
            _PurchaseSearchController.searchBar.hidden = NO;
            [_PurchaseTabelView reloadData];
            
            for (NSDictionary *dic in _PurchaseDatalist) {
                [_PurchaseNames addObject:[dic valueForKey:@"col1"]];
                [_PurchaseNames addObject:[dic valueForKey:@"col3"]];
                
            }
            
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取零售异常失败");
    }];
}

- (void)getLastMonthData
{
    if (_monthString > 1) {
        [self getPurchaseDatalistWithYear:_yearString Month:(_monthString - 1)];
        _monthString--;
    } else if (_monthString == 1){
        _monthString = 12;
        [self getPurchaseDatalistWithYear:(_yearString - 1) Month:_monthString];
        _yearString--;
    }
}


@end
