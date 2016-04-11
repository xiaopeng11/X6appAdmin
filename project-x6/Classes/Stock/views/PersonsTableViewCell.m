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
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 20;
        _imageView.hidden = YES;
        [self.contentView addSubview:_imageView];
        
        
        _noheaderViewView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _noheaderViewView.clipsToBounds = YES;
        _noheaderViewView.layer.cornerRadius = 20;
        _noheaderViewView.hidden = YES;
        [self.contentView addSubview:_noheaderViewView];
        
        _headerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _headerViewLabel.font = [UIFont systemFontOfSize:15];
        _headerViewLabel.textAlignment = NSTextAlignmentCenter;
        _headerViewLabel.hidden = YES;
        [_noheaderViewView addSubview:_headerViewLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 25)];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_nameLabel];
        
        _companyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _companyLabel.font = [UIFont systemFontOfSize:10];
        _companyLabel.textColor = Mycolor;
        [self.contentView addSubview:_companyLabel];
    
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _nameLabel.text = self.name;

    //判断当前是操作员还是员工
    //图片
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    NSString *headerURLString = nil;
    
    
    for (NSDictionary *diced in _datalist) {
        if ([[diced valueForKey:@"name"] isEqualToString:self.name]) {
            _companyLabel.frame = CGRectMake(60, 40, KScreenWidth - 60 - 40, 10);
            _companyLabel.text = [NSString stringWithFormat:@"%@  %@",[diced valueForKey:@"ssgsname"],[diced valueForKey:@"gw"]];
            NSString *headerVeiewpic = [diced objectForKey:@"userpic"];
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
                _headerViewLabel.text = [self.name substringWithRange:NSMakeRange(self.name.length - 2, 2)];
                _headerViewLabel.textColor = [UIColor whiteColor];
            } else {
                _headerViewLabel.hidden = YES;
                _noheaderViewView.hidden = YES;
                _imageView.hidden = NO;
                if ([[diced valueForKey:@"usertype"] intValue] == 0) {
                    //操作员
                    headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[diced objectForKey:@"userpic"]];
                } else {
                    //员工
                    headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[diced objectForKey:@"userpic"]];
                }
                [_imageView sd_setImageWithURL:[NSURL URLWithString:headerURLString] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
            }
            
            
            
            
            
            
        }
    }
  
    
    
}
@end
