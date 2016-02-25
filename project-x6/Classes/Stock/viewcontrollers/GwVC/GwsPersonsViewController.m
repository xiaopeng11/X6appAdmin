//
//  GwsPersonsViewController.m
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GwsPersonsViewController.h"
#import "PersonsTableViewCell.h"
#import "HeaderViewController.h"
#import "WriteViewController.h"
#import "MianDynamicViewController.h"
@interface GwsPersonsViewController ()
{
    UITableView *_gwsPersonTableview;
}

@property(nonatomic,copy)NSMutableArray *gwPersons;
@property(nonatomic,copy)NSArray *selectgwPersons;

@end

@implementation GwsPersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:_titleName];
    
    //处理数据
    [self selectgwsPersonsData];
    
    //绘制UI
    if (_gwPersons.count * 60 < KScreenHeight - 64) {
        _gwsPersonTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, _gwPersons.count * 60 ) style:UITableViewStylePlain];
        _gwsPersonTableview.scrollEnabled = NO;
    } else {
        _gwsPersonTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    }
    
    if (_type == YES) {
        //导航栏右侧确定按钮
        self.selectPersons = YES;

        _gwsPersonTableview.allowsMultipleSelectionDuringEditing = YES;
        [_gwsPersonTableview setEditing:YES];
    }
    _gwsPersonTableview.dataSource = self;
    _gwsPersonTableview.delegate = self;
    [self.view addSubview:_gwsPersonTableview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

#pragma mark - sureAction
- (void)sureAction:(UIButton *)button
{
    
    _selectgwPersons = [NSArray array];
    _selectgwPersons = [_gwsPersonTableview indexPathsForSelectedRows];
    NSLog(@"%@",_selectgwPersons);
    
    //处理数据
    NSMutableArray *personsList = [NSMutableArray array];
    if (_replytype == YES) {
        for (NSIndexPath *indec in _selectgwPersons) {
            NSDictionary *gwdic = [_gwdatalist objectAtIndex:indec.row];
            [personsList addObject:[gwdic valueForKey:@"name"]];
        }
    } else {
        for (NSIndexPath *indec in _selectgwPersons) {
            NSDictionary *gwdic = [_gwdatalist objectAtIndex:indec.row];
            NSString *name = [gwdic valueForKey:@"name"];
            for (NSDictionary *dic in _datalist) {
                if ([[dic valueForKey:@"name"] isEqualToString:name]) {
                    NSMutableDictionary *diced = [NSMutableDictionary dictionary];
                    [diced setObject:[dic valueForKey:@"id"] forKey:@"id"];
                    [diced setObject:[dic valueForKey:@"usertype"] forKey:@"usertype"];
                    [personsList addObject:diced];
                }
            }
        }
    }
    
    if (personsList != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gwPersonList" object:personsList];
    }
    
    if (_replytype == YES) {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[MianDynamicViewController class]]) {
                [self.navigationController popToViewController:VC animated:YES];
            }
        }

    } else {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[WriteViewController class]]) {
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }
    
}


#pragma mark - 处理数据
- (void)selectgwsPersonsData
{
    _gwPersons = [NSMutableArray array];
    for (NSDictionary *dic in _datalist) {
        if ([[dic valueForKey:@"gw"] isEqualToString:_titleName]) {
            [_gwPersons addObject:[dic valueForKey:@"name"]];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gwPersons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gwsPersonsID = @"gwsPersonsID";
    PersonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gwsPersonsID];
    if (cell == nil) {
        cell = [[PersonsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gwsPersonsID];
        if (_type == YES) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
    cell.name = _gwPersons[indexPath.row];
    cell.datalist = _datalist;
    cell.comdatalist = _comdatalist;
    cell.gwdatalist = _gwdatalist;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == NO ){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HeaderViewController *headerVC = [[HeaderViewController alloc] init];
        headerVC.type = YES;
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"name"] isEqualToString:_gwPersons[indexPath.row]]) {
                headerVC.dic = dic;
            }
        }
        [self.navigationController pushViewController:headerVC animated:YES];
    }
}
@end
