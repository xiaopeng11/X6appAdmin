//
//  ForgetpasswordViewController.m
//  project-x6
//
//  Created by Apple on 16/5/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ForgetpasswordViewController.h"

#define titleWidth (KScreenWidth / 3.0)
#define TFwidth (KScreenWidth - 80 - 40)

@interface ForgetpasswordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

{
    UIScrollView *_mainScrollView;             //滑动试图
    
    UITextField *_gsdmTF;                      //公司代码
    UITextField *_userNameTF;                  //用户名
    UITextField *_checkTF;                     //验证码
    
    UITextField *_newpsTF;                     //新密码
    UITextField *_checkpsTF;                   //确认密码
    
    UIButton *_firstnextbutton;                //第一个下一步按钮
    UIButton *_secondnextbutton;               //第二个下一步按钮
    UIButton *_loadbutton;                     //重新登陆按钮
    UIButton *_acquireButton;                  //短信验证码
    UIButton *_isOrshowButton;                 //是否显示获取验证码按钮
}
@property (nonatomic, readwrite, retain)NSTimer *timer;
@property(nonatomic,strong)UIView *lineView;

@end

@implementation ForgetpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    naviView.backgroundColor = Mycolor;
    naviView.userInteractionEnabled = YES;
    [self.view addSubview:naviView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 200) / 2.0, 20, 200, 44)];
    title.text = @"找回密码";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [naviView addSubview:title];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 25, 34, 34);
    [backButton setImage:[UIImage imageNamed:@"btn-fanhui"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backButton];
    
    //绘制标题试图
    [self initTitleView];
    
    //绘制滑动试图子试图
    [self initScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//绘制标题试图
- (void)initTitleView
{
    NSArray *titleArray = @[@"申请密码",@"修改密码",@"修改成功"];
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 54, KScreenWidth, KScreenHeight - 64 - 54)];
    _mainScrollView.contentSize = CGSizeMake(KScreenWidth * 3, KScreenHeight - 64 - 54);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.scrollEnabled = NO;
    [self.view addSubview:_mainScrollView];
    
    for (int i = 0; i < 3; i++) {
        UIView *numbg = [[UIView alloc] initWithFrame:CGRectMake(10 + titleWidth * i, 64 + 15, 20, 20)];
        numbg.clipsToBounds = YES;
        numbg.layer.cornerRadius = 10;
        numbg.tag = 12010 + i;
        [self.view addSubview:numbg];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        label.tag = 12020 + i;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",i + 1];
        [numbg addSubview:label];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + titleWidth * i, 64 + 15, 70, 20)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.tag = 12030 + i;
        [self.view addSubview:titleLabel];
        
        if (i == 0) {
            numbg.backgroundColor = Mycolor;
            label.textColor = [UIColor whiteColor];
            titleLabel.textColor = Mycolor;
        } else {
            numbg.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
            label.textColor = [UIColor grayColor];
            titleLabel.textColor = [UIColor grayColor];
        }
    }
    
    UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 50, KScreenWidth, 4)];
    grayLineView.backgroundColor = GrayColor;
    [self.view addSubview:grayLineView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 50, titleWidth, 4)];
    _lineView.backgroundColor = Mycolor;
    _lineView.clipsToBounds = YES;
    _lineView.layer.cornerRadius = 2;
    [self.view addSubview:_lineView];
}

