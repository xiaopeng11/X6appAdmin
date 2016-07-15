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
        //单元格头的高度
        float height = 10 + 15 + 39 + 10;
        
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic];
        //添加frame参数
        NSString *content = dic[@"content"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{NSFontAttributeName:MainFont,NSParagraphStyleAttributeName:paragraphStyle};
        CGSize size = [content boundingRectWithSize:CGSizeMake(KScreenWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        //单元格尾部高度
        height += size.height + 10 + 30 + 20;
        
        //判断是否有图片2
        NSString *filepropString = dic[@"fileprop"];
        //json解析
        NSArray *fileprop = [filepropString objectFromJSONString];
        if (fileprop.count != 0) {
            //有图片
            if (fileprop.count == 4) {
                height += (PuretureSize * 2) + 5;
            } else {
                height += PuretureSize;
            }
        }
        data[@"frame"] = [NSValue valueWithCGRect:CGRectMake(0, 0, KScreenWidth, height)];
        data[@"contentframe"] = [NSValue valueWithCGRect:CGRectMake(10, 74, KScreenWidth - 20, size.height)];
        [array addObject:data];
        
    }
    return array;
}
@end
