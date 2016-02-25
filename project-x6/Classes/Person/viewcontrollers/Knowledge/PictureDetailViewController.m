//
//  PictureDetailViewController.m
//  project-x6
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PictureDetailViewController.h"
#import "PictureDetailCollectionViewCell.h"
@interface PictureDetailViewController ()<UIActionSheetDelegate>

@end

@implementation PictureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_collectionView setContentOffset:CGPointMake((KScreenWidth + 10) * self.selectimage, 0)];
    
    //瀑布流视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(KScreenWidth + 10, KScreenHeight);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing =0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //创建瀑布流视图
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-5, 0, KScreenWidth + 10, KScreenHeight) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    UITapGestureRecognizer *tapaction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_collectionView addGestureRecognizer:tapaction];
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[PictureDetailCollectionViewCell class] forCellWithReuseIdentifier:@"pictureDetail"];
    
    //加快速度
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.view addSubview:_collectionView];
   
    [_collectionView setContentOffset:CGPointMake((KScreenWidth + 10) * self.selectimage, 0)];

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

#pragma mark - tapaction:点击事件隐藏状态栏和导航栏
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    
    //设置导航栏状态栏效果去反
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:![UIApplication sharedApplication].networkActivityIndicatorVisible animated:YES];
    
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.imageDatalist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureDetailCollectionViewCell *pictureCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictureDetail" forIndexPath:indexPath];
    pictureCell.model = self.imageDatalist[indexPath.item];
    [pictureCell setNeedsLayout];
    return pictureCell;
}



@end





