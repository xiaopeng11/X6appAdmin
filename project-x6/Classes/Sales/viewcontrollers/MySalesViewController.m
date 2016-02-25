//
//  MySalesViewController.m
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MySalesViewController.h"
#import "MySalesModel.h"
#import "MyTodayTableViewCell.h"
#import "XPDatePicker.h"


@interface MySalesViewController ()

@property(nonatomic,strong)NoDataView *nomysalesdataView;
@property(nonatomic,strong)UITableView *tableView;



@property(nonatomic,copy)NSArray *datalist;   // 总的数据
@property(nonatomic,copy)NSMutableArray *mutableKeys;   // 需要展示的组名
@property(nonatomic,copy)NSMutableArray *mutableArray;  //制定key的数组
@property(nonatomic,copy)NSMutableArray *NameDatalist;         //名称集合

@property(nonatomic,strong)NSMutableArray *SearchDatalist;       //搜索的数据
@property(nonatomic,strong)NSMutableArray *NewSearchDatalist;       //搜索的数据
@property(nonatomic,strong)NSMutableArray *SearchdateDatalist;       //搜索的数据


@property(nonatomic, strong)UISearchController *MySalesSearchController;

@end

@implementation MySalesViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        //表示图
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, KScreenWidth, KScreenHeight - 64 - 108 - 40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _tableView;
}

- (NoDataView *)nomysalesdataView
{
    if (!_nomysalesdataView) {
        _nomysalesdataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 108, KScreenWidth, KScreenHeight - 64 - 108 - 40)];
        _nomysalesdataView.text = @"当前没有纪录";
        [self.view addSubview:_nomysalesdataView];
    }
    return _nomysalesdataView;

}

- (void)viewWillDisappear:(BOOL)animated
{
    _MySalesSearchController.searchBar.hidden = YES;
    if ([_MySalesSearchController.searchBar isFirstResponder]) {
        [_MySalesSearchController.searchBar resignFirstResponder];
    }
    
    if (_FirstDatePicker.datePicker != nil || _SecondDatePicker.datePicker != nil) {
        [_FirstDatePicker.datePicker removeFromSuperview];
        [_SecondDatePicker.datePicker removeFromSuperview];
        [_FirstDatePicker.subView removeFromSuperview];
        [_SecondDatePicker.subView removeFromSuperview];
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_MySalesSearchController.searchBar setHidden:NO];
    //搜索框
    [self initHeaderViews];
    
    //获取当前月份的所有数据
    [self getMySalesDataWithFirstDay:_firstDayString LastDay:_dateString];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"我的销量"];

    //获取当前的年月
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    //当前月份的第一天
    NSMutableString *monthFirstString = [NSMutableString stringWithString:_dateString];
    [monthFirstString replaceCharactersInRange:NSMakeRange(_dateString.length - 2, 2) withString:@"01"];
    _firstDayString = [monthFirstString mutableCopy];
    
 
    
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
    _MySalesSearchController.searchResultsUpdater = nil;
    _MySalesSearchController.searchBar.delegate = nil;

}

- (void)dealloc
{
    _MySalesSearchController.searchResultsUpdater = nil;
    _MySalesSearchController.searchBar.delegate = nil;
}


