//
//  AllSalesViewController.m
//  project-x6
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AllSalesViewController.h"
#import "AllSalesModel.h"
@interface AllSalesViewController ()
@property(nonatomic,strong)NoDataView *nosalesView;
@property(nonatomic,strong)AllSalesCollectionView *collectionView;
@end

@implementation AllSalesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"我的排名"];
    

    

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //绘制UI
    [self initSubView];
    
    //获取数据
    [self getAllSalesDataWithDate:@"zr"];}



//双滑动式图的实现
- (void)initSubView
{
    //自己的信息
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 140)];
    _bgView.backgroundColor = Mycolor;
    [self.view addSubview:_bgView];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    //取出个人数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    //公司代码
    NSString *gsdm = [userInformation objectForKey:@"gsdm"];
    //员工头像地址
    NSString *ygImageUrl = [userdefaults objectForKey:X6_UserHeaderView];
    NSString *info_imageURL = [userInformation objectForKey:@"userpic"];
    //头像
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 40;
    if ([userdefaults objectForKey:X6_UserHeaderView] != nil) {
        [headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,ygImageUrl]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    } else {
        [headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,info_imageURL]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    }
    [_bgView addSubview:headView];
    
    for (int i = 0; i < 4; i++) {
        NSUInteger lon = i / 2;
        NSUInteger won = i % 2;
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.right + 20 + (((KScreenWidth - 120) / 2.0) * won), headView.top + 10 + 45 * lon, (KScreenWidth - 120) / 2.0, 30)];
        numberLabel.font = [UIFont systemFontOfSize:16];
        numberLabel.tag = 1800 + i;
        numberLabel.textColor = [UIColor whiteColor];
        [_bgView addSubview:numberLabel];
    }

    //具体数据排名
    NSArray *array = @[@"数量排名",@"利润排名"];
    
    //2页内容的scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, KScreenWidth, KScreenHeight - 36 - 140)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(KScreenWidth * array.count, 100);
    _scrollView.bounces = NO;
    for (int i = 0; i < array.count; i++) {
        UICollectionViewFlowLayout *layouted = [[UICollectionViewFlowLayout alloc] init];
        //单元格大小
        CGFloat width = (KScreenWidth - 50) / 4.0;
        layouted.itemSize = CGSizeMake(width, width);
        layouted.minimumInteritemSpacing = 10;
        layouted.minimumLineSpacing = 10;
        layouted.scrollDirection = UICollectionViewScrollDirectionVertical;
        layouted.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[AllSalesCollectionView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 36, KScreenWidth, KScreenHeight - 100 - 36 - 140 - 36) collectionViewLayout:layouted];
        _collectionView.tag = 1100 + i;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.hidden = YES;
        //添加上拉加载更多，下拉刷新
        _collectionView.datalist = _datalist;
        [_scrollView addSubview:_collectionView];
        
        _nosalesView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 36, KScreenWidth, KScreenHeight - 100 - 36 - 100)];
        _nosalesView.hidden = YES;
        _nosalesView.tag = 7000 + i;
        _nosalesView.text = @"没有纪录";
        [_scrollView addSubview:_nosalesView];
    }
    
    [self.view addSubview:_scrollView];
    
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    config.itemWidth = KScreenWidth / array.count;
    
    _itemsControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, 140, KScreenWidth, 36)];
    _itemsControlView.tapAnimation = NO;
    _itemsControlView.backgroundColor = GrayColor;
    _itemsControlView.config = config;
    _itemsControlView.titleArray = array;
    
    __weak typeof (_scrollView)weakScrollView = _scrollView;
    [_itemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
        
    }];
    [self.view addSubview:_itemsControlView];
    
    
    //添加一个分段空间
    NSArray *dateNames = @[@"昨日",@"本周",@"本月",@"本季"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:dateNames];
    segmentedControl.frame = CGRectMake(0, KScreenHeight - 64 - 36, KScreenWidth, 36);
    segmentedControl.selectedSegmentIndex= 0;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

#pragma mark - 获取数据
- (void)getAllSalesDataWithDate:(NSString *)date
{
    //获取今天的数据
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefault objectForKey:X6_UseUrl];
    NSString *AllSalesURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_allSales];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:date forKey:@"searchType"];
  
    //获取表示图
    AllSalesCollectionView *collectionView,*nocollectionView;
    if (_scrollView.contentOffset.x == 0) {
        collectionView = [_scrollView viewWithTag:1100];
        nocollectionView = [_scrollView viewWithTag:7000];
    } else {
        collectionView = [_scrollView viewWithTag:1101];
        nocollectionView = [_scrollView viewWithTag:7001];
    }
    
    [XPHTTPRequestTool requestMothedWithPost:AllSalesURL params:params success:^(id responseObject) {
        _datalist = [AllSalesModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        if (_datalist.count == 0) {
            nocollectionView.hidden = NO;
            collectionView.hidden = YES;
            
        } else {
            nocollectionView.hidden = YES;
            collectionView.hidden = NO;
        }
        [self dataording];
    } failure:^(NSError *error) {
        NSLog(@"所有销量获取错去");
        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
    }];
}

