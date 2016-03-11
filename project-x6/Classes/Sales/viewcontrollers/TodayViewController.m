//
//  TodayViewController.m
//  project-x6
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayViewController.h"

#import "XPDatePicker.h"

#import "TodayModel.h"
#import "TodaydetailModel.h"

#import "TodayTableViewCell.h"
@interface TodayViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>
{
    NSMutableArray *_selectSectionArray;                 //标题被选中数组
    XPDatePicker *_datepicker;                           //日期选择
}

@property(nonatomic,copy)NSString *dateString;            //今日日期
@property(nonatomic,copy)NSArray *todayDatalist;          //今日战报门店数据
@property(nonatomic,copy)NSMutableDictionary *detailDic;
@property(nonatomic,copy)NSArray *todayDetailDatalist;    //今日战报门店详情数据


@property(nonatomic,strong)NoDataView *NotodayView;       //今日战报为空
@property(nonatomic,strong)UITableView *TodayTableView;   //今日战报
@property(nonatomic,strong)UIView *totalView;

//搜索事件
@property(nonatomic,copy)NSMutableArray *companyNames;    //门店名数组
@property(nonatomic,strong)NSMutableArray *companSearchNames; //搜索的门店名
@property(nonatomic,strong)UISearchController *companySearchController;
@property(nonatomic,copy)NSMutableArray *newtodayDatlist;


@end

@implementation TodayViewController

- (NoDataView *)NotodayView
{
    if (!_NotodayView) {
        _NotodayView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 40)];
        _NotodayView.text = @"没有数据";
        _NotodayView.hidden = YES;
        [self.view addSubview:_NotodayView];
    }
    return _NotodayView;
}

- (UITableView *)TodayTableView
{
    if (!_TodayTableView) {
        _TodayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
        _TodayTableView.hidden = YES;
        _TodayTableView.delegate = self;
        _TodayTableView.dataSource = self;
        _TodayTableView.allowsSelection = NO;
        [self.view addSubview:_TodayTableView];
    }
    return _TodayTableView;
}

- (UIView *)totalView
{
    if (_totalView == nil) {
        _totalView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, 40)];
        _totalView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_totalView];
        
        long long totalNum = 0,totalMoney = 0,totalProfit = 0;
        for (NSDictionary *dic in _todayDatalist) {
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
            [_totalView addSubview:Label];
        }
    }
    return _totalView;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTodayData" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"今日战报"];
    
    
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    
    //导航栏按钮
    [self creatRightNaviButton];
    
    _selectSectionArray = [NSMutableArray array];
    _todayDetailDatalist = [NSArray array];
    _detailDic = [NSMutableDictionary dictionary];
    
    _companyNames = [NSMutableArray array];
    _companSearchNames = [NSMutableArray array];
    
    _newtodayDatlist = [NSMutableArray array];
    
    //搜索框
    _companySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _companySearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _companySearchController.searchResultsUpdater = self;
    _companySearchController.searchBar.delegate = self;
    _companySearchController.dimsBackgroundDuringPresentation = NO;
    _companySearchController.hidesNavigationBarDuringPresentation = NO;
    _companySearchController.searchBar.placeholder = @"搜索";
    [_companySearchController.searchBar sizeToFit];
    [self.view addSubview:_companySearchController.searchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData) name:@"changeTodayData" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_companySearchController.searchBar setHidden:NO];
    
    [self NotodayView];
    [self TodayTableView];
  
    //获取数据
    [self getTodayDataWithDate:_dateString];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_datepicker.datePicker != nil) {
        [_datepicker.datePicker removeFromSuperview];
        [_datepicker.subView removeFromSuperview];
    }
    [_companySearchController.searchBar setHidden:YES];
    if ([_companySearchController.searchBar isFirstResponder]) {
        [_companySearchController.searchBar resignFirstResponder];
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

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.companSearchNames removeAllObjects];
    [self.detailDic removeAllObjects];
    [_selectSectionArray removeAllObjects];
    
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.companySearchController.searchBar.text];
    self.companSearchNames = [[self.companyNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.companSearchNames) {
        for (NSDictionary *dic in self.todayDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_newtodayDatlist addObject:dic];
            }
        }
    }
    
    [_TodayTableView reloadData];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_companySearchController.active) {
        return _companSearchNames.count;
    } else {
        return _todayDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectSectionArray containsObject:string]) {
        UIImageView *loadView = (UIImageView *)[_TodayTableView viewWithTag:4200 + section];
        loadView.image = [UIImage imageNamed:@"btn_jiantou_n"];
        NSArray *sectionArray = [_detailDic objectForKey:string];
        return sectionArray.count;
    } else {
        return 0;

    }
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (self.companySearchController.active) {
        view = [self creatTableviewWithMutableArray:_newtodayDatlist Section:section];
    } else {
        view = [self creatTableviewWithMutableArray:[_todayDatalist mutableCopy] Section:section];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *todayIndet = @"todayIndet";
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todayIndet];
    if (cell == nil) {
        cell = [[TodayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayIndet];
    }
    if ([_selectSectionArray containsObject:indexStr]) {
        NSArray *array = [_detailDic objectForKey:indexStr];
        cell.dic = array[indexPath.row];
    }
    return cell;
}



