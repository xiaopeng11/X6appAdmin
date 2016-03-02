//
//  XPDatePicker.m
//  DatePicker
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XPDatePicker.h"

@implementation XPDatePicker

- (instancetype)initWithFrame:(CGRect)frame Date:(NSString *)dateString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //默认日期格式为yyyy-MM-dd
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.date = [self.dateFormatter dateFromString:dateString];
        
        self.font = [UIFont systemFontOfSize:11];
        self.textColor = [UIColor whiteColor];
        self.text = dateString;
        
        //半透明背景
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        self.datePicker.layer.cornerRadius = 20;
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.maximumDate = [NSDate date];
        self.datePicker.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 240 - 64, KScreenWidth, 200)];
        view.backgroundColor = [UIColor whiteColor];
        
        self.subView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
        self.subView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        self.subView.tag = 0;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight - 240 - 64 - 30, KScreenWidth, 30)];
        label.textColor = [UIColor blackColor];
        [self.subView addSubview:label];
        
        UIButton *cancleDate = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleDate.frame = CGRectMake(0, KScreenHeight - 40 - 64, KScreenWidth / 2.0, 40);
        cancleDate.backgroundColor = Mycolor;
        [cancleDate setTitle:@"取消" forState:UIControlStateNormal];
        [cancleDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancleDate addTarget:self action:@selector(cancledateChange) forControlEvents:UIControlEventTouchUpInside];
        [self.subView addSubview:cancleDate];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth / 2.0, KScreenHeight - 40 - 64, 1, 40)];
        lineview.backgroundColor = [UIColor blackColor];
        [self.subView addSubview:lineview];
        
        UIButton *chooseDate = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseDate.frame = CGRectMake(KScreenWidth / 2.0 + 1, KScreenHeight - 40 - 64, KScreenWidth / 2.0 - 1, 40);
        chooseDate.backgroundColor = Mycolor;
        [chooseDate setTitle:@"确定" forState:UIControlStateNormal];
        [chooseDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chooseDate addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.subView addSubview:chooseDate];
        
       

        UITapGestureRecognizer *pickerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancledateChange)];
        [self.subView addGestureRecognizer:pickerTap];
        [view addSubview:self.datePicker];

        
       
        [self.subView addSubview:view];
        
        //设置输入框
        self.delegate=self;
        
        self.borderStyle=UITextBorderStyleRoundedRect;
        
        self.text=[self.dateFormatter stringFromDate:self.date];
        

        
        
    }
    return self;
}

- (void)setLabelString:(NSString *)labelString
{
    if (_labelString != labelString) {
        _labelString = labelString;
         label.text = _labelString;
    }
}

#pragma mark - 日期控件点击事件
- (void)dateChange:(id)sender
{
    self.date = [self.datePicker date];//获取datepicker的日期
    
    //改变textField的值
    
    self.text = [NSString stringWithString:[self.dateFormatter stringFromDate:self.date]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTodayData" object:[self.dateFormatter stringFromDate:self.date]];
}

- (void)cancledateChange
{
    if(self.subView != nil){
        
        self.subView.tag = 0;
        
        [self.subView removeFromSuperview];
        
        
    }
}

#pragma mark textField delegate method

//当textField被点击时触发

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.subView.tag==0) {//若tag标志等于0，说明datepicker未显示
        
        //置tag标志为1，并显示子视图
        
        self.subView.tag=1;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.subView];
    }
    return NO;
    
}

@end
