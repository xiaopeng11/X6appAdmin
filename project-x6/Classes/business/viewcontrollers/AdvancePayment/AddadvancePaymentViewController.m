//
//  AddadvancePaymentViewController.m
//  project-x6
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AddadvancePaymentViewController.h"

#import "XPDatePicker.h"
@interface AddadvancePaymentViewController ()

{
    XPDatePicker *_datepicker;
    UILabel *_advanceCompanyChoose;
    UILabel *_advanceAcountChoose;
    UITextField *_advanceMoneyChange;
    UITextView *_commentView;
    
}

@end

@implementation AddadvancePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self initAdvancePriceUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initAdvancePricedetailUI];
}

- (void)initAdvancePriceUI
{
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, 25, 100, 100)];
    if (_advancePricedic == nil) {
        [self naviTitleWhiteColorWithText:@"新增预付款"];
        headerView.image = [UIImage imageNamed:@"btn_xinzengyufukuan_h"];
    } else {
        [self naviTitleWhiteColorWithText:@"预付款修改"];
        headerView.image = [UIImage imageNamed:@"btn_yufukuanxiugai_h"];
    }
    [self.view addSubview:headerView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, KScreenWidth, 10)];
    bottomView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomView];
    
    
    NSArray *titles = @[@"日期:",@"供应商:",@"帐户:",@"金额:",@"备注:"];
    NSArray *imageNames = @[@"btn_riqi_h",@"btn_gys_h",@"btn_zhanghu_h",@"btn_jine_h",@"btn_beizhu_h"];
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 189 + 40 * i, 30, 22)];
        imageView.image = [UIImage imageNamed:imageNames[i]];
        [self.view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 185 + 40 * i, 60, 30)];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:18];
        label.text = titles[i];
        [self.view addSubview:label];
    }
    
    
}


#pragma mark - 预付款ui
- (void)initAdvancePricedetailUI
{
    _advanceCompanyChoose = [[UILabel alloc] initWithFrame:CGRectMake(150, 225, KScreenWidth - 160, 30)];
    [self.view addSubview:_advanceCompanyChoose];
    
    
    if (_advancePricedic == nil) {
        NSDate *date = [NSDate date];
        NSString *dateString = [NSString stringWithFormat:@"%@",date];
        dateString = [dateString substringToIndex:10];
        _datepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(150, 185, KScreenWidth - 160, 30) Date:dateString];
        [self.view addSubview:_datepicker];
        
        
    } else {
        _datepicker = [[XPDatePicker alloc] initWithFrame:CGRectMake(150, 185, KScreenWidth - 160, 30) Date:[_advancePricedic valueForKey:@""]];
        [self.view addSubview:_datepicker];
        
        _advanceCompanyChoose.text = [_advancePricedic valueForKey:@""];
    }
}
@end
