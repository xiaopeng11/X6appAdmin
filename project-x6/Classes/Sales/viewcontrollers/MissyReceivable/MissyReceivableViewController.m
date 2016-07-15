//
//  MissyReceivableViewController.m
//  project-x6
//
//  Created by Apple on 16/5/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MissyReceivableViewController.h"

#import "XPDatePicker.h"

#import "MissyRecivableModel.h"
#import "MissyReceivableCell.h"
@interface MissyReceivableViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{
    NSMutableArray *_MissyReceivableDatalist;                                   //应收款明细数据
    XPDatePicker *_MissyReceivabledatepicker;                                   //应收款日期选择

}

@property(nonatomic,copy)NSString *dateString;                                  //今日日期

@property(nonatomic,strong)NoDataView *noMissyReceivableView;                   //当日应收款为空
@property(nonatomic,strong)UITableView *MissyReceivableTabelView;               //当日应收款
@property(nonatomic,strong)UIView *totalMissyReceivableView;                    //当日应收款总计


@property(nonatomic,copy)NSMutableArray *customers;                             //客户集合
@property(nonatomic,strong)NSMutableArray *NewMissyReceivableDatalist;          //搜索的数据
@property(nonatomic,strong)NSMutableArray *searchcustomers;                     //搜索客户名称
@property(nonatomic,strong)UISearchController *MissyReceivableSearchController; //搜索

@end

@implementation MissyReceivableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _customers = nil;
    _searchcustomers = nil;
    
    _MissyReceivableDatalist = nil;
    _NewMissyReceivableDatalist = nil;
}

- (NoDataView *)noMissyReceivableView
{
    if (!_noMissyReceivableView) {
        _noMissyReceivableView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 40)];
        _noMissyReceivableView.text = @"当日没有应收明细";
        _noMissyReceivableView.hidden = YES;
        [self.view addSubview:_noMissyReceivableView];
    }
    return _noMissyReceivableView;
}

- (UITableView *)MissyReceivableTabelView
{
    if (!_MissyReceivableTabelView) {
        _MissyReceivableTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
        _MissyReceivableTabelView.hidden = YES;
        _MissyReceivableTabelView.delegate = self;
        _MissyReceivableTabelView.dataSource = self;
        _MissyReceivableTabelView.allowsSelection = NO;
        _MissyReceivableTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_MissyReceivableTabelView];
    }
    return _MissyReceivableTabelView;
}

- (UIView *)totalMissyReceivableView
{
    if (!_totalMissyReceivableView) {
        _totalMissyReceivableView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, 40)];
        _totalMissyReceivableView.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.2];
        _totalMissyReceivableView.hidden = YES;
        [self.view addSubview:_totalMissyReceivableView];
        
        
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            if (i == 0) {
                label.frame = CGRectMake(20, 0, 40, 40);
                label.text = @"合计:";
            } else if (i == 1) {
                label.frame = CGRectMake(KScreenWidth - 170, 0, 40, 40);
                label.text = @"未收:";
            } else {
                label.frame = CGRectMake(KScreenWidth - 130, 0, 120, 40);
                label.textColor = Mycolor;
                label.tag = 48201;
            }
            [_totalMissyReceivableView addSubview:label];
        }
        
    }
    return _totalMissyReceivableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"应收款明细"];
    
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    
    //导航栏按钮
    [self creatRightNaviButton];
    
    _customers = [NSMutableArray array];
    _searchcustomers = [NSMutableArray array];
    
    _MissyReceivableDatalist = [NSMutableArray array];
    _NewMissyReceivableDatalist = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];
    
    //搜索框
    _MissyReceivableSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _MissyReceivableSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _MissyReceivableSearchController.searchResultsUpdater = self;
    _MissyReceivableSearchController.searchBar.delegate = self;
    _MissyReceivableSearchController.dimsBackgroundDuringPresentation = NO;
    _MissyReceivableSearchController.hidesNavigationBarDuringPresentation = NO;
    _MissyReceivableSearchController.searchBar.placeholder = @"搜索";
    [_MissyReceivableSearchController.searchBar sizeToFit];
    [self.view addSubview:_MissyReceivableSearchController.searchBar];
    
    [self noMissyReceivableView];
    [self MissyReceivableTabelView];
    [self totalMissyReceivableView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.MissyReceivableSearchController.searchBar setHidden:NO];
    [self getMissyReceivableDatalistWithDateString:_dateString];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.MissyReceivableSearchController.searchBar setHidden:YES];
    [_MissyReceivableSearchController setActive:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_MissyReceivabledatepicker.datePicker != nil) {
        [_MissyReceivabledatepicker.datePicker removeFromSuperview];
        [_MissyReceivabledatepicker.subView removeFromSuperview];
    }
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_MissyReceivableSearchController.active) {
        return _NewMissyReceivableDatalist.count;
    } else {
        return _MissyReceivableDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MissyRevicableCell = @"MissyRevicableCell";
    MissyReceivableCell *cell = [tableView dequeueReusableCellWithIdentifier:MissyRevicableCell];
    if (cell == nil) {
        cell = [[MissyReceivableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MissyRevicableCell];
    }
    if (self.MissyReceivableSearchController.active) {
        cell.dic = _NewMissyReceivableDatalist[indexPath.row];
    } else {
        cell.dic = _MissyReceivableDatalist[indexPath.row];
    }
    return cell;
}

#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
    _MissyReceivabledatepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:_dateString];
    _MissyReceivabledatepicker.delegate = self;
    _MissyReceivabledatepicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_MissyReceivabledatepicker];
}

