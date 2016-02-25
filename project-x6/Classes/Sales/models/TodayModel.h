//
//  TodayModel.h
//  project-x6
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayModel : NSObject
/**
 *  {
 message = ok;
 rows =     (
 {
 col0 = 25;
 col1 = "\U5c0f\U7c73-4\U767d\U8272(64G)";
 col2 = 1;
 col3 = 0;
 },
 */

@property(nonatomic,copy)NSNumber *col0;
@property(nonatomic,copy)NSString *col1;
@property(nonatomic,copy)NSNumber *col2;
@property(nonatomic,copy)NSNumber *col3;

@end
