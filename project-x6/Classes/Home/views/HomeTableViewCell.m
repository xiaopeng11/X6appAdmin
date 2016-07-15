//
//  HomeTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIButton+WebCache.h"
#import "HeaderViewController.h"
#import "MyDynamicViewController.h"

#import "TxtViewController.h"

#import "NSString+Additions.h"

#import "XPPhotoViews.h"

@implementation HomeTableViewCell
{
    UIImageView *postBGView;            //整个的背景
    UIView *_lineView;                   //灰色分隔栏
    UIButton *_userHeaderButton;        //用户头像
    UIImageView *cornerImage;           //头像的边框图片

    MLEmojiLabel *_contentLabel;        //发布内容
    UIImageView *_filepropImageView;    //图片背景
    UIImageView *_replyImageView;       //回复图片
    UILabel *_replyCounts;              //回复数
    
    BOOL drawed;
    NSInteger drawColorFlag;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子视图
        //清楚背景试图
        
        self.backgroundView = nil;
        self.backgroundColor = GrayColor;
        self.userInteractionEnabled = YES;
        
        //设置子视图
        postBGView = [[UIImageView alloc] initWithFrame:CGRectZero];
        postBGView.backgroundColor = [UIColor whiteColor];
        postBGView.userInteractionEnabled = YES;
        [self.contentView insertSubview:postBGView atIndex:0];
        [self addlabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        _lineView.backgroundColor = GrayColor;
        [postBGView addSubview:_lineView];
        
        _userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userHeaderButton.frame = CGRectMake(10, 25, 39, 39);
        [_userHeaderButton addTarget:self action:@selector(HeaderAction:) forControlEvents:UIControlEventTouchUpInside];
        [postBGView addSubview:_userHeaderButton];
        
        //头像背景视图
        cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 22.5, 44, 44)];
        cornerImage.image = [UIImage imageNamed:@"corner_circle"];
        [postBGView addSubview:cornerImage];
        
        //图片
        _filepropImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _filepropImageView.hidden = YES;
        _filepropImageView.userInteractionEnabled = YES;
        _filepropImageView.backgroundColor = [UIColor whiteColor];
        [postBGView addSubview:_filepropImageView];
    
        //回复图片
        _replyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [postBGView addSubview:_replyImageView];
    }
    return self;
}

- (void)addlabel
{
    if (_contentLabel) {
        _contentLabel = nil;
    }
    
    //文本
    _contentLabel = [[MLEmojiLabel alloc] initWithFrame:[_data[@"contentframe"] CGRectValue]];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineSpacing = 8;
    _contentLabel.font = MainFont;
    [postBGView addSubview:_contentLabel];
}

- (void)setData:(NSDictionary *)data{
    if (_data != data) {
        _data = data;
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
        NSString *companyString = [dic objectForKey:@"gsdm"];
        
        //设置属性
        //头像
        //通过usertype判断员工还是营业员
        NSString *headerURLString = nil;
        NSString *headerpic = [data valueForKey:@"userpic"];
        if (headerpic.length == 0) {
            NSArray *array = @[[UIColor colorWithRed:161/255.0f green:136/255.0f blue:127/255.0f alpha:1],
                               [UIColor colorWithRed:246/255.0f green:94/255.0f blue:141/255.0f alpha:1],
                               [UIColor colorWithRed:238/255.0f green:69/255.0f blue:66/255.0f alpha:1],
                               [UIColor colorWithRed:245/255.0f green:197/255.0f blue:47/255.0f alpha:1],
                               [UIColor colorWithRed:255/255.0f green:148/255.0f blue:61/255.0f alpha:1],
                               [UIColor colorWithRed:107/255.0f green:181/255.0f blue:206/255.0f alpha:1],
                               [UIColor colorWithRed:94/255.0f green:151/255.0f blue:246/255.0f alpha:1],
                               [UIColor colorWithRed:154/255.0f green:137/255.0f blue:185/255.0f alpha:1],
                               [UIColor colorWithRed:106/255.0f green:198/255.0f blue:111/255.0f alpha:1],
                               [UIColor colorWithRed:120/255.0f green:192/255.0f blue:110/255.0f alpha:1]];
            
            int x = arc4random() % 10;
            [_userHeaderButton setBackgroundColor:(UIColor *)array[x]];
            NSString *lastTwoName = _data[@"name"];
            lastTwoName = [lastTwoName substringWithRange:NSMakeRange(lastTwoName.length - 2, 2)];
            [_userHeaderButton setTitle:lastTwoName forState:UIControlStateNormal];
        } else {
            if ([[data valueForKey:@"userType"] intValue] == 0) {
                headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[data valueForKey:@"userpic"]];
            } else {
                headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[data valueForKey:@"userpic"]];
            }
            NSURL *headerURL = [NSURL URLWithString:headerURLString];
            if (headerURLString) {
                [_userHeaderButton sd_setBackgroundImageWithURL:headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
                [_userHeaderButton setTitle:@"" forState:UIControlStateNormal];
            }
            
        }
        
        //回复图片位置
        NSValue *frame = _data[@"frame"];
        CGRect rect = [frame CGRectValue];
        CGFloat reply_y = rect.size.height - 15 - 20;
        CGFloat reply_x = KScreenWidth - 30 - 8 - 25;
        _replyImageView.frame = CGRectMake(reply_x, reply_y, 21, 20);
        _replyImageView.image = [UIImage imageNamed:@"g1_b"];
        
    }
  
}