#pragma mark - 数据排序
- (void)dataording
{    
    //获取表示图
    AllSalesCollectionView *collectionView;
    if (_scrollView.contentOffset.x == 0) {
        collectionView = [_scrollView viewWithTag:1100];
    } else {
        collectionView = [_scrollView viewWithTag:1101];
    }
    collectionView.hidden = NO;
    //当该用户的数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInformation = [userdefaults objectForKey:X6_UserMessage];
    NSString *ygName = [userInformation objectForKey:@"name"];
    NSNumber *mysales = [[NSNumber alloc] init];
    NSNumber *myprice = [[NSNumber alloc] init];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (NSDictionary *dic in _datalist) {
        //姓名数组
        [nameArray addObject:[dic valueForKey:@"col1"]];
        //自己的数据
        if ([ygName isEqualToString:[dic valueForKey:@"col1"]]) {
            mysales = [dic valueForKey:@"col3"];
            myprice = [dic valueForKey:@"col5"];
        }
    }
    
    
    UILabel *label0 = [_bgView viewWithTag:1800];
    UILabel *label1 = [_bgView viewWithTag:1801];
    UILabel *label2 = [_bgView viewWithTag:1802];
    UILabel *label3 = [_bgView viewWithTag:1803];

    if (![nameArray containsObject:ygName]) {
        NSMutableArray *noprice = [NSMutableArray array];
        for (NSDictionary *dic in _datalist) {
            NSNumber *price = [dic valueForKey:@"col5"];
            if ([price doubleValue] > 0) {
                [noprice addObject:dic];
            }
        }
        
        if (_scrollView.contentOffset.x == 0) {
            //自己不在数据中，排在最后一位
            collectionView.datalist = _datalist;
        } else {
            collectionView.datalist = noprice;
        }
        
        label0.text = @"数量:0/个";
        label2.text = @"利润:0/元";
        label1.text = [NSString stringWithFormat:@"排名:第%lu名",_datalist.count + 1];
        label3.text = [NSString stringWithFormat:@"排名:第%lu名",noprice.count + 1];
    } else {
        //自己在数据中,获取在自己之前的数据
        NSMutableArray *number = [NSMutableArray array];
        NSMutableArray *price = [NSMutableArray array];
        for (NSDictionary *diced in _datalist) {
            NSNumber *num = [diced valueForKey:@"col3"];
            NSNumber *pri = [diced valueForKey:@"col5"];
            if ([num doubleValue] > [mysales doubleValue]) {
                [number addObject:diced];
            }
            if ([pri doubleValue] > [myprice doubleValue]) {
                [price addObject:diced];

            }
        }
        
        label0.text = [NSString stringWithFormat:@"数量:%@/个",mysales];
        label1.text = [NSString stringWithFormat:@"排名:第%lu名",number.count + 1];
        label2.text = [NSString stringWithFormat:@"利润:%@/元",myprice];
        label3.text = [NSString stringWithFormat:@"排名:第%lu名",price.count + 1];
        
        if (_scrollView.contentOffset.x == 0) {
            collectionView.datalist = number;
        } else {
            collectionView.datalist = price;
        }
    }
    [collectionView reloadData];
 
  
}


#pragma mark - UIScrollViewDelegate
//滑动判断分段控件位置刷新数据
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        [_itemsControlView moveToIndex:offset];
        
        
    }
}


//滑动式图的头视图滑倒指定位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        //滑动到指定位置
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        [_itemsControlView endMoveToIndex:offset];
        [self getdata];
    }
    
}


#pragma mark - 分段事件
- (void)segmentAction:(UISegmentedControl *)segment
{
    _index = segment.selectedSegmentIndex;
    [self getdata];
}


#pragma mark - 提取方法
- (void)getdata
{
    if (_index == 0) {
        [self getAllSalesDataWithDate:@"zr"];
    } else if (_index == 1) {
        [self getAllSalesDataWithDate:@"bz"];
    } else if (_index == 2){
        [self getAllSalesDataWithDate:@"by"];
    } else {
        [self getAllSalesDataWithDate:@"bj"];
    }
}

@end