- (void)initHeaderViews
{
    //搜索框
    _MySalesSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _MySalesSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _MySalesSearchController.searchResultsUpdater = self;
    _MySalesSearchController.searchBar.delegate = self;
    _MySalesSearchController.dimsBackgroundDuringPresentation = NO;
    _MySalesSearchController.hidesNavigationBarDuringPresentation = NO;
    _MySalesSearchController.searchBar.placeholder = @"搜索";
    [_MySalesSearchController.searchBar sizeToFit];
    [self.view addSubview:_MySalesSearchController.searchBar];
    
    //按日期查询
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, 40)];
    headerView.backgroundColor = GrayColor;
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    
    _FirstDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(5, 5, 110, 30) Date:_firstDayString];
    _FirstDatePicker.delegate = self;
    _FirstDatePicker.labelString = @"  起始日期:";
    [headerView addSubview:_FirstDatePicker];
    
    _SecondDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(125, 5, 110, 30) Date:_dateString];
    _SecondDatePicker.delegate = self;
    _SecondDatePicker.labelString = @"  结束日期:";
    [headerView addSubview:_SecondDatePicker];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(KScreenWidth - 60 - 30, 5, 60, 30);
    button.backgroundColor = Mycolor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"查询" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    //注释
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, 23)];
    view.backgroundColor = GrayColor;
    NSArray *name = @[@"商品名称",@"数量／个",@"成本／元"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(0, 0, KScreenWidth / 2.0, 24);
        } else {
            label.frame = CGRectMake(KScreenWidth / 2.0 + (KScreenWidth / 4.0) * (i - 1), 0, KScreenWidth / 4.0, 23);
        }
        label.text = name[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        [view addSubview:label];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 23, KScreenWidth, 1)];
    lineView.backgroundColor = LineColor;
    [view addSubview:lineView];
    
    [self.view addSubview:view];
    
    //总计
    _totalNumberViews= [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 40 - 64, KScreenWidth, 40)];
    _totalNumberViews.backgroundColor = GrayColor;
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.text = @"合计：";
            label.frame = CGRectMake(0, 0, KScreenWidth / 2.0, 40);
        } else {
            label.frame = CGRectMake(KScreenWidth / 2.0 + (KScreenWidth / 4.0) * (i - 1), 0, KScreenWidth / 4.0, 40);
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1000 + i;
        label.font = [UIFont boldSystemFontOfSize:20];
        [_totalNumberViews addSubview:label];
    }
    [self.view addSubview:_totalNumberViews];
    
}

#pragma mark - 获取数据
- (void)getMySalesDataWithFirstDay:(NSString *)firstDay LastDay:(NSString *)lastDay
{
    //获取今天的数据
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *MySalesURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_MySales];
    [GiFHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:firstDay forKey:@"fsrqq"];
    [params setObject:lastDay forKey:@"fsrqz"];
    
    [XPHTTPRequestTool requestMothedWithPost:MySalesURL params:params success:^(id responseObject) {
        _datalist = [MySalesModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        
        if (_datalist.count == 0) {
            [self nomysalesdataView];
            if (_tableView) {
                _tableView.hidden = YES;
            }
        } else {
            [self tableView];
            if (_nomysalesdataView) {
                _nomysalesdataView.hidden = YES;
            }
            NSLog(@"%@",responseObject);
            //获取时间
            NSMutableSet *set = [NSMutableSet set];
            for (NSDictionary *dic in _datalist) {
                [set addObject:[dic valueForKey:@"col0"]];
            }
            _mutableKeys = [[set allObjects] mutableCopy];
            
            _NameDatalist = [NSMutableArray array];
            for (NSDictionary *dic in _datalist) {
                [_NameDatalist addObject:[dic valueForKey:@"col2"]];
            }
           
            //处理数据
            [self makedata];
            [_tableView reloadData];
            
            //       总计的数据
            [self insertLabelWithdatalist:_datalist];
        }

    } failure:^(NSError *error) {
        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
    }];
    
    
}

- (void)makedata
{
    _mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in _datalist) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *date in _mutableKeys) {
            if ([[dic valueForKey:@"col0"] isEqualToString:date]) {
                [array addObject:dic];
            }
        }
        [_mutableArray addObject:array];
    }
}


- (void)insertLabelWithdatalist:(NSArray *)datalist
{
    UILabel *label = [_totalNumberViews viewWithTag:1001];
    long numbers = 0;
    
    UILabel *label2 = [_totalNumberViews viewWithTag:1002];
    long double prices = 0;
    for (id dic in datalist) {
        if ([dic isKindOfClass:[NSArray class]]) {
            for (NSDictionary *diced in dic) {
                numbers += [[diced valueForKey:@"col3"] intValue];
                prices += [[diced valueForKey:@"col4"] doubleValue];
            }
        } else {
            numbers += [[dic valueForKey:@"col3"] intValue];
            prices += [[dic valueForKey:@"col4"] doubleValue];
        }
        
    }
    label.text = [NSString stringWithFormat:@"%.0ld",numbers];
    label2.text = [NSString stringWithFormat:@"%.0Lf",prices];
    
    
}

