//
//  TodaySalesViewController.m
//  project-x6
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodaySalesViewController.h"

#import "TodayModel.h"
#import "TodaySalesDetailModel.h"

#import "XPDatePicker.h"

#import "TodaySalesTableViewCell.h"
@interface TodaySalesViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>


{
     XPDatePicker *_todaydatepicker;
}

@property(nonatomic,copy)NSString *dateString;                 //今日日期

@property(nonatomic,strong)NoDataView *noTodaySalesView;       //今日销量为空
@property(nonatomic,strong)UITableView *TodaySalesTabelView;   //今日销量表示图
@property(nonatomic,strong)UIView *totalTodaySalesView;        //总计

@property(nonatomic,copy)NSArray *todaySalesDatalist;          //门店销量数据
@property(nonatomic,copy)NSArray *todaySalesdetailArray;    //指定门店销量
@property(nonatomic,copy)NSMutableDictionary *todaySalesDic;
@property(nonatomic,copy)NSMutableArray *selectTodaySalesSection;

@property(nonatomic,copy)NSMutableArray *companyNames;         //门店名集合
@property(nonatomic,copy)NSMutableArray *newtodaySalesDatalist;
@property(nonatomic,strong)NSMutableArray *companysearchNames;
@property(nonatomic,strong)UISearchController *todaySalesSearchController; 

@end

@implementation TodaySalesViewController


- (NoDataView *)noTodaySalesView
{
    if (!_noTodaySalesView) {
        _noTodaySalesView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 40 - 40)];
        _noTodaySalesView.text = @"没有数据";
        _noTodaySalesView.hidden = YES;
        [self.view addSubview:_noTodaySalesView];
    }
    return _noTodaySalesView;
}

- (UITableView *)TodaySalesTabelView
{
    if (!_TodaySalesTabelView) {
        _TodaySalesTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 64 - 40 - 40) style:UITableViewStylePlain];
        _TodaySalesTabelView.hidden = YES;
        _TodaySalesTabelView.delegate = self;
        _TodaySalesTabelView.dataSource = self;
        _TodaySalesTabelView.allowsSelection = NO;
        [self.view addSubview:_TodaySalesTabelView];
    }
    return _TodaySalesTabelView;
}

- (UIView *)totalTodaySalesView
{
    if (!_totalTodaySalesView) {
        _totalTodaySalesView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, 40)];
        _totalTodaySalesView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_totalTodaySalesView];
        
        long long totalNum = 0,totalMoney = 0,totalProfit = 0;
        for (NSDictionary *dic in _todaySalesDatalist) {
            totalNum += [[dic valueForKey:@"col2"] longLongValue];
            totalMoney += [[dic valueForKey:@"col3"] longLongValue];
            totalProfit += [[dic valueForKey:@"col4"] longLongValue];
        }
        for (int i = 0; i < 3; i++) {
            UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(i * (KScreenWidth / 3.0), 0, KScreenWidth / 3.0, 40)];
            Label.textAlignment = NSTextAlignmentCenter;
            
            if (i == 0) {
                Label.text = [NSString stringWithFormat:@"总数量:%lld",totalNum];
            } else if (i == 1) {
                Label.text = [NSString stringWithFormat:@"总金额:%lld",totalMoney];
            } else {
                Label.text = [NSString stringWithFormat:@"总毛利:%lld",totalProfit];
            }
            [_totalTodaySalesView addSubview:Label];
        }

    }
    return _totalTodaySalesView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTodayData" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"今日销量"];
    
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    
    //导航栏按钮
    [self creatRightNaviButton];
    
    _selectTodaySalesSection = [NSMutableArray array];
    _todaySalesDatalist = [NSArray array];
    _todaySalesDic = [NSMutableDictionary dictionary];
    
    _companyNames = [NSMutableArray array];
    _companysearchNames = [NSMutableArray array];
    
    _newtodaySalesDatalist = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];
    
    //搜索框
    _todaySalesSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _todaySalesSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _todaySalesSearchController.searchResultsUpdater = self;
    _todaySalesSearchController.searchBar.delegate = self;
    _todaySalesSearchController.dimsBackgroundDuringPresentation = NO;
    _todaySalesSearchController.hidesNavigationBarDuringPresentation = NO;
    _todaySalesSearchController.searchBar.placeholder = @"搜索";
    [_todaySalesSearchController.searchBar sizeToFit];
    [self.view addSubview:_todaySalesSearchController.searchBar];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_todaySalesSearchController.searchBar setHidden:NO];
    
    [self noTodaySalesView];
    [self TodaySalesTabelView];
    
    [self getTodaySalesDataWithDate:_dateString];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_todaydatepicker.datePicker != nil) {
        [_todaydatepicker.datePicker removeFromSuperview];
        [_todaydatepicker.subView removeFromSuperview];
    }
    [_todaySalesSearchController.searchBar setHidden:YES];
    if ([_todaySalesSearchController.searchBar isFirstResponder]) {
        [_todaySalesSearchController.searchBar resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_todaySalesSearchController.active) {
        return _companysearchNames.count;
    } else {
        return _todaySalesDatalist.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectTodaySalesSection containsObject:string]) {
        UIImageView *loadView = (UIImageView *)[_TodaySalesTabelView viewWithTag:4300 + section];
        loadView.image = [UIImage imageNamed:@"btn_jiantou_n"];
        NSArray *array = [_todaySalesDic objectForKey:string];
        return array.count;
    } else {
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}


