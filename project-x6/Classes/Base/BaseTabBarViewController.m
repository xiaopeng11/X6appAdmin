//
//  BaseTabBarViewController.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseTabBarViewController.h"

#import "AllDynamicViewController.h"
#import "StockViewController.h"
#import "BusinessViewController.h"
#import "SalesViewController.h"
#import "PersonViewController.h"

#import "BaseNavigationController.h"

#import "AppDelegate.h"
@interface BaseTabBarViewController ()


@end

@implementation BaseTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化子视图
    [self initViewControllers];
    
    //创建tabbar
    [self initTabBarView];
    
    //网络获取版本
    [self isNetworkNewVersion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

//网络获取版本
- (void)isNetworkNewVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));
    NSString *appVersionString = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSArray *array = [appVersionString componentsSeparatedByString:@"."];
    NSString *appVersion = [NSString stringWithFormat:@"%@%@",array[1],array[2]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:APP_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *infoArray = [responseObject objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseinfo = [infoArray objectAtIndex:0];
            NSString *lastVersionSting = [releaseinfo objectForKey:@"version"];
            
            NSArray *arrayed = [lastVersionSting componentsSeparatedByString:@"."];
            NSString *lastVersion = [NSString stringWithFormat:@"%@%@",arrayed[1],arrayed[2]];
            if ([lastVersion longLongValue] > [appVersion longLongValue]) {
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     NSURL *url = [NSURL URLWithString:[releaseinfo objectForKey:@"trackViewUrl"]];
                    [[UIApplication sharedApplication] openURL:url];
                }];
                UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                [alertcontroller addAction:cancelaction];
                [alertcontroller addAction:okaction];
                [self presentViewController:alertcontroller animated:YES completion:nil];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}



//创建自定义tabbar
- (void)initTabBarView
{
    //创建tabbar
    _customTabBar = [[UITabBar alloc] init];
    
//    更换系统的tabbar
    [self setValue:_customTabBar forKeyPath:@"tabBar"];

}

//初始化所有的子控制器
- (void)initViewControllers
{
    //首页
    AllDynamicViewController *homeVC = [[AllDynamicViewController alloc] init];
    [self addOneChildVC:homeVC title:@"工作圈" selectedImageName:@"a_2" unselectedImageName:@"a_1"];
    
    //联系人
    StockViewController *stockVC = [[StockViewController alloc] init];
    [self addOneChildVC:stockVC title:@"联系人" selectedImageName:@"b_2" unselectedImageName:@"b_1"];
    
    //业务
    BusinessViewController *BusinessVC = [[BusinessViewController alloc] init];
    [self addOneChildVC:BusinessVC title:@"业务" selectedImageName:@"c_2" unselectedImageName:@"c_1"];
    
    //销量
    SalesViewController *salesVC = [[SalesViewController alloc] init];
    [self addOneChildVC:salesVC title:@"报表" selectedImageName:@"d_2" unselectedImageName:@"d_1"];
    
    //我
    PersonViewController *personVC = [[PersonViewController alloc] init];
    [self addOneChildVC:personVC title:@"我" selectedImageName:@"e_2" unselectedImageName:@"e_1"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVC             子控制器对象
 *  @param title               标题
 *  @param selectedImageName   图标
 *  @param unselectedImageName 选中的图标
 */
- (void)addOneChildVC:(UIViewController *)childVC
                title:(NSString *)title
    selectedImageName:(NSString *)selectedImageName
  unselectedImageName:(NSString *)unselectedImageName
{
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    UIImage *unselectedImage = [UIImage imageNamed:unselectedImageName];
    if (iOS7) {
        //如果是iOS7以上的系统，取消自动渲染效果
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:title image:unselectedImage selectedImage:selectedImage];

    barItem.title = title;
    
    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Mycolor} forState:UIControlStateSelected];
    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
//    childVC.view.backgroundColor = [UIColor whiteColor];
    childVC.tabBarItem = barItem;
    
    //添加tabbar控制器的字控制器
    BaseNavigationController *naviVC = [[BaseNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:naviVC];
}

@end
