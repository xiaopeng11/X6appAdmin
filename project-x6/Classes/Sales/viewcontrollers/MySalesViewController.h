//
//  MySalesViewController.h
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "XPDatePicker.h"
@interface MySalesViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITextFieldDelegate>
{
    NSString *_dateString;        //当前的时间
    NSString *_firstDayString;    //当前月份的第一天
    UIView *_totalNumberViews;    //总计  
    
    XPDatePicker *_FirstDatePicker;      //第一个textfield
    XPDatePicker *_SecondDatePicker;     //第二个textfield
}


@end
