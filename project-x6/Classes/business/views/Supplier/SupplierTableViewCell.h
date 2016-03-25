//
//  SupplierTableViewCell.h
//  project-x6
//
//  Created by Apple on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplierTableViewCell : UITableViewCell

{
    UIImageView *_imageView;
    UILabel *_supplierName;
    UILabel *_needPayMoney;
    
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
}

@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,assign)BOOL issupplier;
@end
