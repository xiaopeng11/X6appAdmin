//
//  BasicControls.h
//  MasterplateDemo
//
//  Created by diudiu on 15/7/30.
//  Copyright (c) 2015年 diudiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicControls : NSObject


+(UITextField  *)createTextFieldWithframe:(CGRect)rect
                                addTarget:(id)target
                                    image:(UIImage *)backGroudImage;

+ (void)setLeftImageViewToTextField:(UITextField *)field;

+(UIImage *)getImageWithName:(NSString *)imageName type:(NSString *)imageType;

+(UILabel  *)createLabelWithframe:(CGRect)rect
                            image:(UIImage *)backGroudImage;

+(void)showAlertWithMsg:(NSString *)msg
              addTarget:(id)target;

+(UIImageView  *)createImageViewWithframe:(CGRect )rect
                                    image:(UIImage *)backGroudImage;

+(UIButton  *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect )rect
                              image:(UIImage *)backGroudImage;

+ (void)showNDKNotifyWithMsg:(NSString *)showMsg
                WithDuration:(CGFloat)duration
                       speed:(CGFloat)speed;

+ (BOOL)isNewVersion;


+ (UIView *)drawLineWithFrame:(CGRect)frame;

@end
