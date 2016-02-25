//
//  AllSalesCollectionViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AllSalesCollectionViewCell.h"
#define width (KScreenWidth - 50) / 4.0 - 20
@implementation AllSalesCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    //初始化子视图
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width + 20, width + 20)];
        [self.contentView addSubview:_view];
        
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, width, width)];
        _headerView.backgroundColor = [UIColor yellowColor];
        _headerView.clipsToBounds = YES;
        _headerView.layer.cornerRadius = 30;
        [_view addSubview:_headerView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(0, width, width + 20, 20)];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.font = [UIFont systemFontOfSize:18];
        [_view addSubview:_name];
    
     
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    
    //取出个人数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    //公司代码
    NSString *gsdm = [userInformation objectForKey:@"gsdm"];
    NSString *ygImageUrl = [self.dic objectForKey:@"col2"];
    [_headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,ygImageUrl]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    
    _name.text = [self.dic valueForKey:@"col1"];
    
    
}



























@end