- (void)draw
{
    if (drawed) {
        return;
    }
    NSInteger flag = drawColorFlag;
    drawed = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect rect = [_data[@"frame"] CGRectValue];
        //开始绘画
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor whiteColor] set];
        CGContextFillRect(context, rect);
        //发布人的名称 时间
        {
            float leftX = 59;
            float x = leftX;
            float y = 30;
            float size = KScreenWidth - leftX - 10;
            [_data[@"name"] drawInContext:context withPosition:CGPointMake(x, y) andFont:MainFont andTextColor:[UIColor blackColor] andHeight:rect.size.height andWidth:size];
            
            y += 20;
            NSString *dateString = [_data[@"fsrq"] substringFromIndex:5];
            [dateString drawInContext:context withPosition:CGPointMake(x, y) andFont:ExtitleFont andTextColor:ExtraTitleColor andHeight:rect.size.height andWidth:size];
        }
        
        //公司 岗位
        {
            CGFloat totalheight = rect.size.height - 20 - 15;
            float fromeX = 10;
            float size = KScreenWidth - 20 - 63;
            NSString *xinxi = [NSString stringWithFormat:@"%@  %@",[_data valueForKey:@"ssgsname"],[_data valueForKey:@"gw"]];
            [xinxi drawInContext:context withPosition:CGPointMake(fromeX, totalheight) andFont:ExtitleFont andTextColor:ExtraTitleColor andHeight:rect.size.height andWidth:size];
        }
        
        //评论
        {
            float leftX = KScreenWidth - 20 - 10;
            CGFloat y = rect.size.height - 15 - 20;
            float replyCount = [_data[@"replayCount"] doubleValue];
            float size = 20;
            NSString *replycount = nil;
            if (replyCount < 100) {
                replycount = [NSString stringWithFormat:@"%.0f",replyCount];
            } else {
                replycount = @"99+";
            }
            [replycount drawInContext:context withPosition:CGPointMake(leftX, y) andFont:ExtitleFont andTextColor:[UIColor blackColor] andHeight:rect.size.height andWidth:size];
            
        }
        {
            CGPoint posts[2];
            posts[0] = CGPointMake(0, rect.size.height);
            posts[1] = CGPointMake(KScreenWidth, rect.size.height);
            CGContextAddLines(context, posts, 2);
            CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
            
        }
        
        // 完成绘画
        UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (flag == drawColorFlag) {
                postBGView.frame = rect;
                postBGView.image = nil;
                postBGView.image = temp;
            }
        });
        
    });
    
    [self drawtext];
    [self loadImages];

}

- (void)drawtext
{
    if (_contentLabel == nil) {
        [self addlabel];
    }
    _contentLabel.frame = [_data[@"contentframe"] CGRectValue];
    _contentLabel.text = _data[@"content"];
    
}


