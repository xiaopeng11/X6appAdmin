//
//  KnowledgeCell.h
//  project-x6
//
//  Created by Apple on 16/1/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowledgeCell : UITableViewCell

{
    UIImageView *_imageView;
    UILabel *_label;
}

@property(nonatomic,strong)NSDictionary *dic;
@end
