//
//  KnowledgesViewController.m
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "KnowledgesViewController.h"

#import "KnowledgeCell.h"

#import "PicsViewController.h"
#import "TxtViewController.h"

@interface KnowledgesViewController ()

@property(nonatomic,copy)NSArray *tableViewtitles;


@end

@implementation KnowledgesViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self naviTitleWhiteColorWithText:@"我的知识库"];


    _tableViewtitles = [NSArray array];
    _tableViewtitles = @[@{@"image":@"btn_wendang_n-",@"title":@"文  档"},@{@"image":@"btn_zhaopian_n",@"title":@"图  片"}];
    _leixingTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 160) style:UITableViewStylePlain];
    _leixingTbaleView.delegate = self;
    _leixingTbaleView.dataSource = self;
    [self.view addSubview:_leixingTbaleView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"知识库收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableViewtitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *knownledges = @"knownledgesID";
    KnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:knownledges];
    if (cell == nil) {
        cell = [[KnowledgeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:knownledges];
    }
    cell.dic = _tableViewtitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSLog(@"展示文档");
        TxtViewController *knowledgeVC = [[TxtViewController alloc] init];
        [self.navigationController pushViewController:knowledgeVC animated:YES];
    } else {
        NSLog(@"展示图片");
        PicsViewController *picsVC = [[PicsViewController alloc] init];
        [self.navigationController pushViewController:picsVC animated:YES];
    }
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
