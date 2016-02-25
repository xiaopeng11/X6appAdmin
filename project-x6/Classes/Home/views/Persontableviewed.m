//
//  Persontableviewed.m
//  project-x6
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "Persontableviewed.h"

@implementation Persontableviewed

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@的动态:",self.name];
}

@end
