//
//  MyKucunViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyKucunViewController.h"
#import "KucunModel.h"
#import "KucunDeatilModel.h"
#import "MykucunDeatilTableViewCell.h"
@interface MyKucunViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>
@property(nonatomic,strong)UITableView *KucunTableview;                 //库存表示图
@property(nonatomic,strong)NoDataView *NokucunView;                     //没有库存


@property(nonatomic,copy)NSMutableArray *Kucundatalist;                 //库存数据
@property(nonatomic,copy)NSMutableDictionary *mykucunDic;             //表示图的数据
@property(nonatomic,copy)NSMutableArray *selectkucunSection;


@property(nonatomic,copy)NSMutableArray *KucunNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *KucunSearchNames;
@property(nonatomic,copy)NSMutableArray *newkucunDatalist;
@property(nonatomic, strong)UISearchController *KucunSearchController;
@end

@implementation MyKucunViewController
- (UITableView *)KucunTableview
{
    if (!_KucunTableview) {
        _KucunTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
        _KucunTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _KucunTableview.delegate = self;
        _KucunTableview.dataSource = self;
        _KucunTableview.hidden = YES;
        [self.view addSubview:_KucunTableview];
    }
    return _KucunTableview;
}

- (NoDataView *)NokucunView
{
    if (!_NokucunView) {
        _NokucunView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44)];
        _NokucunView.text = @"您还没有库存";
        _NokucunView.hidden = YES;
        [self.view addSubview:_NokucunView];
    }
    return _NokucunView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"我的库存"];
    _KucunNames = [NSMutableArray array];
    _KucunSearchNames = [NSMutableArray array];
    
    _selectkucunSection = [NSMutableArray array];
    _mykucunDic = [NSMutableDictionary dictionary];
    
    _newkucunDatalist = [NSMutableArray array];
    _Kucundatalist = [[NSMutableArray alloc] initWithCapacity:0];
    //绘制UI
    [self initKucunUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_KucunSearchController.searchBar setHidden:NO];
    
    
    [self getMykucunData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_KucunSearchController.searchBar setHidden:YES];
    if ([_KucunSearchController.searchBar isFirstResponder]) {
        [_KucunSearchController.searchBar resignFirstResponder];
    }
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.KucunSearchController.active) {
        return _KucunSearchNames.count;
    } else {
        return _Kucundatalist.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectkucunSection containsObject:string]) {
        UIImageView *loadView = (UIImageView *)[_KucunTableview viewWithTag:4100 + section];
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
    return 85;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (self.KucunSearchController.active) {
        view = [self creatTableviewWithMutableArray:_newkucunDatalist Section:section];
    } else {
        view = [self creatTableviewWithMutableArray:[_Kucundatalist mutableCopy] Section:section];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    static NSString *mykucunIndet = @"mykucunIndet";
    MykucunDeatilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mykucunIndet];
    if (cell == nil) {
        cell = [[MykucunDeatilTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mykucunIndet];
    }
    if ([_selectkucunSection containsObject:indexStr]) {
        NSDictionary *mukucundic = [_mykucunDic objectForKey:indexStr];
        cell.dic = mukucundic;
    }
    return cell;
    
}





#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    view.backgroundColor = GrayColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 20)];
    imageView.image = [UIImage imageNamed:@"btn_chanpin_h"];
    [view addSubview:imageView];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, KScreenWidth - 180, 30)];
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 10, 20, 20)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectkucunSection containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_n"];
    } else {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_h"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 40);
    button.tag = 4100 + section;
    [button addTarget:self action:@selector(leadmykucunSectionData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 5, 60, 30)];
    Label.text = [NSString stringWithFormat:@"%@个",[mutableArray[section] valueForKey:@"col2"]];
    [view addSubview:Label];
    
    
    UIView *lowLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, KScreenWidth, 1)];
    lowLineView.backgroundColor = LineColor;
    [view addSubview:lowLineView];
    
    return view;
}

