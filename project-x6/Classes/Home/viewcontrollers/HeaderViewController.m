//
//  HeaderViewController.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "HeaderViewController.h"
#import "HomeModel.h"
#import "PersonsModel.h"

#import "ChatViewController.h"
#import "HomeTableView.h"

#define ThirdPcentWidth ((KScreenWidth - 2) / 3)
@interface HeaderViewController ()

{
    UIView *_bgView;
    HomeTableView *_personTableView;
    double _page;
    double _pages;
}

@property(nonatomic,strong)NoDataView *noDynamicView; //没有动态提示
@property(nonatomic,assign)BOOL isConcerned;          //是否被关注
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
    [self naviTitleWhiteColorWithText:@"个人中心"];
    
    
    //获取数据
    [self getPersonDynamicDataWithPage:1];
    //初始化子视图
    [self initSubViews];
    //是否关注
    [self judgewhetherconcerned];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 130)];
    _bgView.userInteractionEnabled = YES;
    _bgView.backgroundColor = [UIColor whiteColor];
    
    //头像
    UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 39, 39)];
    UIImageView *cornView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 17.5, 44, 44)];
    cornView.image = [UIImage imageNamed:@"corner_circle"];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    
    //头像
    //通过usertype判断员工还是营业员
    NSString *headerURLString = nil;
    NSString *headerpic = [self.dic valueForKey:@"userpic"];
    if (headerpic.length == 0) {
        NSArray *array = @[[UIColor colorWithRed:161/255.0f green:136/255.0f blue:127/255.0f alpha:1],
                           [UIColor colorWithRed:246/255.0f green:94/255.0f blue:141/255.0f alpha:1],
                           [UIColor colorWithRed:238/255.0f green:69/255.0f blue:66/255.0f alpha:1],
                           [UIColor colorWithRed:245/255.0f green:197/255.0f blue:47/255.0f alpha:1],
                           [UIColor colorWithRed:255/255.0f green:148/255.0f blue:61/255.0f alpha:1],
                           [UIColor colorWithRed:107/255.0f green:181/255.0f blue:206/255.0f alpha:1],
                           [UIColor colorWithRed:94/255.0f green:151/255.0f blue:246/255.0f alpha:1],
                           [UIColor colorWithRed:154/255.0f green:137/255.0f blue:185/255.0f alpha:1],
                           [UIColor colorWithRed:106/255.0f green:198/255.0f blue:111/255.0f alpha:1],
                           [UIColor colorWithRed:120/255.0f green:192/255.0f blue:110/255.0f alpha:1]];
        
        int x = arc4random() % 10;
        [headerView setBackgroundColor:(UIColor *)array[x]];
        NSString *lastTwoName = self.dic[@"name"];
        lastTwoName = [lastTwoName substringWithRange:NSMakeRange(lastTwoName.length - 2, 2)];
        [headerView setTitle:lastTwoName forState:UIControlStateNormal];
    } else {
        if ([[self.dic valueForKey:@"userType"] intValue] == 0) {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[self.dic valueForKey:@"userpic"]];
        } else {
            headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[self.dic valueForKey:@"userpic"]];
        }
        NSURL *headerURL = [NSURL URLWithString:headerURLString];
        if (headerURL) {
            [headerView sd_setBackgroundImageWithURL:headerURL forState:UIControlStateNormal placeholderImage:nil options:SDWebImageLowPriority];
            [headerView setTitle:@"" forState:UIControlStateNormal];
        }
        
    }
    
    [_bgView addSubview:headerView];
    [_bgView addSubview:cornView];


    //个人信息
    NSArray *personDetail;
    personDetail = @[[_dic valueForKey:@"name"],[_dic valueForKey:@"phone"],[NSString stringWithFormat:@"%@  %@",[_dic valueForKey:@"ssgsname"],[_dic valueForKey:@"gw"]]];
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(59, 8 + 22 * i, KScreenWidth - 69, 20)];
        label.text = personDetail[i];
        if (i < 2) {
            label.font = MainFont;
            label.textColor = [UIColor blackColor];
        } else {
            label.font = ExtitleFont;
            label.textColor = ExtraTitleColor;
        }
        [_bgView addSubview:label];
    }

    //绘制分割线
    UIView *firstLineView = [BasicControls drawLineWithFrame:CGRectMake(0, 84, KScreenWidth, 1)];
    [_bgView addSubview:firstLineView];
    
    for (int i = 1; i < 3; i++) {
        UIView *secondLineView = [BasicControls drawLineWithFrame:CGRectMake(ThirdPcentWidth * i, 84, 1, 45)];
        [_bgView addSubview:secondLineView];
    }

    //个人信息功能－打电话，关注，即时消息
    NSArray *buttonLabel = @[@"拨号",@"消息",@"关注"];
    NSArray *buttonImages = @[@"g4_a",@"g4_b",@"g4_c"];
    for (int i = 0; i < buttonImages.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1300 + i;
        button.frame = CGRectMake(ThirdPcentWidth * i, 85, ThirdPcentWidth, 45);
        
        [button addTarget:self action:@selector(HeaderbuttonAction:) forControlEvents:UIControlEventTouchUpInside];

        [button setImage:[UIImage imageNamed:buttonImages[i]] forState:UIControlStateNormal];//给button添加image
        button.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,13);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        
        [button setTitle:buttonLabel[i] forState:UIControlStateNormal];//设置button的title
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = MainFont;//title字体大小
        button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）

        
        
        
        
        [_bgView addSubview:button];
    }
    
}

