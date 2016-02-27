//
//  UIViewController+ThemeNavigationController.m
//  project-x6
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "UIViewController+ThemeNavigationController.h"



@implementation UIViewController (ThemeNavigationController)

@dynamic selectPersons;

/**
 *  联系人确定按钮
 *
 *  @param selectPersons 是否添加
 */

- (void)setSelectPersons:(BOOL)selectPersons
{
    if (selectPersons) {
        //添加确定按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 27, 60, 30);
        [button setBackgroundColor:Mycolor];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

#pragma mark - 返回联系人信息
- (void)sureAction:(UIButton *)button
{
    NSLog(@"确定返回联系人信息");
}


/**
 *  提示
 *
 *  @param name 提示文本
 */
- (void)writeWithName:(NSString *)name
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:name message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertcontroller addAction:cancelaction];
    [alertcontroller addAction:okaction];
    [self presentViewController:alertcontroller animated:YES completion:nil];
}



/**
 *  上传文件
 *
 *  @param uuid uuid
 */
- (void)unloadFileWithUuid:(NSString *)uuid
                  Filepath:(NSString *)filepath
                  FileName:(NSString *)fileName
                    group:(dispatch_group_t)group
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *usemessage = [userdefault objectForKey:X6_UserMessage];
    NSString *userURL = [userdefault objectForKey:X6_UseUrl];
    NSString *userId = [usemessage valueForKey:@"id"];
    NSString *name = [fileName substringWithRange:NSMakeRange(0, fileName.length - 4)];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",userURL,X6_unloadFile];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uuid forKey:@"uuid"];
    [params setObject:userId forKey:@"userId"];
    if (group != nil) {
        dispatch_group_enter(group);
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:filepath] name:name fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上传成功");
        if (group != nil) {
            dispatch_group_leave(group);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败");
        if (group != nil) {
            dispatch_group_leave(group);
        }
    }];

}


/**
 *  标题
 *
 *  @param text 标题文本
 */
- (void)naviTitleWhiteColorWithText:(NSString *)text
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.text = text;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;
}

/**
 *  导航栏右侧视图
 *
 *  @param navbar 导航栏
 *
 *  @return 按钮视图
 */

- (UIView *)findRightBarItemView:(UINavigationBar *)navbar
{
    UIView *rightView = nil;
    for (UIView *view in navbar.subviews) {
        if (rightView == nil) {
            rightView = view;
        } else if (view.frame.origin.x > rightView.frame.origin.x) {
            rightView = view;
        }
    }
    return rightView;
}

/**
 *  图片尺寸压缩
 *
 *  @param UIImage 图片
 *
 *  @return 压缩后的图片
 */
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  保存图片至沙盒
 *
 *  @return nil
 */
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    //压缩图片
    currentImage = [self imageCompressForWidth:currentImage targetWidth:KScreenWidth];
    NSData *imageData = UIImageJPEGRepresentation(currentImage,0.75);
    
    // 获取沙盒目录
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //获取文件夹路径
    NSString *imageDir = [DOCSFOLDER stringByAppendingPathComponent:@"Image"];
    //判断文件夹是否存在，不存在创建
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:imageDir];
    if (!isExit) {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //指定文件夹下创建文件
    NSString *fullPath = [imageDir stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:YES];
}

/**
 *  清楚图片缓存
 *
 *  @param fullpatch 图片路径
 */
- (void)deleteImageFile
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //需要清除的文件路径
    NSString *imageDir = [DOCSFOLDER stringByAppendingPathComponent:@"Image"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:imageDir];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:imageDir error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
    }
}
@end
