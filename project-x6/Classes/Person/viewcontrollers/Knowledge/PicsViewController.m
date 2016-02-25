//
//  PicsViewController.m
//  project-x6
//
//  Created by Apple on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PicsViewController.h"
#import "PictureCollectionViewCell.h"
#import "FocusModel.h"
#import "PictureDetailViewController.h"


@interface PicsViewController ()<UISearchResultsUpdating>
@property(nonatomic,strong)UISearchController *searchVC;


@property(nonatomic,strong)NSMutableArray *newdatalist;  //搜索后的数据
@property(nonatomic,strong)NSMutableArray *nameArray;    //名称集合

@property(nonatomic,copy)NSMutableArray *datalist;
@property(nonatomic,strong)NSArray *picDatalist;
@end

@implementation PicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"图片"];
    
    [self initSearchView];
    [self initCollectionView];
    
    
    _picDatalist = [NSArray new];
    _datalist = [NSMutableArray new];
    [self getknowledgeData];
    
    //处理数据--获取图片名称的集合
    _nameArray = [NSMutableArray array];
    NSMutableArray *nameArray = nil;
    nameArray = [FocusModel mj_keyValuesArrayWithObjectArray:_picDatalist];
    for (NSDictionary *dic in nameArray) {
        [_nameArray addObject:[dic valueForKey:@"shortname"]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_searchVC.searchBar setHidden:NO];

  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"知识库－照片收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_searchVC.searchBar isFirstResponder]) {
        [_searchVC.searchBar resignFirstResponder];
    }
    [_searchVC.searchBar setHidden:YES];
}

#pragma mark - UI
//搜索框
- (void)initSearchView
{
    _searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchVC.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _searchVC.searchResultsUpdater = self;
    _searchVC.dimsBackgroundDuringPresentation = NO;
    _searchVC.hidesNavigationBarDuringPresentation = NO;
    _searchVC.searchBar.placeholder = @"搜索";
    [_searchVC.searchBar sizeToFit];
    [self.view addSubview:_searchVC.searchBar];
}

//瀑布流视图
- (void)initCollectionView
{
    //绘制瀑布流视图
    CGFloat width = (KScreenWidth - 80) / 3.0;
    UICollectionViewFlowLayout *layouted = [[UICollectionViewFlowLayout alloc] init];
    layouted.itemSize = CGSizeMake(width, width);
    layouted.minimumInteritemSpacing = 20;
    layouted.minimumLineSpacing = 20;
    layouted.scrollDirection = UICollectionViewScrollDirectionVertical;
    layouted.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    _picCollectionViews = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) collectionViewLayout:layouted];
    _picCollectionViews.backgroundColor = GrayColor;
    _picCollectionViews.dataSource = self;
    _picCollectionViews.delegate = self;
    //注册
    [_picCollectionViews registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [self.view addSubview:_picCollectionViews];
    
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.searchVC.active) {
        return _datalist.count;
    } else {
        return _newdatalist.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    if (!self.searchVC.active) {
        cell.model = _datalist[indexPath.item];
    } else {
        cell.model = _newdatalist[indexPath.item];
    }
    [cell setNeedsLayout];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureDetailViewController *pictureDetail = [[PictureDetailViewController alloc] init];
    pictureDetail.imageDatalist = _datalist;
    pictureDetail.selectimage = (int)indexPath.item;
    [self.navigationController pushViewController:pictureDetail animated:YES];
}


#pragma mark - searchResultsUpdater
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.newdatalist = [NSMutableArray array];
    if (self.newdatalist == nil) {
        self.newdatalist = [_datalist mutableCopy];
    } else {
        [self.newdatalist removeAllObjects];
    }
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", self.searchVC.searchBar.text];
    NSMutableArray *array = nil;
    NSMutableSet *set = [NSMutableSet set];
    array = [[_nameArray filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    for (FocusModel *model in _datalist) {
        for (NSString *name in array) {
            if ([model.shortname isEqualToString:name]) {
                [set addObject:model];
            }
            
        }
    }
    self.newdatalist = [[set allObjects] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_picCollectionViews reloadData];
    });
}



#pragma mark - 获取数据
- (void)getknowledgeData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:X6_UseUrl];
    NSString *collectionURL = [NSString stringWithFormat:@"%@%@",url,X6_collectionView];
    [XPHTTPRequestTool requestMothedWithPost:collectionURL params:nil success:^(id responseObject) {
        NSLog(@"知识库:%@",responseObject);
        _picDatalist = [FocusModel mj_keyValuesArrayWithObjectArray:responseObject[@"rows"]];
        //处理数据
        [self getPicsAndTxtData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_picCollectionViews reloadData];
        });
        
    } failure:^(NSError *error) {
        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
        NSLog(@"图片请求失败%@",error);
    }];
}

#pragma mark - 将数据分类
- (void)getPicsAndTxtData
{
    NSMutableArray *picdatalist = [NSMutableArray array];
    NSMutableArray *txtdatalist = [NSMutableArray array];
    for (NSDictionary *dic in _picDatalist) {
        NSString *shortName = [dic valueForKey:@"shortname"];
        NSArray *newname = [shortName componentsSeparatedByString:@"."];
        if ([newname[1] isEqualToString:@"jpg"] || [newname[1] isEqualToString:@"png"] || [newname[1] isEqualToString:@"JPG"]) {
            [picdatalist addObject:dic];
        } else {
            [txtdatalist addObject:dic];
        }
    }
    
    for (NSDictionary *dic in picdatalist) {
        FocusModel *model = [FocusModel mj_objectWithKeyValues:dic];
        [_datalist addObject:model];
    }
    
 
}
@end