#pragma mark - 日期选择响应事件
- (void)changeData
{
    [self getMissyReceivableDatalistWithDateString:_MissyReceivabledatepicker.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_MissyReceivabledatepicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _MissyReceivabledatepicker.subView.tag=1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_MissyReceivabledatepicker.subView];
    }
    
    return NO;
}


#pragma mark - 获取数据
- (void)getMissyReceivableDatalistWithDateString:(NSString *)dateString
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todaydetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_MissyReceivable];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dateString forKey:@"fsrq"];
    [self showProgress];
    
    [XPHTTPRequestTool requestMothedWithPost:todaydetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        _MissyReceivableDatalist = [MissyRecivableModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];

        if (_MissyReceivableDatalist.count == 0) {
            _MissyReceivableTabelView.hidden = YES;
            _noMissyReceivableView.hidden = NO;
            _totalMissyReceivableView.hidden = YES;            
        } else {
            _noMissyReceivableView.hidden = YES;
            _MissyReceivableTabelView.hidden = NO;
            _totalMissyReceivableView.hidden = NO;

            double totalMoney = 0;
            totalMoney = [self leijiaNumDataList:_MissyReceivableDatalist Code:@"col4"];
            UILabel *label = (UILabel *)[_totalMissyReceivableView viewWithTag:48201];
            label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
            
            NSArray *sortacountArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col0" ascending:YES]];
            [_MissyReceivableDatalist sortUsingDescriptors:sortacountArray];
            [_MissyReceivableTabelView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [_customers removeAllObjects];
                for (NSDictionary *dic in _MissyReceivableDatalist) {
                    [_customers addObject:[dic valueForKey:@"col3"]];
                }
            });
            
            [_MissyReceivableTabelView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"应收明细数据获取失败");
    }];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchcustomers removeAllObjects];
    [self.NewMissyReceivableDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.MissyReceivableSearchController.searchBar.text];
    self.searchcustomers = [[self.customers filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    NSMutableSet *set = [NSMutableSet set];
    for (NSString *title in self.searchcustomers) {
        for (NSDictionary *dic in _MissyReceivableDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col3"]]) {
                [set addObject:dic];
            }
        }
    }
    _NewMissyReceivableDatalist = [[set allObjects] mutableCopy];    
    NSArray *sortacountArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col0" ascending:YES]];
    [_NewMissyReceivableDatalist sortUsingDescriptors:sortacountArray];
    [_MissyReceivableTabelView reloadData];
    
    if (_NewMissyReceivableDatalist.count != 0) {
        double totalMoney =0;
        for (NSDictionary *dic in _NewMissyReceivableDatalist) {
            totalMoney += [[dic valueForKeyPath:@"col4"] doubleValue];
        }
        UILabel *label = (UILabel *)[_totalMissyReceivableView viewWithTag:48201];
        label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    double totalMoney = [self leijiaNumDataList:_MissyReceivableDatalist Code:@"col4"];
    UILabel *label = (UILabel *)[_totalMissyReceivableView viewWithTag:48201];
    label.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
}


@end