#pragma mark - 标题栏按钮事件
- (void)leadmykucunSectionData:(UIButton *)button
{
    //获取数据
    
    NSString *string = [NSString stringWithFormat:@"%ld",button.tag - 4100];
    NSMutableArray *array;
    if (self.KucunSearchController.active) {
        array = _newkucunDatalist;
    } else {
        array = _Kucundatalist;
    }
    
    if ([_selectkucunSection containsObject:string]) {
        [_selectkucunSection removeObject:string];
        [_mykucunDic removeObjectForKey:string];
        [_KucunTableview reloadData];
        
    } else {
        dispatch_group_t grouped = dispatch_group_create();
        
        [_selectkucunSection addObject:string];
        
        [self getkucunDetailWithArray:array Section:string group:grouped];
        dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
            [_KucunTableview reloadData];
            
        });
        
    }
    
}



#pragma mark - 绘制UI
- (void)initKucunUI
{
    //搜索框
    _KucunSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _KucunSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _KucunSearchController.searchResultsUpdater = self;
    _KucunSearchController.searchBar.delegate = self;
    _KucunSearchController.dimsBackgroundDuringPresentation = NO;
    _KucunSearchController.hidesNavigationBarDuringPresentation = NO;
    _KucunSearchController.searchBar.placeholder = @"搜索";
    [_KucunSearchController.searchBar sizeToFit];
    [self.view addSubview:_KucunSearchController.searchBar];
    
    [self NokucunView];
    
    [self KucunTableview];
}

#pragma mark - 获取数据
- (void)getMykucunData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucun];
    [XPHTTPRequestTool requestMothedWithPost:mykucunURL params:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _Kucundatalist = [KucunModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_Kucundatalist.count == 0) {
            _KucunTableview.hidden = YES;
            _NokucunView.hidden = NO;
        } else {
            _NokucunView.hidden = YES;
            _KucunTableview.hidden = NO;
            
            [_KucunTableview reloadData];

           dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSDictionary *dic in _Kucundatalist) {
                [_KucunNames addObject:[dic valueForKey:@"col1"]];
                
            }
        });

        }
        
    } failure:^(NSError *error) {
        NSLog(@"我的库存请求失败");
    }];
    
}

- (void)getkucunDetailWithArray:(NSMutableArray *)array
                       Section:(NSString *)section
                         group:(dispatch_group_t)group
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSNumber *spdm = [[array objectAtIndex:[section longLongValue]] valueForKey:@"col0"];
    [params setObject:spdm forKey:@"spdm"];
    dispatch_group_enter(group);

    [XPHTTPRequestTool requestMothedWithPost:mykucunDetailURL params:params success:^(id responseObject) {
        NSLog(@"我的");
        NSMutableDictionary *kucundetailDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"vo"]];
        NSNumber *jine = [[array objectAtIndex:[section longLongValue]] valueForKey:@"col3"];
        NSNumber *numb = [[array objectAtIndex:[section longLongValue]] valueForKey:@"col2"];
        long long junjia = [jine longLongValue] / [numb longLongValue];
        
        [kucundetailDic setObject:@(junjia) forKey:@"zongjunjia"];
        [kucundetailDic setObject:jine forKey:@"zongjine"];
        [_mykucunDic setObject:kucundetailDic forKey:section];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        NSLog(@"行的");
        dispatch_group_leave(group);

    }];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.KucunSearchNames removeAllObjects];
    [self.mykucunDic removeAllObjects];
    [self.selectkucunSection removeAllObjects];
    
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.KucunSearchController.searchBar.text];
    self.KucunSearchNames = [[self.KucunNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    for (NSString *title in self.KucunSearchNames) {
        for (NSDictionary *dic in self.Kucundatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [_newkucunDatalist addObject:dic];
            }
        }
    }
    
    [_KucunTableview reloadData];
    
}

@end
