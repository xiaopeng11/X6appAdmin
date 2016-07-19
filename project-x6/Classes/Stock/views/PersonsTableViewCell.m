//
//  PersonsTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PersonsTableViewCell.h"

@implementation PersonsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //背景颜色
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 39, 39)];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 19.5;
        _imageView.hidden = YES;
        [self.contentView addSubview:_imageView];
        
        
        _noheaderViewView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 39, 39)];
        _noheaderViewView.clipsToBounds = YES;
        _noheaderViewView.layer.cornerRadius = 19.5;
        _noheaderViewView.hidden = YES;
        [self.contentView addSubview:_noheaderViewView];
        
        _headerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 39, 39)];
        _headerViewLabel.font = MainFont;
        _headerViewLabel.textAlignment = NSTextAlignmentCenter;
        _headerViewLabel.hidden = YES;
        [_noheaderViewView addSubview:_headerViewLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(59, 10.5, 200, 25)];
        _nameLabel.font = MainFont;
        [self.contentView addSubview:_nameLabel];
        
        _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(59, 36.5, KScreenWidth - 60 - 40, 16)];
        _companyLabel.font = ExtitleFont;
        _companyLabel.textColor = ExtraTitleColor;
        [self.contentView addSubview:_companyLabel];
    
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSString *userName = [self.dic valueForKey:@"name"];
    _nameLabel.text = userName;

    _companyLabel.text = [NSString stringWithFormat:@"%@  %@",[self.dic valueForKey:@"ssgsname"],[self.dic valueForKey:@"gw"]];

    //判断当前是操作员还是员工
    //图片
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *diced = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [diced objectForKey:@"gsdm"];
    NSString *headerURLString = nil;
    NSString *headerVeiewpic = [self.dic objectForKey:@"userpic"];
    if (headerVeiewpic.length == 0) {
        _imageView.hidden = YES;
        _noheaderViewView.hidden = NO;
        _headerViewLabel.hidden = NO;
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
        _noheaderViewView.backgroundColor = (UIColor *)array[x];
        _headerViewLabel.text = [userName substringWithRange:NSMakeRange(userName.length - 2, 2)];
        _headerViewLabel.textColor = [UIColor whiteColor];
    } else {
        _headerViewLabel.hidden = YES;
        _noheaderViewView.hidden = YES;
        _imageView.hidden = NO;
        if ([[self.dic valueForKey:@"usertype"] intValue] == 0) {
            //操作员
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[self.dic objectForKey:@"userpic"]];
        } else {
            //员工
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[self.dic objectForKey:@"userpic"]];
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:headerURLString] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    }
  
    
    
}
@end
