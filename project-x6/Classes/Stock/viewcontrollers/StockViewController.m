//
//  StockViewController.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "StockViewController.h"
#import "BaseTabBarViewController.h"
#import "PersonsModel.h"
#import "GwModel.h"
#import "kuangjiaModel.h"

#import "PersonsTableViewCell.h"

#import "ChineseString.h"

#import "CompanysViewController.h"
#import "GwsViewController.h"

#import "HeaderViewController.h"

#import "WriteViewController.h"

#import "GroupListViewController.h"
#import "ConversationListController.h"



static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface StockViewController ()<IChatManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

{
    UITableView *_tableView;   //联系人页面
    NSMutableArray *_nameArray;
    
    UIButton *_contactList;
    UIImageView *_unreadCantact;
    
    
    EMConnectionState _connectionState;
    
    
    UILabel *_label;
    ConversationListController *_chatListVC;
    GroupListViewController *_groupListVC;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@property(nonatomic,copy)NSMutableArray *sections;          //获取右侧提示文本数据
@property(nonatomic,copy)NSMutableArray *sectionDatalist;   //数据按照首字母分类
@property(nonatomic,strong)NSMutableArray *newdatalist;       //搜索后的数据
@property (strong, nonatomic)UISearchBar *stocksearchBar;

@property(nonatomic,strong)NSArray *selectpersonArray;          //选中的联系人
@property(nonatomic,copy)NSMutableArray *personsList;

@end

@implementation StockViewController


- (void)dealloc
{
    [self unregisterNotifications];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"联系人"];
    
    // 初始化子视图
    [self initSubViews];
    
    //获取数据
    [self getPersonsData];
    
    if (_type == YES) {
        self.selectPersons = YES;
    } else {
        //添加会话按钮
        _contactList = [UIButton buttonWithType:UIButtonTypeCustom];
        _contactList.frame = CGRectMake(0, 27, 27, 21);
        [_contactList setBackgroundImage:[UIImage imageNamed:@"btn_xixiaotixing_n"] forState:UIControlStateNormal];
        [_contactList addTarget:self action:@selector(contactList:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_contactList];
        
    }
    
    [self registerNotifications];
    [self setupUnreadMessageCount];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示搜索框
    _stocksearchBar.hidden = NO;
    
    NSLog(@"联系人%@",self.view.subviews);
    
}




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _stocksearchBar.hidden = YES;
    
    //移除键盘
    if ([_stocksearchBar isFirstResponder]) {
        [_stocksearchBar resignFirstResponder];
    }
    //隐藏搜索框
    NSLog(@"联系人页面移除");
    
}
#pragma mark - 初始化子视图
- (void)initSubViews
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _stocksearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    _stocksearchBar.delegate = self;
    _stocksearchBar.placeholder = @"搜索";
    _stocksearchBar.showsScopeBar = YES;
    _stocksearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_stocksearchBar];
    
    NSArray *feileiTitle = nil;
    NSArray *buttonImages = nil;
    if (_type == YES) {
        feileiTitle = @[@"按岗位",@"按公司框架"];
        buttonImages = @[@"btn_gangwei_h",@"btn_kuangjia_h"];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 44) style:UITableViewStylePlain];
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        [_tableView setEditing:YES];
    } else {
        feileiTitle = @[@"按岗位",@"按公司框架",@"群组"];
        buttonImages = @[@"btn_gangwei_h",@"btn_kuangjia_h",@"btn_qun_h"];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 64 - 49 - 44) style:UITableViewStylePlain];
        [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getPersonsData)];
        
    }
    //添加分类
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50 * feileiTitle.count)];
    for (int i = 0; i < feileiTitle.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50 * i, KScreenWidth, 50)];
        [button addTarget:self action:@selector(PersonbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1400 + i;
        [view addSubview:button];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        imageview.image = [UIImage imageNamed:buttonImages[i]];
        [button addSubview:imageview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
        label.text = feileiTitle[i];
        [button addSubview:label];
        
        if (i < feileiTitle.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 49, KScreenWidth - 20, 1)];
            lineView.backgroundColor = LineColor;
            [button addSubview:lineView];
        }
        
    }
    
    //联系人页面
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = view;
    
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    for (id view in [_stocksearchBar subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.newdatalist removeAllObjects];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.newdatalist removeAllObjects];
    if (searchBar.text.length == 0) {
        self.newdatalist = [_datalist mutableCopy];
    }
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", _stocksearchBar.text];
    self.newdatalist = [[_nameArray filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}



- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.newdatalist removeAllObjects];
    self.stocksearchBar.text = @"";
    [self.stocksearchBar resignFirstResponder];
    
    [self.stocksearchBar setShowsCancelButton:NO animated:NO];
    
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.stocksearchBar resignFirstResponder];
}




