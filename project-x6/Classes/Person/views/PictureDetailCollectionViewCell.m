//
//  PictureDetailCollectionViewCell.m
//  project-x6
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PictureDetailCollectionViewCell.h"

@implementation PictureDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建滑动式图实现缩放
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, KScreenWidth, KScreenHeight)];
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 1.5;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:_imageView];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressAction = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_imageView addGestureRecognizer:longPressAction];
    }
    return self;
}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //放大效果要还原
    _scrollView.zoomScale = 1.0;
    
    _imageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",X6_personMessage,companyString,self.model.filename];
    NSURL *url = [NSURL URLWithString:urlString];
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"moren_tupian_"]];
    
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

#pragma mark - 长安收拾
- (void)longPress:(UILongPressGestureRecognizer *)longpress
{
    //创建底部显示的视图
    if (longpress.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"保存到相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
        actionsheet.delegate = self;
        //显示
        [actionsheet showInView:_imageView];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}


@end
