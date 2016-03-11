//
//  YearAndMonthDatePicker.h
//  project-x6
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMDatePicker.h"

@interface YearAndMonthDatePicker : UITextField<UITextFieldDelegate>

{
    UILabel *label;
}

@property(nonatomic,strong)YMDatePicker *datePicker;  //日期选择
@property(nonatomic,strong)NSString *labelString;            //提示文本
@property(nonatomic,strong)UIView *subView;           //背景
@property(nonatomic,strong)NSDateFormatter *dateFormatter;  //日期的样式
- (instancetype)initWithFrame:(CGRect)frame Date:(NSString *)dateString;
@end
