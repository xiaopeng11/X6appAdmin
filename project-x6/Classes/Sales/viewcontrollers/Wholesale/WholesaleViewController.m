//
//  WholesaleViewController.m
//  project-x6
//
//  Created by Apple on 16/5/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "WholesaleViewController.h"

#import "XPDatePicker.h"

#import "WholesaleModel.h"
#import "WholesaleotherModel.h"

#import "WholesaleTableViewCell.h"

#define todaywidth ((KScreenWidth - 135) / 5.0)

@interface WholesaleViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>

{
    NSMutableArray *_WholesaleDatalist;
    
    NSString *_dateString;        //当前的时间
    NSString *_firstDayString;    //当前月份的第一天
    
    XPDatePicker *_FirstDatePicker;      //第一个textfield
    XPDatePicker *_SecondDatePicker;     //第二个textfield
}

@property(nonatomic,strong)NoDataView *NoWholesaleView;                         //批发战报数据为空
@property(nonatomic,strong)UITableView *WholesaleTableView;                     //批发战报
@property(nonatomic,strong)UIView *totalWholesaleView;                          //统计

//搜索
@property(nonatomic,copy)NSMutableArray *WholesalePersonNames;                  //批发人员集合
@property(nonatomic,strong)NSMutableArray *WholesalePersonSearchNames;          //批发人员搜索集合
@property(nonatomic,strong)UISearchController *WholesalePersonSearchController; //搜索
@property(nonatomic,copy)NSMutableArray *NewWholesaleDatlist;                   //搜索后的数据

@end

@implementation WholesaleViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _WholesalePersonNames = nil;
    _WholesalePersonSearchNames = nil;
    _NewWholesaleDatlist = nil;
    _WholesaleDatalist = nil;
}


- (UIView *)totalWholesaleView
{
    if (!_totalWholesaleView) {
        _totalWholesaleView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 104, KScreenWidth, 40)];
        _totalWholesaleView.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.2];
        [self.view addSubview:_totalWholesaleView];
        
        for (int i = 0; i < 7; i++)
        {
            UILabel *Label = [[UILabel alloc] init];
            Label.font = [UIFont systemFontOfSize:13];
            if (i == 0) {
                Label.text = @"合计:";
                Label.frame = CGRectMake(10, 0, 30, 40);
            } else if (i == 1) {
                Label.frame = CGRectMake(40, 0, 30, 40);
                Label.text = @"数量:";
            } else if (i == 2) {
                Label.frame = CGRectMake(70, 0, todaywidth, 40);
            } else if (i == 3) {
                Label.frame = CGRectMake(70 + todaywidth, 0, 30, 40);
                Label.text = @"金额:";
            } else if (i == 4) {
                Label.frame = CGRectMake(100 + todaywidth , 0, todaywidth * 2, 40);
                Label.textColor = [UIColor redColor];
            } else if (i == 5) {
                Label.frame = CGRectMake(100 + todaywidth * 3, 0, 30, 40);
                Label.text = @"毛利:";
            } else if (i == 6) {
                Label.frame = CGRectMake(130 + todaywidth * 3, 0, todaywidth * 2, 40);
                Label.textColor = Mycolor;
            }
            Label.tag = 49010 + i;
            [_totalWholesaleView addSubview:Label];
        }
        
        
    }
    return _totalWholesaleView;
}


- (UITableView *)WholesaleTableView
{
    if (!_WholesaleTableView) {
        _WholesaleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 40, KScreenWidth, KScreenHeight - 64 - 84 - 40) style:UITableViewStylePlain];
        _WholesaleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _WholesaleTableView.allowsSelection = NO;
        _WholesaleTableView.hidden = YES;
        _WholesaleTableView.delegate = self;
        _WholesaleTableView.dataSource = self;
        [self.view addSubview:_WholesaleTableView];
    }
    return _WholesaleTableView;
}

