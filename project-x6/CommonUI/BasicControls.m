//
//  BasicControls.m
//  MasterplateDemo
//
//  Created by diudiu on 15/7/30.
//  Copyright (c) 2015年 diudiu. All rights reserved.
//

#import "BasicControls.h"
#import "BDKNotifyHUD.h"

@implementation BasicControls

+(UITextField  *)createTextFieldWithframe:(CGRect)rect
                                addTarget:(id)target
                                    image:(UIImage *)backGroudImage
{
    UITextField  *textFiled = [[UITextField  alloc]initWithFrame:rect];
    textFiled.backgroundColor = [UIColor  clearColor];
    //解决placeholder在IOS6.0和IOS6.0以上显示兼容问题
    textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFiled setBackground:backGroudImage];
    textFiled.delegate = target;
    return textFiled;
}

+ (void)setLeftImageViewToTextField:(UITextField *)field
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0, field.frame.size.height)];
    [view setBackgroundColor:[UIColor clearColor]];
    [field setLeftView:view];
    [field setLeftViewMode:UITextFieldViewModeAlways];
}

+(UIImage *)getImageWithName:(NSString *)imageName type:(NSString *)imageType
{
    //    NSString *imagePath =[[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
    UIImage *image =[UIImage imageNamed:imageName];
    
    return image;
}

+(UILabel  *)createLabelWithframe:(CGRect)rect
                            image:(UIImage *)backGroudImage
{
    UILabel  *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    //    [label setBackgroundColor:[UIColor colorWithPatternImage:backGroudImage]];
    return label;
    
}

+(void)showAlertWithMsg:(NSString *)msg
              addTarget:(id)target
{
    UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+(UIImageView  *)createImageViewWithframe:(CGRect )rect
                                    image:(UIImage *)backGroudImage
{
    UIImageView  *imageView  = [[UIImageView  alloc]initWithFrame:rect];
    imageView.backgroundColor = [UIColor  clearColor];
    [imageView setImage:backGroudImage];
    return imageView;
    
}

+(UIButton  *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect )rect
                              image:(UIImage *)backGroudImage
{
    UIButton  *button = [UIButton  buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:backGroudImage forState:UIControlStateNormal];
    return button;
    
}

+ (void)showNDKNotifyWithMsg:(NSString *)showMsg  WithDuration:(CGFloat)duration speed:(CGFloat)speed
{
    BDKNotifyHUD *notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:nil] text:showMsg];
    notify.frame = CGRectMake(40, KScreenWidth -  100, 0,0);
    notify.center_X = (KScreenWidth - 250) / 2;
    UIWindow  *window = [[[UIApplication  sharedApplication] delegate] window];
    [window addSubview:notify];
    [notify presentWithDuration:duration speed:speed inView:window completion:^{
        [notify removeFromSuperview];
    }];
}

+ (BOOL)isNewVersion
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastVersion = [defaults objectForKey:SYSTEMVERSION];
    
    //获取当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[SYSTEMVERSION];
    
    if (![currentVersion isEqualToString:lastVersion])
    {
        [defaults setObject:currentVersion forKey:SYSTEMVERSION];
        return YES;
    }else
    {
        return NO;
    }
}



#pragma mark - 绘制风格线
+ (UIView *)drawLineWithFrame:(CGRect)frame
{
    UIView *lineview = [[UIView alloc] initWithFrame:frame];
    lineview.backgroundColor = LineColor;
    return lineview;
}
@end
