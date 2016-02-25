//
//  HeaderViewController.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HeaderViewController.h"
#import "HomeModel.h"
#import "ChatViewController.h"
#import "Persontableviewed.h"
@interface HeaderViewController ()

{
    UIImageView *_bgView;
    Persontableviewed *_personTableView;
    double _page;
    double _pages;
}

@property(nonatomic,strong)NoDataView *noDynamicView; //没有动态提示


@end

@implementation HeaderViewController

- (NoDataView *)noDynamicView
{
    if (!_noDynamicView) {
        _noDynamicView = [[NoDataView alloc] initWithFrame:CGRectMake(0, _bgView.bottom, KScreenWidth, KScreenHeight - 64 - _bgView.height)];
        _noDynamicView.text = @"该用户无动态";
        [self.view addSubview:_noDynamicView];
    }
    return _noDynamicView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self naviTitleWhiteColorWithText:[NSString stringWithFormat:@"%@的动态",[_dic valueForKey:@"name"]]];

    
    //获取数据
    [self getPersonDynamicDataWithPage:1];
    //初始化子视图
    [self initSubViews];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"头像点击页面收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }

}

#pragma mark - 初始化表示图
- (void)initSubViews
{
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
    _bgView.userInteractionEnabled = YES;
    _bgView.image = [UIImage imageNamed:@"btn_beijing_n"];

    //头像设置
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 100) / 2.0, 10, 100, 100)];
    headerView.clipsToBounds = YES;
    headerView.layer.cornerRadius = 50;
    //头像数据
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    NSString *picURLString;
    if (_type) {
        if ([[_dic valueForKey:@"usertype"] intValue] == 0) {
            picURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[_dic valueForKey:@"userpic"]];
        } else {
            picURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[_dic valueForKey:@"userpic"]];
        }
    } else {
        if ([[_dic valueForKey:@"userType"] intValue] == 0) {
            picURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[_dic valueForKey:@"userpic"]];
        } else {
            picURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[_dic valueForKey:@"userpic"]];
        }
    }
    
    [headerView sd_setImageWithURL:[NSURL URLWithString:picURLString] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    [_bgView addSubview:headerView];
    
    //个人信息
    NSArray *personDetail;
    if (_type) {
        if ([[_dic valueForKey:@"usertype"] integerValue] == 1) {
            personDetail = @[[_dic valueForKey:@"name"],[NSString stringWithFormat:@"%@  营业员",[_dic valueForKey:@"ssgsname"]]];
        } else {
            personDetail = @[[_dic valueForKey:@"name"],[NSString stringWithFormat:@"%@  操作员",[_dic valueForKey:@"ssgsname"]]];
        }
    } else {
        if ([[_dic valueForKey:@"userType"] integerValue] == 1) {
            personDetail = @[[_dic valueForKey:@"name"],[NSString stringWithFormat:@"%@  营业员",[_dic valueForKey:@"ssgsname"]]];
        } else {
            personDetail = @[[_dic valueForKey:@"name"],[NSString stringWithFormat:@"%@  操作员",[_dic valueForKey:@"ssgsname"]]];
        }
    }
    
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.bottom + 5 + 25 * i, KScreenWidth, 20)];
        label.text = personDetail[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
       
        [_bgView addSubview:label];
    }

    
    //个人信息功能－打电话，关注，即时消息
    NSArray *buttonLabel = @[@"电话",@"消息",@"关注"];
    NSArray *buttonImages = @[@"btn_dianhua_h",@"btn_xinxi_h",@"btn_guanzhu_h"];
    for (int i = 0; i < buttonImages.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1300 + i;
        button.frame = CGRectMake(KScreenWidth / 2.0 - 120 + 90 * i, headerView.bottom + 10 + 50, 30, 30);
        [button setImage:[UIImage imageNamed:buttonImages[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(HeaderbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth /2.0 - 125 + 90 * i, button.bottom + 5, 40, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = buttonLabel[i];
        [_bgView addSubview:button];
        [_bgView addSubview:label];
    }
    
}

- (void)initTableView
{
    //显示列表
    _personTableView = [[Persontableviewed alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _personTableView.name = [_dic valueForKey:@"name"];
    
    [_personTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(HeaderViewheaderAction)];
    [_personTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(HeaderViewfooterAction)];
    _personTableView.tableHeaderView = _bgView;
    [self.view addSubview:_personTableView];
    NSMutableArray *array;
    array = [[_datalist mutableCopy] loadframeKeyWithDatalist];
    _personTableView.datalist = array;
    [_personTableView reloadData];
}

#pragma mark - 按钮事件
- (void)HeaderbuttonAction:(UIButton *)button
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    if ([[_dic valueForKey:@"name"] isEqualToString:[dic valueForKey:@"name"]]) {
        if (button.tag == 1300) {
            [self writeWithName:@"不能自我拨号"];
        } else if (button.tag == 1301) {
            [self writeWithName:@"不能发送消息给自己"];
        } else {
            [self writeWithName:@"不能关注自己"];
        }
    } else {
        if (button.tag == 1300) {
            //判断是否有电话
            NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",[_dic valueForKey:@"phone"]];
            if (phone.length == 4) {
                [self writeWithName:@"当前用户没有手机号码"];
            } else {
                //打电话
                UIWebView *callWebView = [[UIWebView alloc] init];
                [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phone]]];
                [self.view addSubview:callWebView];
            }
        } else if (button.tag == 1301) {
            //消息
            NSLog(@"消息");
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
            if ([[_dic valueForKey:@"hxflag"] intValue] == 1) {
                NSString *easeID = [NSString stringWithFormat:@"%@%@",[dic valueForKey:@"gsdm"],[_dic valueForKey:@"phone"]];
                ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:easeID conversationType:eConversationTypeChat];
                chatVC.title = [_dic valueForKey:@"name"];
                [self.navigationController pushViewController:chatVC animated:YES];
            } else  {
                [self writeWithName:@"该用户还未登录"];
            }

        } else {
            //关注
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSString *userURL = [userdefaults objectForKey:X6_UseUrl];
            NSString *focusURL = [NSString stringWithFormat:@"%@%@",userURL,X6_focus];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (_type) {
                [params setObject:[_dic valueForKey:@"id"] forKey:@"msguserid"];
                [params setObject:[_dic valueForKey:@"usertype"] forKey:@"msgusertype"];
            } else {
                [params setObject:[_dic valueForKey:@"senderid"] forKey:@"msguserid"];
                [params setObject:[_dic valueForKey:@"userType"] forKey:@"msgusertype"];
            }
            [XPHTTPRequestTool requestMothedWithPost:focusURL params:params success:^(id responseObject) {
                //关注成功
                [self writeWithName:@"关注成功"];
            } failure:^(NSError *error) {
                [BasicControls showNDKNotifyWithMsg:@"关注失败 请检查您的网络连接" WithDuration:0.5f speed:0.5f];
            }];
            
        }

    }
    
}




#pragma mark - 下拉刷新，上拉加载更多
- (void)HeaderViewfooterAction
{
    //判断是哪一个表示图
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [self getrefreshdataWithHead:NO];
}

- (void)HeaderViewheaderAction
{
    [self getrefreshdataWithHead:YES];
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(Persontableviewed *)personTableView
{
    if (personTableView.header.isRefreshing) {
        //正在下拉刷新
        //关闭
        [personTableView.header endRefreshing];
        [personTableView.footer resetNoMoreData];
    } else {
        [personTableView.footer endRefreshing];
    }
}

#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head
{
    
    if (head == YES) {
        //是下拉刷新
        [self getPersonDynamicDataWithPage:1];
        
    } else {
        //上拉加载更多
        if (_page <= _pages - 1) {
            [self getPersonDynamicDataWithPage:_page + 1];
        } else {
            [_personTableView.footer noticeNoMoreData];
        }
        
    }
}


#pragma mark - 获取数据
- (void)getPersonDynamicDataWithPage:(double)page
{
    NSString *userid;
    NSString *userType;
    if (_type) {
        userid = [_dic valueForKey:@"id"];
        userType = [_dic valueForKey:@"usertype"];
    } else {
        userid = [_dic valueForKey:@"senderid"];
        userType = [_dic valueForKey:@"userType"];
    }
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *personDynamicURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_personDynamic];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userid forKey:@"userid"];
    [params setObject:userType forKey:@"usertype"];
    [params setObject:@(8) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@"zdrq" forKey:@"sidx"];
    [params setObject:@"desc" forKey:@"sord"];
    
    [GiFHUD show];
    [XPHTTPRequestTool requestMothedWithPost:personDynamicURL params:params success:^(id responseObject) {
        if (_personTableView.header.isRefreshing || _personTableView.footer.isRefreshing) {
            [self endrefreshWithTableView:_personTableView];
        }
        
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [_personTableView.footer noticeNoMoreData];
        }
        
        
        if (_datalist.count == 0 || _personTableView.header.isRefreshing) {
            _datalist = [HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        } else {
            _datalist = [_datalist arrayByAddingObjectsFromArray:[HomeModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
        }
        _page = [[responseObject valueForKey:@"page"] doubleValue];
        _pages = [[responseObject valueForKey:@"pages"] doubleValue];
        if (_datalist.count == 0) {
            [self noDynamicView];
            
            [self.view addSubview:_bgView];
        } else {
            if (_noDynamicView) {
                _noDynamicView.hidden = YES;
            }
            [self initTableView];
        }
 
    } failure:^(NSError *error) {
        NSLog(@"获取失败");
        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
    }];
    
}

@end
