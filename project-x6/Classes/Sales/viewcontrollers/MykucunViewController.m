//
//  MykucunViewController.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MykucunViewController.h"

#import "KucunModel.h"
#import "MykucunTableViewCell.h"
#import "MykucunDeatilTableViewCell.h"
@interface MykucunViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>


@property(nonatomic,strong)UITableView *KucunTableview;
@property(nonatomic,strong)NoDataView *NokucunView;  //没有库存
@property(nonatomic,copy)NSMutableArray *Kucundatalist;
@property(nonatomic,copy)NSMutableArray *KucunNames;
@property(nonatomic,strong)NSMutableArray *KucunSearchNames;
@property(nonatomic, strong)UISearchController *KucunSearchController;

@end

@implementation MykucunViewController

- (UITableView *)KucunTableview
{
    if (!_KucunTableview) {
        _KucunTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_KucunSearchController.searchBar setHidden:NO];

    //绘制UI
    [self initKucunUI];
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.KucunSearchController.active) {
        return _KucunSearchNames.count;
    } else {
        return _KucunNames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tableviewdatalist = [NSMutableArray array];
    if (self.KucunSearchController.active && self.KucunSearchController.searchBar.text.length != 0) {
        for (NSString *title in _KucunSearchNames) {
            for (NSMutableDictionary *dic in _Kucundatalist) {
                if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                    [tableviewdatalist addObject:dic];
                }
            }
        }
    } else {
        tableviewdatalist = _Kucundatalist;
    }
    
    if ([[tableviewdatalist[indexPath.row] objectForKey:@"cell"] isEqualToString:@"Maincell"]) {
        static NSString *MyKucunident = @"MyKucunident";
        MykucunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyKucunident];
        if (cell == nil) {
            cell = [[MykucunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyKucunident];
        }
        cell.dic = tableviewdatalist[indexPath.row];
        return cell;
    } else {
        static NSString *MykucunDetailIdent = @"MykucunDetailIdent";
        MykucunDeatilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MykucunDetailIdent];
        if (cell == nil) {
            cell = [[MykucunDeatilTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MykucunDetailIdent];
        }
        cell.dic = tableviewdatalist[indexPath.row];
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_Kucundatalist objectAtIndex:indexPath.item];
    if ([[dic valueForKey:@"cell"] isEqualToString:@"Maincell"]) {
        return 40;
    } else {
        return 85;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath *path = nil;
    if ([[_Kucundatalist[indexPath.row] valueForKey:@"cell"] isEqualToString:@"Maincell"]) {
        path = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
    } else {
        path = indexPath;
    }

    if ([_Kucundatalist[indexPath.row] valueForKey:@"isopen"] == NO) {
        //获取指定单元格数据
        [self getkucunDetailWithPoistion:indexPath];
        
    } else {
        NSMutableDictionary *dic = _Kucundatalist[path.row - 1];
        [dic setObject:@NO forKey:@"isopen"];
        _Kucundatalist[path.row - 1] = dic;
        
        [_Kucundatalist removeObjectAtIndex:path.row];
        
        [_KucunTableview beginUpdates];
        [_KucunTableview deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
        [_KucunTableview endUpdates];
    }
    
    
}

#pragma mark -获取指定单元格的详情数据
- (void)getkucunDetailWithPoistion:(NSIndexPath *)poistion
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_Kucundatalist[poistion.row] objectForKey:@"col0"] forKey:@"spdm"];
    [XPHTTPRequestTool requestMothedWithPost:mykucunDetailURL params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        //制作详情数据
        NSMutableDictionary *kucundetaildic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"",@"",@"",@"",@"",@"",@"", nil];
        
        
        [_KucunTableview beginUpdates];
        [_KucunTableview insertRowsAtIndexPaths:@[poistion] withRowAnimation:UITableViewRowAnimationTop];
        [_KucunTableview endUpdates];
        
    } failure:^(NSError *error) {
        NSLog(@"库存详情获取失败");
    }];
    
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
            
            for (int i = 0; i < _Kucundatalist.count; i++) {
                NSDictionary *dic = _Kucundatalist[i];
                [_KucunNames addObject:[dic valueForKey:@"col1"]];
                NSMutableDictionary *diced = [NSMutableDictionary dictionaryWithDictionary:dic];
                [diced setValue:@NO forKey:@"isopen"];
                [diced setValue:@"Maincell" forKey:@"cell"];
                [_Kucundatalist replaceObjectAtIndex:i withObject:diced];
            }
            
            [_KucunTableview reloadData];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"我的库存请求失败");
    }];
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.KucunSearchNames removeAllObjects];
  
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.KucunSearchController.searchBar.text];
    self.KucunSearchNames = [[self.KucunNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    
    [_KucunTableview reloadData];
 
}



































@end
