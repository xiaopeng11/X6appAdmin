//
//  ReplyTableViewCell.h
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyTableViewCell : UITableViewCell

{
    UIImageView *_headerView;   //头像
    UIImageView *cornerImage;  //头像的边框图片

    UILabel *_nameLabel;        //回复人姓名
    UILabel *_gwLabel;          //岗位
    UILabel *_timeLabel;        //时间
    MLEmojiLabel *_contentLabel;     //内容
    
}

@property(nonatomic,strong)NSString *faburen;
@property(nonatomic,strong)NSDictionary *dic;
@end
