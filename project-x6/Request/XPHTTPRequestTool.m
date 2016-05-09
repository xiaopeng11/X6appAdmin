//
//  XPHTTPRequestTool.m
//  project-x6
//
//  Created by Apple on 15/12/17.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XPHTTPRequestTool.h"

@implementation XPHTTPRequestTool
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
//http://192.168.1.199:8080/test44/msg/msgAction_getAppMsg.action

+ (void)requestMothedWithPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    //获得请求管理者
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    // 设置cookie
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.responseSerializer.acceptableContentTypes = [requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
   
    
    requestManager.requestSerializer.timeoutInterval = 10;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *cookiedata = [userDefaults objectForKey:X6_Cookie];

    if (cookiedata.length) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiedata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    
    //发送POST请求
    [requestManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setObject:data forKey:X6_Cookie];
            [userDefaults synchronize];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
//            [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];

        }
    }];
}
@end
