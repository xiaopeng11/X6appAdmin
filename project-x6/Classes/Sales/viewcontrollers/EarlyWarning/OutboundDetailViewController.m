//
//  OutboundDetailViewController.m
//  project-x6
//
//  Created by Apple on 16/3/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OutboundDetailViewController.h"
#import "OutboundDetailTableViewCell.h"
#import "OutboundMoredetailModel.h"
#import "OutboundViewController.h"
@interface OutboundDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray *_OutboundDetaildatalist;
}

@property(nonatomic,copy)NSString *dateString;  //年月
@property(nonatomic,strong)UITableView *OutboundDetailTableView;
@property(nonatomic,strong)NoDataView *noOutboundDetailView;


@end

@implementation OutboundDetailViewController

- (UITableView *)OutboundDetailTableView
{
    if (_OutboundDetailTableView == nil) {
        _OutboundDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
        _OutboundDetailTableView.delegate = self;
        _OutboundDetailTableView.dataSource = self;
        _OutboundDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _OutboundDetailTableView.hidden = YES;
        [self.view addSubview:_OutboundDetailTableView];
    }
    return _OutboundDetailTableView;
}

- (NoDataView *)noOutboundDetailView
{
    if (_noOutboundDetailView == nil) {
        _noOutboundDetailView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        _noOutboundDetailView.text = @"您还没有异常";
        _noOutboundDetailView.hidden = YES;
        [self.view addSubview:_noOutboundDetailView];
    }
    return _noOutboundDetailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"出库异常"];
    
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    
    //绘制UI
    [self initWithOutboundDetailView];
    
    [self addRightNaviItem];

   
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
        if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
            if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                //异常明细
                [self getTabelViewData];
            } else {
                [self writeWithName:@"您没有查看出库异常详情的权限"];
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self cleanOutboundWarningNumber];
    });
}

#pragma mark - 绘制UI
- (void)initWithOutboundDetailView
{
    _OutboundDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _OutboundDetailTableView.delegate = self;
    _OutboundDetailTableView.dataSource = self;
    _OutboundDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_OutboundDetailTableView];
}

#pragma mark - addRightNaviItem
- (void)addRightNaviItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 30);
    [button addTarget:self action:@selector(moreOutboundData) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"统计" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

- (void)moreOutboundData
{
    OutboundViewController *outboundView = [[OutboundViewController alloc] init];
    [self.navigationController pushViewController:outboundView animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _OutboundDetaildatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OutboundDetailidnet = @"OutboundDetailidnet";
    OutboundDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OutboundDetailidnet];
    if (cell == nil) {
        cell = [[OutboundDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OutboundDetailidnet];
    }
    cell.dic = _OutboundDetaildatalist[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *ignore = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"忽略" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
        NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
        NSString *ignoreURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_ignore];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSNumber *djid = [_OutboundDetaildatalist[indexPath.row] valueForKey:@"col0"];
        NSNumber *djh = [_OutboundDetaildatalist[indexPath.row] valueForKey:@"col1"];
        [params setObject:djid forKey:@"djid"];
        [params setObject:djh forKey:@"djh"];
        [params setObject:@"CKYC" forKey:@"txlx"];
        [XPHTTPRequestTool requestMothedWithPost:ignoreURL params:params success:^(id responseObject) {
            NSLog(@"出库异常忽略成功");
        } failure:^(NSError *error) {
            NSLog(@"出库异常忽略失败");
        }];
            
        [_OutboundDetaildatalist removeObjectAtIndex:indexPath.row];
        [_OutboundDetailTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];

    return @[ignore];
}



#pragma mark - 获取数据
/**
 *   表示图数据
 */
- (void)getTabelViewData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *myOutboundDetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_OutboundMoredetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *uyear = [_dateString substringToIndex:4];
    NSString *umonth = [_dateString substringWithRange:NSMakeRange(5, 2)];
    [params setObject:uyear forKey:@"uyear"];
    [params setObject:umonth forKey:@"accper"];
    [self showProgress];

    [XPHTTPRequestTool requestMothedWithPost:myOutboundDetailURL params:params success:^(id responseObject) {
        [self hideProgress];
        _OutboundDetaildatalist = [OutboundMoredetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        if (_OutboundDetaildatalist.count == 0) {
            _OutboundDetailTableView.hidden = YES;
            _noOutboundDetailView.hidden = NO;
        } else {            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in _OutboundDetaildatalist) {
                if ([[dic valueForKey:@"col8"] boolValue] == 1) {
                    [array addObject:dic];
                }
            }
            [_OutboundDetaildatalist removeObjectsInArray:array];
            
            _noOutboundDetailView.hidden = YES;
            _OutboundDetailTableView.hidden = NO;
            NSArray *OutboundDetailArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"col1" ascending:NO]];
            [_OutboundDetaildatalist sortUsingDescriptors:OutboundDetailArray];
            [_OutboundDetailTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideProgress];
        NSLog(@"出库异常明细获取失败");
    }];
    
    
}

/**
 *  清除出库异常条数
 */
- (void)cleanOutboundWarningNumber
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *removeWarningNumberURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_removeWarningNumber];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"CKYC" forKey:@"txlx"];
    [XPHTTPRequestTool requestMothedWithPost:removeWarningNumberURL params:params success:^(id responseObject) {
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
    
}
@end
