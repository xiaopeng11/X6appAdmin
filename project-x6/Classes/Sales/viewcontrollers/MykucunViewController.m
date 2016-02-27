//
//  MykucunViewController.m
//  project-x6
//
//  Created by Apple on 16/2/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MykucunViewController.h"

#import "KucunModel.h"
#import "KucunDeatilModel.h"
#import "MykucunTableViewCell.h"
#import "MykucunDeatilTableViewCell.h"
@interface MykucunViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>


@property(nonatomic,strong)UITableView *KucunTableview;                 //库存表示图
@property(nonatomic,strong)NoDataView *NokucunView;                     //没有库存
@property(nonatomic,copy)NSMutableArray *Kucundatalist;                 //库存数据
@property(nonatomic,copy)NSMutableArray *TableviewDatalist;             //表示图的数据

@property(nonatomic,copy)NSMutableArray *KucunNames;                    //数据名的集合
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
    _TableviewDatalist = [NSMutableArray array];
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
        return _Kucundatalist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tableDatalist = [NSMutableArray array];
    if (self.KucunSearchController.active && _TableviewDatalist == nil) {
        for (NSString *title in _KucunSearchNames) {
            for (NSDictionary *dic in _Kucundatalist) {
                if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                    [tableDatalist addObject:dic];
                }
            }
        }
        _TableviewDatalist = tableDatalist;
    } else {
        tableDatalist = _Kucundatalist;
        
    }
    
    if ([[tableDatalist[indexPath.row] objectForKey:@"cell"] isEqualToString:@"Maincell"]) {
        static NSString *MyKucunident = @"MyKucunident";
        MykucunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyKucunident];
        if (cell == nil) {
            cell = [[MykucunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyKucunident];
        }
        cell.dic = tableDatalist[indexPath.row];
        return cell;
    } else {
        static NSString *MykucunDetailIdent = @"MykucunDetailIdent";
        MykucunDeatilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MykucunDetailIdent];
        if (cell == nil) {
            cell = [[MykucunDeatilTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MykucunDetailIdent];
        }
        cell.dic = tableDatalist[indexPath.row];
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [NSDictionary dictionary];
    if (_TableviewDatalist.count != 0) {
        dic = [_TableviewDatalist objectAtIndex:indexPath.row];
    } else {
        dic = [_Kucundatalist objectAtIndex:indexPath.row];
    }
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
    
    if (_TableviewDatalist.count != 0) {
        if ([[_TableviewDatalist[indexPath.row] valueForKey:@"cell"] isEqualToString:@"Maincell"]) {
            path = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
            
        } else {
            path = indexPath;
        }
        
        
        if ([[_TableviewDatalist[indexPath.row] valueForKey:@"isopen"] boolValue] == NO) {
            //获取指定单元格数据
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getkucunDetailWithPoistion:path Datalist:_TableviewDatalist];
            });
            
        } else {
            NSMutableDictionary *dic = _Kucundatalist[path.row - 1];
            [dic setObject:@NO forKey:@"isopen"];
            _TableviewDatalist[path.row - 1] = dic;
            
            [_TableviewDatalist removeObjectAtIndex:path.row];
            [_KucunSearchNames removeLastObject];
            [_KucunTableview beginUpdates];
            [_KucunTableview deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
            [_KucunTableview endUpdates];
        }
    } else {
        if ([[_Kucundatalist[indexPath.row] valueForKey:@"cell"] isEqualToString:@"Maincell"]) {
            path = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
        } else {
            path = indexPath;
        }
        
        
        if ([[_Kucundatalist[indexPath.row] valueForKey:@"isopen"] boolValue] == NO) {
            //获取指定单元格数据
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getkucunDetailWithPoistion:path Datalist:_Kucundatalist];
            });
            
        } else {
            NSMutableDictionary *dic = _Kucundatalist[path.row - 1];
            [dic setObject:@NO forKey:@"isopen"];
            _Kucundatalist[path.row - 1] = dic;
            
            [_Kucundatalist removeObjectAtIndex:path.row];
            [_KucunSearchNames removeLastObject];
            
            NSIndexPath *positioned = [NSIndexPath indexPathForRow:(path.row -1) inSection:0];
            MykucunTableViewCell *cell = (MykucunTableViewCell *)[_KucunTableview cellForRowAtIndexPath:positioned];
            cell.leadView.image = [UIImage imageNamed:@"btn_jiantou_h"];
            
            [_KucunTableview beginUpdates];
            [_KucunTableview deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
            [_KucunTableview endUpdates];
        }
    }
   
  
}

#pragma mark -获取指定单元格的详情数据
- (void)getkucunDetailWithPoistion:(NSIndexPath *)poistion Datalist:(NSMutableArray *)datalist
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *mykucunDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_mykucunDetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[datalist[poistion.row] objectForKey:@"col0"] forKey:@"spdm"];
    [XPHTTPRequestTool requestMothedWithPost:mykucunDetailURL params:params success:^(id responseObject) {
        //更新主单元格数据
        NSMutableDictionary *kucundic = [NSMutableDictionary dictionaryWithDictionary:datalist[poistion.row - 1]];
        [kucundic setObject:@YES forKey:@"isopen"];
        datalist[poistion.row - 1] = kucundic;
        //制作详情数据
        NSMutableDictionary *kucundetaildic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"vo"]];
        [kucundetaildic setObject:@YES forKey:@"isopen"];
        //将主单元格中的均价和金额设置到详情单元格中
        NSNumber *jine = [kucundic valueForKey:@"col3"];
        NSNumber *numb = [kucundic valueForKey:@"col2"];
        long junjia = [jine longLongValue] / [numb longLongValue];
        
        [kucundetaildic setObject:@(junjia) forKey:@"zongjunjia"];
        [kucundetaildic setObject:jine forKey:@"zongjine"];
        [kucundetaildic setObject:@"attavcell" forKey:@"cell"];
        [datalist insertObject:kucundetaildic atIndex:poistion.row];
        
        [_KucunSearchNames addObject:@""];

        NSIndexPath *positioned = [NSIndexPath indexPathForRow:(poistion.row -1) inSection:0];
        MykucunTableViewCell *cell = (MykucunTableViewCell *)[_KucunTableview cellForRowAtIndexPath:positioned];
        cell.leadView.image = [UIImage imageNamed:@"btn_jiantou_n"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_KucunTableview beginUpdates];
            [_KucunTableview insertRowsAtIndexPaths:@[poistion] withRowAnimation:UITableViewRowAnimationTop];
            [_KucunTableview endUpdates];
        });
       
        
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
    
    for (int i = 0; i < _Kucundatalist.count; i++) {
        NSMutableDictionary *dic = _Kucundatalist[i];
        if ([[dic valueForKey:@"cell"] isEqualToString:@"attavcell"]) {
            [_Kucundatalist removeObject:dic];
            NSMutableDictionary *diclast = _Kucundatalist[i - 1];
            [diclast setObject:@NO forKey:@"isopen"];
            [_Kucundatalist replaceObjectAtIndex:(i - 1) withObject:diclast];
        }
    }

    [_KucunTableview reloadData];
 
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_TableviewDatalist removeAllObjects];
}
































@end
