//
//  ChangePasswordViewController.m
//  project-x6
//
//  Created by Apple on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@end

@implementation ChangePasswordViewController
- (void)dealloc
{
    self.view = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self naviTitleWhiteColorWithText:@"修改密码"];
    
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"改变密码收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }

}

- (void)creatUI
{
    NSArray *placeholders = @[@" 原密码",@" 新密码", @" 确认新密码"];
    for (int i = 0; i < placeholders.count; i++) {
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40 + 50 * i, KScreenWidth, 50)];
        bgview.userInteractionEnabled = YES;
        [self.view addSubview:bgview];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 49)];
        textField.placeholder = placeholders[i];
        textField.layer.cornerRadius = 10;
        textField.secureTextEntry = YES;
        textField.tag = 800 + i;
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [bgview addSubview:textField];
        
        
        UIView *imaline = [[UIView alloc] initWithFrame:CGRectMake(20, 49, KScreenWidth - 30, 1)];
        imaline.backgroundColor = LineColor;
        [bgview addSubview:imaline];
    }
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(20, 210, KScreenWidth - 40, 50);
    button.layer.cornerRadius = 10;
    button.backgroundColor = Mycolor;
    [button setTitle:@"确  认" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changepassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)changepassword:(UIButton *)button
{
    
    [self.view endEditing:YES];
    
    UITextField *oldpassword = (UITextField *)[self.view viewWithTag:800];
    UITextField *newpassword = (UITextField *)[self.view viewWithTag:801];
    UITextField *tonewpassword = (UITextField *)[self.view viewWithTag:802];
    
    if (oldpassword.text.length == 0) {
        //请输入新密码
        [self writeWithName:@"请输入原密码"];
    } else if (newpassword.text.length == 0) {
        [self writeWithName:@"请输入新密码"];
    } else if (tonewpassword.text.length == 0) {
        [self writeWithName:@"请确定新密码"];
    } else if (![newpassword.text isEqualToString:tonewpassword.text]) {
        [self writeWithName:@"您的新密码不一致，请重新输入"];
    } else if (oldpassword.text.length != 0 && newpassword.text.length != 0 && [newpassword.text isEqualToString:tonewpassword.text]) {
        //更改密码
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
        NSString *userid = [dic objectForKey:@"id"];
        NSString *userURL = [userdefaults objectForKey:X6_UseUrl];
        NSString *changePassword = [NSString stringWithFormat:@"%@%@",userURL,X6_changePassword];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:userid forKey:@"id"];
        [params setObject:oldpassword.text forKey:@"old_pwd"];
        [params setObject:newpassword.text forKey:@"pwd"];
        
        [XPHTTPRequestTool requestMothedWithPost:changePassword params:params success:^(id responseObject) {
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"密码修改成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertcontroller addAction:cancelaction];
            [alertcontroller addAction:okaction];
            [self presentViewController:alertcontroller animated:YES completion:nil];
        } failure:^(NSError *error) {
//            [BasicControls showNDKNotifyWithMsg:@"密码修改失败 请检查您的网络连接" WithDuration:0.5f speed:0.5f];
        }];
        
    }
    
}


@end
