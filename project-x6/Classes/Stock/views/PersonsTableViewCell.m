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
        [self.contentView addSubview:_imageView];
        
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
@end
