//
//  TodayViewController.m
//  project-x6
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TodayViewController.h"

#import "XPDatePicker.h"

#import "TodayModel.h"
@interface TodayViewController ()
{
    NSMutableArray *_selectSectionArray;         //标题被选中数组
    XPDatePicker *_datepicker;
}

@property(nonatomic,copy)NSString *dateString;   //今日日期
@property(nonatomic,copy)NSArray *todayDatalist; //今日战报数据



@property(nonatomic,strong)NoDataView *NotodayView;  //今日战报为空
@property(nonatomic,strong)UITableView *TodayTableView;  //今日战报

@end

@implementation TodayViewController

- (NoDataView *)NotodayView
{
    if (!_NotodayView) {
        _NotodayView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        _NotodayView.text = @"没有数据";
        [self.view addSubview:_NotodayView];
    }
    return _NotodayView;
}

- (UITableView *)TodayTableView
{
    if (!_TodayTableView) {
        _TodayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
        _TodayTableView.delegate = self;
        _TodayTableView.dataSource = self;
        [self.view addSubview:_TodayTableView];
    }
    return _TodayTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"今日战报"];
    NSDate *date = [NSDate date];
    _dateString = [NSString stringWithFormat:@"%@",date];
    _dateString = [_dateString substringToIndex:10];
    NSLog(@"%@",_dateString);
    
    //导航栏按钮
    [self creatRightNaviButton];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
    //获取数据
    [self getTodayData];
}

#pragma mark - 导航栏按钮
- (void)creatRightNaviButton
{
 
    _datepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(0, 7, 80, 30) Date:_dateString];
    
    _datepicker.delegate = self;
    _datepicker.labelString = @"选择查询日期:";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_datepicker];
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"按日期搜索数据");
//}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _todayDatalist.count;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
//    if ([_selectSectionArray containsObject:string]) {
//        UIImageView *loadView = (UIImageView *)[_TodayTableView viewWithTag:4200 + section];
//        loadView.image = [UIImage imageNamed:@"btn_zhankai-_h1"];
//        
////        NSArray *array = 
//    }
//}

#pragma mark - UITableViewDataSource

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *todayIndet = @"todayIndet";
//    
//}

- (void)getTodayData
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *todayURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_today];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_dateString forKey:@"fsrqq"];
    [params setObject:_dateString forKey:@"fsrqz"];
    [XPHTTPRequestTool requestMothedWithPost:todayURL params:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _todayDatalist = [TodayModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        
        
    } failure:^(NSError *error) {
        NSLog(@"今日战报数据获取失败");
    }];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_datepicker.subView.tag == 0) {
        //置tag标志为1，并显示子视
        _datepicker.subView.tag=1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_datepicker.subView];
    }
    
    return NO;
}






@end
