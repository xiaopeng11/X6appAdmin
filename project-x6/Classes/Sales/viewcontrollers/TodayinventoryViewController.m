//
//  TodayinventoryViewController.m
//  project-x6
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TodayinventoryViewController.h"
#import "TodayModel.h"
#import "TodayTableViewCell.h"


@interface TodayinventoryViewController ()
{
    UIView *_totalNumberViews;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NoDataView *notodaydataView;


@property(nonatomic,copy)NSArray *datalist;            //获取的数据
@property(nonatomic,copy)NSMutableArray *salesNames;          //货品名称集合
@property(nonatomic,strong)NSMutableArray *SearchNames;         //搜索的货品名称
@property(nonatomic, strong)UISearchController *TodaySearchController;
@end

@implementation TodayinventoryViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        //表示图
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 64 - 40 - 44 - 40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NoDataView *)notodaydataView
{
    if (!_notodaydataView) {
        _notodaydataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 64 - 40 - 44 - 40)];
        _notodaydataView.text = @"没有纪录";
        [self.view addSubview:_notodaydataView];
    }
    return _notodaydataView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_TodaySearchController.searchBar setHidden:NO];
    
    [_TodaySearchController.searchBar setHidden:YES];
    [_TodaySearchController.searchBar resignFirstResponder];
    
    [self initViews];
    //获取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self gettodayData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"今日库存"];
  
}

- (void)dealloc
{
    _TodaySearchController.searchBar.delegate = nil;
    _TodaySearchController.searchResultsUpdater = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
    _TodaySearchController.searchBar.delegate = nil;
    _TodaySearchController.searchResultsUpdater = nil;

}
- (void)initViews
{
    //搜索框
    _TodaySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _TodaySearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _TodaySearchController.searchResultsUpdater = self;
    _TodaySearchController.searchBar.delegate = self;
    _TodaySearchController.dimsBackgroundDuringPresentation = NO;
    self.TodaySearchController.hidesNavigationBarDuringPresentation = NO;
    _TodaySearchController.searchBar.placeholder = @"搜索";
    [_TodaySearchController.searchBar sizeToFit];
    [self.view addSubview:_TodaySearchController.searchBar];
   
    
    //注释
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, 39)];
    view.backgroundColor = GrayColor;
    NSArray *name = @[@"商品名称",@"数量／个",@"成本／元"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(0, 0, KScreenWidth / 2.0, 40);
        } else {
            label.frame = CGRectMake(KScreenWidth / 2.0 + (KScreenWidth / 4.0) * (i - 1), 0, KScreenWidth / 4.0, 39);
        }
        label.text = name[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:15];
        [view addSubview:label];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth - 0, 1)];
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
        label.font = [UIFont boldSystemFontOfSize:17];
        [_totalNumberViews addSubview:label];
    }
    [self.view addSubview:_totalNumberViews];
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.TodaySearchController.active) {
        return _salesNames.count;
    } else {
        return _SearchNames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"todayident";
    TodayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[TodayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];

    }
    
    if (!self.TodaySearchController.active) {
        cell.dic = _datalist[indexPath.row];
    } else {
        NSMutableArray *newdatalist = [NSMutableArray array];
        for (NSString *name in _SearchNames) {
            for (NSDictionary *dic in _datalist) {
                if ([name isEqualToString:[dic valueForKey:@"col1"]]) {
                    [newdatalist addObject:dic];
                }
            }
        }
        cell.dic = newdatalist[indexPath.row];
    }
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = GrayColor;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{

    [self.SearchNames removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.TodaySearchController.searchBar.text];
    self.SearchNames = [[self.salesNames filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in _datalist) {
            for (NSString *name in self.SearchNames) {
                if ([name isEqualToString:[dic valueForKey:@"col1"]]) {
                    [array addObject:dic];
                }
            }
        }
        [self insertLabelWithdatalist:array];
        
    });
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self insertLabelWithdatalist:_datalist];
    
}

#pragma mark - 获取数据
- (void)gettodayData
{
    //获取今天的数据
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *todayURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_today];
    [GiFHUD show];
    [XPHTTPRequestTool requestMothedWithPost:todayURL params:nil success:^(id responseObject) {
        _datalist = [TodayModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_datalist.count == 0) {
                [self notodaydataView];
                if (_tableView) {
                    _tableView.hidden = YES;
                }
            } else {
                [self tableView];
                if (_notodaydataView) {
                    _notodaydataView.hidden = YES;
                }
                // 遍历获取总计的销量和金额
                [self insertLabelWithdatalist:_datalist];
                
                //取出货品名称
                NSMutableArray *nameArray = [NSMutableArray array];
                for ( NSDictionary *dic in _datalist) {
                    [nameArray addObject:[dic valueForKey:@"col1"]];
                }
                _salesNames = [nameArray mutableCopy];
                [_tableView reloadData];
            }

        });
        } failure:^(NSError *error) {
        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
    }];
}

#pragma mark - 总计的数量和金额
- (void)insertLabelWithdatalist:(NSArray *)datalist
{
    UILabel *label = [_totalNumberViews viewWithTag:1001];
    long numbers = 0;
    
    UILabel *label2 = [_totalNumberViews viewWithTag:1002];
    long double prices = 0;
    for (id dic in datalist) {
        if ([dic isKindOfClass:[NSArray class]]) {
            for (NSDictionary *diced in dic) {
                numbers += [[diced valueForKey:@"col2"] intValue];
                prices += [[diced valueForKey:@"col3"] doubleValue];
            }
        } else {
            numbers += [[dic valueForKey:@"col2"] intValue];
            prices += [[dic valueForKey:@"col3"] doubleValue];
        }
    }
    label.text = [NSString stringWithFormat:@"%.0ld",numbers];
    label2.text = [NSString stringWithFormat:@"%.0Lf",prices];
  
}

@end