#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (self.todaySalesSearchController.active) {
        view = [self creatTableviewWithMutableArray:_newtodaySalesDatalist Section:section];
    } else {
        view = [self creatTableviewWithMutableArray:[_todaySalesDatalist mutableCopy] Section:section];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *todaySalesIndet = @"todaySalesIndet";
    TodaySalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todaySalesIndet];
    if (cell == nil) {
        cell = [[TodaySalesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todaySalesIndet];
    }
    if ([_selectTodaySalesSection containsObject:indexStr]) {
        NSArray *todaySalesArray = [_todaySalesDic objectForKey:indexStr];
        cell.dic = [todaySalesArray objectAtIndex:indexPath.row];
    }
    return cell;
}





#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companysearchNames removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.todaySalesSearchController.searchBar.text];
    self.companysearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.companysearchNames) {
        for (NSDictionary *dic in self.todaySalesDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_newtodaySalesDatalist addObject:dic];
            }
        }
    }
    
    [_TodaySalesTabelView reloadData];
    
}


#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
    view.backgroundColor = GrayColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@""];
    [view addSubview:imageView];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, KScreenWidth - 40 - 40, 39)];
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 10, 20, 20)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectTodaySalesSection containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_n"];
    } else {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_h"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 40);
    button.tag = 4300 + section;
    [button addTarget:self action:@selector(leadTodaySalesSectionData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView *lineImageView = [[UIView alloc] initWithFrame:CGRectMake(40, 39, KScreenWidth - 40, 1)];
    lineImageView.backgroundColor = LineColor;
    [view addSubview:lineImageView];
    
    for (int i = 0; i < 3; i++) {
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(i * (KScreenWidth / 3.0), 40, KScreenWidth / 3.0, 29)];
        Label.textColor = [UIColor grayColor];
        Label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            Label.text = [NSString stringWithFormat:@"数量:%@",[mutableArray[section] valueForKey:@"col2"]];
        } else if (i == 1) {
            Label.text = [NSString stringWithFormat:@"金额:%@",[mutableArray[section] valueForKey:@"col3"]];
        } else {
            Label.text = [NSString stringWithFormat:@"毛利:%@",[mutableArray[section] valueForKey:@"col4"]];
        }
        [view addSubview:Label];
    }
    
    UIView *lowLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, KScreenWidth, 1)];
    lowLineView.backgroundColor = LineColor;
    [view addSubview:lowLineView];
    
    return view;
}

#pragma mark - 标题栏按钮事件
- (void)leadTodaySalesSectionData:(UIButton *)button
{
    //获取数据
    
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 4300];
    NSNumber *comStore = 0;
    if (_todaySalesSearchController.active) {
        comStore = [[_newtodaySalesDatalist objectAtIndex:[string integerValue]] objectForKey:@"col0"];
    } else {
        comStore = [[_todaySalesDatalist objectAtIndex:[string integerValue]] objectForKey:@"col0"];
    }

    if ([_selectTodaySalesSection containsObject:string]) {
        [_selectTodaySalesSection removeObject:string];
        [_todaySalesDic removeObjectForKey:string];
        [_TodaySalesTabelView reloadData];
        
    } else {
        dispatch_group_t grouped = dispatch_group_create();
        
        [_selectTodaySalesSection addObject:string];
        
        [self getOneSalesDataWithDate:_todaydatepicker.text StoreCode:comStore Section:[string longLongValue] group:grouped];
        dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
            [_TodaySalesTabelView reloadData];
            
        });
        
    }
    
}



#pragma mark - 获取数据
/**
 *  门店数据
 *
 *  @param date 日期
 */
- (void)getTodaySalesDataWithDate:(NSString *)date
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todaySalesDataString = [NSString stringWithFormat:@"%@%@",baseURL,X6_todaySales];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [XPHTTPRequestTool requestMothedWithPost:todaySalesDataString params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _todaySalesDatalist = [TodayModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todaySalesDatalist.count == 0) {
            
            _TodaySalesTabelView.hidden = YES;
            _noTodaySalesView.hidden = NO;
            if (_totalTodaySalesView != nil) {
                [_totalTodaySalesView removeFromSuperview];
                _totalTodaySalesView = nil;
            }
        } else {
            _noTodaySalesView.hidden = YES;
            _TodaySalesTabelView.hidden = NO;
            [_TodaySalesTabelView reloadData];
            [self totalTodaySalesView];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _todaySalesDatalist) {
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
- (void)getOneSalesDataWithDate:(NSString *)date
                      StoreCode:(NSNumber *)storeCode
                        Section:(long)section
                          group:(dispatch_group_t)group
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todaydetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_todaySalesDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [params setObject:storeCode forKey:@"ssgs"];
    [GiFHUD show];
    dispatch_group_enter(group);
    
    [XPHTTPRequestTool requestMothedWithPost:todaydetailURL params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _todaySalesdetailArray = [TodaySalesDetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        NSString *idnex = [NSString stringWithFormat:@"%ld",section];
        dispatch_group_leave(group);
        [_todaySalesDic setObject:_todaySalesdetailArray forKey:idnex];
    } failure:^(NSError *error) {
        NSLog(@"今日战报数据获取失败");
        dispatch_group_leave(group);
    }];
    
}


#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
    
    _todaydatepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:_dateString];
    
    _todaydatepicker.delegate = self;
    _todaydatepicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_todaydatepicker];
}

#pragma mark - 日期选择响应事件
- (void)changeData
{
    NSLog(@"改变了日期");
    if (_todaydatepicker.subView != nil) {
        _todaydatepicker.subView.tag = 0;
        [_todaydatepicker.subView removeFromSuperview];
    }
    [self getTodaySalesDataWithDate:_todaydatepicker.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_todaydatepicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _todaydatepicker.subView.tag=1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_todaydatepicker.subView];
    }
    
    return NO;
}

@end
