//
//  GwsViewController.m
//  project-x6
//
//  Created by Apple on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "GwsViewController.h"
#import "GwsPersonsViewController.h"
#import "SelectTableViewCell.h"
#import "GwsModel.h"
#import "WriteViewController.h"
#import "MianDynamicViewController.h"
@interface GwsViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_gwsTableview;
}

@property(nonatomic,copy)NSMutableArray *gwsArray;

@property(nonatomic,copy)NSMutableArray *selectgws;

@property(nonatomic,copy)NSMutableArray *arrays;

@end

@implementation GwsViewController

- (void)dealloc
{
    _gwsArray = nil;
    _selectgws = nil;
    _arrays = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"按岗位"];
    
    self.view.backgroundColor = GrayColor;

    //处理数据
    [self selectGWsData];
    
    _selectgws = [NSMutableArray array];
    
 
    _gwsTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _gwsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _gwsTableview.dataSource = self;
    _gwsTableview.delegate = self;
    [self.view addSubview:_gwsTableview];
    
    if (_type == YES) {
        //确定按钮
        self.selectPersons = YES;
    }

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

#pragma mark - 处理数据
- (void)selectGWsData
{
    _gwsArray = [NSMutableArray array];
    NSMutableArray *datalist = [_datalist mutableCopy];
    for (int i = 0; i < datalist.count; i++) {
        NSDictionary *dic = datalist[i];
        NSString *gw = [dic valueForKey:@"gw"];
        [datalist replaceObjectAtIndex:i withObject:gw];
        
    }
    for (NSDictionary *dic in _gwdatalist) {
        
        //将联系人数据中有的公司框架放到_nameArray中组成－－标题数组
        NSString *gw = [dic valueForKey:@"name"];
        if ([datalist indexOfObject:gw] != NSNotFound) {
            [_gwsArray addObject:gw];
        }
    }

    //将岗位数组转换成模型对象数组
    NSMutableArray *newarray = [NSMutableArray array];
    for (NSString *name in _gwsArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:name forKey:@"name"];
        [newarray addObject:dic];
    }
    
    _arrays = [NSMutableArray array];
    
    for (NSDictionary *dic in newarray) {
        [_arrays addObject:[GwsModel mj_objectWithKeyValues:dic]];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gwsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gwsID = @"gwsID";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gwsID];
    if (cell == nil) {
        cell = [[SelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gwsID];
    }
    
    [cell.button addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.type = _type;
    cell.button.tag = indexPath.row;
    
    cell.model = _arrays[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GwsPersonsViewController *gwsPersonVC = [[GwsPersonsViewController alloc] init];
    gwsPersonVC.datalist = _datalist;
    gwsPersonVC.gwdatalist = _gwdatalist;
    gwsPersonVC.comdatalist = _comdatalist;
    gwsPersonVC.titleName = _gwsArray[indexPath.row];
    gwsPersonVC.type = _type;
    gwsPersonVC.replytype = _replytype;
    [self.navigationController pushViewController:gwsPersonVC animated:YES];
 
}

#pragma mark - 单元格按钮点击事件
- (void)cellButtonAction:(UIButton *)button
{
    GwsModel *cellmodel = _arrays[button.tag];
    if (![cellmodel check]) {
        cellmodel.check = YES;
        [button setImage:[UIImage imageNamed:@"icon_image_yes"] forState:UIControlStateNormal];
        [_selectgws addObject:_gwsArray[button.tag]];
    } else {
        cellmodel.check = NO;
        [button setImage:[UIImage imageNamed:@"icon_image_no"] forState:UIControlStateNormal];
        [_selectgws removeObject:_gwsArray[button.tag]];
    }
}

#pragma mark - 重写确定联系人按钮事件
- (void)sureAction:(UIButton *)button
{
    NSMutableArray *personList = [NSMutableArray array];
    if (_replytype == YES) {
        for (NSString *gw in _selectgws) {
            for (NSDictionary *dic in _datalist) {
                if ([[dic valueForKey:@"gw"] isEqualToString:gw]) {
                    [personList addObject:[dic valueForKey:@"name"]];
                }
            }
        }
    } else {
        for (NSString *gw in _selectgws) {
            for (NSDictionary *dic in _datalist) {
                if ([[dic valueForKey:@"gw"] isEqualToString:gw]) {
                    NSMutableDictionary *diced = [NSMutableDictionary dictionary];
                    [diced setObject:[dic valueForKey:@"id"] forKey:@"id"];
                    [diced setObject:[dic valueForKey:@"usertype"] forKey:@"usertype"];
                    [personList addObject:diced];
                }
            }
        }
    }
    
    
    if (personList != nil) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gwsList" object:personList];
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
@end

