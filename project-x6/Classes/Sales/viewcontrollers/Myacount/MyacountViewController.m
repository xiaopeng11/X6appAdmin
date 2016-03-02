//
//  MyacountViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyacountViewController.h"

#import "MyacountModel.h"
#import "MyacountTableViewCell.h"

#import "XPDatePicker.h"
@interface MyacountViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NSArray *_myacountDatalist;
    NSString *_dateString;            //今日日期

    UITableView *_myacountTableView;
    
    XPDatePicker *_datepicker;
}

@property(nonatomic,strong)NoDataView *noacountView;
@property(nonatomic,copy)NSMutableArray *companyNames;         //门店名集合
@property(nonatomic,copy)NSMutableArray *newmyacountDatalist;
@property(nonatomic,strong)NSMutableArray *companysearchNames;
@property(nonatomic,strong)UISearchController *MyacountSearchController;
@end

@implementation MyacountViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTodayData" object:nil];
}

- (NoDataView *)noacountView
{
    if (!_noacountView) {
        _noacountView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 130, KScreenWidth, KScreenHeight - 64 - 130)];
        _noacountView.text = @"您还没有银行账户";
        _noacountView.hidden = YES;
        [self.view addSubview:_noacountView];
    }
    return _noacountView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"我的帐户"];
    
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    //导航栏按钮
    [self creatRightNaviButton];
    
    _companyNames = [NSMutableArray array];
    _companysearchNames = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];

}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companysearchNames removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.MyacountSearchController.searchBar.text];
    self.companysearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    _newmyacountDatalist = [NSMutableArray array];
    
    for (NSString *title in self.companysearchNames) {
        for (NSDictionary *dic in _myacountDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col2"]]) {
                [_newmyacountDatalist addObject:dic];
            }
        }
    }
    
    [_myacountTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //绘制UI
    [self initWithMyacountView];
    
    //获取数据
    [self getMyacountDataWithDate:_dateString];
    
}

#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
    
    _datepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:_dateString];
    
    _datepicker.delegate = self;
    _datepicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_datepicker];
    
}

#pragma mark - 日期选择响应事件
- (void)changeData
{
    if (_datepicker.subView != nil) {
        _datepicker.subView.tag = 0;
        [_datepicker.subView removeFromSuperview];
    }
    [self getMyacountDataWithDate:_datepicker.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_datepicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _datepicker.subView.tag=1;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:_datepicker.subView];
    }
    
    return NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myacountDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myacountCell = @"myacountCell";
    MyacountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myacountCell];
    if (cell == nil) {
        cell = [[MyacountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myacountCell];
    }
    cell.dic = _myacountDatalist[indexPath.row];
    return cell;
}




#pragma mark - 绘制UI
- (void)initWithMyacountView
{
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 130)];
    headerView.image = [UIImage imageNamed:@"btn_wodezhanghu_h"];
    
    _myacountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _myacountTableView.delegate = self;
    _myacountTableView.dataSource = self;
    _myacountTableView.hidden = YES;
    _myacountTableView.tableHeaderView = headerView;
    _myacountTableView.allowsSelection = NO;
    _myacountTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myacountTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myacountTableView];
}

#pragma mark - 获取数据
- (void)getMyacountDataWithDate:(NSString *)date
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *myacountURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_myAcount];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [XPHTTPRequestTool requestMothedWithPost:myacountURL params:params success:^(id responseObject) {
        NSLog(@"我的帐户%@",responseObject);
        _myacountDatalist = [MyacountModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_myacountDatalist.count == 0) {
            if (!_noacountView) {
                [self noacountView];
                _noacountView.hidden = NO;
                _myacountTableView.hidden = YES;
            }
        } else {
            if (_noacountView) {
                _noacountView.hidden = YES;
            }
            _myacountTableView.hidden = NO;
            [_myacountTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"我的帐户数据失败");
    }];
}

@end