#pragma mark - UITableViewDataSource
//组的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_MySalesSearchController.active) {
        return _mutableKeys.count;
    } else {
        return _NewSearchDatalist.count;
    }
}

//组的单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_MySalesSearchController.active) {
        return [_mutableArray[section] count];
    } else {
        return [_NewSearchDatalist[section] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!_MySalesSearchController.active) {
        return _mutableKeys[section];
    } else {
        return _SearchdateDatalist[section];
    }
}


//标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"MySalesident";
    MyTodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[MyTodayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    if (!_MySalesSearchController.active) {
        //默认情况下的数据
        cell.dic = [[_mutableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
        //搜索情况下的数据
        cell.dic = [_NewSearchDatalist[indexPath.section] objectAtIndex:indexPath.row];
    }

    return cell;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    [self.SearchDatalist removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", _MySalesSearchController.searchBar.text];
    self.SearchDatalist = [[self.NameDatalist filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    //处理数据
    [self makeSearchDta];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [self insertLabelWithdatalist:_NewSearchDatalist];
    });
    
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self insertLabelWithdatalist:_datalist];
    
}


- (void)makeSearchDta
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *name in _SearchDatalist) {
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"col2"] isEqualToString:name]) {
                [array addObject:dic];
            }
        }
    }
    
    NSMutableSet *set = [NSMutableSet set];
    for (NSDictionary *dic in array) {
        [set addObject:[dic valueForKey:@"col0"]];
    }
    _SearchdateDatalist = [[set allObjects] mutableCopy];
    
    
    _NewSearchDatalist = [NSMutableArray array];
    for (NSString *date in set) {
        NSMutableArray *dateArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            if ([[dic valueForKey:@"col0"] isEqualToString:date]) {
                [dateArray addObject:dic];
            }
        }
        [_NewSearchDatalist addObject:dateArray];
    }
    
    
}

#pragma mark - 查询按钮事件
- (void)buttonAction:(UIButton *)button
{
    
    NSLog(@"查询%@-%@",_FirstDatePicker.text,_SecondDatePicker.text);
    if (_MySalesSearchController.active) {
        [_MySalesSearchController resignFirstResponder];
    }
    if (_FirstDatePicker.subView != nil && _SecondDatePicker == nil) {
        [_FirstDatePicker.subView removeFromSuperview];
        _FirstDatePicker.subView.tag = 0;
    } else if (_SecondDatePicker.subView != nil && _FirstDatePicker == nil) {
        [_SecondDatePicker.subView removeFromSuperview];
        _SecondDatePicker.subView.tag = 0;
    } else if (_FirstDatePicker.subView != nil && _SecondDatePicker.subView != nil) {
        [_FirstDatePicker.subView removeFromSuperview];
        [_SecondDatePicker.subView removeFromSuperview];
        _SecondDatePicker.subView.tag = 0;
        _FirstDatePicker.subView.tag = 0;
    }
    
    [self getMySalesDataWithFirstDay:_FirstDatePicker.text LastDay:_SecondDatePicker.text];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _FirstDatePicker) {
        if ([[[UIApplication sharedApplication] keyWindow].subviews containsObject:_SecondDatePicker.subView]) {
            _SecondDatePicker.subView.tag = 0;
            [_SecondDatePicker.subView removeFromSuperview];
        }
        if (_FirstDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _FirstDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_FirstDatePicker.subView];
        }
    } else {
        if ([[[UIApplication sharedApplication] keyWindow].subviews containsObject:_FirstDatePicker.subView]) {
            _FirstDatePicker.subView.tag = 0;
            [_FirstDatePicker.subView removeFromSuperview];
        }
        if (_SecondDatePicker.subView.tag == 0) {
            //置tag标志为1，并显示子视
            _SecondDatePicker.subView.tag=1;
            [[[UIApplication sharedApplication] keyWindow] addSubview:_SecondDatePicker.subView];
        }
    }
    return NO;
}


@end