//绘制滑动试图子试图
- (void)initScrollView
{
    //申请密码
    NSArray *firstViewtitle = @[@"公司代码",@"用户名",@"验证码"];
    for (int i = 0; i < 3; i++) {
        UILabel *firstViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100 + 50 * i, 80, 30)];
        firstViewLabel.text = firstViewtitle[i];
        [_mainScrollView addSubview:firstViewLabel];
    }
    
    _gsdmTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, TFwidth, 30)];
    _gsdmTF.placeholder = @"请输入公司代码";
    _gsdmTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mainScrollView addSubview:_gsdmTF];
    
    _userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 150, TFwidth, 30)];
    _userNameTF.placeholder = @"请输入用户名(默认为手机号)";
    _userNameTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mainScrollView addSubview:_userNameTF];
    
    _checkTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, TFwidth / 2.0, 30)];
    _checkTF.placeholder = @"6位数字验证码";
    _checkTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mainScrollView addSubview:_checkTF];
    
    _firstnextbutton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 150) / 2.0, 250, 150, 40)];
    _firstnextbutton.clipsToBounds = YES;
    _firstnextbutton.layer.cornerRadius = 10;
    [_firstnextbutton setTitle:@"下一步" forState:UIControlStateNormal];
    [_firstnextbutton setBackgroundColor:Mycolor];
    [_firstnextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_firstnextbutton addTarget:self action:@selector(nextbutton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_firstnextbutton];
    
    _acquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_acquireButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _acquireButton.frame = CGRectMake(_checkTF.right + 10, _checkTF.top, 80, 30);
    [_acquireButton setTitleColor:ColorRGB(228, 76, 45) forState:UIControlStateNormal];
    [_acquireButton setBackgroundColor:ColorRGB(240, 240, 240)];
    _acquireButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _acquireButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _acquireButton.layer.cornerRadius = 7;
    [_acquireButton addTarget:self action:@selector(requestGetRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_acquireButton];
    
    //修改密码
    NSArray *secondViewtitle = @[@"新密码",@"确认密码"];
    for (int i = 0; i < 2; i++) {
        UILabel *secondViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth + 20, 150 + 50 * i, 80, 30)];
        secondViewLabel.text = secondViewtitle[i];
        [_mainScrollView addSubview:secondViewLabel];
    }
    
    _newpsTF = [[UITextField alloc] initWithFrame:CGRectMake(KScreenWidth + 100, 150, TFwidth, 30)];
    _newpsTF.placeholder = @"请输入新密码";
    _newpsTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mainScrollView addSubview:_newpsTF];
    
    _checkpsTF = [[UITextField alloc] initWithFrame:CGRectMake(KScreenWidth + 100, 200, TFwidth, 30)];
    _checkpsTF.placeholder = @"确认新密码";
    _checkpsTF.borderStyle = UITextBorderStyleRoundedRect;
    [_mainScrollView addSubview:_checkpsTF];
    
    _secondnextbutton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth + ((KScreenWidth - 150) / 2.0), 250, 150, 40)];
    _secondnextbutton.clipsToBounds = YES;
    _secondnextbutton.layer.cornerRadius = 10;
    [_secondnextbutton setTitle:@"下一步" forState:UIControlStateNormal];
    [_secondnextbutton setBackgroundColor:Mycolor];
    [_secondnextbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_secondnextbutton addTarget:self action:@selector(nextbutton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_secondnextbutton];
    
    
    //修改成功
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth * 2 + 20, 200, KScreenWidth - 40, 40)];
    successLabel.text = @"密码修改成功,请重新登陆！";
    successLabel.textAlignment = NSTextAlignmentCenter;
    [_mainScrollView addSubview:successLabel];
    
    _loadbutton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth * 2 + ((KScreenWidth - 150) / 2.0), 250, 150, 40)];
    _loadbutton.clipsToBounds = YES;
    _loadbutton.layer.cornerRadius = 10;
    [_loadbutton setTitle:@"重新登陆" forState:UIControlStateNormal];
    [_loadbutton setBackgroundColor:Mycolor];
    [_loadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loadbutton addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_loadbutton];

}

#pragma makr - 返回事件
- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 按钮事件
- (void)nextbutton:(UIButton *)button
{
    if ([button isEqual:_firstnextbutton]) {
        [self changetoptitleIndex:1];
    } else if ([button isEqual:_secondnextbutton]){
        [self changetoptitleIndex:2];
    }
}

//获取验证码
- (void)requestGetRegisterAction:(UIButton *)button
{
    if (_userNameTF.text.length == 0) {
        [BasicControls showAlertWithMsg:@"请输入手机号" addTarget:nil];
        return;
    } else if (_userNameTF.text.length < 11) {
        [BasicControls showAlertWithMsg:@"请输入11位有效手机号" addTarget:nil];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码已发" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.tag = 100002;
    [alertView show];
    //网络请求获取验证码
    _acquireButton.enabled = NO;
    [_acquireButton setTitle:@"60s" forState:UIControlStateNormal];
    [_acquireButton setUserInteractionEnabled:NO];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerText:) userInfo:nil repeats:YES];
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

//改变顶部位置位置
-(void)changetoptitleIndex:(float)index
{
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = _lineView.frame;
        rect.origin.x = index * titleWidth;
        _lineView.frame = rect;
    } completion:nil];
    
    [_mainScrollView setContentOffset:CGPointMake(KScreenWidth * index, 0)];
    
    for (int i = 0; i < 3; i++) {
        UIView *numbg = [self.view viewWithTag:12010 + i];
        UILabel *label = [self.view viewWithTag:12020 + i];
        UILabel *titleLabel = [self.view viewWithTag:12030 + i];
        
        if (i == index) {
            numbg.backgroundColor = Mycolor;
            label.textColor = [UIColor whiteColor];
            titleLabel.textColor = Mycolor;
        } else {
            numbg.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
            label.textColor = [UIColor grayColor];
            titleLabel.textColor = [UIColor grayColor];
        }
    }
}
@end
