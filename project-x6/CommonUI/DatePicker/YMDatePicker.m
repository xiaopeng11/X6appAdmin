//
//  YMDatePicker.m
//  yearAndmonthDatepICKER
//
//  Created by Apple on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YMDatePicker.h"

// Identifiers of components
#define MONTH ( 1 )
#define YEAR ( 0 )


// Identifies for component views
#define LABEL_TAG 43

@interface YMDatePicker ()

@property(nonatomic,strong)NSIndexPath *todayIndexPath;
@property(nonatomic,strong)NSArray *months;
@property(nonatomic,strong)NSArray *years;

@property(nonatomic,assign)NSInteger minYear;
@property(nonatomic,assign)NSInteger maxYear;

@end

@implementation YMDatePicker
const NSInteger bigRowCount = 1000;
const NSInteger numberOfComponents = 2;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //最大的年份和最小的年份
        self.minYear = 2000;
        
        NSString *nowyear = [self currentYearName];
        self.maxYear = [nowyear longLongValue];
        self.rowheight = 44;
        
        //年月的集合以及今天的年月
        self.months = [self nameofMonths];
        self.years = [self nameOfYears];
        self.todayIndexPath = [self todayPath];
        
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - Open methods

- (NSDate *)date
{
    NSInteger monthCount = self.months.count;
    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
    
    NSInteger yearCount = self.years.count;
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@-%@", year, month]];
    return date;
}

- (void)selectDay
{
    [self selectRow: self.todayIndexPath.section
        inComponent: MONTH
           animated: NO];
    
    [self selectRow: self.todayIndexPath.row
        inComponent: YEAR
           animated: NO];
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

- (UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
        NSString *currentMonthName = [self currentMonthName];
        if([monthName isEqualToString:currentMonthName] == YES)
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger yearCount = self.years.count;
        NSString *yearName = [self.years objectAtIndex:(row % yearCount)];
        NSString *currenrYearName  = [self currentYearName];
        if([yearName isEqualToString:currenrYearName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent:component];
    }
    
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowheight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self bigRowMonthCount];
    }
    return [self bigRowYearCount];
}




- (NSArray *)nameofMonths
{
    return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
}

- (NSArray *)nameOfYears
{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = self.minYear; year <= self.maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%li", (long)year];
        [years addObject:yearStr];
    }
    return years;
}

- (NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            section = [self.months indexOfObject:cellMonth];
            section = section + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            row = [self.years indexOfObject:cellYear];
            row = row + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSString *)currentMonthName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"MM"];
    NSLog(@"%@",[formatter stringFromDate:[NSDate date]]);
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)currentYearName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy"];
    NSLog(@"%@",[formatter stringFromDate:[NSDate date]]);
    return [formatter stringFromDate:[NSDate date]];
    
}

#pragma mark - Util

- (NSInteger)bigRowMonthCount
{
    return self.months.count  * bigRowCount;
}

- (NSInteger)bigRowYearCount
{
    return self.years.count  * bigRowCount;
}

- (CGFloat)componentWidth
{
    return self.bounds.size.width / numberOfComponents;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        return [self.months objectAtIndex:(row % monthCount)];
    }
    NSInteger yearCount = self.years.count;
    return [self.years objectAtIndex:(row % yearCount)];
}

- (UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, [self componentWidth], self.rowheight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}


@end
