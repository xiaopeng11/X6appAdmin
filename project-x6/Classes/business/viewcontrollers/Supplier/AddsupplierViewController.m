//
//  AddsupplierViewController.m
//  project-x6
//
//  Created by Apple on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AddsupplierViewController.h"

@interface AddsupplierViewController ()

{
    UIView *_editbgView;
    NSDictionary *_suppliermessage;
    
    UITextView *_textView;
}

@end

@implementation AddsupplierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAddsupplierUI];
    
    if (_issupplier) {
        if (_supplierdic == nil) {
            [self naviTitleWhiteColorWithText:@"供应商新增"];
        } else{
            [self naviTitleWhiteColorWithText:[NSString stringWithFormat:@"供应商详情"]];
        }
    } else {
        if (_supplierdic == nil) {
            [self naviTitleWhiteColorWithText:@"客户新增"];
        } else{
            [self naviTitleWhiteColorWithText:[NSString stringWithFormat:@"客户详情"]];
        }
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  绘制UI
- (void)initAddsupplierUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
    if (_issupplier) {
        if (_supplierdic == nil) {
            imageView.image = [UIImage imageNamed:@"btn_gongyingxinzeng_h"];
        } else {
            imageView.image = [UIImage imageNamed:@"btn_gongshangbianji_h"];
        }
    } else {
        if (_supplierdic == nil) {
            imageView.image = [UIImage imageNamed:@"btn_kehuxinzeng_h"];
        } else {
            imageView.image = [UIImage imageNamed:@"btn_kehuxiangqing_h"];
        }
    }
    
    [self.view addSubview:imageView];
    
    _editbgView = [[UIView alloc] initWithFrame:CGRectMake(10, 170, KScreenWidth - 20, 240)];
    _editbgView.backgroundColor = LineColor;
    [self.view addSubview:_editbgView];
    
    for (int i = 0; i < 5; i++) {
        UIImageView *imgaeview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16 + 40 * i, 22, 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(42, 10 + 40 * i, 60, 30)];
        label.textAlignment = NSTextAlignmentRight;
        UITextField *textfield;
        if (i < 4) {
            textfield = [[UITextField alloc] initWithFrame:CGRectMake(110, 10 + 39 * i, KScreenWidth - 140, 30)];
            textfield.borderStyle = UITextBorderStyleNone;
            textfield.tag = 3100 + i;
            [_editbgView addSubview:textfield];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(110, 39 + 40 * i , KScreenWidth - 140, 1)];
            lineView.backgroundColor = LineColor;
            [_editbgView addSubview:lineView];
        }
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(110, 170, KScreenWidth - 110 - 30, 55)];
        [_editbgView addSubview:_textView];
     
        if (i == 0) {
            imgaeview.image = [UIImage imageNamed:@""];
            label.text = @"名称:";
        } else if (i == 1) {
            imgaeview.image = [UIImage imageNamed:@""];
            label.text = @"联系人:";
        } else if (i == 2) {
            imgaeview.image = [UIImage imageNamed:@"btn_dianhua_h"];
            label.text = @"电话:";
        } else if (i == 3) {
            imgaeview.image = [UIImage imageNamed:@""];
            label.text = @"地址:";
        } else if (i == 4) {
            imgaeview.image = [UIImage imageNamed:@"btn_beizhu_h"];
            label.text = @"备注:";
        }
        
        if (_supplierdic != nil) {
            if (i == 0) {
                textfield.text = [_supplierdic valueForKey:@"name"];
            } else if (i == 1) {
                textfield.text = [_supplierdic valueForKey:@"lxr"];
            } else if (i == 2) {
                textfield.text = [_supplierdic valueForKey:@"lxhm"];
            } else if (i == 3) {
                textfield.text = [_supplierdic valueForKey:@"dz"];
            }
            _textView.text = [_supplierdic valueForKey:@"comments"];
        }
        
        [_editbgView addSubview:imgaeview];
        [_editbgView addSubview:label];
    }
    
    UIButton *uploadsupplier = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadsupplier addTarget:self action:@selector(uploadsupplier) forControlEvents:UIControlEventTouchUpInside];
    uploadsupplier.frame = CGRectMake(0, KScreenHeight - 40 - 64, KScreenWidth, 40);
    [uploadsupplier setTitle:@"确定" forState:UIControlStateNormal];
    [uploadsupplier setBackgroundColor:Mycolor];
    [self.view addSubview:uploadsupplier];
    
}

#pragma mark - 新增供应商
- (void)uploadsupplier
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *addsupplierORcostumerURL;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_issupplier) {
        addsupplierORcostumerURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_addsupplier];
    } else {
        addsupplierORcostumerURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_addcustomer];
    }
    
    if (_supplierdic == nil) {
        [params setObject:@(-1) forKey:@"id"];
    } else {
        NSInteger supplierid = [[_supplierdic valueForKey:@"id"] integerValue];
        [params setObject:@(supplierid) forKey:@"id"];
    }

    UITextField *nametextfield = (UITextField *)[_editbgView viewWithTag:3100];
    UITextField *lxrtextfield = (UITextField *)[_editbgView viewWithTag:3101];
    UITextField *lxhmtextfield = (UITextField *)[_editbgView viewWithTag:3102];
    UITextField *dztextfield = (UITextField *)[_editbgView viewWithTag:3103];
    [params setObject:nametextfield.text forKey:@"name"];
    [params setObject:lxrtextfield.text forKey:@"lxr"];
    [params setObject:lxhmtextfield.text forKey:@"lxhm"];
    [params setObject:dztextfield.text forKey:@"dz"];
    [params setObject:_textView.text forKey:@"comments"];
    
    NSMutableDictionary *diced = [NSMutableDictionary dictionary];
    [diced setObject:params forKey:@"vo"];
    NSMutableDictionary *dics = [NSMutableDictionary dictionary];

    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:diced options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    [dics setObject:string forKey:@"postdata"];

    [XPHTTPRequestTool requestMothedWithPost:addsupplierORcostumerURL params:dics success:^(id responseObject) {
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


@end
