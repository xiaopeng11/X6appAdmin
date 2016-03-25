//
//  AdddepositViewController.m
//  project-x6
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AdddepositViewController.h"

#import "XPDatePicker.h"

#import "StoresViewController.h"
#import "AcountChooseViewController.h"

#import "AcuntAndMoneyTableViewCell.h"
@interface AdddepositViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UIView *_editbgView;
    UITextView *_textView;
    
    XPDatePicker *_datePicker;
    UILabel *_companyChoose;
    UILabel *_personChoose;
    UITableView *_acountChoose;
    
    NSString *_storeid;    //门店id
    NSString *_personid;   //经办人id
    
    NSMutableArray *_acountAndmoneyDatalist;
    NSMutableArray *_acountAndmoneyArray;
}
@end

@implementation AdddepositViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"银行存款新增"];

    
    [self initAdddepositUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeChoose:) name:@"storeChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personChoose:) name:@"personChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AcountChoose:) name:@"sureAcounts" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_datePicker.datePicker != nil) {
        [_datePicker.datePicker removeFromSuperview];
        [_datePicker.subView removeFromSuperview];
    }
    
    
}

#pragma mark - initAdddepositUI
- (void)initAdddepositUI
{
    //头视图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
    imageView.image = [UIImage imageNamed:@"btn_yinghang-cunkuan-xinzeng-_h"];
    [self.view addSubview:imageView];
    
     //编辑背景
    _editbgView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, KScreenWidth - 20, 240)];
    _editbgView.backgroundColor = LineColor;
    [self.view addSubview:_editbgView];
    
    //标题
    for (int i = 0; i < 4; i++) {
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 16 + 40 * i, 22, 20)];
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 10 + 40 * i, 70, 30)];
        titlelabel.textAlignment = NSTextAlignmentRight;
        
        if (i == 0) {
            headerView.image = [UIImage imageNamed:@"btn_riqi_h"];
            titlelabel.text = @"日期:";
        } else if (i == 1) {
            headerView.image = [UIImage imageNamed:@"btn_mendian_h"];
            titlelabel.text = @"门店:";
        } else if (i == 2) {
            headerView.image = [UIImage imageNamed:@"btn_khu_h"];
            titlelabel.text = @"经办人:";
        } else if (i == 3) {
            headerView.image = [UIImage imageNamed:@"btn_zhanghu_h"];
            titlelabel.text = @"帐户/金额:";
            titlelabel.font = [UIFont systemFontOfSize:14];

        }
        
        [_editbgView addSubview:headerView];
        [_editbgView addSubview:titlelabel];
        
        
    }
    
    //日期选择
    NSDate *date = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%@",date];
    dateString = [dateString substringToIndex:10];
    _datePicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(105, 10, KScreenWidth - 105 - 20, 30) Date:dateString];
    _datePicker.borderStyle = UITextBorderStyleNone;
    _datePicker.textColor = [UIColor blackColor];
    _datePicker.font = [UIFont systemFontOfSize:14];
    [_editbgView addSubview:_datePicker];
    
    //门店选择
    _companyChoose = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, KScreenWidth - 125, 30)];
    _companyChoose.userInteractionEnabled = YES;
    UITapGestureRecognizer *companyChooseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(companyChooseTap)];
    [_companyChoose addGestureRecognizer:companyChooseTap];
    [_editbgView addSubview:_companyChoose];
    
    //经办人选择
    _personChoose = [[UILabel alloc] initWithFrame:CGRectMake(105, 90, KScreenWidth - 125, 30)];
    _personChoose.userInteractionEnabled = YES;
    UITapGestureRecognizer *personChooseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personChooseTap)];
    [_personChoose addGestureRecognizer:personChooseTap];
    [_editbgView addSubview:_personChoose];
    
    //账号选择
    _acountChoose = [[UITableView alloc] initWithFrame:CGRectMake(105, 130, KScreenWidth - 125, 90) style:UITableViewStylePlain];
    _acountChoose.delegate = self;
    _acountChoose.dataSource = self;
    _acountChoose.backgroundColor = [UIColor clearColor];
    _acountChoose.separatorStyle = UITableViewCellSeparatorStyleNone;
    _acountChoose.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_editbgView addSubview:_acountChoose];

    //底部线条和右侧图片
    for (int i = 0; i < 3; i++) {
        if (i < 2) {
            UIImageView *acountChooseView = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - 35, 50 + 40 * i, 10, 20)];
            acountChooseView.image = [UIImage imageNamed:@"btn_zhankai-_h1"];
            [_editbgView addSubview:acountChooseView];
        }
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(105, 50 + 40 * i, KScreenWidth - 145, 1)];
        [_editbgView addSubview:lineview];
    }
 
    //确定按钮
    UIButton *uploadsupplier = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadsupplier addTarget:self action:@selector(uploadsupplier) forControlEvents:UIControlEventTouchUpInside];
    uploadsupplier.frame = CGRectMake((KScreenWidth - 150) / 2.0, KScreenHeight - 40 - 64 - 10, 150, 40);
    [uploadsupplier setTitle:@"确定" forState:UIControlStateNormal];
    [uploadsupplier setBackgroundColor:Mycolor];
    [self.view addSubview:uploadsupplier];

}



