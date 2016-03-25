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
    NSArray *_todayPayDatalist;
}

@property(nonatomic,copy)NSMutableArray *companyNames;         //门店名集合
@property(nonatomic,copy)NSMutableArray *newtodayPayDatalist;
@property(nonatomic,strong)NSMutableArray *companysearchNames;
@property(nonatomic,strong)UISearchController *todayPaySearchController;

@end

@implementation TodayPayViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTodayData" object:nil];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.todayPaySearchController.searchBar setHidden:NO];
    //绘制UI
    [self initTodayPay];

    //获取数据
    [self gettodayPayDataWithDate:_dateString];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.todayPaySearchController.searchBar setHidden:YES];
    if ([self.todayPaySearchController.searchBar isFirstResponder]) {
        [self.todayPaySearchController.searchBar resignFirstResponder];
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companysearchNames removeAllObjects];
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.todayPaySearchController.searchBar.text];
    self.companysearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    _newtodayPayDatalist = [NSMutableArray array];
    
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
    return 100;
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
    
    _todayPayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _todayPayTableView.delegate = self;
    _todayPayTableView.dataSource = self;
    _todayPayTableView.hidden = YES;
    _todayPayTableView.allowsSelection = NO;
    _todayPayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    [XPHTTPRequestTool requestMothedWithPost:todayPayURL params:params success:^(id responseObject) {
        NSLog(@"我的今日付款%@",responseObject);
        _todayPayDatalist = [TodayPayModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todayPayDatalist.count == 0) {
            _todayPayTableView.hidden = YES;
            _notodayPayView.hidden = NO;
        } else {
            _notodayPayView.hidden = YES;
            _todayPayTableView.hidden = NO;
            [_todayPayTableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _todayPayDatalist) {
                    [_companyNames addObject:[dic valueForKey:@"col2"]];
                }
            });
        }

    } failure:^(NSError *error) {
        NSLog(@"我的今日付款为空");
    }];
    
}

@end
