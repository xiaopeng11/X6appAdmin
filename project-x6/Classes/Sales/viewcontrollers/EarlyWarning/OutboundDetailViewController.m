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
#import "HeaderViewController.h"
@interface OutboundDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UIButton *_headerButton;
    UILabel *_title;
    UILabel *_name;
    UILabel *_phone;
    UITableView *_OutboundDetailTableView;
    
    NSMutableArray *_OutboundDetaildatalist;
    NSDictionary *_MDpersonDic;
}


@end

@implementation OutboundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"出库异常详情"];
    
    //绘制UI
    [self initWithOutboundDetailView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getheadViewData];
    
    [self getTabelViewData];
}

#pragma mark - 绘制UI
- (void)initWithOutboundDetailView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    bgView.image = [UIImage imageNamed:@"btn_xiangqingtubiao_h"];
    [self.view addSubview:bgView];
    
    _headerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    _headerButton.clipsToBounds = YES;
    _headerButton.layer.cornerRadius = 40;
    _headerButton.backgroundColor = [UIColor yellowColor];
    [_headerButton addTarget:self action:@selector(MDpersonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_headerButton];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, KScreenWidth - 120, 35)];
    _title.font = [UIFont boldSystemFontOfSize:18];
    _title.text = _ssgsName;
    [bgView addSubview:_title];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, (KScreenWidth - 100) / 2.0, 25)];
    _name.font = [UIFont systemFontOfSize:16];
    _name.text = @"姓名:";
    [bgView addSubview:_name];
    
    _phone = [[UILabel alloc] initWithFrame:CGRectMake(100 + (KScreenWidth - 100) / 2.0, 65, (KScreenWidth - 100) / 2.0, 25)];
    _phone.font = [UIFont systemFontOfSize:16];
    _phone.text = @"电话:";
    [bgView addSubview:_phone];
    
    _OutboundDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, KScreenWidth, KScreenHeight - 64 - 100) style:UITableViewStylePlain];
    _OutboundDetailTableView.delegate = self;
    _OutboundDetailTableView.dataSource = self;
    _OutboundDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_OutboundDetailTableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _OutboundDetaildatalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"确定忽略吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_OutboundDetaildatalist removeObjectAtIndex:indexPath.row];
            [_OutboundDetailTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
                
            });
            
        }];
        UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertcontroller addAction:okaction];
        [alertcontroller addAction:cancelaction];
        [self presentViewController:alertcontroller animated:YES completion:nil];
    }];
    return @[ignore];
}

#pragma mark - 门店负责人头像点击时间
- (void)MDpersonAction
{
    HeaderViewController *headerVC = [[HeaderViewController alloc] init];
    headerVC.dic = _MDpersonDic;
    [self.navigationController pushViewController:headerVC animated:YES];
}

#pragma mark - 获取数据
/**
 *  透视图数据
 */
- (void)getheadViewData
{
    NSLog(@"获取透视图数据");
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *MDPersondetailURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_MDPersondetail];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_ssgs forKey:@"ssgs"];
    [XPHTTPRequestTool requestMothedWithPost:MDPersondetailURL params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"shibai");
    }];
}

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
    [params setObject:_ssgs forKey:@"ssgs"];
    
    [XPHTTPRequestTool requestMothedWithPost:myOutboundDetailURL params:params success:^(id responseObject) {
        _OutboundDetaildatalist = [OutboundMoredetailModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        for (NSDictionary *dic in _OutboundDetaildatalist) {
            if ([[dic valueForKey:@"col8"] boolValue] == 1) {
                [_OutboundDetaildatalist removeObject:dic];
            }
        }
        [_OutboundDetailTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"出库异常明细获取失败");
    }];
    
    
}

@end
