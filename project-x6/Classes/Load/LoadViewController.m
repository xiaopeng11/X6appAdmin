//
//  LoadViewController.m
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LoadViewController.h"
#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"

#import "JPUSHService.h"

#import "UserRegisterViewController.h"
#import "ForgetpasswordViewController.h"
@interface LoadViewController ()<UITextFieldDelegate>

@end

@implementation LoadViewController


- (void)dealloc
{
    self.view = nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GrayColor;
    [self drawViews];

    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

#pragma mark - view
- (void)drawViews
{
    //默认头像
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 72) / 2.0,75, 72, 73)];
    headerView.image = [UIImage imageNamed:@"p1_a"];
    [self.view addSubview:headerView];
    
    //欢迎使用提示语
    UILabel *welcomelabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 260) / 2.0, 173, 260, 36)];
    welcomelabel.text = @"欢迎使用X6平台";
    welcomelabel.font = TitleFont;
    welcomelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:welcomelabel];
    
    //输入框
    NSArray *placeholders = @[@" 请输入公司代码",@" 请输入用户名",@" 请输入密码"];
    NSArray *textfieldImageNames = @[@"p1_b",@"p1_c",@"p1_d"];
    for (int i = 0; i < placeholders.count; i++) {
        UIImageView *textfieldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, welcomelabel.bottom + 45 + 14 + 48 * i, 19, 19)];
        textfieldImageView.image = [UIImage imageNamed:textfieldImageNames[i]];
        [self.view addSubview:textfieldImageView];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textfieldImageView.right + 10, welcomelabel.bottom + 45 + 48 * i, KScreenWidth - 70, 47)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.delegate = self;
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *usedic = [userdefaults objectForKey:X6_UserMessage];
        if (usedic != nil) {            
            if (i == 0) {
                textField.text = [usedic valueForKey:@"gsdm"];
                textField.keyboardType = UIKeyboardTypeNumberPad;
            } else if (i == 1) {
                textField.text = [usedic valueForKey:@"phone"];
            } else {
                textField.placeholder = placeholders[i];
            }
        } else {
            textField.placeholder = placeholders[i];
        }
        textField.layer.cornerRadius = 5;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.tag = 10 + i;
        if (i == placeholders.count - 1) {
            textField.secureTextEntry = YES;
        }
        [self.view addSubview:textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(35, textField.bottom, KScreenWidth - 70, 1)];
        lineView.backgroundColor = LineColor;
        [self.view addSubview:lineView];
    }
    
    
    UIButton *loadButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 398 + 35, KScreenWidth - 70, 45)];
    loadButton.backgroundColor = Mycolor;
    loadButton.clipsToBounds = YES;
    loadButton.layer.cornerRadius = 4;
    [loadButton setTitle:@"登陆" forState:UIControlStateNormal];
    loadButton.titleLabel.font = TitleFont;
    [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [loadButton addTarget:self action:@selector(loadtabAction) forControlEvents:UIControlEventTouchUpInside];
    loadButton.layer.cornerRadius = 5;
    [self.view addSubview:loadButton];
  
    UIButton *userRegisterButton = [[UIButton alloc] initWithFrame:CGRectMake(35, loadButton.bottom + 10, 70, 30)];
    userRegisterButton.backgroundColor = [UIColor clearColor];
    [userRegisterButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [userRegisterButton setTitleColor:Mycolor forState:UIControlStateNormal];
    userRegisterButton.titleLabel.font = ExtitleFont;
    [userRegisterButton addTarget:self action:@selector(RegisterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userRegisterButton];
    
    UIButton *forgetPas = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 105, userRegisterButton.top, 70, 30)];
    forgetPas.backgroundColor = [UIColor clearColor];
    [forgetPas setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPas setTitleColor:Mycolor forState:UIControlStateNormal];
    forgetPas.titleLabel.font = ExtitleFont;
    [forgetPas addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPas];

    UIButton *userHelp = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 70) / 2.0, KScreenHeight - 60, 70, 30)];
    userHelp.backgroundColor = [UIColor clearColor];
    [userHelp setTitle:@"使用帮助" forState:UIControlStateNormal];
    [userHelp setTitleColor:Mycolor forState:UIControlStateNormal];
    userHelp.titleLabel.font = ExtitleFont;
    [userHelp addTarget:self action:@selector(userhelp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userHelp];

}

