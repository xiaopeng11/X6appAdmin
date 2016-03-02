//
//  UIViewController+ThemeNavigationController.h
//  project-x6
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ThemeNavigationController)
@property(nonatomic,assign)BOOL selectPersons;
/**
 *  上传文件
 *
 *  @param uuid UUID
 */
- (void)unloadFileWithUuid:(NSString *)uuid Filepath:(NSString *)filepath FileName:(NSString *)fileName group:(dispatch_group_t)group;

/**
 *  提示
 *
 *  @param name 提示文本
 */
- (void)writeWithName:(NSString *)name;

/**
 *  白色标题
 *
 *  @param text 标题文本
 */
- (void)naviTitleWhiteColorWithText:(NSString *)text;


/**
 *  导航栏右侧视图
 *
 *  @param navbar 导航栏
 *
 *  @return 按钮视图
 */

- (UIView *)findRightBarItemView:(UINavigationBar *)navbar;

/**
 *  图片尺寸压缩
 *
 *  @param UIImage 图片
 *
 *  @return 压缩后的图片
 */
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**
 *  保存图片至沙盒
 *
 *  @return nil
 */
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;

/**
 *  清楚图片缓存
 *
 *
 */
- (void)deleteImageFile;
@end
