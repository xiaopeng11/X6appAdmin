//
//  UserRegisterViewController.m
//  project-x6
//
//  Created by Apple on 16/4/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UserRegisterViewController.h"

@interface UserRegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

{
    //输入背景
    UIView *_enterbgView;
    
    //公司代码
    UITextField *_gdsmTF;
    
    //用户名(汉字)
    UITextField *_userNameTF;
    
    //手机号码
    UITextField *_phoneTF;
    
    //短信验证码
    UIButton *_acquireButton;
    
    //验证码
    UITextField *_smsCodeTF;
    
    //密码
    UITextField *_passwordTF;
    
    //确认密码
    UITextField *_ensurePasswordTF;
    
    //是否显示获取验证码按钮
    UIButton *_isOrshowButton;
    
    //注册按钮
    UIButton *_registerButton;
}

@property (nonatomic, readwrite, retain)NSTimer *timer;

@end

@implementation UserRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    naviView.backgroundColor = Mycolor;
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2.0, 20, 200, 44)];
    title.text = @"新用户注册";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [naviView addSubview:title];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 25, 34, 34);
    [backButton setImage:[UIImage imageNamed:@"btn-fanhui"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
    //绘制UI层
    [self drawUserRegisterUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK - 绘制ui
- (void)drawUserRegisterUI
{
    
    _enterbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 15, KScreenWidth, 45.5 * 5 + 44)];
    _enterbgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_enterbgView];
    
    //绘制textField之间相隔线
    for (int i = 1; i < 6; i++) {
        [self showLineImageWithFrame:CGRectMake(20, 44 * i + 0.5, KScreenWidth, 0.5)];
    }
    
    //公司代码
    {
        UILabel *gsdmLabel = [BasicControls createLabelWithframe:CGRectMake(20, 0, 80, 44) image:nil];
        gsdmLabel.text = @"公司代码";
        gsdmLabel.textColor = [UIColor darkGrayColor];
        gsdmLabel.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:gsdmLabel];
        
        _gdsmTF = [BasicControls createTextFieldWithframe:CGRectMake(90, gsdmLabel.top, KScreenWidth - 115, 44) addTarget:self image:nil];
        _gdsmTF.placeholder = @"请输入公司代码";
        _gdsmTF.font = [UIFont systemFontOfSize:15.0];
        _gdsmTF.keyboardType = UIKeyboardTypePhonePad;
        [_enterbgView addSubview:_gdsmTF];
    }
    
    //用户名
    {
        UILabel *userNameLabel = [BasicControls createLabelWithframe:CGRectMake(20, 44 + 1.5, 80, 44) image:nil];
        userNameLabel.text = @"用户名";
        userNameLabel.textColor = [UIColor darkGrayColor];
        userNameLabel.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:userNameLabel];
        
        _userNameTF = [BasicControls createTextFieldWithframe:CGRectMake(90, userNameLabel.top, KScreenWidth - 115, 44) addTarget:self image:nil];
        _userNameTF.placeholder = @"请输入有效用户名";
        _userNameTF.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:_userNameTF];
    }
    
    //手机号
    {
        UILabel *phoneLabel = [BasicControls createLabelWithframe:CGRectMake(20, (44 + 1.5) * 2, 80, 44) image:nil];
        phoneLabel.text = @"手机号码";
        phoneLabel.textColor = [UIColor darkGrayColor];
        phoneLabel.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:phoneLabel];
        
        _phoneTF = [BasicControls createTextFieldWithframe:CGRectMake(90, phoneLabel.top, KScreenWidth - 115, 44) addTarget:self image:nil];
        _phoneTF.placeholder = @"请输入手机号码";
        _phoneTF.font = [UIFont systemFontOfSize:15.0];
        _phoneTF.keyboardType = UIKeyboardTypePhonePad;
        [_enterbgView addSubview:_phoneTF];
        
        _acquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _acquireButton.frame = CGRectMake(0, _phoneTF.top + 7, 80, 30);
        [_acquireButton setTitleColor:ColorRGB(228, 76, 45) forState:UIControlStateNormal];
        [_acquireButton setBackgroundColor:ColorRGB(240, 240, 240)];
        _acquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _acquireButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _acquireButton.layer.cornerRadius = 7;
        [_acquireButton addTarget:self action:@selector(requestGetRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
        [_phoneTF setRightView:_acquireButton];
        [_phoneTF setRightViewMode:UITextFieldViewModeAlways];
    }
    
    //验证码
    {
        UILabel *smsCodeLabel = [BasicControls createLabelWithframe:CGRectMake(20, (44 + 1.5) * 3, 80, 44) image:nil];
        smsCodeLabel.text = @"验证码";
        smsCodeLabel.textColor = [UIColor darkGrayColor];
        smsCodeLabel.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:smsCodeLabel];
        
        _smsCodeTF = [BasicControls createTextFieldWithframe:CGRectMake(90, smsCodeLabel.top, KScreenWidth - 115, 44) addTarget:self image:nil];
        _smsCodeTF.placeholder = @"6位短信数字验证码";
        _smsCodeTF.font = [UIFont systemFontOfSize:15.0];
        _smsCodeTF.keyboardType = UIKeyboardTypePhonePad;
        [_enterbgView addSubview:_smsCodeTF];
    }
    
    //登陆密码
    {
        UILabel *passwordLabel = [BasicControls createLabelWithframe:CGRectMake(20, (44 + 1.5) * 4, 80, 44) image:nil];
        passwordLabel.text = @"登陆密码";
        passwordLabel.textColor = [UIColor darkGrayColor];
        passwordLabel.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:passwordLabel];
        
        _passwordTF = [BasicControls createTextFieldWithframe:CGRectMake(90, passwordLabel.top, KScreenWidth - 115, 44) addTarget:self image:nil];
        _passwordTF.placeholder = @"请输入6~18位有效登陆密码";
        _passwordTF.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:_passwordTF];
    }
    
    //确认密码
    {
        UILabel *ensurePasswordLabel = [BasicControls createLabelWithframe:CGRectMake(20, (44 + 1.5) * 5, 80, 44) image:nil];
        ensurePasswordLabel.text = @"确认密码";
        ensurePasswordLabel.textColor = [UIColor darkGrayColor];
        ensurePasswordLabel.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:ensurePasswordLabel];
        
        _ensurePasswordTF = [BasicControls createTextFieldWithframe:CGRectMake(90, ensurePasswordLabel.top, KScreenWidth - 115, 44) addTarget:self image:nil];
        _ensurePasswordTF.placeholder = @"请再一次输入登陆密码";
        _ensurePasswordTF.font = [UIFont systemFontOfSize:15.0];
        [_enterbgView addSubview:_ensurePasswordTF];
    }
    
    //注册按钮
    {
        _registerButton = [BasicControls createButtonWithTitle:@"注册" frame:CGRectMake(15, _enterbgView.bottom + 15, KScreenWidth - 30, 44) image:nil];
        [_registerButton setBackgroundColor:Mycolor];
        [_registerButton addTarget:self action:@selector(submitNextAction:) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.layer.cornerRadius = 7;
        [self.view addSubview:_registerButton];
    }
}

