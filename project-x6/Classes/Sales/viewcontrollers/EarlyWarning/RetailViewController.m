//
//  RetailViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RetailViewController.h"

#import "RetailModel.h"
#import "RetailTableViewCell.h"

@interface RetailViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    UITableView *_RetailTabelView;
    NoDataView *_noRetailView;
    
    
    NSMutableArray *_ReatilDatalist;
    
    
}

@property(nonatomic,copy)NSMutableArray *ReatilNames;                    //数据名的集合
@property(nonatomic,strong)NSMutableArray *ReatilSearchNames;
@property(nonatomic,copy)NSMutableArray *NewReatilDatalist;
@property(nonatomic, strong)UISearchController *ReatilSearchController;

@end

@implementation RetailViewController

- (void)dealloc
{
    _ReatilNames = nil;
    _ReatilSearchNames = nil;
    _NewReatilDatalist = nil;
    _ReatilDatalist = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"零售异常"];
    

    
    _ReatilNames = [NSMutableArray array];
    _ReatilSearchNames = [NSMutableArray array];
    _NewReatilDatalist = [NSMutableArray array];
    
    
    [self initRetailUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_ReatilSearchController.searchBar setHidden:NO];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    for (NSDictionary *dic in qxList) {
        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]) {
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                //获取数据
                [self getRetailDatalist];
            } else {
                [self writeWithName:@"您没有查看零售异常详情的权限"];
            }
        }
    }
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self cleanRetailWarningNumber];
    });
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_ReatilSearchController.searchBar setHidden:YES];
    [_ReatilSearchController setActive:NO];
    
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.ReatilSearchController.active) {
        return _NewReatilDatalist.count;
    } else {
        return _ReatilDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height;
    if (self.ReatilSearchController.active) {
        height = [[_NewReatilDatalist[indexPath.row] valueForKey:@"frame"] floatValue];
    } else {
        height = [[_ReatilDatalist[indexPath.row] valueForKey:@"frame"] floatValue];
    }
    return height;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Reatilident = @"Reatilident";
    RetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Reatilident];
    if (cell == nil) {
        cell = [[RetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Reatilident];
    }
    if (self.ReatilSearchController.active) {
        cell.dic = _NewReatilDatalist[indexPath.row];
    } else {
        cell.dic = _ReatilDatalist[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewRowAction *ignore = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"忽略" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSMutableArray *array = [NSMutableArray array];
            if (_ReatilSearchController.active) {
                array = _NewReatilDatalist;
            } else {
                array = _ReatilDatalist;
            }
            NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
            NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
            NSString *ignoreURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_ignore];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];

            NSNumber *djid = [array[indexPath.row] valueForKey:@"col0"];
            NSNumber *djh = [array[indexPath.row] valueForKey:@"col1"];
            [params setObject:djid forKey:@"djid"];
            [params setObject:djh forKey:@"djh"];
            [params setObject:@"LSYC" forKey:@"txlx"];
            [XPHTTPRequestTool requestMothedWithPost:ignoreURL params:params success:^(id responseObject) {
                NSLog(@"零售异常忽略成功");
            } failure:^(NSError *error) {
                NSLog(@"零售异常忽略失败");
            }];
            if (_ReatilSearchController.active) {
                [_NewReatilDatalist removeObjectAtIndex:indexPath.row];
            } else {
                [_ReatilDatalist removeObjectAtIndex:indexPath.row];
            }
            [_RetailTabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }];

    return @[ignore];
}

#pragma mark - initRetailUI
- (void)initRetailUI
{
    //搜索框
    _ReatilSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _ReatilSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _ReatilSearchController.searchResultsUpdater = self;
    _ReatilSearchController.searchBar.delegate = self;
    _ReatilSearchController.dimsBackgroundDuringPresentation = NO;
    _ReatilSearchController.hidesNavigationBarDuringPresentation = NO;
    _ReatilSearchController.searchBar.placeholder = @"搜索";
    [_ReatilSearchController.searchBar sizeToFit];
    _ReatilSearchController.searchBar.hidden = YES;
    [self.view addSubview:_ReatilSearchController.searchBar];
    
    
    _RetailTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
    _RetailTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _RetailTabelView.delegate = self;
    _RetailTabelView.dataSource = self;
    _RetailTabelView.hidden = YES;
    _RetailTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_RetailTabelView];
    
    _noRetailView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _noRetailView.text = @"当前月份无零售异常";
    _noRetailView.hidden = YES;
    [self.view addSubview:_noRetailView];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.ReatilSearchNames removeAllObjects];
    [self.NewReatilDatalist removeAllObjects];
    NSPredicate *ReatilPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.ReatilSearchController.searchBar.text];
    self.ReatilSearchNames = [[self.ReatilNames filteredArrayUsingPredicate:ReatilPredicate] mutableCopy];
    
    for (NSString *title in self.ReatilSearchNames) {
        for (NSDictionary *dic in _ReatilDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]] || [title isEqualToString:[dic valueForKey:@"col3"]] || [title isEqualToString:[dic valueForKey:@"col4"]]) {
                [_NewReatilDatalist addObject:dic];
            }
        }
    }
    [_RetailTabelView reloadData];
    
}


#pragma mark - 获取数据
/**
 *  获取零售异常数据
 *
 *  @param year  年
 *  @param month 月
 */
- (void)getRetailDatalist
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *RetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Retail];

    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:RetailURL params:nil success:^(id responseObject) {
        [self hideProgress];
        _ReatilDatalist = [RetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        
        if (_ReatilDatalist.count == 0) {
            _RetailTabelView.hidden = YES;
            _ReatilSearchController.searchBar.hidden = YES;
            _noRetailView.hidden = NO;
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _ReatilDatalist) {
                if ([[dic valueForKey:@"col10"] boolValue] == 1) {
                    [array addObject:dic];
                }
            }
            [_ReatilDatalist removeObjectsInArray:array];
            
            _noRetailView.hidden = YES;
            _RetailTabelView.hidden = NO;
            _ReatilSearchController.searchBar.hidden = NO;
            NSArray *ReatilArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
            [_ReatilDatalist sortUsingDescriptors:ReatilArray];
            
            _ReatilDatalist = [self loadframeKeyWithDatalist:_ReatilDatalist];
            
            [_RetailTabelView reloadData];
            
            for (NSDictionary *dic in _ReatilDatalist) {
                [_ReatilNames addObject:[dic valueForKey:@"col1"]];
                [_ReatilNames addObject:[dic valueForKey:@"col3"]];
                [_ReatilNames addObject:[dic valueForKey:@"col4"]];

            }
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"获取零售异常失败");
    }];
}

/**
 *  清除采购异常条数
 */
- (void)cleanRetailWarningNumber
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *removeWarningNumberURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_removeWarningNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"LSYC" forKey:@"txlx"];
    [XPHTTPRequestTool requestMothedWithPost:removeWarningNumberURL params:params success:^(id responseObject) {
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}


- (NSMutableArray *)loadframeKeyWithDatalist:(NSMutableArray *)datalist
{
    NSMutableArray *array = [NSMutableArray array];
    //计算动态高度
    //计算文本高度
    for (NSDictionary *dic in datalist) {
        float height = 40 + 40 + 10;
        
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect rect = [[dic valueForKey:@"col6"] boundingRectWithSize:CGSizeMake(KScreenWidth - 120, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        
        if (rect.size.height > 20) {
            height += 40 + 20 * 4 + 10;
        } else {
            height += 20 * 5 + 10;
        }
        data[@"frame"] = @(height);
        [array addObject:data];

    }
    return array;
}

@end