- (void)initTableView
{
    //显示列表
    _personTableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _personTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
            if ([[_dic valueForKey:@"hxflag"] intValue] == 1) {
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                NSString *gsdm = [[userdefaults objectForKey:X6_UserMessage] valueForKey:@"gsdm"];
                NSString *easeID = [NSString stringWithFormat:@"%@%@%@",gsdm,[_dic valueForKey:@"usertype"],[_dic valueForKey:@"phone"]];
                ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:easeID conversationType:eConversationTypeChat];
                chatVC.title = [_dic valueForKey:@"name"];
                //判断是否有联系人数据
                if ([userdefaults objectForKey:X6_Contactlist] == NULL) {
                    dispatch_group_t grouped = dispatch_group_create();
                    dispatch_group_enter(grouped);
                    NSString *baseURL = [userdefaults objectForKey:X6_UseUrl];
                    NSString *personsURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_persons];
                    [XPHTTPRequestTool requestMothedWithPost:personsURL params:nil success:^(id responseObject) {
                        NSArray *contactList = [PersonsModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"userList"] ignoredKeys:@[@"phone",@"ssgs"]];

                        [self writeContactListDataWithContactlist:contactList];
                        dispatch_group_leave(grouped);

                    } failure:^(NSError *error) {
                        dispatch_group_leave(grouped);

                    }];
                    dispatch_group_notify(grouped, dispatch_get_main_queue(), ^{
                        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                        NSMutableArray *contactList = [userdefaults objectForKey:X6_Contactlist];
                        NSLog(@"%@",contactList);
                        [self.navigationController pushViewController:chatVC animated:YES];
                    });
                } else {
                    [self.navigationController pushViewController:chatVC animated:YES];

                }
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
                UIButton *concrened = [_bgView viewWithTag:1302];
                if (_isConcerned == NO) {
                    [self writeWithName:@"关注成功"];
                    _isConcerned = YES;
                    [concrened setTitle:@"已关注" forState:UIControlStateNormal];
                    [concrened setImage:[UIImage imageNamed:@"g4_d"] forState:UIControlStateNormal];
                } else {
                    [self writeWithName:@"取消关注成功"];
                    _isConcerned = NO;
                    [concrened setTitle:@"关注" forState:UIControlStateNormal];
                    [concrened setImage:[UIImage imageNamed:@"g4_c"] forState:UIControlStateNormal];
                }
            } failure:^(NSError *error) {
//                [BasicControls showNDKNotifyWithMsg:@"关注失败 请检查您的网络连接" WithDuration:0.5f speed:0.5f];
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
- (void)endrefreshWithTableView:(HomeTableView *)personTableView
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
//获取个人动态数据
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
    if (!_personTableView.header.isRefreshing || !_personTableView.footer.isRefreshing) {
        [self showProgress];
    }
    [XPHTTPRequestTool requestMothedWithPost:personDynamicURL params:params success:^(id responseObject) {
        [self hideProgress];
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
        [self hideProgress];
    }];
    
}

//判断是否已经关注
- (void)judgewhetherconcerned
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *judgeconcernURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_whetherConcerned];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_type) {
        [params setObject:[_dic valueForKey:@"id"] forKey:@"msguserid"];
        [params setObject:[_dic valueForKey:@"usertype"] forKey:@"msgusertype"];
    } else {
        [params setObject:[_dic valueForKey:@"senderid"] forKey:@"msguserid"];
        [params setObject:[_dic valueForKey:@"userType"] forKey:@"msgusertype"];
    }
    [XPHTTPRequestTool requestMothedWithPost:judgeconcernURL params:params success:^(id responseObject) {
        UIButton *concrened = [_bgView viewWithTag:1302];
        if ([responseObject[@"message"] isEqualToString:@"exist"]) {
            _isConcerned = YES;
            [concrened setTitle:@"已关注" forState:UIControlStateNormal];
            [concrened setImage:[UIImage imageNamed:@"g4_d"] forState:UIControlStateNormal];
        } else {
            _isConcerned = NO;
            [concrened setTitle:@"关注" forState:UIControlStateNormal];
            [concrened setImage:[UIImage imageNamed:@"g4_c"] forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 将数据写入本地
- (void)writeContactListDataWithContactlist:(NSArray *)contactlist
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *gsdm = [[userdefaults objectForKey:X6_UserMessage] valueForKey:@"gsdm"];
    NSMutableArray *huanxinContacts = [NSMutableArray array];
    
    for (NSDictionary *dic in contactlist) {
        @autoreleasepool {
            NSString *headerURLString,*easeID;
            if ([[dic valueForKey:@"usertype"] intValue] == 0) {
                headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_czyURL,gsdm,[dic valueForKey:@"userpic"]];
            } else {
                headerURLString = [NSString stringWithFormat:@"%@%@/%@",X6_ygURL,gsdm,[dic valueForKey:@"userpic"]];
            }
            easeID = [NSString stringWithFormat:@"%@%@%@",gsdm,[dic valueForKey:@"usertype"],[dic valueForKey:@"phone"]];
            
            NSString *easeNickName = [dic valueForKey:@"name"];
            NSNumber *hxflag = [dic valueForKey:@"hxflag"];
            NSMutableDictionary *FBdic = [NSMutableDictionary dictionary];
            [FBdic setObject:easeID forKey:@"username"];
            [FBdic setObject:headerURLString forKey:@"avatar"];
            [FBdic setObject:easeNickName forKey:@"nickname"];
            [FBdic setObject:hxflag forKey:@"hxflag"];
            [huanxinContacts addObject:FBdic];
        }

    }
    [userdefaults setObject:huanxinContacts forKey:X6_Contactlist];
    [userdefaults synchronize];
    
}

@end
