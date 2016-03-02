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
#import "X6ImageView.h"

@implementation HomeTableViewCell
{
    UIImageView *postBGView;   //整个的背景
    UIButton *_userHeaderButton;        //用户头像
    UIImageView *cornerImage;  //头像的边框图片

    UILabel *_userNameLabel;            //用户姓名
    UILabel *_companyLabel;             //公司
    UILabel *_dateLabel;                //发布时间
    MLEmojiLabel *_contentLabel;              //发布内容
    UIImageView *_filepropImageView;         //图片背景
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
        self.userInteractionEnabled = YES;
        
        //设置子视图
        postBGView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView insertSubview:postBGView atIndex:0];
        [self addlabel];
        
        _userHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userHeaderButton.frame = CGRectMake(10, 10, 40, 40);
        [_userHeaderButton addTarget:self action:@selector(HeaderAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_userHeaderButton];
        
        //头像背景视图
        cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 45, 45)];
        cornerImage.image = [UIImage imageNamed:@"corner_circle"];
        [self.contentView addSubview:cornerImage];
        
        //图片
        _filepropImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _filepropImageView.hidden = YES;
        _filepropImageView.userInteractionEnabled = YES;
        _filepropImageView.backgroundColor = self.backgroundColor;
        [self.contentView addSubview:_filepropImageView];
    
        
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
    _contentLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_contentLabel];
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
        if ([[data valueForKey:@"userType"] intValue] == 0) {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[data valueForKey:@"userpic"]];
        } else {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[data valueForKey:@"userpic"]];
        }
        NSURL *headerURL = [NSURL URLWithString:headerURLString];
        if (headerURLString) {
            [_userHeaderButton sd_setBackgroundImageWithURL:headerURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pho-moren"] options:SDWebImageLowPriority];
        }
        
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
        //发布人的性命 岗位 公司 时间
        {
            float leftX = 60;
            float x = leftX;
            float y = 5;
            float size = KScreenWidth - leftX - 60;
            [_data[@"name"] drawInContext:context withPosition:CGPointMake(x, y) andFont:[UIFont boldSystemFontOfSize:16] andTextColor:[UIColor blackColor] andHeight:rect.size.height andWidth:size];
            y += 20;
            float fromeX = leftX;
            NSString *xinxi = [NSString stringWithFormat:@"%@  %@",[_data valueForKey:@"ssgsname"],[_data valueForKey:@"gw"]];
            [xinxi drawInContext:context withPosition:CGPointMake(fromeX, y) andFont:[UIFont systemFontOfSize:11] andTextColor:Mycolor andHeight:rect.size.height andWidth:size];
            
            y += 17;
            [_data[@"fsrq"] drawInContext:context withPosition:CGPointMake(fromeX, y) andFont:[UIFont systemFontOfSize:11] andTextColor:[UIColor grayColor] andHeight:rect.size.height andWidth:size];
        }
        {
            float leftX = KScreenWidth - 50 - 20;
            float y = 10;
            float replyCount = [_data[@"replayCount"] doubleValue];
            float size = KScreenWidth - 60 - 60;
            NSString *replycount = nil;
            if (replyCount < 100) {
                replycount = [NSString stringWithFormat:@"评论数:%.0f",replyCount];
            } else {
                replycount = @"评论数:99+";
            }
            [replycount drawInContext:context withPosition:CGPointMake(leftX, y) andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor blackColor] andHeight:rect.size.height andWidth:size];
            
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
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [content boundingRectWithSize:CGSizeMake(KScreenWidth - 40, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    float y = 60 + size.height + 10;
    NSString *filepropstring = [_data valueForKey:@"fileprop"];
    NSArray *fileprop = [filepropstring objectFromJSONString];
    if (fileprop.count > 0) {
        _filepropImageView.hidden = NO;

        if (fileprop.count == 4) {
            _filepropImageView.frame = CGRectMake(20, y, 170, 170);
        } else {
            _filepropImageView.frame = CGRectMake(20, y, 85 * fileprop.count, 80);
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
                    wengdanView.frame = CGRectMake(85 * filepropheight, 85 * filepropwidth, 80, 80);
                } else {
                    wengdanView.frame = CGRectMake(85 * i, 0, 80, 80);
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
                X6ImageView *x6imageView = nil;
                if (fileprop.count == 4) {
                    filepropwidth = i / 2;
                    filepropheight = i % 2;
                    x6imageView = [[X6ImageView alloc] initWithFrame:CGRectMake(85 * filepropheight, 85 * filepropwidth, 80, 80)];
                } else {
                    x6imageView = [[X6ImageView alloc] initWithFrame:CGRectMake(85 * i, 0, 80, 80)];
                }
                [_filepropImageView addSubview:x6imageView];
                //获取图片url,截取拼接
                NSDictionary *diced = [fileprop objectAtIndex:i];
                NSString *imageurlString = [diced objectForKey:@"name"];
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",X6_personMessage,companyString,imageurlString];
                [x6imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"moren_tupian_"]];
                
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
    NSLog(@"点击了");
    
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
    NSLog(@"点击了头像");
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
    for (UIImageView *imagview in _filepropImageView.subviews) {
        if (!imagview.hidden) {
            [imagview sd_cancelCurrentImageLoad];
        }
    }
    
    _filepropImageView.hidden = YES;
    drawColorFlag = arc4random();
    drawed = NO;
}

- (void)releaseMemory{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //	if ([self.delegate keepCell:self]) {
    //		return;
    //	}
    [self clear];
    [super removeFromSuperview];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NSLog(@"postview dealloc %@", self);
}

@end
