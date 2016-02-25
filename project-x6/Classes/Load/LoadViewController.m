//
//  LoadViewController.m
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LoadViewController.h"
#import "BaseTabBarViewController.h"
#import "AppDelegate.h"
@interface LoadViewController ()<UITextFieldDelegate>

@end

@implementation LoadViewController


- (void)dealloc
{
    NSLog(@"登录页面释放");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GrayColor;
    [self drawViews];
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

#pragma mark - view
- (void)drawViews
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    titleView.backgroundColor = Mycolor;
    [self.view addSubview:titleView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, 44)];
    titleLabel.text = @"欢迎使用X6平台";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, 20 + 64, 100, 100)];
    headerView.image = [UIImage imageNamed:@"pho-moren"];
    headerView.backgroundColor = [UIColor yellowColor];
    headerView.clipsToBounds = YES;
    headerView.layer.cornerRadius = 50;
    [self.view addSubview:headerView];
    
    //输入框
    NSArray *placeholders = @[@" 请输入公司代码",@" 请输入用户名",@" 请输入密码"];
    for (int i = 0; i < placeholders.count; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 184 + 20 + 61 * i, KScreenWidth - 20, 60)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.delegate = self;
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *usedic = [userdefaults objectForKey:X6_UserMessage];
        if (usedic != nil) {            
            if (i == 0) {
                textField.text = [usedic valueForKey:@"gsdm"];
                
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
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tag = 10 + i;
        if (i == placeholders.count - 1) {
            textField.secureTextEntry = YES;
        }
        [self.view addSubview:textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 184 + 20 + 60 * i + 60, KScreenWidth - 20, 1)];
        lineView.backgroundColor = LineColor;
        [self.view addSubview:lineView];
        
    }
    
    UIButton *loadButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 394, KScreenWidth - 40, 50)];
    loadButton.backgroundColor = Mycolor;
    loadButton.clipsToBounds = YES;
    loadButton.layer.cornerRadius = 15;
    [loadButton setTitle:@"登     陆" forState:UIControlStateNormal];
    [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [loadButton addTarget:self action:@selector(loadAction) forControlEvents:UIControlEventTouchUpInside];
    loadButton.layer.cornerRadius = 5;
    [self.view addSubview:loadButton];


}

#pragma mark - loadAction：
- (void)loadAction
{
    [self.view endEditing:YES];
    
    if (isDevice4_4s) {
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
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
                    NSString *mainURL = [NSString stringWithFormat:@"%@/ygLogin.action",leaderurl];

                    NSMutableDictionary *paramsload = [NSMutableDictionary dictionary];
                    [paramsload setObject:company.text forKey:@"gsdm"];
                    [paramsload setObject:userid.text forKey:@"uname"];
                    [paramsload setObject:password.text forKey:@"pwd"];
                    AFHTTPRequestOperationManager *managerload = [AFHTTPRequestOperationManager manager];
                    //加载提示
                    [GiFHUD show];
                    [managerload POST:mainURL parameters:paramsload success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        //登陆成功
                        if ([[responseObject objectForKey:@"type"] isEqualToString:@"error"]) {
                            [GiFHUD dismiss];
                            [self writeWithName:[responseObject objectForKey:@"message"]];
                        } else {
                            //保存cookie
                            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//                            for (NSHTTPCookie *cookie in cookies) {
//                                NSLog(@"%@",cookie);
//                            }
                            
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                            
                            //移除加载提示
                            NSMutableDictionary *loaddictionary = [responseObject valueForKey:@"vo"];
                            //保存本地
                            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                            [userdefaults setObject:data forKey:X6_Cookie];
                            [userdefaults setObject:loaddictionary forKey:X6_UserMessage];
                            [userdefaults setObject:leaderurl forKey:X6_UseUrl];
                            [userdefaults setObject:[loaddictionary objectForKey:@"userpic"] forKey:X6_UserHeaderView];
                            [userdefaults setObject:@(0) forKey:X6_refresh];
                            [userdefaults synchronize];
                            
                            //注册环信账号(后期添加参数判断是否已经登陆过)
                            NSString *EaseID = [NSString stringWithFormat:@"%@%@",company.text,[[responseObject valueForKey:@"vo"] valueForKey:@"phone"]];
                            NSString *password = @"yjxx&*()";
                                [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:EaseID password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
                                    NSLog(@"环信注册完成");
                                   
                                } onQueue:nil];
                            
                            //登录
                            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:EaseID password:password completion:^(NSDictionary *loginInfo, EMError *error) {
                                //设置成自动登录
                                NSLog(@"自动登录成功");
                                [GiFHUD dismiss];
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
//                            AppDelegate *appdelete = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            UIWindow *window = [UIApplication sharedApplication].keyWindow;
                            window.rootViewController = baseVC;
                            self.view = nil;
                            }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [GiFHUD dismiss];
                        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
                    }];
              }
         }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}


//移动视图
-(void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    if (!isDevice6P) {
        int offset = 216.0 - (KScreenHeight - 394.0 - 50);//iPhone键盘高度216，iPad的为352
        
        
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        
        [UIView setAnimationDuration:0.5f];
        
        
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        
        //    if(offset > 0)
        
        self.view.frame = CGRectMake(0.0f, - offset, self.view.frame.size.width, self.view.frame.size.height);
        
        
        
        [UIView commitAnimations];
    }
   
    
}


@end
