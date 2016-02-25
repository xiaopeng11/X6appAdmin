//
//  AllDynamicViewController.m
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "AllDynamicViewController.h"
#import "UIBarButtonItem+Extension.h"

#import "LoadViewController.h"
#import "WJItemsControlView.h"
#import "HomeModel.h"
#import "HomeTableViewCell.h"
#import "WriteViewController.h"

#import "BaseTabBarViewController.h"
@interface AllDynamicViewController ()<UIScrollViewDelegate>

{
    UIImageView *_unreadViews;
    WJItemsControlView *_itemsControlView;   //眉头试图
    UIScrollView *_scrollView;               //首页滑动式图
    
}

@property(nonatomic,strong)NSArray *datalist;
@property(nonatomic,strong)NSArray *Mycollectiondatalist;
@property(nonatomic,strong)NSArray *Myfocusdatalist;
@property(nonatomic,assign)double page;
@property(nonatomic,assign)double pages;
@property(nonatomic,assign)double MyfocusPage;
@property(nonatomic,assign)double MyfocusPages;
@property(nonatomic,assign)double MycollectPage;
@property(nonatomic,assign)double MycollectPages;

@end

@implementation AllDynamicViewController

- (NSArray *)datalist
{
    if (_datalist == nil) {
        _datalist = [NSArray array];
    }
    return _datalist;
}

- (NSArray *)Mycollectiondatalist
{
    if (_Mycollectiondatalist == nil) {
        _Mycollectiondatalist = [NSArray array];
    }
    return _Mycollectiondatalist;
}

- (NSArray *)Myfocusdatalist
{
    if (_Myfocusdatalist == nil) {
        _Myfocusdatalist = [NSArray array];
    }
    return _Myfocusdatalist;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadTableview" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"乐乐圈内存泄漏");
    //释放ui
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
    //释放全局变量
    _datalist = nil;
    _Mycollectiondatalist = nil;
    _Myfocusdatalist = nil;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    [self naviTitleWhiteColorWithText:@"工作圈"];
    
    [self insertNaviButton];
    
    //界面搭建
    [self initSubView];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 请求数据
        [self requestdata];
    });
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableview:) name:@"reloadTableview" object:nil];
    
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer setFireDate:[NSDate distantFuture]];
}


#pragma mark - 通知刷新页面
- (void)reloadTableview:(NSNotification *)noti
{
    if (_scrollView.contentOffset.x == 0) {
        HomeTableView *tableview = (HomeTableView *)[_scrollView viewWithTag:100];
        [tableview.header beginRefreshing];
    }
}

#pragma mark - 定时器方法
- (void)timerAction:(NSTimer *)timer
{
    NSLog(@"定时器");
    
    if (_datalist.count == 0) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:X6_UseUrl];
    
    NSString *newMessageCountString = [NSString stringWithFormat:@"%@%@",url,X6_NewMessageCount];
    [XPHTTPRequestTool requestMothedWithPost:newMessageCountString params:nil success:^(id responseObject) {
        long count = [[responseObject valueForKey:@"vo"] doubleValue];
        [self unReadMessageCountBadyViewWithCount:count];

    } failure:^(NSError *error) {
        NSLog(@"获取失败");
    }];
}

#pragma mark - 未读消息
- (void)unReadMessageCountBadyViewWithCount:(long)count
{
    if (count > 0) {
        self.tabBarItem.badgeValue = nil;
        if (!_unreadViews) {
            _unreadViews = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth / 3.0) - 9 - 18, 6, 10, 10)];
            _unreadViews.image = [UIImage imageNamed:@"SmallPoint"];
            [_itemsControlView addSubview:_unreadViews];
        }
        _unreadViews.hidden = NO;
       if (count >= 100){
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"99+"];
        } else {
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",count];
        }
    } else {
        _unreadViews.hidden = YES;
        self.tabBarItem.badgeValue = nil;
    }
}


#pragma mark - 请求数据
- (void)requestdata
{
    if (_scrollView.contentOffset.x == 0) {
        [self getdataWithPage:1 SearchType:0];
    } else if (_scrollView.contentOffset.x == KScreenWidth) {
        [self getdataWithPage:1 SearchType:1];
    } else {
        [self getdataWithPage:1 SearchType:2];
    }
    
}

