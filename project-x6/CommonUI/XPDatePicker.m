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
        //默认日期格式为yyyy-MM-dd
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        [self.dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.date = [self.dateFormatter dateFromString:dateString];
        
        self.text = dateString;
        //半透明背景
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, 30, KScreenWidth, 200)];
        self.datePicker.layer.cornerRadius = 20;
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.maximumDate = [NSDate date];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        self.subView = [[UIView alloc] initWithFrame:CGRectMake(0, 149, KScreenWidth, KScreenHeight  - 64 - 49 - 40)];
        self.subView.backgroundColor = [UIColor whiteColor];
        self.subView.tag = 0;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        label.textColor = [UIColor blackColor];
        
        [self.subView addSubview:label];
        
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.subView addGestureRecognizer:tap];
        
        [self.subView addSubview:self.datePicker];
        
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
    self.date = [sender date];//获取datepicker的日期
    
    //改变textField的值
    
    self.text=[NSString stringWithString:[self.dateFormatter stringFromDate:self.date]];
}

#pragma mark textField delegate method

//当textField被点击时触发

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.subView.tag==0) {//若tag标志等于0，说明datepicker未显示
        
        //置tag标志为1，并显示子视图
        
        self.subView.tag=1;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.subView];
    }
    NSLog(@"点击了视图");
    return NO;
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if(self.subView != nil){
        
        self.subView.tag=0;
        
        [self.subView removeFromSuperview];
        
    }
}
@end
