//
//  OldlibraryViewController.m
//  project-x6
//
//  Created by Apple on 16/3/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OldlibraryViewController.h"

#import "OldlibraryModel.h"
#import "OldlibraryDetailModel.h"

#import "OldlibraryTabelView.h"

#import "NoDataView.h"
@interface OldlibraryViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NoDataView *_noOldlibraryView;
    UITableView *_OldlibraryTabelView;
    NSMutableArray *_OldlibraryDatalist;
}

@end

@implementation OldlibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"库龄预警"];
    
    [self initOldlibraryUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSArray *qxList = [userdefault objectForKey:X6_UserQXList];
    for (NSDictionary *dic in qxList) {
        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_klyj"]) {
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                //获取数据
                [self getOldlibraryData];
            } else {
                [self writeWithName:@"您没有查看库龄预警详情的权限"];
            }
        }
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _OldlibraryDatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Oldlibraryindet = @"Oldlibraryindet";
    OldlibraryTabelView *cell = [tableView dequeueReusableCellWithIdentifier:Oldlibraryindet];
    if (cell == nil) {
        cell = [[OldlibraryTabelView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Oldlibraryindet];
    }
    cell.dic = _OldlibraryDatalist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 绘制UI
- (void)initOldlibraryUI
{
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
    headerView.image = [UIImage imageNamed:@"btn_kulinyuqitu_h"];
    
    _OldlibraryTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _OldlibraryTabelView.delegate = self;
    _OldlibraryTabelView.dataSource = self;
    _OldlibraryTabelView.hidden = YES;
    _OldlibraryTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _OldlibraryTabelView.tableHeaderView = headerView;
    [self.view addSubview:_OldlibraryTabelView];
    
    _noOldlibraryView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _noOldlibraryView.text = @"没有库龄预警";
    _noOldlibraryView.hidden = YES;
    [self.view addSubview:_noOldlibraryView];
}

#pragma mark - 
- (void)getOldlibraryData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *OldlibraryURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_Oldlibrary];
    [GiFHUD show];
    [XPHTTPRequestTool requestMothedWithPost:OldlibraryURL params:nil success:^(id responseObject) {
        _OldlibraryDatalist = [OldlibraryModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_OldlibraryDatalist.count == 0) {
            _OldlibraryTabelView.hidden = YES;
            _noOldlibraryView.hidden = NO;
        } else {
            _noOldlibraryView.hidden = YES;
            _OldlibraryTabelView.hidden = NO;
            
            NSArray *arrayDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"col5" ascending:NO], nil];
            [_OldlibraryDatalist sortUsingDescriptors:arrayDescriptors];
            [_OldlibraryTabelView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"库龄预警获取失败");
    }];
}

@end
