//
//  Error.m
//  WeiBo
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "Error.h"

@implementation Error

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        创建按钮
        _errorButton = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, (KScreenHeight - 50) / 2.0, 100, 50)];
        [_errorButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_errorButton setTitleColor:Mycolor forState:UIControlStateNormal];
        [_errorButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_errorButton addTarget:self action:@selector(buttonaction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_errorButton];
    }
    return self;
}


#pragma mark - 按钮事件
- (void)buttonaction:(UIButton *)button
{
    if (self.superview != nil) {
        //移除加载视图
        [self removeFromSuperview];
    }
    
    
    //调用协议的方法
    if ([self.delegate respondsToSelector:@selector(errorView:reloadViewWithMessage:)]) {
        //执行了协议
        [self.delegate errorView:self reloadViewWithMessage:button.titleLabel.text];
    }
}

@end
