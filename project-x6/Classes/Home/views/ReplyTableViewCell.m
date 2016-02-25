//
//  ReplyTableViewCell.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ReplyTableViewCell.h"

@implementation ReplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        //初始化子视图
        _headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_headerView];
        
        cornerImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        cornerImage.image = [UIImage imageNamed:@"corner_circle"];
        [self.contentView addSubview:cornerImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        _gwLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _gwLabel.font = [UIFont systemFontOfSize:8];
        _gwLabel.textColor = Mycolor;
        [self.contentView addSubview:_gwLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:8];
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.lineSpacing = 6;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.isNeedAtAndPoundSign = YES;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [[_dic valueForKey:@"content"] boundingRectWithSize:CGSizeMake(KScreenWidth - 50, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    //判断评论人是否为发布人自己
    if ([_faburen isEqualToString:[self.dic valueForKey:@"name"]]) {
        //所有的子视图位置靠右
        _headerView.frame = CGRectMake(KScreenWidth - 40, 10, 30, 30);
        cornerImage.frame = CGRectMake(KScreenWidth - 42.5, 7.5, 35, 35);
        _nameLabel.frame = CGRectMake(10, _headerView.top - 5, KScreenWidth - 60, 20);
        _nameLabel.textAlignment = NSTextAlignmentRight;
        
        _gwLabel.frame = CGRectMake(0, _nameLabel.bottom + 3, _nameLabel.width, 7);
        _gwLabel.textAlignment = NSTextAlignmentRight;
        
        _timeLabel.frame = CGRectMake(0, _gwLabel.bottom + 3, _nameLabel.width, 7);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        _contentLabel.frame = CGRectMake(10, _headerView.bottom + 10, KScreenWidth - 60, size.height);
        _contentLabel.textAlignment = NSTextAlignmentRight;
        
    } else {
        //所有的子视图位置靠左
        _headerView.frame = CGRectMake(10, 10, 30, 30);
        cornerImage.frame = CGRectMake(7.5, 7.5, 35, 35);
        _nameLabel.frame = CGRectMake(_headerView.right + 10, _headerView.top - 5, KScreenWidth - 40 - 10, 20);
        
        _gwLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 3, _nameLabel.width, 7);
        
        _timeLabel.frame = CGRectMake(_nameLabel.left, _gwLabel.bottom + 3, _gwLabel.width, 7);
        
        _contentLabel.frame = CGRectMake(_nameLabel.left, _headerView.bottom + 10, KScreenWidth - 50, size.height);
    }
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    //通过usertype判断员工还是营业员
    NSString *headerURLString = nil;
    if ([[_dic objectForKey:@"userType"] intValue] == 0) {
        headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[_dic objectForKey:@"userpic"]];
    } else {
        headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[_dic objectForKey:@"userpic"]];
    }
    
    NSURL *headerURL = [NSURL URLWithString:headerURLString];
    if (_dic == nil) {
        [_headerView removeFromSuperview];
    }
    [_headerView sd_setImageWithURL:headerURL placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    
    _nameLabel.text = [_dic valueForKey:@"name"];
    
    _gwLabel.text = [_dic valueForKey:@"gw"];
    
    _timeLabel.text = [_dic valueForKey:@"fsrq"];
    
    _contentLabel.emojiText = [_dic valueForKey:@"content"];
}


@end