#pragma mark - 分类按钮
- (void)PersonbuttonAction:(UIButton *)button
{
    if ([_stocksearchBar isFirstResponder]) {
        [_stocksearchBar resignFirstResponder];
    }
    
    if (_type == YES) {
        if (button.tag == 1400) {
            GwsViewController *gwVC = [[GwsViewController alloc] init];
            gwVC.replytype = _replytype;
            gwVC.type = _type;
            gwVC.datalist = _datalist;
            gwVC.gwdatalist = _gwdatalist;
            gwVC.comdatalist = [_kuangjiadatalist mutableCopy];
            [self.navigationController pushViewController:gwVC animated:YES];
        } else if (button.tag == 1401){
            CompanysViewController *companysVC = [[CompanysViewController alloc] init];
            companysVC.datalist = _datalist;
            companysVC.type = _type;
            companysVC.replytype = _replytype;
            companysVC.kuangjiadatalist = [_kuangjiadatalist mutableCopy];
            [self.navigationController pushViewController:companysVC animated:YES];
        }
    } else {
        if (button.tag == 1400) {
            GwsViewController *gwVC = [[GwsViewController alloc] init];
            gwVC.datalist = _datalist;
            gwVC.gwdatalist = _gwdatalist;
            gwVC.comdatalist = [_kuangjiadatalist mutableCopy];
            [self.navigationController pushViewController:gwVC animated:YES];
        } else if (button.tag == 1401){
            CompanysViewController *companysVC = [[CompanysViewController alloc] init];
            companysVC.datalist = _datalist;
            companysVC.kuangjiadatalist = [_kuangjiadatalist mutableCopy];
            [self.navigationController pushViewController:companysVC animated:YES];
        } else {
            NSLog(@"群组");
            GroupListViewController *groupVC = [[GroupListViewController alloc] init];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
    }
}


#pragma mark - UITableViewDataSource
//组的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![_stocksearchBar isFirstResponder]) {
        return _sections.count;
    } else {
        return 1;
    }
}

///右侧提示文本
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (![_stocksearchBar isFirstResponder]) {
        return _sections;
    } else {
        return nil;
    }
}

//组名
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![_stocksearchBar isFirstResponder]) {
        return _sections[section];
    } else {
        return nil;
    }
}

//每一组的条数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![_stocksearchBar isFirstResponder]) {
        return [[_sectionDatalist objectAtIndex:section] count];
    } else {
        return _newdatalist.count;
    }
}

