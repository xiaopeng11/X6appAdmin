//
//  TodayPayViewController.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayPayViewController.h"

#import "TodayPayModel.h"

#import "TodayPayTableViewCell.h"

#import "XPDatePicker.h"
@interface TodayPayViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NoDataView *_notodayPayView;
    UITableView *_todayPayTableView;
    XPDatePicker *_datePicker;
    
    NSString *_dateString;
    NSMutableArray *_todayPayDatalist;
}

@property(nonatomic,copy)NSMutableArray *companyNames;         //门店名集合
@property(nonatomic,copy)NSMutableArray *newtodayPayDatalist;
@property(nonatomic,strong)NSMutableArray *companysearchNames;
@property(nonatomic,strong)UISearchController *todayPaySearchController;


@property(nonatomic,strong)UIView *totalTodayPayView;        //总计

@end

@implementation TodayPayViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTodayData" object:nil];
    _companyNames = nil;
    _companysearchNames = nil;
    _todayPayDatalist = nil;
    _newtodayPayDatalist = nil;
    
}

- (UIView *)totalTodayPayView
{
    if (!_totalTodayPayView) {
        _totalTodayPayView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, 40)];
        _totalTodayPayView.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.2];
        _totalTodayPayView.hidden = YES;
        [self.view addSubview:_totalTodayPayView];
        
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            if (i == 0) {
                label.frame = CGRectMake(20, 0, 40, 40);
                label.text = @"合计:";
            } else if (i == 1) {
                label.frame = CGRectMake(KScreenWidth - 150, 0, 40, 40);
                label.text = @"金额:";
            } else {
                label.frame = CGRectMake(KScreenWidth - 110, 0, 100, 40);
                label.textColor = [UIColor redColor];
                label.tag = 4511;
            }
            [_totalTodayPayView addSubview:label];
            
        }
        
    }
    return _totalTodayPayView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"今日付款"];
    
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    
    //导航栏按钮
    [self creatRightNaviButton];
    
    _companyNames = [NSMutableArray array];
    _companysearchNames = [NSMutableArray array];
    _newtodayPayDatalist = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];

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
    [self.todayPaySearchController.searchBar setHidden:NO];
    
    //绘制UI
    [self initTodayPay];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    for (NSDictionary *dic in qxList) {
        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jrcwfk"]) {
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                //获取数据
                [self gettodayPayDataWithDate:_dateString];
            } else {
                [self writeWithName:@"您没有查看今日付款详情的权限"];
            }
        }
    }
 
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.todayPaySearchController.searchBar setHidden:YES];
    [_todayPaySearchController setActive:NO];
    
    if (_datePicker.datePicker != nil) {
        [_datePicker.datePicker removeFromSuperview];
        [_datePicker.subView removeFromSuperview];
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companysearchNames removeAllObjects];
    [_newtodayPayDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.todayPaySearchController.searchBar.text];
    self.companysearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.companysearchNames) {
        for (NSDictionary *dic in _todayPayDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col2"]]) {
                [_newtodayPayDatalist addObject:dic];
            }
        }
    }
    
    [_todayPayTableView reloadData];
    
}




#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.todayPaySearchController.active) {
        return _newtodayPayDatalist.count;
    } else {
        return _todayPayDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *todayPayCell = @"todayPayCell";
    TodayPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todayPayCell];
    if (cell == nil) {
        cell = [[TodayPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayPayCell];
    }
    if (self.todayPaySearchController.active) {
        cell.dic = _newtodayPayDatalist[indexPath.row];
    } else {
        cell.dic = _todayPayDatalist[indexPath.row];
    }
    return cell;
}

#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
    
    _datePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:_dateString];
    
    _datePicker.delegate = self;
    _datePicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_datePicker];
    
}

#pragma mark - 日期选择响应事件
- (void)changeData
{
    [self gettodayPayDataWithDate:_datePicker.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_datePicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _datePicker.subView.tag=1;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:_datePicker.subView];
    }
    
    return NO;
}

#pragma mark - 绘制UI
- (void)initTodayPay
{
    //搜索框
    _todayPaySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _todayPaySearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _todayPaySearchController.searchResultsUpdater = self;
    _todayPaySearchController.searchBar.delegate = self;
    _todayPaySearchController.dimsBackgroundDuringPresentation = NO;
    _todayPaySearchController.hidesNavigationBarDuringPresentation = NO;
    _todayPaySearchController.searchBar.placeholder = @"搜索";
    [_todayPaySearchController.searchBar sizeToFit];
    [self.view addSubview:_todayPaySearchController.searchBar];
    
    _todayPayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
    _todayPayTableView.delegate = self;
    _todayPayTableView.dataSource = self;
    _todayPayTableView.hidden = YES;
    _todayPayTableView.allowsSelection = NO;
    _todayPayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _todayPayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_todayPayTableView];
    
    _notodayPayView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
    _notodayPayView.text = @"您今日没有付款";
    _notodayPayView.hidden = YES;
    [self.view addSubview:_notodayPayView];
}

#pragma mark - 获取数据
- (void)gettodayPayDataWithDate:(NSString *)date
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todayPayURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_todayPay];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:todayPayURL params:params success:^(id responseObject) {
        [self hideProgress];
        _todayPayDatalist = [TodayPayModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todayPayDatalist.count == 0) {
            _todayPayTableView.hidden = YES;
            _notodayPayView.hidden = NO;
            if (_totalTodayPayView) {
                _totalTodayPayView.hidden = YES;
            }
        } else {
            _notodayPayView.hidden = YES;
            _todayPayTableView.hidden = NO;
            [self totalTodayPayView];
            _totalTodayPayView.hidden = NO;
            long long totalMoney = 0;
            for (NSDictionary *dic in _todayPayDatalist) {
                totalMoney += [[dic valueForKey:@"col3"] longLongValue];
            }
            UILabel *label = (UILabel *)[_totalTodayPayView viewWithTag:4511];
            label.text = [NSString stringWithFormat:@"￥%lld",totalMoney];

            NSArray *sorttodaypayArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col3" ascending:NO]];
            [_todayPayDatalist sortUsingDescriptors:sorttodaypayArray];
            
            [_todayPayTableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _todayPayDatalist) {
                    [_companyNames addObject:[dic valueForKey:@"col2"]];
                }
            });
        }

    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"我的今日付款为空");
    }];
    
}

@end
