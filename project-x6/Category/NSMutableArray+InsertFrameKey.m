//
//  NSMutableArray+InsertFrameKey.m
//  project-x6
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSMutableArray+InsertFrameKey.h"

@implementation NSMutableArray (InsertFrameKey)
- (NSMutableArray *)loadframeKeyWithDatalist
{
    NSMutableArray *array = [NSMutableArray array];
    //计算动态高度
    //计算文本高度
    for (NSDictionary *dic in self) {
        float height = 10 + 40 + 10;
        
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
        //添加frame参数
        NSString *content = dic[@"content"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle};
        CGSize size = [content boundingRectWithSize:CGSizeMake(KScreenWidth - 40, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        height += size.height + 10;
        
        //判断是否有图片
        NSString *filepropString = dic[@"fileprop"];
        //json解析
        NSArray *fileprop = [filepropString objectFromJSONString];
        if (fileprop.count != 0) {
            //有图片
            if (fileprop.count == 4) {
                height += 170 + 10;
            } else {
                height += 80 + 10;
            }
        }
        data[@"frame"] = [NSValue valueWithCGRect:CGRectMake(0, 0, KScreenWidth, height)];
        data[@"contentframe"] = [NSValue valueWithCGRect:CGRectMake(20, 60, KScreenWidth - 40, size.height)];
        [array addObject:data];
        
    }
    return array;
}
@end