//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PersonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[PersonsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.datalist = _datalist;
    cell.comdatalist = _kuangjiadatalist;
    //文本
    if (![_stocksearchBar isFirstResponder]) {
        cell.name = [[_sectionDatalist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
    } else {
        cell.name = _newdatalist[indexPath.row];
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == YES) {
        _selectpersonArray = [NSMutableArray array];
   
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HeaderViewController *headerVC = [[HeaderViewController alloc] init];
        headerVC.type = YES;
        if ([_stocksearchBar isFirstResponder]) {
            for (NSDictionary *dic in _datalist) {
                if ([[dic valueForKey:@"name"] isEqualToString:_newdatalist[indexPath.row]]) {
                    headerVC.dic = dic;
                }
            }
            
        } else {
            for (NSDictionary *dic in _datalist) {
                if ([[dic valueForKey:@"name"] isEqualToString:[_sectionDatalist[indexPath.section] objectAtIndex:indexPath.row]]) {
                    headerVC.dic = dic;
                }
            }
        }
        [self.navigationController pushViewController:headerVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 获取联系人的数据
- (void)getPersonsData
{
    if ([_stocksearchBar isFirstResponder]) {
        [_stocksearchBar resignFirstResponder];
    }
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *personsURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_persons];
    if (!_tableView.header.isRefreshing) {
        [GiFHUD show];
    }
    [XPHTTPRequestTool requestMothedWithPost:personsURL params:nil success:^(id responseObject) {
        
        if (_tableView.header.isRefreshing) {
            [_tableView.header endRefreshing];
        }
        if ([[responseObject valueForKey:@"userList"] count] != 0) {
            _datalist = nil;
            _datalist = [PersonsModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"userList"] ignoredKeys:@[@"phone",@"ssgs"]];
            _gwdatalist = [GwModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"gwList"]];
            _kuangjiadatalist = [kuangjiaModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"gsList"]];
            
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            if ([userdefaults objectForKey:X6_Contactlist] == NULL) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //将数据写入本地
                    [self writeContactListData];
                    
                });
            }
            //获取姓名数据
            _nameArray = [NSMutableArray array];
            for (NSDictionary *dic in _datalist) {
                NSString *name = [dic valueForKey:@"name"];
                [_nameArray addObject:name];
            }
            
            _sections = [ChineseString IndexArray:_nameArray];    //右侧的提示文本
            _sectionDatalist = [ChineseString LetterSortArray:_nameArray];    //数据分类
            [_tableView reloadData];
        }
        
    } failure:^(NSError *error) {
//        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
    }];
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

#pragma mark - 将数据写入本地
- (void)writeContactListData
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *gsdm = [[userdefaults objectForKey:X6_UserMessage] valueForKey:@"gsdm"];
    NSMutableArray *huanxinContacts = [NSMutableArray array];
    
    for (NSDictionary *dic in _datalist) {
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


#pragma mark - 重写确定联系人按钮事件
- (void)sureAction:(UIButton *)button
{
    //确定联系人列表
    //判断岗位列表和公司框架列表
    
    _selectpersonArray = [NSArray array];
    _selectpersonArray = [_tableView indexPathsForSelectedRows];
    //处理数据
    _personsList = [NSMutableArray array];
    if (_replytype == NO) {
        if ([_stocksearchBar isFirstResponder]) {
            [self getPersondatalistWithArray:_newdatalist Section:YES];
        } else {
            [self getPersondatalistWithArray:_sectionDatalist Section:NO];
        }
    } else {
        if ([_stocksearchBar isFirstResponder]) {
            for (NSIndexPath *indec in _selectpersonArray) {
                NSString *name = _newdatalist[indec.row];
                [_personsList addObject:name];
            }
        } else {
            for (NSIndexPath *indec in _selectpersonArray) {
                NSString *name = [_sectionDatalist[indec.section] objectAtIndex:indec.row];
                [_personsList addObject:name];
            }
        }
        
    }
    
    if (_personsList.count != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stockList" object:_personsList];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)getPersondatalistWithArray:(NSArray *)array Section:(BOOL)section
{
    for (NSIndexPath *indec in _selectpersonArray) {
        NSString *name;
        if (section == YES) {
            name = array[indec.row];
        } else {
            name = [array[indec.section] objectAtIndex:indec.row];
        }
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"name"] isEqualToString:name]) {
                NSMutableDictionary *diced = [NSMutableDictionary dictionary];
                [diced setObject:[dic valueForKey:@"id"] forKey:@"id"];
                [diced setObject:[dic valueForKey:@"usertype"] forKey:@"usertype"];
                [_personsList addObject:diced];
            }
        }
    }
}