#pragma mark - 上传数据
- (void)uploadsupplier
{
    if (_companyChoose.text.length == 0) {
        [self writeWithName:@"门店不能为空"];
    } else if (_personChoose.text.length == 0) {
        [self writeWithName:@"经办人不能为空"];
    } else if (_acountAndmoneyDatalist.count == 0 ) {
        [self writeWithName:@"帐户金额不能为空"];
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *url = [userDefaults objectForKey:X6_UseUrl];
        NSString *saveacountAndmoneyURL = [NSString stringWithFormat:@"%@%@",url,X6_savedeposit];
        
        NSDictionary *userMessage = [userDefaults objectForKey:X6_UserMessage];
        NSString *userid = [userMessage valueForKey:@"id"];
        NSString *username = [userMessage valueForKey:@"name"];
        
        NSMutableArray *rows = [NSMutableArray array];
        for (int i = 1; i < _acountAndmoneyArray.count + 1; i++) {
            NSDictionary *dic = _acountAndmoneyArray[i - 1];
            NSMutableDictionary *mutabledic = [NSMutableDictionary dictionary];
            [mutabledic setObject:@"-1" forKey:@"id"];
            [mutabledic setObject:@(i) forKey:@"line"];
            [mutabledic setObject:[dic valueForKey:@"choose"] forKey:@"je"];
            [mutabledic setObject:[dic valueForKey:@"id"] forKey:@"zhid"];
            [mutabledic setObject:[dic valueForKey:@"name"] forKey:@"zhname"];
            [rows addObject:mutabledic];
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"New" forKey:@"djh"];
        [params setObject:_datePicker.text forKey:@"fsrq"];
        [params setObject:_storeid forKey:@"ssgsid"];
        [params setObject:_companyChoose.text forKey:@"ssgsname"];
        [params setObject:_personid forKey:@"jsrdm"];
        [params setObject:_personChoose.text forKey:@"jsrmc"];
        [params setObject:userid forKey:@"zdrdm"];
        [params setObject:username forKey:@"zdrmc"];
        [params setObject:@"" forKey:@"zdrq"];
        [params setObject:@"" forKey:@"comments"];
        [params setObject:rows forKey:@"rows"];
        
        
        NSMutableDictionary *diced = [NSMutableDictionary dictionary];
        [diced setObject:params forKey:@"vo"];
        NSMutableDictionary *dics = [NSMutableDictionary dictionary];
        
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:diced options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
        
        [dics setObject:string forKey:@"postdata"];
        [XPHTTPRequestTool requestMothedWithPost:saveacountAndmoneyURL params:dics success:^(id responseObject) {
            NSLog(@"上传信息成功%@",responseObject);
            if ([responseObject[@"type"] isEqualToString:@"error"]) {
                [self writeWithName:responseObject[@"message"]];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"上传信息失败%@",error);
            [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
            
        }];

    }
    
}

/**
 *  门店选择
 
 
 {
 comments = "";
 djh = New;
 fsrq = "2016-03-25";
 jsrdm = 39;
 jsrmc = "\U5434\U5b97\U5b89";
 rows =     (
 {
 id = "-1";
 je = 6666;
 line = 1;
 zhid = 72;
 zhname = "\U5f90\U5dde\U5206\U516c\U53f8-\U5149\U5927";
 }
 );
 ssgsid = 55;
 ssgsname = "\U8d3e\U6c6a\U4e8c\U5e97";
 zdrdm = 87;
 zdrmc = 002;
 zdrq = "";
 }
 */
- (void)companyChooseTap
{
    NSLog(@"点击了萌点选择");
    StoresViewController *storeVC = [[StoresViewController alloc] init];
    storeVC.isStore = YES;
    [self.navigationController pushViewController:storeVC animated:YES];
}


- (void)storeChoose:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    _companyChoose.text = [dic valueForKey:@"name"];
    _storeid = [dic valueForKey:@"id"];
}

/**
 *  帐户选择
 */


- (void)AcountChoose:(NSNotification *)noti
{
    _acountAndmoneyDatalist = [NSMutableArray array];
    _acountAndmoneyArray = [NSMutableArray array];
    _acountAndmoneyArray = noti.object;
    for (NSDictionary *acountAndmoney in _acountAndmoneyArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[acountAndmoney valueForKey:@"name"] forKey:@"acount"];
        [dic setObject:[acountAndmoney valueForKey:@"choose"] forKey:@"money"];
        [_acountAndmoneyDatalist addObject:dic];
    }
    
    [_acountChoose reloadData];
    
}

/**
 *  经办人选择
 */
- (void)personChooseTap
{
    NSLog(@"点击了经办人选择");
    StoresViewController *storeVC = [[StoresViewController alloc] init];
    [self.navigationController pushViewController:storeVC animated:YES];
}

- (void)personChoose:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    _personChoose.text = [dic valueForKey:@"name"];
    _personid = [dic valueForKey:@"id"];
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_acountAndmoneyDatalist.count == 0) {
        return 1;
    } else {
        return _acountAndmoneyDatalist.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *acountAndmoneyCell = @"acountAndmoneyCell";
    AcuntAndMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:acountAndmoneyCell];
    if (cell == nil) {
        cell = [[AcuntAndMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:acountAndmoneyCell];
        
    }
    
    cell.dic = _acountAndmoneyDatalist[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_acountAndmoneyDatalist.count == 0) {
        //判断是否选择了门店
        if (_companyChoose.text == nil) {
            [self writeWithName:@"请先选择门店"];
        } else {
            AcountChooseViewController *acountChooseVC = [[AcountChooseViewController alloc] init];
            acountChooseVC.storeID = _storeid;
            [self.navigationController pushViewController:acountChooseVC animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_acountAndmoneyDatalist removeObjectAtIndex:indexPath.row];
    [_acountChoose beginUpdates];
    [_acountChoose deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_acountChoose endUpdates];
}
@end
