//
//  X6ImageView.m
//  project-x6
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "X6ImageView.h"
@implementation X6ImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景色和填充模式
//        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor clearColor];
        
        //添加手势
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 点击放大事件
- (void)tapAction
{
    //创建滑动式图
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //添加长安手势
        [_scrollView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)]];
        //添加单击手势
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)]];
        
    }
    
    //设置滑动式图的背景
    _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //添加到window上
    [self.window addSubview:_scrollView];
    
    //放大后的视图
    if (_orginImageView == nil) {
        _orginImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //这填充模式
        _orginImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    //设置放大视图的frame
    _orginImageView.frame = [self convertRect:self.bounds toView:self.window];
    //设置默认图片
    _orginImageView.image = self.image;
    //添加到scrollview中
    [_scrollView addSubview:_orginImageView];
    
    //计算图片的高度
    CGFloat imageheight = _orginImageView.image.size.height / _orginImageView.image.size.width * KScreenWidth;
    //添加动画
    [UIView animateWithDuration:.35 animations:^{
        //设置滑动式图的透明度
        _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
   
        //判断图片的高度
        if (imageheight > _scrollView.height) {
            _orginImageView.frame = CGRectMake(0, 0, KScreenWidth, imageheight);
            //设置滑动视图的偏移量
            _scrollView.contentSize = CGSizeMake(KScreenWidth, imageheight);
        } else {
            _orginImageView.frame = _scrollView.bounds;
            //设置滑动视图的偏移量
            _scrollView.contentSize = _scrollView.frame.size;
        }
        
    } completion:^(BOOL finished) {
        if (_orginImageView != nil) {
            [_orginImageView sd_setImageWithURL:[NSURL URLWithString:_bgImageURL] placeholderImage:_orginImageView.image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, (KScreenHeight - 20) / 2.0, KScreenWidth, 20)];
                [_scrollView addSubview:_progressView];
                _progressView.progress = receivedSize;
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _orginImageView.image = self.image;
                [_progressView removeFromSuperview];
            }];
        }
    }];
    
}

#pragma mark - 长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longpress
{
    //判断当前是长按状态
    if (longpress.state == UIGestureRecognizerStateBegan) {
        //创建底部视图
        //创建底部显示的视图
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"保存到相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
        actionsheet.delegate = self;
        //显示
        [actionsheet showInView:_scrollView];

    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(_orginImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - 单击手势
- (void)tapActions:(UITapGestureRecognizer *)tap
{
    //判断是否在下载
    if (_progressView != nil) {
        [_progressView removeFromSuperview];
    }
    
    //退出大图操作
    [UIView animateWithDuration:.35 animations:^{
        //滑动式图变透明
        _scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _orginImageView.frame = [self convertRect:self.bounds toView:self.window];
    } completion:^(BOOL finished) {
        //移除
        [_scrollView removeFromSuperview];
        [_orginImageView removeFromSuperview];
    }];
}





@end