#pragma mark - 会话列表按钮
- (void)contactList:(UIButton *)button
{
    ConversationListController *converationVC = [[ConversationListController alloc] init];
    converationVC.datalist = _datalist;
    [self.navigationController pushViewController:converationVC animated:YES];
}


#pragma mark - IChatManagerDelegate
- (void)registerNotifications
{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


//本地通知
- (void)didReceiveMessage:(EMMessage *)message
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground) {
        
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        //发送本地通知
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date];  //出发通知事件
        //        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
            //            id<IEMMessageBody>messageBody = [message.messageBodies firstObject];
            
            //            NSString *messageStr;
            //            switch (messageBody.messageBodyType) {
            //                case eMessageBodyType_Text:
            //                {
            //                    messageStr = ((EMTextMessageBody *)messageBody).text;
            //                }
            //                    break;
            //                case eMessageBodyType_Image:
            //                {
            //                    messageStr = NSLocalizedString(@"message.image", @"Image");
            //                }
            //                    break;
            //                case eMessageBodyType_Location:
            //                {
            //                    messageStr = NSLocalizedString(@"message.location", @"Location");
            //                }
            //                    break;
            //                case eMessageBodyType_Voice:
            //                {
            //                    messageStr = NSLocalizedString(@"message.voice", @"Voice");
            //                }
            //                    break;
            //                default:
            //                    break;
            //            }
            
            
            //        NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.messageType == eMessageTypeGroupChat) {
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationChatter]) {
                        //                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                        break;
                    }
                }
            }
            //        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } else {
            notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
        }
        notification.alertBody = [[NSString alloc] initWithFormat:@"%@", notification.alertBody];
        
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        
        notification.userInfo = userInfo;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        //        UIApplication *application = [UIApplication sharedApplication];
        //        application.applicationIconBadgeNumber += 1;
        
    } else if (state == UIApplicationStateInactive) {
        [self playSoundAndVibration];
    } else if (state == UIApplicationStateActive) {
        [self playSoundAndVibration];
    }
    
    
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    [_chatListVC refreshDataSource];
    
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if (unreadCount > 0) {
        if (_label == nil) {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(18, -5, 20, 20)];
            _label.clipsToBounds = YES;
            _label.layer.cornerRadius = 10;
            _label.backgroundColor = [UIColor redColor];
            _label.font = [UIFont systemFontOfSize:12];
            _label.textColor = [UIColor whiteColor];
            _label.textAlignment = NSTextAlignmentCenter;
            [_contactList addSubview:_label];
        }
        _label.hidden = NO;
        if (_unreadCantact == nil) {
            _unreadCantact = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth / 5.0) * 2 - 24, 5, 10, 10)];
            _unreadCantact.image = [UIImage imageNamed:@"SmallPoint"];
            BaseTabBarViewController *centerVC = (BaseTabBarViewController *)self.navigationController.tabBarController;
            [centerVC.customTabBar addSubview:_unreadCantact];
        }
        _unreadCantact.hidden = NO;
        if (unreadCount > 99) {
            _label.text = @"99+";
        } else {
            _label.text = [NSString stringWithFormat:@"%d",(int)unreadCount];
        }
        
    } else if (unreadCount == 0) {
        _label.hidden = YES;
        if (_unreadCantact != nil) {
            _unreadCantact.hidden = YES;
        }
    }
    
    
    //未读消息数
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif
    
    [_groupListVC reloadDataSource];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
        
        [_groupListVC reloadDataSource];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}


- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed to join the group of \'%@\'"), groupname];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatListVC isConnect:NO];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.endAutoLogin", @"End automatic login...") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
    }
}


@end
