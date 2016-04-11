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
    NSMutableArray *_myacountDatalist;
    NSString *_dateString;            //今日日期

    UITableView *_myacountTableView;
    
    XPDatePicker *_datepicker;
}

@property(nonatomic,strong)NoDataView *noacountView;
@property(nonatomic,strong)UIView *totalacountView;        //总计

@property(nonatomic,copy)NSMutableArray *bankNames;         //门店名集合
@property(nonatomic,copy)NSMutableArray *newmyacountDatalist;
@property(nonatomic,strong)NSMutableArray *banksearchNames;
@property(nonatomic,strong)UISearchController *MyacountSearchController;

@end

@implementation MyacountViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _bankNames = nil;
    _banksearchNames = nil;
    _myacountDatalist = nil;
    _newmyacountDatalist = nil;
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

- (UIView *)totalacountView
{
    if (!_totalacountView) {
        _totalacountView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, 40)];
        _totalacountView.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.2];
        _totalacountView.hidden = YES;
        [self.view addSubview:_totalacountView];
   
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            if (i == 0) {
                label.frame = CGRectMake(20, 0, 40, 40);
                label.text = @"合计:";
            } else if (i == 1) {
                label.frame = CGRectMake(KScreenWidth - 170, 0, 40, 40);
                label.text = @"金额:";
            } else {
                label.frame = CGRectMake(KScreenWidth - 130, 0, 120, 40);
                label.textColor = [UIColor redColor];
                label.tag = 4711;
            }
            [_totalacountView addSubview:label];
            
        }
        
        
        
    }
    return _totalacountView;
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
    
    _bankNames = [NSMutableArray array];
    _banksearchNames = [NSMutableArray array];
    _newmyacountDatalist = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];
    
    //绘制UI
    [self initWithMyacountView];

    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    for (NSDictionary *dic in qxList) {
        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_myzh"]) {
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                //获取数据
                [self getMyacountDataWithDate:_dateString];
            } else {
                [self writeWithName:@"您没有查看帐户详情的权限"];
            }
        }
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.banksearchNames removeAllObjects];
    [self.newmyacountDatalist removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.MyacountSearchController.searchBar.text];
    self.banksearchNames = [[self.bankNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.banksearchNames) {
        for (NSDictionary *dic in _myacountDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col0"]]) {
                [_newmyacountDatalist addObject:dic];
            }
        }
    }
    
    [_myacountTableView reloadData];
    
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
    [self.MyacountSearchController.searchBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.MyacountSearchController.searchBar setHidden:YES];
    if ([self.MyacountSearchController.searchBar isFirstResponder]) {
        [self.MyacountSearchController.searchBar resignFirstResponder];
    }
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
    if (self.MyacountSearchController.active) {
        return _newmyacountDatalist.count;
    } else {
        return _myacountDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myacountCell = @"myacountCell";
    MyacountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myacountCell];
    if (cell == nil) {
        cell = [[MyacountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myacountCell];
    }
    if (self.MyacountSearchController.active) {
        cell.dic = _newmyacountDatalist[indexPath.row];
    } else {
        cell.dic = _myacountDatalist[indexPath.row];
    }
    return cell;
}

#pragma mark - 绘制UI
- (void)initWithMyacountView
{
    //搜索框
    _MyacountSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _MyacountSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _MyacountSearchController.searchResultsUpdater = self;
    _MyacountSearchController.searchBar.delegate = self;
    _MyacountSearchController.dimsBackgroundDuringPresentation = NO;
    _MyacountSearchController.hidesNavigationBarDuringPresentation = NO;
    _MyacountSearchController.searchBar.placeholder = @"搜索";
    [_MyacountSearchController.searchBar sizeToFit];
    [self.view addSubview:_MyacountSearchController.searchBar];
    
    
    _myacountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
    _myacountTableView.delegate = self;
    _myacountTableView.dataSource = self;
    _myacountTableView.hidden = YES;
    _myacountTableView.allowsSelection = NO;
    _myacountTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myacountTableView.showsVerticalScrollIndicator = NO;
    _myacountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [GiFHUD show];
    [XPHTTPRequestTool requestMothedWithPost:myacountURL params:params success:^(id responseObject) {
        NSLog(@"我的帐户%@",responseObject);
        _myacountDatalist = [MyacountModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_myacountDatalist.count == 0) {
            if (!_noacountView) {
                [self noacountView];
                _noacountView.hidden = NO;
                _myacountTableView.hidden = YES;
                if (_totalacountView) {
                    _totalacountView.hidden = YES;
                }
            }
        } else {
            if (_noacountView) {
                _noacountView.hidden = YES;
            }
            _myacountTableView.hidden = NO;
            [self totalacountView];
            _totalacountView.hidden = NO;
            long long totalMoney = 0;
            for (NSDictionary *dic in _myacountDatalist) {
                totalMoney += [[dic valueForKey:@"col4"] longLongValue];
            }
            UILabel *label = (UILabel *)[_totalacountView viewWithTag:4711];
            label.text = [NSString stringWithFormat:@"￥%lld",totalMoney];
            
            NSArray *sortacountArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col4" ascending:NO]];
            [_myacountDatalist sortUsingDescriptors:sortacountArray];
            [_myacountTableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in _myacountDatalist) {
                    [_bankNames addObject:[dic valueForKey:@"col0"]];
                }
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"我的帐户数据失败");
    }];
}

@end