#pragma mark - 提出请求数据方法
- (void)getdataWithPage:(double)page SearchType:(double)searchType
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:X6_UseUrl];
    NSNumber *refresh = [userDefaults objectForKey:X6_refresh];
    
    NSString *homeURL = [NSString stringWithFormat:@"%@%@",url,X6_Dynamiclist];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(8) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"zdrq" forKey:@"sidx"];
    [params setObject:@"desc" forKey:@"sord"];
    [params setObject:@(searchType) forKey:@"searchType"];
    int refreshnumber = [refresh intValue];
    [params setObject:@(refreshnumber) forKey:@"refreshFlag"];
    
    //获取表示图
    HomeTableView *tableview = (HomeTableView *)[_scrollView viewWithTag:100 + searchType];
    NoDataView *nodataView = (NoDataView *)[_scrollView viewWithTag:110 + searchType];
    if (!tableview.header.isRefreshing) {
          [GiFHUD show];
    }
    [XPHTTPRequestTool requestMothedWithPost:homeURL params:params success:^(id responseObject) {
        //将刷新参数保存在本地
       NSLog(@"%@",responseObject);
        [userDefaults setObject:@(1) forKey:X6_refresh];
        [userDefaults synchronize];
        if (tableview.header.isRefreshing || tableview.footer.isRefreshing) {
            [self endrefreshWithTableView:tableview];
        }
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [tableview.footer noticeNoMoreData];
        }
        NSMutableArray *array = nil;
        //判断是第一次请求数据还是加载更多并且判断表示图的位置[responseObject valueForKey:@"rows"]
        if (_scrollView.contentOffset.x == 0) {
            if (_datalist.count == 0 || tableview.header.isRefreshing) {
                _datalist = [HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
            } else {
                _datalist = [_datalist arrayByAddingObjectsFromArray:[HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
            }
            //保存当前页码
            _page = [[responseObject valueForKey:@"page"] doubleValue];
            _pages = [[responseObject valueForKey:@"pages"] doubleValue];
            array = [[_datalist mutableCopy] loadframeKeyWithDatalist];
        } else if (_scrollView.contentOffset.x == KScreenWidth) {
            if (_Myfocusdatalist.count == 0 || tableview.header.isRefreshing) {
                _Myfocusdatalist = [HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
            } else {
                _Myfocusdatalist = [_Myfocusdatalist arrayByAddingObjectsFromArray:[HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
            }
            //保存当前页码
            _MyfocusPage = [[responseObject valueForKey:@"page"] doubleValue];
            _MyfocusPages = [[responseObject valueForKey:@"pages"] doubleValue];
            array = [[_Myfocusdatalist mutableCopy] loadframeKeyWithDatalist];
        } else {
            if (_Mycollectiondatalist.count == 0 || tableview.header.isRefreshing) {
                _Mycollectiondatalist = [HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
            } else {
                _Mycollectiondatalist = [_Myfocusdatalist arrayByAddingObjectsFromArray:[HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
            }
            //保存当前页码
            _MycollectPage = [[responseObject valueForKey:@"page"] doubleValue];
            _MycollectPages = [[responseObject valueForKey:@"pages"] doubleValue];
            array = [[_Mycollectiondatalist mutableCopy] loadframeKeyWithDatalist];
        }
        tableview.datalist = array;

        //判断是否有数据
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tableview.datalist.count == 0) {
                tableview.hidden = YES;
                nodataView.hidden = NO;
            } else {
                tableview.hidden = NO;
                nodataView.hidden = YES;
                [tableview reloadData];
            }
        });

        
    } failure:^(NSError *error) {
            tableview.hidden = YES;
            NSLog(@"首页请求数据失败%@",error);
        
    }];
}

#pragma mark - 网络错误
- (void)errorView:(Error *)errorView reloadViewWithMessage:(NSString *)message
{
    if (_scrollView.contentOffset.x == 0) {
        [self requestdata];
    } else {
        [_tableView reloadData];

    }
}



//双滑动式图的实现
- (void)initSubView
{
    NSArray *array = @[@"全部动态",@"我的关注",@"我的收藏"];
    NSArray *nodataNames = @[@"您无动态信息",@"您无关注信息",@"您无收藏信息"];
    //3页内容的scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 36)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(KScreenWidth * array.count, 100);
    _scrollView.bounces = NO;
    for (int i = 0; i < array.count; i++) {
        _tableView = [[HomeTableView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 36, KScreenWidth, KScreenHeight - 149) style:UITableViewStylePlain];
        _tableView.tag = 100 + i;
        _tableView.hidden = YES;
        //添加上拉加载更多，下拉刷新
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(homefooterAction)];
        [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(homeheaderAction)];
        [_scrollView addSubview:_tableView];
        
        _nodataView = [[NoDataView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 36, KScreenWidth, KScreenHeight - 149)];
        _nodataView.text = nodataNames[i];
        _nodataView.hidden = YES;
        _nodataView.tag = 110 + i;
        [_scrollView addSubview:_nodataView];
    }
    
    [self.view addSubview:_scrollView];
    
    
    //头部控制的设置
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    config.itemWidth = KScreenWidth / 3.0;
    
    _itemsControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 36)];
    _itemsControlView.tapAnimation = NO;
    _itemsControlView.backgroundColor = GrayColor;
    _itemsControlView.config = config;
    _itemsControlView.titleArray = array;
    
    __weak typeof (_scrollView)weakScrollView = _scrollView;
    [_itemsControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
    [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
    }];
    [self.view addSubview:_itemsControlView];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        [_itemsControlView moveToIndex:offset];
        if (offset == 1 || offset == 2) {
            [self getdataWithPage:1 SearchType:offset];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        //滑动到指定位置
        float offset = scrollView.contentOffset.x;
        offset = offset/CGRectGetWidth(scrollView.frame);
        [_itemsControlView endMoveToIndex:offset];

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x == 0 && [_scrollView isEqual:_tableView]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_scrollView.contentOffset.x == 0 && [_scrollView isEqual:_tableView]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
}



#pragma mark - 下拉刷新，上拉加载更多
- (void)homefooterAction
{
    //判断是哪一个表示图
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    if (_scrollView.contentOffset.x == 0) {
        [self getrefreshdataWithHead:NO SearchType:0];
    } else if (_scrollView.contentOffset.x == KScreenWidth) {
        [self getrefreshdataWithHead:NO SearchType:1];
    } else {
        [self getrefreshdataWithHead:NO SearchType:2];
    }
}

- (void)homeheaderAction
{
    if (_scrollView.contentOffset.x == 0) {
        [self getrefreshdataWithHead:YES SearchType:0];
    } else if (_scrollView.contentOffset.x == KScreenWidth) {
        [self getrefreshdataWithHead:YES SearchType:1];
    } else {
        [self getrefreshdataWithHead:YES SearchType:2];
    }
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(HomeTableView *)hometableview
{
    if (hometableview.header.isRefreshing) {
        //正在下拉刷新
        //关闭
        if (_scrollView.contentOffset.x == 0) {
             self.tabBarItem.badgeValue = nil;
            _unreadViews.hidden = YES;
        }
        [hometableview.header endRefreshing];
        [hometableview.footer resetNoMoreData];
    } else {
        [hometableview.footer endRefreshing];
    }
}

#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head SearchType:(double)searchType
{
    
    if (head == YES) {
        //是下拉刷新
        [self getdataWithPage:1 SearchType:searchType];
        
    } else {
        //上拉加载更多
        HomeTableView *tabelview;
        if (_scrollView.contentOffset.x == 0) {
            tabelview = [_scrollView viewWithTag:100];
            if (_page <= _pages - 1) {
                [self getdataWithPage:_page + 1 SearchType:searchType];
            } else {
                [tabelview.footer noticeNoMoreData];
            }
        } else if (_scrollView.contentOffset.x == KScreenWidth){
            tabelview = [_scrollView viewWithTag:101];
            if (_MyfocusPage <= _MyfocusPages - 1) {
                [self getdataWithPage:_MyfocusPage + 1 SearchType:searchType];
            } else {
                [tabelview.footer noticeNoMoreData];
            }
        } else {
            tabelview = [_scrollView viewWithTag:102];
            if (_MycollectPage <= _MycollectPages - 1) {
                [self getdataWithPage:_MycollectPage + 1 SearchType:searchType];
            } else {
                [tabelview.footer noticeNoMoreData];
            }
        }
    }
}

/**
 *  导航栏按钮
 */
- (void)insertNaviButton
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn-dongtai-n" highImageName:nil target:self action:@selector(writeMessage)];
}

#pragma mark - 写动态
- (void)writeMessage
{
    WriteViewController *writeVC = [[WriteViewController alloc] init];
    [self.navigationController pushViewController:writeVC animated:YES];
}




@end