#pragma mark - loadAction：
- (void)loadtabAction
{
    [self.view endEditing:YES];
    
    UITextField *company = (UITextField *)[self.view viewWithTag:10];
    UITextField *userid = (UITextField *)[self.view viewWithTag:11];
    UITextField *password = (UITextField *)[self.view viewWithTag:12];

    //网络请求
    if (company.text.length == 0) {
        [self writeWithName:@"公司代码不能为空"];
    } else if (userid.text.length == 0) {
        [self writeWithName:@"用户名不能为空"];
    } else if (password.text.length == 0) {
        [self writeWithName:@"密码不能为空"];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:company.text forKey:@"gsdm"];
        NSString *xlstring = @"电信";
        NSData *data = [xlstring dataUsingEncoding:NSUTF8StringEncoding];
        [params setObject:data forKey:@"xl"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:X6_API_loadmain parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //继续网络请求
            if ([[responseObject objectForKey:@"type"] isEqualToString:@"error"]) {
                [self writeWithName:@"该公司未开通"];
            } else {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString *leaderurl = [responseObject objectForKey:@"message"];
                    NSString *mainURL = [NSString stringWithFormat:@"%@%@",leaderurl,X6_API_load];

                    NSMutableDictionary *paramsload = [NSMutableDictionary dictionary];
                    [paramsload setObject:company.text forKey:@"gsdm"];
                    [paramsload setObject:userid.text forKey:@"uname"];
                    [paramsload setObject:password.text forKey:@"pwd"];
                    AFHTTPRequestOperationManager *managerload = [AFHTTPRequestOperationManager manager];
                    [self showProgress];
                    [managerload POST:mainURL parameters:paramsload success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hideProgress];
                        //登陆成功
                        if ([[responseObject objectForKey:@"type"] isEqualToString:@"error"]) {
                            [self writeWithName:[responseObject objectForKey:@"message"]];
                        } else {
                            //保存cookie
                            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//                            for (NSHTTPCookie *cookie in cookies) {
//                                NSLog(@"%@",cookie);
//                            }
                            
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                            
                         
                            NSMutableDictionary *loaddictionary = [responseObject valueForKey:@"vo"];
                            NSArray *userqxList = [responseObject valueForKey:@"qxlist"];
                            
                            //保存本地
                            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                            [userdefaults setObject:data forKey:X6_Cookie];
                            [userdefaults setObject:loaddictionary forKey:X6_UserMessage];
                            [userdefaults setObject:leaderurl forKey:X6_UseUrl];
                            [userdefaults setObject:[loaddictionary objectForKey:@"userpic"] forKey:X6_UserHeaderView];
                            [userdefaults setObject:userqxList forKey:X6_UserQXList];
                            [userdefaults setObject:@(0) forKey:X6_refresh];
                            [userdefaults synchronize];
                            
                            //设置极光tags                            
                            NSString *ssgs = [NSString stringWithFormat:@"%@_%@",[loaddictionary valueForKey:@"gsdm"],[loaddictionary valueForKey:@"ssgs"]];
                            NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:ssgs, nil];
                            NSLog(@"%@",userqxList);
                            for (NSDictionary *dic in userqxList) {
                                if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_ckyc"]) {
                                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                        [set addObject:@"XJXC"];
                                    }
                                } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_cgyc"]){
                                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                        [set addObject:@"CGJJ"];
                                    }
                                } else if ([[dic valueForKey:@"qxid"] isEqualToString:@"bb_jxc_lsyc"]){
                                    if ([[dic valueForKey:@"pc"] integerValue] == 1) {
                                        [set addObject:@"LSXJ"];
                                    }
                                }
                            }
                            
                            [JPUSHService setTags:set alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                                NSLog(@"极光的tags：%@,返回的状态吗：%d",iTags,iResCode);
                            }];
                            
                            //注册环信账号(后期添加参数判断是否已经登陆过)
                            NSString *EaseID = [NSString stringWithFormat:@"%@0%@",company.text,[[responseObject valueForKey:@"vo"] valueForKey:@"phone"]];
                            NSString *password = @"yjxx&*()";
                            
                            if (![[EaseMob sharedInstance].chatManager loginWithUsername:EaseID password:password error:nil]) {
                                [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:EaseID password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
                                    NSLog(@"环信注册完成");
                                    
                                } onQueue:nil];
                            }
                            
                            //登录
                            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:EaseID password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                                //设置成自动登录
                                NSLog(@"自动登录成功");
                                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                
                                //获取数据库中数据
                                [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                
                                EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                                [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
                                    NSLog(@"全局设置完成");
                                } onQueue:nil];
                                
                                //单独设置昵称
                                [[EaseMob sharedInstance].chatManager setApnsNickname:[loaddictionary valueForKey:@"name"]];
                                
                            }onQueue:nil];
                            
                            BaseTabBarViewController *baseVC = [[BaseTabBarViewController alloc] init];
                            UIWindow *window = [UIApplication sharedApplication].keyWindow;
                            window.rootViewController = baseVC;
                            }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self hideProgress];
                        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
                    }];
              }
         }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

#pragma mark - 注册
- (void)RegisterAction
{
    UserRegisterViewController *userRegisterVC = [[UserRegisterViewController alloc] init];
    [self presentViewController:userRegisterVC animated:YES completion:nil];
}

#pragma mark - 忘记密码
- (void)forgetPassword
{
    ForgetpasswordViewController *forgetPSVC = [[ForgetpasswordViewController alloc] init];
    [self presentViewController:forgetPSVC animated:YES completion:nil]; 
}

#pragma mark - 使用帮助
- (void)userhelp
{
    NSLog(@"使用帮助");
}


@end