- (void)loadImages
{
    NSString *content = _data[@"content"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *attributes = @{NSFontAttributeName:MainFont,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [content boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    float y = 74 + size.height + 10;
    NSString *filepropstring = [_data valueForKey:@"fileprop"];
    NSArray *fileprop = [filepropstring objectFromJSONString];
    if (fileprop.count > 0) {
        _filepropImageView.hidden = NO;

        if (fileprop.count == 4) {
            _filepropImageView.frame = CGRectMake(10, y, (PuretureSize * 2) + 5, (PuretureSize * 2) + 5);
        } else {
            _filepropImageView.frame = CGRectMake(10, y, ((PuretureSize + 5) * (fileprop.count - 1)) + PuretureSize, PuretureSize);
        }
        
        int filepropwidth,filepropheight;
        for (int i = 0; i < fileprop.count; i++) {
            NSArray *endfile = [[fileprop[i] valueForKey:@"name"] componentsSeparatedByString:@"."];
            if ([endfile[1] isEqualToString:@"doc"] || [endfile[1] isEqualToString:@"docx"] || [endfile[1] isEqualToString:@"xlsx"] || [endfile[1] isEqualToString:@"ppt"] || [endfile[1] isEqualToString:@"txt"] || [endfile[1] isEqualToString:@"pptx"]) {
                UIImageView *wengdanView = [[UIImageView alloc] init];
                wengdanView.userInteractionEnabled = YES;
                if (fileprop.count == 4) {
                    filepropwidth = i / 2;
                    filepropheight = i % 2;
                    wengdanView.frame = CGRectMake((PuretureSize + 5) * filepropheight, (PuretureSize + 5) * filepropwidth, PuretureSize, PuretureSize);
                } else {
                    wengdanView.frame = CGRectMake((PuretureSize + 5) * i, 0, PuretureSize, PuretureSize);
                }
                wengdanView.tag = 5100 + i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wendangtapAction:)];
                [wengdanView addGestureRecognizer:tap];
                [_filepropImageView addSubview:wengdanView];
                
                if ([endfile[1] isEqualToString:@"doc"] || [endfile[1] isEqualToString:@"docx"]) {
                    wengdanView.image = [UIImage imageNamed:@"btn-wendang1-n"];
                } else if ([endfile[1] isEqualToString:@"xlsx"]){
                    wengdanView.image = [UIImage imageNamed:@"btn-wendang2-n"];
                } else if ([endfile[1] isEqualToString:@"ppt"] || [endfile[1] isEqualToString:@"pptx"]) {
                    wengdanView.image = [UIImage imageNamed:@"btn-wendang3-n"];
                } else if ([endfile[1] isEqualToString:@"txt"]) {
                    wengdanView.image = [UIImage imageNamed:@"btn-wendang4-n"];
                }
            } else {
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
                NSString *companyString = [dic objectForKey:@"gsdm"];
                NSMutableArray *picsURL = [NSMutableArray array];
                for (NSDictionary *dic in fileprop) {
                    NSString *imageurlString = [dic objectForKey:@"name"];
                    NSString *picURLString = [NSString stringWithFormat:@"%@%@/%@",X6_personMessage,companyString,imageurlString];
                    [picsURL addObject:picURLString];
                }
                XPPhotoViews *photos = [[XPPhotoViews alloc] initWithFrame:_filepropImageView.bounds];
                photos.picsArray = picsURL;
                [_filepropImageView addSubview:photos];
            }
        }
    } else {
        _filepropImageView.hidden = YES;
    }
   
}

/**
 *  当附件为文档的点击事件
 *
 *  @param button nil
 */
- (void)wendangtapAction:(UITapGestureRecognizer *)tap
{
    TxtViewController *knowledVC = [[TxtViewController alloc] init];
    NSString *filepropstring = _data[@"fileprop"];
    NSArray *fileprop = [filepropstring objectFromJSONString];
    knowledVC.txtString = [[fileprop[tap.view.tag - 5100] valueForKey:@"name"] substringFromIndex:37];
    [self.ViewController.navigationController pushViewController:knowledVC animated:YES];
}

/**
 *  HeaderAction
 */
- (void)HeaderAction:(UIButton *)button
{
    HeaderViewController *headerVC = [[HeaderViewController alloc] init];
    headerVC.dic = _data;
    [self.ViewController.navigationController pushViewController:headerVC animated:YES];
}


- (void)clear
{
    if (!drawed) {
        return;
    }
    postBGView.frame = CGRectZero;
    postBGView.image = nil;
    for (UIView *imagview in _filepropImageView.subviews) {
        if ([imagview isKindOfClass:[XPPhotoViews class]]) {
            for (UIImageView *photo in imagview.subviews) {
                if (!photo.hidden) {
                    [photo sd_cancelCurrentImageLoad];
                }
            }
        }
        
    }
    
    _filepropImageView.hidden = YES;
    drawColorFlag = arc4random();
    drawed = NO;
}

- (void)releaseMemory{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self clear];
    [super removeFromSuperview];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
