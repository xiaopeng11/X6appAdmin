//
//  AppDelegate.m
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AppDelegate.h"
#import "LoadViewController.h"
#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "StartCarouselViewController.h"
#import "Reachability.h"
#import "BasicControls.h"
#import "ConversationListController.h"

#import "JPUSHService.h"
@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[EaseSDKHelper shareHelper] easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"xp1100#x6" apnsCertName:@"chatdemos" otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    //注册apns
    [self registerRemoteNotification];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //检查网络
    [self checkNetWorkState];
    
    //设置极光推送
    [self settingJpushMothed:launchOptions];
    
    //设置加载动画
    [GiFHUD setGifWithImageName:@"pika.gif"];
    
    //判断是否已经登陆    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *userURL = [userdefaults objectForKey:X6_UseUrl];
    
    if ([BasicControls isNewVersion]) {
        StartCarouselViewController *startVC = [[StartCarouselViewController alloc] init];
        _window.rootViewController = startVC;
    } else if (userURL.length == 0) {
        LoadViewController *loadVC = [[LoadViewController alloc] init];
        _window.rootViewController = loadVC;
    } else {
        //重新登录环信号
        NSString *EaseID = [NSString stringWithFormat:@"%@%@",[[userdefaults objectForKey:X6_UserMessage] valueForKey:@"gsdm"],[[userdefaults objectForKey:X6_UserMessage] valueForKey:@"phone"]];
        NSString *password = @"yjxx&*()";
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:EaseID password:password completion:^(NSDictionary *loginInfo, EMError *error) {
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            NSLog(@"环信号登录成功");
        } onQueue:nil];
      
                
        BaseTabBarViewController *baseTBVC = [[BaseTabBarViewController alloc] init];
        _window.rootViewController = baseTBVC;
    }
   
    [_window makeKeyAndVisible];
    return YES;
}

#pragma mark - 检测网络状态
- (void)checkNetWorkState
{
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReach startNotifier];
}

#pragma mark - 检测网络状况Mothed
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"当前网络不给力,请稍后再试"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    
    }
}


- (void)registerRemoteNotification
{
    
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings= [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}


#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - 设置极光推送
- (void)settingJpushMothed:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:@"2a34962b1321290c7871d136" channel:@"Publish channel" apsForProduction:NO];
}

//设置极光推送和环信推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"极光推送获取失败");
}

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [self.stockVC networkChanged:connectionState];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    [self handleNotifacation:userInfo];
    BaseTabBarViewController *baseTar = (BaseTabBarViewController *)self.window.rootViewController;

    [baseTar writeWithName:@"收到离线消息"];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSDictionary *alert = [userInfo objectForKey:@"aps"];
    NSString *string = [alert objectForKey:@"alert"];
    BaseTabBarViewController *baseTar = (BaseTabBarViewController *)self.window.rootViewController;
    if ([string isEqualToString:@"您有一条新消息"]) {
        baseTar.selectedIndex = 1;
    } else {
        baseTar.selectedIndex = 3;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
    
    
    if (application.applicationState == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SamllPoint" object:nil userInfo:nil];
        //操作时间
        NSLog(@"程序收到一条离线推送%@",alert);
        NSLog(@"%@",userInfo);
    } else if (application.applicationState == UIApplicationStateInactive) {
        completionHandler(UIBackgroundFetchResultNewData);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"openMessagePage" object:nil userInfo:nil];
        NSLog(@"程序活跃状态");
    }
    [self handleNotifacation:userInfo];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //    if (_mainController) {
    //        [_mainController didReceiveLocalNotification:notification];
    //    }
    NSLog(@"收到本地通知");
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];

}



- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"appdelegate收到内存警告");
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [JPUSHService resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - 处理推送信息
- (void)handleNotifacation:(NSDictionary *)dic
{
    NSString *from = [dic objectForKey:@"from"];
    if ([from isEqualToString:@"JPush"])
    {
        NSString *text = dic[@"aps"][@"alert"];
        if (!text) {
            text = @"推送格式出错";
        }

        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:text delegate:self cancelButtonTitle:@"稍后再看！" otherButtonTitles:@"查看", nil];
        alterView.tag = 2001;
        [alterView show];
        
        
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}


@end