//
//  PictureCollectionViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化子视图
        _view = [[UIView alloc] initWithFrame:CGRectZero];
        _view.userInteractionEnabled = YES;
        [self.contentView addSubview:_view];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        [_view addSubview:_imageView];
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textAlignment = NSTextAlignmentCenter;
        [_view addSubview:_title];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = (KScreenWidth - 80) / 3.0;
    _view.frame = CGRectMake(0, 0, width, width);
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    
    _imageView.frame = CGRectMake(10, 0, width - 20, width - 20);

    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",X6_personMessage,companyString,self.model.filename];
    NSURL *url = [NSURL URLWithString:urlString];
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"moren_tupian_"]];
  
    
    _title.frame = CGRectMake(0, _imageView.bottom, width, 20);
    _title.text = self.model.shortname;
    
}
@end
