//
//  YMDatePicker.h
//  yearAndmonthDatepICKER
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMDatePicker : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>


@property(nonatomic,assign)NSInteger rowheight;

@property(nonatomic,strong,readonly)NSDate *date;

- (void)selectDay;

@end
