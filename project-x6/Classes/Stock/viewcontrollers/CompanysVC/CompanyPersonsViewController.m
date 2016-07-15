//
//  CompanyPersonsViewController.m
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CompanyPersonsViewController.h"
#import "PersonsTableViewCell.h"
#import "HeaderViewController.h"
#import "WriteViewController.h"
#import "MianDynamicViewController.h"
@interface CompanyPersonsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_companyPersonTableview;
}

@property(nonatomic,copy)NSMutableArray *personNameArray;   //姓名
@property(nonatomic,copy)NSArray *selectpersons;
@end

@implementation CompanyPersonsViewController

- (void)dealloc
{
    _companyPersonTableview = nil;
    _personNameArray = nil;
    _selectpersons = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:_titleName];
    
    //处理数据
    [self selectCompanyPersonsData];
    
    //绘制UI


    _companyPersonTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _companyPersonTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    if (_type == YES) {
        //确定联系人
        self.selectPersons = YES;
        //可多选
        _companyPersonTableview.allowsMultipleSelectionDuringEditing = YES;
        [_companyPersonTableview setEditing:YES];
    }

    _companyPersonTableview.dataSource = self;
    _companyPersonTableview.delegate = self;
    [self.view addSubview:_companyPersonTableview];
    

    
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
    
    _selectpersons = [NSArray array];
    _selectpersons = [_companyPersonTableview indexPathsForSelectedRows];
    
    //处理数据
    NSMutableArray *personsList = [NSMutableArray array];
    if (_replytype == YES) {
        for (NSIndexPath *indec in _selectpersons) {
            NSString *name = [_personNameArray objectAtIndex:indec.row];
            [personsList addObject:name];
        }
    } else {
        for (NSIndexPath *indec in _selectpersons) {
            NSString *name = [_personNameArray objectAtIndex:indec.row];
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
    
    if (personsList.count != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"companyPersonList" object:personsList];
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
- (void)selectCompanyPersonsData
{
    NSString *daima = [NSString string];
    for (NSDictionary *dic in _kuangjiadatalist) {
        if ([[dic valueForKey:@"name"] isEqualToString:_titleName]) {
            daima = [dic valueForKey:@"bm"];
        }
    }
    
    _personNameArray = [NSMutableArray array];
    for (NSDictionary *dic in _datalist) {
        if ([[dic valueForKey:@"ssgs"] isEqualToString:daima]) {
            [_personNameArray addObject:dic];
        }
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *companyPersonID = @"companyPersonID";
    PersonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:companyPersonID];
    if (cell == nil) {
        cell = [[PersonsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:companyPersonID];
    }
    cell.dic = _personNameArray[indexPath.row];
    cell.comdatalist = _kuangjiadatalist;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == NO) {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HeaderViewController *headerVC = [[HeaderViewController alloc] init];
    headerVC.type = YES;
    headerVC.dic = _personNameArray[indexPath.row];
    [self.navigationController pushViewController:headerVC animated:YES];
    }
}

@end