//绘制textField之间相隔线
- (void)showLineImageWithFrame:(CGRect)frame
{
    UIImageView *imageview = [BasicControls createImageViewWithframe:frame image:nil];
    imageview.backgroundColor = SR_Color_Line;
    [_enterbgView addSubview:imageview];
}


//获取验证码
- (void)requestGetRegisterAction:(UIButton *)button
{
    if (_phoneTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入手机号" addTarget:nil];
        return;
    } else if (_phoneTF.text.length < 11) {
        [BasicControls showAlertWithMsg:@"请输入11位有效手机号" addTarget:nil];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码已发" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.tag = 000002;
    [alertView show];
    //网络请求获取验证码
    _acquireButton.enabled = NO;
    [_acquireButton setTitle:@"60s" forState:UIControlStateNormal];
    [_acquireButton setUserInteractionEnabled:NO];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerText:) userInfo:nil repeats:YES];
    
}

#pragma mark - 按钮事件
- (void)submitNextAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    //输入框逻辑处理
    if (![self manageRegisterViewWithAccountWithPwdTextFiled])
    {
        return;
    }
    [self requestUserRegister];
 
}

#pragma mark - manageUITextField
//输入框逻辑处理
- (BOOL)manageRegisterViewWithAccountWithPwdTextFiled
{
    if (_gdsmTF.text.length < 3 || _gdsmTF.text.length > 4)
    {
        [BasicControls showAlertWithMsg:@"请输入3～4位有效公司代码" addTarget:nil];
        return NO;
    }
    if (_phoneTF.text.length < 11)
    {
        [BasicControls showAlertWithMsg:@"请输入11位有效号码" addTarget:nil];
        return NO;
    }
    if (_smsCodeTF.text.length < 6)
    {
        [BasicControls showAlertWithMsg:@"6位短信数字验证码" addTarget:nil];
        return NO;
    }
    if (_passwordTF.text.length <= 5  || _passwordTF.text.length > 18)
    {
        [BasicControls showAlertWithMsg:@"请输入6~18为有效登录密码" addTarget:nil];
        return NO;
    }
    if (![_passwordTF.text isEqualToString:_ensurePasswordTF.text]) {
        [BasicControls showAlertWithMsg:@"密码不一致,请重新输入" addTarget:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 数据网络请求
//用户注册请求
- (void)requestUserRegister
{
    NSLog(@"用户注册");
}

#pragma mark - 获取验证码倒计时
-(void)updateTimerText:(NSTimer*)theTimer
{
    NSString *countdown = _acquireButton.titleLabel.text;
    if([countdown isEqualToString:@"0s"])
    {
        [self.timer invalidate];
        _acquireButton.enabled = YES;
        [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_acquireButton setUserInteractionEnabled:YES];
    } else {
        int icountdown = [countdown intValue];
        icountdown = icountdown - 1;
        NSString *ncountdown = [[NSString alloc] initWithFormat:@"%ds", icountdown];
        
        if (isDevice4_4s)
        {
            _acquireButton.titleLabel.text = ncountdown;
        } else {
            [_acquireButton setTitle:ncountdown forState:UIControlStateNormal];
        }
        [_acquireButton setTitle:ncountdown forState:UIControlStateNormal];
    }
}

#pragma makr - 返回事件
- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