- (NoDataView *)NoWholesaleView
{
    if (!_NoWholesaleView) {
        _NoWholesaleView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 84, KScreenWidth, KScreenHeight - 64 - 84 - 40)];
        _NoWholesaleView.text = @"该时间段内没有数据";
        _NoWholesaleView.hidden = YES;
        [self.view addSubview:_NoWholesaleView];
    }
    return _NoWholesaleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.Viewtitle isEqualToString:X6_WholesaleUnits]) {
        [self naviTitleWhiteColorWithText:@"批发战报"];
    } else if ([self.Viewtitle isEqualToString:X6_WholesaleSales]) {
        [self naviTitleWhiteColorWithText:@"批发销量"];
    } else if ([self.Viewtitle isEqualToString:X6_WholesaleSummary]) {
        [self naviTitleWhiteColorWithText:@"批发汇总"];
    }
    
    //获取当前的年月
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    //当前月份的第一天
    NSMutableString *monthFirstString = [NSMutableString stringWithString:_dateString];
    [monthFirstString replaceCharactersInRange:NSMakeRange(_dateString.length - 2, 2) withString:@"01"];
    _firstDayString = [monthFirstString mutableCopy];
    
    _WholesalePersonNames = [NSMutableArray array];
    _WholesalePersonSearchNames = [NSMutableArray array];
    _NewWholesaleDatlist = [NSMutableArray array];
    
    //搜索框
    _WholesalePersonSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _WholesalePersonSearchController.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _WholesalePersonSearchController.searchResultsUpdater = self;
    _WholesalePersonSearchController.searchBar.delegate = self;
    _WholesalePersonSearchController.dimsBackgroundDuringPresentation = NO;
    _WholesalePersonSearchController.hidesNavigationBarDuringPresentation = NO;
    _WholesalePersonSearchController.searchBar.placeholder = @"搜索";
    [_WholesalePersonSearchController.searchBar sizeToFit];
    [self.view addSubview:_WholesalePersonSearchController.searchBar];

    [self intWholesaleUI];
    
    //获取当前月份的所有数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getWholesaleDatalistWithFirstDay:_firstDayString LastDay:_dateString Source:self.Viewtitle];
        
    });
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



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    _WholesalePersonSearchController.searchBar.hidden = YES;
    
    [_WholesalePersonSearchController setActive:NO];
    

    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_FirstDatePicker.datePicker != nil || _SecondDatePicker.datePicker != nil) {
        [_FirstDatePicker.datePicker removeFromSuperview];
        [_SecondDatePicker.datePicker removeFromSuperview];
        [_FirstDatePicker.subView removeFromSuperview];
        [_SecondDatePicker.subView removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_WholesalePersonSearchController.searchBar setHidden:NO];
    //搜索框
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_WholesalePersonSearchController.active) {
        return _NewWholesaleDatlist.count;
    } else {
        return _WholesaleDatalist.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *todaySalesIndet = @"todaySalesIndet";
    WholesaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:todaySalesIndet];
    if (cell == nil) {
        cell = [[WholesaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todaySalesIndet];
    }
    if (_WholesalePersonSearchController.active) {
        cell.dic = _NewWholesaleDatlist[indexPath.row];
    } else {
        cell.dic = _WholesaleDatalist[indexPath.row];
    }
    cell.soucre = self.Viewtitle;
    return cell;
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.WholesalePersonSearchNames removeAllObjects];
    [self.NewWholesaleDatlist removeAllObjects];
    NSPredicate *kucunPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.WholesalePersonSearchController.searchBar.text];
    self.WholesalePersonSearchNames = [[self.WholesalePersonNames filteredArrayUsingPredicate:kucunPredicate] mutableCopy];
    
    NSMutableSet *set = [NSMutableSet set];
    for (NSString *title in self.WholesalePersonSearchNames) {
        for (NSDictionary *dic in _WholesaleDatalist) {
            if ([title isEqualToString:[dic valueForKey:@"col1"]]) {
                [set addObject:dic];
            }
        }
    }
    _NewWholesaleDatlist = [[set allObjects] mutableCopy];
    [_WholesaleTableView reloadData];
    
    if (_NewWholesaleDatlist.count != 0) {
        float totalNum = 0,totalMoney = 0,totalProfit = 0;
        for (NSDictionary *dic in _NewWholesaleDatlist) {
            if ([_Viewtitle isEqualToString:X6_WholesaleUnits]) {
                totalNum += [[dic valueForKey:@"col3"] longLongValue];
                totalMoney += [[dic valueForKey:@"col4"] longLongValue];
                totalProfit += [[dic valueForKey:@"col5"] longLongValue];
            } else {
                totalNum += [[dic valueForKey:@"col2"] longLongValue];
                totalMoney += [[dic valueForKey:@"col3"] longLongValue];
                totalProfit += [[dic valueForKey:@"col4"] longLongValue];
            }
            
        }
        
        UILabel *numlabel = (UILabel *)[_totalWholesaleView viewWithTag:49012];
        UILabel *jinelabel = (UILabel *)[_totalWholesaleView viewWithTag:49014];
        UILabel *maolilabel = (UILabel *)[_totalWholesaleView viewWithTag:49016];
        numlabel.text = [NSString stringWithFormat:@"%.0f个",totalNum];
        jinelabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
        
        if (![maolilabel.text isEqualToString:@"￥****"]) {
            maolilabel.text = [NSString stringWithFormat:@"￥%.2f",totalProfit];
        }
    
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    float totalNum = 0,totalMoney = 0,totalProfit = 0;
    for (NSDictionary *dic in _WholesaleDatalist) {
        if ([_Viewtitle isEqualToString:X6_WholesaleUnits]) {
            totalNum += [[dic valueForKey:@"col3"] longLongValue];
            totalMoney += [[dic valueForKey:@"col4"] longLongValue];
            totalProfit += [[dic valueForKey:@"col5"] longLongValue];
        } else {
            totalNum += [[dic valueForKey:@"col2"] longLongValue];
            totalMoney += [[dic valueForKey:@"col3"] longLongValue];
            totalProfit += [[dic valueForKey:@"col4"] longLongValue];
        }
        
    }
    
    UILabel *numlabel = (UILabel *)[_totalWholesaleView viewWithTag:49012];
    UILabel *jinelabel = (UILabel *)[_totalWholesaleView viewWithTag:49014];
    UILabel *maolilabel = (UILabel *)[_totalWholesaleView viewWithTag:49016];
    numlabel.text = [NSString stringWithFormat:@"%.0f个",totalNum];
    jinelabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    
    if (![maolilabel.text isEqualToString:@"￥****"]) {
        maolilabel.text = [NSString stringWithFormat:@"￥%.2f",totalProfit];
    }
}

