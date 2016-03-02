//
//  Error.h
//  WeiBo
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Error;

//创建一个协议---原因：因为按钮事件要调用控制器里的方法---可以用协议或者block实现这个功能
@protocol ErrorDelegate <NSObject>

- (void)errorView:(Error *)errorView reloadViewWithMessage:(NSString *)message;

@end

@interface Error : UIView
{
    UIButton *_errorButton;
}

@property(nonatomic,weak) id<ErrorDelegate> delegate;
@end
