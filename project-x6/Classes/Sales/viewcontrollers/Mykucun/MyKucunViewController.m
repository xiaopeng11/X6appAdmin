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
@property(nonatomic,strong)UIView *MykucuntotalView;


@property(nonatomic,copy)NSMutableArray *Kucundatalist;                 //库存数据
@property(nonatomic,copy)NSMutableDictionary *mykucunDic;             //表示图的数据
@property(nonatomic,copy)NSMutableArray *selectkucunSection;


@property(nonatomic,copy)NSMutableArray *KucunNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *KucunSearchNames;
@property(nonatomic,copy)NSMutableArray *newkucunDatalist;
@property(nonatomic, strong)UISearchController *KucunSearchController;

@end

@implementation MyKucunViewController

- (void)dealloc
{
    _Kucundatalist = nil;
    _mykucunDic = nil;
    _selectkucunSection = nil;
    _KucunNames = nil;
    _KucunSearchNames = nil;
    _newkucunDatalist = nil;
    
}


- (UITableView *)KucunTableview
{
    if (!_KucunTableview) {
        _KucunTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44 - 40) style:UITableViewStylePlain];
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


- (UIView *)MykucuntotalView
{
    if (_MykucuntotalView == nil) {
        _MykucuntotalView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, 40)];
        _MykucuntotalView.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.2];
        [self.view addSubview:_MykucuntotalView];
        
        long long totalNum = 0,totalMoney = 0;
        for (NSDictionary *dic in _Kucundatalist) {
            totalNum += [[dic valueForKey:@"col2"] longLongValue];
            totalMoney += [[dic valueForKey:@"col3"] longLongValue];
        }
        for (int i = 0; i < 5; i++) {
            UILabel *Label = [[UILabel alloc] init];
            Label.font = [UIFont systemFontOfSize:13];
            if (i == 0) {
                Label.frame = CGRectMake(10, 0, 30, 40);
                Label.text = @"合计:";
            } else if (i == 1) {
                Label.frame = CGRectMake(40, 0, 30, 40);
                Label.text = @"数量:";
            } else if (i == 2) {
                Label.frame = CGRectMake(70, 0, (KScreenWidth - 110) / 2.0, 40);
                Label.text = [NSString stringWithFormat:@"%lld个",totalNum];
            } else if (i == 3) {
                Label.text = @"金额:";
                Label.frame = CGRectMake(70 + ((KScreenWidth - 110) / 2.0), 0, 30, 40);
            } else {
                Label.frame = CGRectMake(100 + ((KScreenWidth - 110) / 2.0), 0, (KScreenWidth - 110) / 2.0, 40);
                Label.text = [NSString stringWithFormat:@"￥%lld",totalMoney];
                Label.textColor = [UIColor redColor];
            }
            [_MykucuntotalView addSubview:Label];
        }
    }
    return _MykucuntotalView;
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
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
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
    [_KucunSearchController setActive:NO];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.KucunSearchController.active) {
        return _newkucunDatalist.count;
    } else {
        return _Kucundatalist.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([_selectkucunSection containsObject:string]) {
        UIImageView *loadView = (UIImageView *)[_KucunTableview.tableHeaderView viewWithTag:4180 + section];
        loadView.image =[UIImage imageNamed:@"btn_jiantou_n"];
        return 1;
    } else {
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSMutableDictionary *dic = [_mykucunDic objectForKey:indexStr];
    CGFloat height = [[dic valueForKey:@"rowheight"] floatValue];
    return height;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark - 标题视图
- (UIView *)creatTableviewWithMutableArray:(NSMutableArray *)mutableArray Section:(long)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    view.backgroundColor = GrayColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 30, 20)];
    imageView.image = [UIImage imageNamed:@"btn_chanpin_h"];
    [view addSubview:imageView];
    
    UILabel *companyTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, KScreenWidth - 180, 30)];
    companyTitle.text = [mutableArray[section] valueForKey:@"col1"];
    [view addSubview:companyTitle];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 30, 20, 20, 20)];
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    selectView.tag = 4180 + section;
    if ([_selectkucunSection containsObject:string]) {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_n"];
    } else {
        selectView.image = [UIImage imageNamed:@"btn_jiantou_h"];
    }
    [view addSubview:selectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, KScreenWidth, 60);
    button.tag = 4100 + section;
    [button addTarget:self action:@selector(leadmykucunSectionData:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, 15, 60, 30)];
    Label.text = [NSString stringWithFormat:@"%@个",[mutableArray[section] valueForKey:@"col2"]];
    [view addSubview:Label];
    
    
    UIView *lowLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, KScreenWidth, 1)];
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
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
        for (NSDictionary *dic in qxList) {
            if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_mykc"]) {
                if ([[dic valueForKey:@"pcb"] integerValue] == 0) {
                    [self getkucunDetailWithArray:array Section:string group:grouped];
                } else {
                    [self writeWithName:@"您没有查看我的库存详情的权限"];
                }
            }
        }
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
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:mykucunURL params:nil success:^(id responseObject) {
        [self hideProgress];
        _Kucundatalist = [KucunModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_Kucundatalist.count == 0) {
            _KucunTableview.hidden = YES;
            _MykucuntotalView.hidden = YES;
            _NokucunView.hidden = NO;
        } else {
            _NokucunView.hidden = YES;
            _KucunTableview.hidden = NO;
            [self MykucuntotalView];
            _MykucuntotalView.hidden = NO;
            NSArray *sortkucunArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
            [_Kucundatalist sortUsingDescriptors:sortkucunArray];
            
            [_KucunTableview reloadData];

           dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSDictionary *dic in _Kucundatalist) {
                [_KucunNames addObject:[dic valueForKey:@"col1"]];
                
            }
        });

        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
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
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:mykucunDetailURL params:params success:^(id responseObject) {
        NSLog(@"我的");
        [self hideProgress];
        NSMutableDictionary *kucundetailDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"vo"]];
        NSNumber *jine = [[array objectAtIndex:[section longLongValue]] valueForKey:@"col3"];
        NSNumber *numb = [[array objectAtIndex:[section longLongValue]] valueForKey:@"col2"];
        long long junjia = [jine longLongValue] / [numb longLongValue];
        
        [kucundetailDic setObject:@(junjia) forKey:@"zongjunjia"];
        [kucundetailDic setObject:jine forKey:@"zongjine"];
        
        //增加高度参数
        CGFloat rowhight;
        if ([[kucundetailDic valueForKey:@"zgsl"] integerValue] == 0 && [[kucundetailDic valueForKey:@"zdsl"] integerValue] == 0) {
            rowhight = 30;
        } else {
            rowhight = 85;
        }
        [kucundetailDic setObject:@(rowhight) forKey:@"rowheight"];
        
        [_mykucunDic setObject:kucundetailDic forKey:section];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        NSLog(@"行的");
        [self hideProgress];
        dispatch_group_leave(group);

    }];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.KucunSearchNames removeAllObjects];
    [self.mykucunDic removeAllObjects];
    [self.selectkucunSection removeAllObjects];
    [self.newkucunDatalist removeAllObjects];
    
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
