//
//  TodayMoneyViewController.m
//  project-x6
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayMoneyViewController.h"

#import "XPDatePicker.h"

#import "TodayMoneyModel.h"

#import "TodayMoneyTableViewCell.h"
@interface TodayMoneyViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>


{
    XPDatePicker *_todayMoneydatepicker;
}

@property(nonatomic,copy)NSString *dateString;                 //今日日期

@property(nonatomic,strong)NoDataView *noTodayMoneyView;       //今日销量为空
@property(nonatomic,strong)UITableView *TodayMoneyTabelView;   //今日销量表示图
@property(nonatomic,strong)UIView *totalTodayMoneyView;        //总计

@property(nonatomic,copy)NSArray *todayMoneyDatalist;          //门店销量数据
@property(nonatomic,copy)NSDictionary *todayMoneydetailDic;       //指定门店销量
@property(nonatomic,copy)NSMutableDictionary *todayMoneyDic;
@property(nonatomic,copy)NSMutableArray *selectTodayMoneySection;

@property(nonatomic,copy)NSMutableArray *companyNames;          //门店名集合
@property(nonatomic,copy)NSMutableArray *newtodayMoneyDatalist;
@property(nonatomic,strong)NSMutableArray *companysearchNames;
@property(nonatomic,strong)UISearchController *todayMoneySearchController;
@end

@implementation TodayMoneyViewController

- (NoDataView *)noTodayMoneyView
{
    if (!_noTodayMoneyView) {
        _noTodayMoneyView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 40)];
        _noTodayMoneyView.text = @"没有数据";
        _noTodayMoneyView.hidden = YES;
        [self.view addSubview:_noTodayMoneyView];
    }
    return _noTodayMoneyView;
}

- (UITableView *)TodayMoneyTabelView
{
    if (!_TodayMoneyTabelView) {
        _TodayMoneyTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 40) style:UITableViewStylePlain];
        _TodayMoneyTabelView.hidden = YES;
        _TodayMoneyTabelView.delegate = self;
        _TodayMoneyTabelView.dataSource = self;
        _TodayMoneyTabelView.allowsSelection = NO;
        [self.view addSubview:_TodayMoneyTabelView];
    }
    return _TodayMoneyTabelView;
}

- (UIView *)totalTodayMoneyView
{
    if (!_totalTodayMoneyView) {
        _totalTodayMoneyView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, 40)];
        _totalTodayMoneyView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_totalTodayMoneyView];
        
        long long totalMoney = 0;
        for (NSDictionary *dic in _todayMoneyDatalist) {
            totalMoney += [[dic valueForKey:@"col2"] longLongValue];
        }
        
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth / 2.0, 0, KScreenWidth / 3.0, 40)];
        Label.textAlignment = NSTextAlignmentCenter;

        Label.text = [NSString stringWithFormat:@"总金额:%lld",totalMoney];
        
        [_totalTodayMoneyView addSubview:Label];
        
        
    }
    return _totalTodayMoneyView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTodayData" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"今日营业款"];
    
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    
    //导航栏按钮
    [self creatRightNaviButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];
    
    _selectTodayMoneySection = [NSMutableArray array];
    _todayMoneyDatalist = [NSArray array];
    _todayMoneyDic = [NSMutableDictionary dictionary];
    
    _companyNames = [NSMutableArray array];
    _companysearchNames = [NSMutableArray array];
    
    _newtodayMoneyDatalist = [NSMutableArray array];
    
    //搜索框
    _todayMoneySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _todayMoneySearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _todayMoneySearchController.searchResultsUpdater = self;
    _todayMoneySearchController.searchBar.delegate = self;
    _todayMoneySearchController.dimsBackgroundDuringPresentation = NO;
    _todayMoneySearchController.hidesNavigationBarDuringPresentation = NO;
    _todayMoneySearchController.searchBar.placeholder = @"搜索";
    [_todayMoneySearchController.searchBar sizeToFit];
    [self.view addSubview:_todayMoneySearchController.searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_todayMoneySearchController.searchBar setHidden:NO];
    
    [self noTodayMoneyView];
    [self TodayMoneyTabelView];
    
    [self getTodayMoneyDataWithDate:_dateString];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_todayMoneydatepicker.datePicker != nil) {
        [_todayMoneydatepicker.datePicker removeFromSuperview];
        [_todayMoneydatepicker.subView removeFromSuperview];
    }
    [_todayMoneySearchController.searchBar setHidden:YES];
    if ([_todayMoneySearchController.searchBar isFirstResponder]) {
        [_todayMoneySearchController.searchBar resignFirstResponder];
    }
}

#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
    
    _todayMoneydatepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:_dateString];
    
    _todayMoneydatepicker.delegate = self;
    _todayMoneydatepicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_todayMoneydatepicker];
}

#pragma mark - 日期选择响应事件
- (void)changeData
{
    NSLog(@"改变了日期");
    if (_todayMoneydatepicker.subView != nil) {
        _todayMoneydatepicker.subView.tag = 0;
        [_todayMoneydatepicker.subView removeFromSuperview];
    }
    [self getTodayMoneyDataWithDate:_todayMoneydatepicker.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_todayMoneydatepicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _todayMoneydatepicker.subView.tag=1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_todayMoneydatepicker.subView];
    }
    
    return NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_todayMoneySearchController.active) {
        return _companysearchNames.count;
    } else {
        return _todayMoneyDatalist.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectTodayMoneySection containsObject:string]) {
        UIImageView *loadView = (UIImageView *)[_TodayMoneyTabelView viewWithTag:4400 + section];
        loadView.image = [UIImage imageNamed:@"btn_jiantou_n"];
        return 1;
    } else {
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}