#pragma mark - 绘制ui
- (void)intWholesaleUI
{
    //日期查询
    //按日期查询
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.2];
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 30)];
    dateLabel.text = @"日期:";
    dateLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:dateLabel];
    
    _FirstDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(50, 5, 80, 30) Date:_firstDayString];
    _FirstDatePicker.delegate = self;
    _FirstDatePicker.textColor = [UIColor blackColor];
    _FirstDatePicker.labelString = @"  起始日期:";
    [headerView addSubview:_FirstDatePicker];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(140, 19.5, 20, 1)];
    lineView.backgroundColor = LineColor;
    [headerView addSubview:lineView];
    
    _SecondDatePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(170, 5, 80, 30) Date:_dateString];
    _SecondDatePicker.delegate = self;
    _SecondDatePicker.textColor = [UIColor blackColor];
    _SecondDatePicker.labelString = @"  结束日期:";
    [headerView addSubview:_SecondDatePicker];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(KScreenWidth - 60 - 10, 5, 60, 30);
    button.backgroundColor = Mycolor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"查询" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(WholesaleAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    [self NoWholesaleView];
    [self WholesaleTableView];
    
    //统计UI
    [self totalWholesaleView];
    
}

#pragma makr - 获取数据
- (void)getWholesaleDatalistWithFirstDay:(NSString *)firstDay
                                 LastDay:(NSString *)lastDay
                                  Source:(NSString *)source
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *userURL = [userdefaults objectForKey:X6_UseUrl];
    NSString *WholesaleURL = [NSString stringWithFormat:@"%@%@",userURL,source];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:firstDay forKey:@"fsrqq"];
    [params setObject:lastDay forKey:@"fsrqz"];
    [self showProgress];
    [XPHTTPRequestTool requestMothedWithPost:WholesaleURL params:params success:^(id responseObject) {
        [self hideProgress];
        if ([responseObject[@"message"] isEqualToString:@"ok"]) {
            NSMutableArray *datalist = nil;
            datalist = responseObject[@"rows"];
            if (datalist.count == 0) {
                _WholesaleTableView.hidden = YES;
                _NoWholesaleView.hidden = NO;
            } else {
                if ([source isEqualToString:X6_WholesaleUnits]) {
                    _WholesaleDatalist = [WholesaleModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
                } else {
                    _WholesaleDatalist = [WholesaleotherModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
                }
                
                NSArray *sortwholesalesArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
                [_WholesaleDatalist sortUsingDescriptors:sortwholesalesArray];
                
                NSString *signStringone = [self.Viewtitle substringWithRange:NSMakeRange(self.Viewtitle.length - 11, 4)];
                NSString *signString = [NSString stringWithFormat:@"bb_%@",signStringone];
                
                if ([signString isEqualToString:@"bb_pfzb"]) {
                    [self passwordTodayDatalistWithDataList:_WholesaleDatalist Key:@"col5" Jmdx:signString];
                } else {
                    [self passwordTodayDatalistWithDataList:_WholesaleDatalist Key:@"col4" Jmdx:signString];
                }
                
                [self totalWholesaleView];
                
                
                float totalNum = 0,totalMoney = 0,totalProfit = 0;
                for (NSDictionary *dic in _WholesaleDatalist) {
                    if ([_Viewtitle isEqualToString:X6_WholesaleUnits]) {
                        totalNum += [[dic valueForKey:@"col3"] longLongValue];
                        totalMoney += [[dic valueForKey:@"col4"] longLongValue];
                        totalProfit += [[dic valueForKey:@"col5"] longLongValue];
                    } else {
                        totalNum += [[dic valueForKey:@"col2"] longLongValue];
                        totalMoney += [[dic valueForKey:@"col3"] longLongValue];
                        totalProfit += [[dic valueForKey:@"col4"] longLongValue];
                    }
                    
                }
                
                UILabel *numlabel = (UILabel *)[_totalWholesaleView viewWithTag:49012];
                UILabel *jinelabel = (UILabel *)[_totalWholesaleView viewWithTag:49014];
                UILabel *maolilabel = (UILabel *)[_totalWholesaleView viewWithTag:49016];
                numlabel.text = [NSString stringWithFormat:@"%.0f个",totalNum];
                jinelabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
                
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
                for (NSDictionary *dic in qxList) {
                    if ([[dic valueForKey:@"qxid"] isEqualToString:signString]) {
                        if ([[dic valueForKey:@"pcb"] integerValue] == 1) {
                            maolilabel.text = [NSString stringWithFormat:@"￥****"];
                        } else {
                            maolilabel.text = [NSString stringWithFormat:@"￥%.2f",totalProfit];
                        }
                    }
                }
                
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dic in _WholesaleDatalist) {
                    [array addObject:[dic valueForKey:@"col1"]];
                }
                _WholesalePersonNames = array;
                
                _NoWholesaleView.hidden = YES;
                _WholesaleTableView.hidden = NO;
                [_WholesaleTableView reloadData];

            }
            
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
    }];
}

#pragma mark - 查询按钮事件
- (void)WholesaleAction
{
    if (_WholesalePersonSearchController.active) {
        [_WholesalePersonSearchController resignFirstResponder];
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
    
    [self getWholesaleDatalistWithFirstDay:_FirstDatePicker.text LastDay:_SecondDatePicker.text Source:self.Viewtitle];
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
            _FirstDatePicker.subView.tag = 1;
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