#pragma mark - 获取数据
/**
 *  门店数据
 *
 *  @param date 日期
 */
- (void)getTodayDataWithDate:(NSString *)date
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todayURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_today];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [GiFHUD show];
    [XPHTTPRequestTool requestMothedWithPost:todayURL params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _todayDatalist = [TodayModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_todayDatalist.count == 0) {
            
            _TodayTableView.hidden = YES;
            _NotodayView.hidden = NO;
            if (_totalView != nil) {
                [_totalView removeFromSuperview];
                _totalView = nil;
            }
        } else {
            _NotodayView.hidden = YES;
            _TodayTableView.hidden = NO;
            [_TodayTableView reloadData];
            [self totalView];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _todayDatalist) {
                [array addObject:[dic valueForKey:@"col1"]];
            }
            _companyNames = array;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"今日战报数据获取失败");
    }];
}

/**
 *  门店员工数据
 *
 *  @param date      日期
 *  @param storeCode 门店代码
 */
- (void)getYuanGongDataWithDate:(NSString *)date
                      StoreCode:(NSNumber *)storeCode
                        Section:(long)section
                          group:(dispatch_group_t)group
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todaydetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_todayDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"fsrqq"];
    [params setObject:date forKey:@"fsrqz"];
    [params setObject:storeCode forKey:@"ssgs"];
    [GiFHUD show];
    dispatch_group_enter(group);

    [XPHTTPRequestTool requestMothedWithPost:todaydetailURL params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _todayDetailDatalist = [TodaydetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        NSString *idnex = [NSString stringWithFormat:@"%ld",section];
        [_detailDic setObject:_todayDetailDatalist forKey:idnex];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        NSLog(@"今日战报数据获取失败");
        dispatch_group_leave(group);
    }];
    
}

#pragma mark - 日期选择响应事件
- (void)changeData
{
    NSLog(@"改变了日期");
    if (_datepicker.subView != nil) {
        _datepicker.subView.tag = 0;
        [_datepicker.subView removeFromSuperview];
    }
    [self getTodayDataWithDate:_datepicker.text];
}


#pragma mark - 标题栏按钮事件
- (void)leadSectionData:(UIButton *)button
{
    //获取数据
   
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 4220];
    NSNumber *comStore = 0;
    if (_companySearchController.active) {
        comStore = [[_newtodayDatlist objectAtIndex:[string integerValue]] objectForKey:@"col0"];
    } else {
        comStore = [[_todayDatalist objectAtIndex:[string integerValue]] objectForKey:@"col0"];
    }
    
    
   
    if ([_selectSectionArray containsObject:string]) {
        [_selectSectionArray removeObject:string];
        [_detailDic removeObjectForKey:string];
        [_TodayTableView reloadData];

    } else {
        dispatch_group_t grouped = dispatch_group_create();

        [_selectSectionArray addObject:string];
        
        [self getYuanGongDataWithDate:_datepicker.text StoreCode:comStore Section:[string longLongValue] group:grouped];
        dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
            [_TodayTableView reloadData];

        });
   
    }

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

#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
    view.backgroundColor = GrayColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"btn_mendian_h"];
    [view addSubview:imageView];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, KScreenWidth - 40 - 40, 39)];
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 10, 20, 20)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectSectionArray containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_n"];
    } else {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_h"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 40);
    button.tag = 4220 + section;
    [button addTarget:self action:@selector(leadSectionData:) forControlEvents:UIControlEventTouchUpInside];
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




@end