#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (self.todayMoneySearchController.active) {
        view = [self creatTableviewWithMutableArray:_newtodayMoneyDatalist Section:section];
    } else {
        view = [self creatTableviewWithMutableArray:[_todayMoneyDatalist mutableCopy] Section:section];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *todayMoneyIndet = @"todayMoneyIndet";
    TodayMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todayMoneyIndet];
    if (cell == nil) {
        cell = [[TodayMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayMoneyIndet];
    }
    if ([_selectTodayMoneySection containsObject:indexStr]) {
        NSDictionary *todayMoneydic = [_todayMoneyDic objectForKey:indexStr];
        cell.dic = todayMoneydic;
    }
    return cell;
}





#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companysearchNames removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.todayMoneySearchController.searchBar.text];
    self.companysearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.companysearchNames) {
        for (NSDictionary *dic in self.todayMoneyDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_newtodayMoneyDatalist addObject:dic];
            }
        }
    }
    
    [_TodayMoneyTabelView reloadData];
    
}


#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    view.backgroundColor = GrayColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@""];
    [view addSubview:imageView];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, KScreenWidth - 40 - 40 - 100, 39)];
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 10, 20, 20)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectTodayMoneySection containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_n"];
    } else {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_h"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 40);
    button.tag = 4400 + section;
    [button addTarget:self action:@selector(leadTodayMoneySectionData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 140, 0, 100, 39)];
    Label.text = [NSString stringWithFormat:@"金额:%@",[mutableArray[section] valueForKey:@"col2"]];
    [view addSubview:Label];
    
    
    UIView *lowLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth, 1)];
    lowLineView.backgroundColor = LineColor;
    [view addSubview:lowLineView];
    
    return view;
}

#pragma mark - 标题栏按钮事件
- (void)leadTodayMoneySectionData:(UIButton *)button
{
    //获取数据
    
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 4400];
    NSNumber *comStore = 0;
    if (_todayMoneySearchController.active) {
        comStore = [[_newtodayMoneyDatalist objectAtIndex:[string integerValue]] objectForKey:@"col0"];
    } else {
        comStore = [[_todayMoneyDatalist objectAtIndex:[string integerValue]] objectForKey:@"col0"];
    }
    
    if ([_selectTodayMoneySection containsObject:string]) {
        [_selectTodayMoneySection removeObject:string];
        [_todayMoneyDic removeObjectForKey:string];
        [_TodayMoneyTabelView reloadData];
        
    } else {
        dispatch_group_t grouped = dispatch_group_create();
        
        [_selectTodayMoneySection addObject:string];
        
        [self getOneMoneyDataWithDate:_todayMoneydatepicker.text StoreCode:comStore Section:[string longLongValue] group:grouped];
        dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
            [_TodayMoneyTabelView reloadData];
            
        });
        
    }
    
}



#pragma mark - 获取数据
/**
 *  门店数据
 *
 *  @param date 日期
 */
- (void)getTodayMoneyDataWithDate:(NSString *)date
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todayMoneyDataString = [NSString stringWithFormat:@"%@%@",baseURL,X6_todayMoney];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [XPHTTPRequestTool requestMothedWithPost:todayMoneyDataString params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _todayMoneyDatalist = [TodayMoneyModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todayMoneyDatalist.count == 0) {
            
            _TodayMoneyTabelView.hidden = YES;
            _noTodayMoneyView.hidden = NO;
            if (_totalTodayMoneyView != nil) {
                [_totalTodayMoneyView removeFromSuperview];
                _totalTodayMoneyView = nil;
            }
        } else {
            _noTodayMoneyView.hidden = YES;
            _TodayMoneyTabelView.hidden = NO;
            [_TodayMoneyTabelView reloadData];
            [self totalTodayMoneyView];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _todayMoneyDatalist) {
                [array addObject:[dic valueForKey:@"col1"]];
            }
            _companyNames = array;
        }
    } failure:^(NSError *error) {
        NSLog(@"今日销量获取失败");
    }];
    
}

/**
 *  门店员工数据
 *
 *  @param date      日期
 *  @param storeCode 门店代码
 */
- (void)getOneMoneyDataWithDate:(NSString *)date
                      StoreCode:(NSNumber *)storeCode
                        Section:(long)section
                          group:(dispatch_group_t)group
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todaydetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_todayMoneyDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [params setObject:storeCode forKey:@"ssgs"];
    [GiFHUD show];
    dispatch_group_enter(group);
    
    [XPHTTPRequestTool requestMothedWithPost:todaydetailURL params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _todayMoneydetailDic = responseObject[@"vo"];
        NSString *idnex = [NSString stringWithFormat:@"%ld",section];
        dispatch_group_leave(group);
        [_todayMoneyDic setObject:_todayMoneydetailDic forKey:idnex];
    } failure:^(NSError *error) {
        NSLog(@"今日战报数据获取失败");
        dispatch_group_leave(group);
    }];
    
}


@end
