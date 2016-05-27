//
//  MianDynamicViewController.m
//  project-x6
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MianDynamicViewController.h"
#import "ReplyModel.h"
#import "ReplyTableView.h"
#import "XPPhotoViews.h"
#import "StockViewController.h"
#import "TxtViewController.h"

#import "IQKeyboardManager.h"

@interface MianDynamicViewController ()<UITextViewDelegate>

@property(nonatomic,copy)NSArray *personList;
@property(nonatomic,copy)NSMutableString *personString;

@end

@implementation MianDynamicViewController



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //移除联系人列表通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gwsList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gwPersonList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"companysList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"companyPersonList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"stockList" object:nil];
    
    _personList = nil;
    _datalist = nil;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self naviTitleWhiteColorWithText:@"动态详情"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化动态详情页面
    [self initWithSubview];
    
    //获取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getReplyDataWithPage:1];
        
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //监听岗位通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainpersonsList:) name:@"gwsList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainpersonsList:) name:@"gwPersonList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainpersonsList:) name:@"companysList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainpersonsList:) name:@"companyPersonList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainpersonsList:) name:@"stockList" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_textfield resignFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self drawCollectedButton];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"消息详情收到警告");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            self.view = nil;
        }
    }
}

#pragma mark - 初始化动态详情页面
- (void)initWithSubview
{
    //绘制ui
    [self initHeaderView];
    
    //回复按钮
    _replyView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50 - 64, KScreenWidth, 50)];
    _replyView.backgroundColor = GrayColor;
    if (_nodataView.hidden == NO) {
        [self.view insertSubview:_replyView aboveSubview:_nodataView];
    } else {
        [self.view insertSubview:_replyView aboveSubview:_replyView];
    }
    
    //回复按钮上面添加半透明的遮罩
    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 50)];
    _alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    _alphaView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_alphaView addGestureRecognizer:tap];
    
    
    //@按钮
    UIButton *addPersons = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
    [addPersons setImage:[UIImage imageNamed:@"at"] forState:UIControlStateNormal];
    [addPersons addTarget:self action:@selector(addPersons:) forControlEvents:UIControlEventTouchUpInside];
    [_replyView addSubview:addPersons];
    
    
    _textfield = [[UITextView alloc] initWithFrame:CGRectMake(40, 10, KScreenWidth - 40 - 60, 30)];
    _textfield.delegate = self;
    _textfield.keyboardType = UIKeyboardTypeNamePhonePad;
    _textfield.font = [UIFont systemFontOfSize:16];
    [_replyView addSubview:_textfield];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth - 55, 10, 50, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.text = @"评 论";
    [button addSubview:label];
    [button setBackgroundColor:[UIColor colorWithRed:188/255.0f green:196/255.0f blue:200/255.0f alpha:1]];
    button.tag = 2003;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_replyView addSubview:button];
}

#pragma mark -  头视图
- (void)initHeaderView
{
    _bgView = [[UIImageView alloc] init];
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    //头像
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    headerView.clipsToBounds = YES;
    headerView.layer.cornerRadius = 20;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
    NSString *companyString = [dic objectForKey:@"gsdm"];
    if ([[self.dic valueForKey:@"userType"] intValue] == 0) {
        [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_czyURL,companyString,[_dic valueForKey:@"userpic"]]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    } else {
        [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",X6_ygURL,companyString,[_dic valueForKey:@"userpic"]]] placeholderImage:[UIImage imageNamed:@"pho-moren"]];
    }
    
    [_bgView addSubview:headerView];
    
    //基本信息
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerView.right + 10, headerView.top - 5, KScreenWidth - 100 - 20 - 40, 20)];
    nameLabel.text = [self.dic valueForKey:@"name"];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [_bgView addSubview:nameLabel];
    
    UILabel *gwLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 5, nameLabel.width, 10)];
    gwLabel.text = [NSString stringWithFormat:@"%@  %@",[self.dic valueForKey:@"gw"],[self.dic valueForKey:@"ssgsname"]];
    gwLabel.textColor = Mycolor;
    gwLabel.font = [UIFont systemFontOfSize:10];
    [_bgView addSubview:gwLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, gwLabel.bottom + 5, nameLabel.width, 10)];
    timeLabel.text = [self.dic valueForKey:@"fsrq"];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = [UIColor grayColor];
    [_bgView addSubview:timeLabel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [[self.dic valueForKey:@"content"] boundingRectWithSize:CGSizeMake(KScreenWidth - 40, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    MLEmojiLabel *contentLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectMake(headerView.left + 10, headerView.bottom + 10, KScreenWidth - 40, size.height)];
    contentLabel.numberOfLines = 0;
    contentLabel.lineSpacing = 8;
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.emojiText = [self.dic valueForKey:@"content"];
    [_bgView addSubview:contentLabel];
    
    //判断是否有图片
    NSString *filepropString = [_dic objectForKey:@"fileprop"];
    //json解析
    NSArray *fileprop = [filepropString objectFromJSONString];
    
    //回复列表和表头
    _replyTableView = [[ReplyTableView alloc] init];
    _replyTableView.hidden = YES;
    _replyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_replyTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerAction)];
    [_replyTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerAction)];
    _replyTableView.frame = CGRectMake(0, 0 , KScreenWidth, KScreenHeight - 64 - 40);
    NSNumber *fb = [_dic valueForKey:@"zdrdm"];
    _replyTableView.fabuName = [fb longValue];
    [self.view addSubview:_replyTableView];
    
    
    _nodataView = [[NoDataView alloc] init];
    _nodataView.hidden = YES;
    _nodataView.text = @"无回复";
    [self.view addSubview:_nodataView];
    
    int filepropwidth,filepropheight;
    float upheight = 60 + size.height + 10 ;
    if (fileprop.count == 0) {
        _bgView.frame = CGRectMake(0, 0, KScreenWidth, upheight);
        _nodataView.frame = CGRectMake(0, _bgView.bottom, KScreenWidth, KScreenHeight - 60 - size.height - 40);
    } else {
        for (int i = 0; i < fileprop.count; i++) {
            NSArray *endfile = [[fileprop[i] valueForKey:@"name"] componentsSeparatedByString:@"."];
            if ([endfile[1] isEqualToString:@"doc"] || [endfile[1] isEqualToString:@"docx"] || [endfile[1] isEqualToString:@"xlsx"] || [endfile[1] isEqualToString:@"ppt"] || [endfile[1] isEqualToString:@"txt"] || [endfile[1] isEqualToString:@"pptx"]) {
                UIButton *wengdanView = [UIButton buttonWithType:UIButtonTypeCustom];
                wengdanView.frame = CGRectZero;
                if (fileprop.count == 4) {
                    _bgView.frame = CGRectMake(0, 0, KScreenWidth,upheight + 165 + 10);
                    filepropwidth = i / 2;
                    filepropheight = i % 2;
                    wengdanView = [[UIButton alloc] initWithFrame:CGRectMake(20 + 85 * filepropheight,upheight + 85 * filepropwidth, 80, 80)];
                } else {
                    wengdanView = [[UIButton alloc] initWithFrame:CGRectMake(20 + 85 * i, upheight, 80, 80)];
                }
                wengdanView.tag = 5100 + i;
                [wengdanView addTarget:self action:@selector(wendangtapAction:) forControlEvents:UIControlEventTouchUpInside];
                [_bgView addSubview:wengdanView];
                
                if ([endfile[1] isEqualToString:@"doc"] || [endfile[1] isEqualToString:@"docx"]) {
                    [wengdanView setBackgroundImage:[UIImage imageNamed:@"btn-wendang1-n"] forState:UIControlStateNormal];
                } else if ([endfile[1] isEqualToString:@"xlsx"]){
                    [wengdanView setBackgroundImage:[UIImage imageNamed:@"btn-wendang2-n"] forState:UIControlStateNormal];
                } else if ([endfile[1] isEqualToString:@"ppt"] || [endfile[1] isEqualToString:@"pptx"]) {
                    [wengdanView setBackgroundImage:[UIImage imageNamed:@"btn-wendang3-n"] forState:UIControlStateNormal];
                } else if ([endfile[1] isEqualToString:@"txt"]) {
                    [wengdanView setBackgroundImage:[UIImage imageNamed:@"btn-wendang4-n"] forState:UIControlStateNormal];
                }
            } else {
                XPPhotoViews *XPimageViews = [[XPPhotoViews alloc] init];
                if (fileprop.count == 4) {
                    _bgView.frame = CGRectMake(0, 0, KScreenWidth, upheight + 170 + 10);
                    XPimageViews.frame = CGRectMake(20, upheight, 170, 170);
                } else {
                    _bgView.frame = CGRectMake(0, 0, KScreenWidth, upheight + 80 + 10);
                    XPimageViews.frame = CGRectMake(20, upheight, 170, 170);
                }
                //获取图片url,截取拼接
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *dic = [userdefaults objectForKey:X6_UserMessage];
                NSString *companyString = [dic objectForKey:@"gsdm"];
                NSMutableArray *picsURL = [NSMutableArray array];
                for (NSDictionary *dic in fileprop) {
                    NSString *imageurlString = [dic objectForKey:@"name"];
                    NSString *picURLString = [NSString stringWithFormat:@"%@%@/%@",X6_personMessage,companyString,imageurlString];
                    [picsURL addObject:picURLString];
                }
                XPimageViews.picsArray = picsURL;
                [_bgView addSubview:XPimageViews];

            }
            _nodataView.frame = CGRectMake(0, _bgView.bottom, KScreenWidth, KScreenHeight - _bgView.height - 40 - 64);
        }
        
    }
    
    
    
}

- (void)initReplyTableView
{
    _nodataView.hidden = YES;
    _reLabel.hidden = YES;
    _replyTableView.hidden = NO;
    _replyTableView.tableHeaderView = _bgView;
}

- (void)initNoreplyView
{
    _replyTableView.hidden = YES;
    _reLabel.hidden = NO;
    _nodataView.hidden = NO;
}
#pragma mark - 收藏按钮
- (void)drawCollectedButton
{
    //收藏
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame = CGRectMake(KScreenWidth - 10 - 30, 20, 30, 30);
    _clickcount = [[_dic valueForKey:@"issc"] intValue];
    if (_clickcount == 0) {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"btn_meicang_n"] forState:UIControlStateNormal];
    } else if ([[_dic valueForKey:@"issc"] intValue] == 1) {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"btn_shoucang_h"] forState:UIControlStateNormal];
    }
    [_collectButton addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_collectButton];
}

- (void)collectionAction:(UIButton *)button
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *collectURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_collection];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[self.dic valueForKey:@"id"] forKey:@"msgId"];
    if (_clickcount % 2 == 0) {
        [XPHTTPRequestTool requestMothedWithPost:collectURL params:params success:^(id responseObject) {
            //收藏成功
            [self writeWithName:@"收藏成功"];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_shoucang_h"] forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            //收藏失败
            [BasicControls showNDKNotifyWithMsg:@"收藏失败 请检查您的网络连接" WithDuration:0.5f speed:0.5f];
        }];
    } else {
        [XPHTTPRequestTool requestMothedWithPost:collectURL params:params success:^(id responseObject) {
            //收藏成功
            [self writeWithName:@"已取消收藏"];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_meicang_n"] forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            //收藏失败
            NSLog(@"取消收藏失败");
            [BasicControls showNDKNotifyWithMsg:@"取消收藏失败 请检查您的网络连接" WithDuration:0.5f speed:0.5f];
        }];
    }
    _clickcount++;
    
}



#pragma mark - 键盘显示事件
- (void)keyboardShow:(NSNotification *)notification
{
    //获取键盘的高度
    CGFloat boardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    if (boardHeight < 300) {
//        boardHeight = 327.66;
//    }
    NSLog(@"%f",boardHeight);
    //获取键盘的大小
    float duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _replyView.transform = CGAffineTransformMakeTranslation(0, - boardHeight);
        //出现半透明遮罩`
        _alphaView.hidden = NO;
    }];
  
}

#pragma mark - 键盘消失事件
- (void)keyboardHide:(NSNotification *)noti
{
    float duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _replyView.transform = CGAffineTransformIdentity;
        //隐藏版遮罩视图
        _alphaView.hidden = YES;
    }];
  
    
}

#pragma mark - 监听通知
- (void)MainpersonsList:(NSNotification *)notif
{
    _personList = notif.object;
    [self makeTextViewText];
}


#pragma mark - 添加@ 事件
- (void)addPersons:(UIButton *)button
{
    _personList = [NSArray array];
    StockViewController *stockVC = [[StockViewController alloc] init];
    stockVC.type = YES;
    stockVC.replytype = YES;
    
    [self.navigationController pushViewController:stockVC animated:YES];
    
}

#pragma mark - 将联系人添加到输入框里
- (void)makeTextViewText
{
    _personString = [NSMutableString string];
    
    NSString *at = @"@";
    for (NSString *name in _personList) {
        [_personString appendFormat:@"%@%@",at,name];
        
    }
    [_textfield becomeFirstResponder];
    
    if (_textfield.text != 0) {
        _textfield.text = [NSString stringWithFormat:@"%@%@",_textfield.text,_personString];
    } else {
        _textfield.text = [NSString stringWithFormat:@"%@",_personString];
    }
    NSLog(@"%@",_textfield.text);
    
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_nodataView.hidden == NO) {
        [self.view insertSubview:_alphaView aboveSubview:_nodataView];
    } else {
        [self.view insertSubview:_alphaView aboveSubview:_replyTableView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    UIButton *button = [_replyView viewWithTag:2003];
    if (_textfield.text.length != 0) {
        [button setBackgroundColor:Mycolor];
    } else {
        [button setBackgroundColor:[UIColor colorWithRed:188/255.0f green:196/255.0f blue:200/255.0f alpha:1]];
    }
}


#pragma mark - 回复事件
- (void)replyAction:(UIButton *)button
{
    
    NSString *contentString = _textfield.text;
    
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *replyURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_reply];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_dic valueForKey:@"id"] forKey:@"msgId"];
    if (_textfield.text.length == 0) {
        [self writeWithName:@"当前输入框还没有文本"];
        return;
    } else if (_textfield.text.length > 1000) {
        [self writeWithName:@"最多输入140个字符"];
        return;
    } else if (_personString.length != 0) {
        NSArray *textArray = [_textfield.text componentsSeparatedByString:_personString];
        NSString *kongbai = @" ";
        contentString = [NSString stringWithFormat:@"%@%@%@%@",textArray[0],_personString,kongbai,textArray[1]];
        [params setObject:contentString forKey:@"replycontent"];
        
    } else if (_personString.length == 0) {
        [params setObject:contentString forKey:@"replycontent"];
    }
    
    [XPHTTPRequestTool requestMothedWithPost:replyURL params:params success:^(id responseObject) {
        NSLog(@"评论成功");
        _textfield.text = nil;
        [_textfield resignFirstResponder];
        [self writeWithName:@"回复成功"];
        [_replyTableView.header beginRefreshing];
        _personString = nil;
    } failure:^(NSError *error) {
        NSLog(@"回复失败");
        [BasicControls showNDKNotifyWithMsg:@"回复失败 请检查您的网络连接" WithDuration:0.5f speed:0.5f];
    }];
    
}

#pragma mark - 半透明遮罩事件
- (void)tapAction
{
    [_textfield resignFirstResponder];
    _alphaView.hidden = YES;
}

#pragma mark - 获取回复列表数据
- (void)getReplyDataWithPage:(double)page
{
    NSUserDefaults *userdefaluts = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [userdefaluts objectForKey:X6_UseUrl];
    NSString *replyURL = [NSString stringWithFormat:@"%@%@",baseURL,X6_replyList];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *messgageID = [self.dic objectForKey:@"id"];
    [params setValue:messgageID forKey:@"msgId"];
    [params setValue:@(8) forKey:@"rows"];
    [params setValue:@(page) forKey:@"page"];
    [params setValue:@"zdrq" forKey:@"sidx"];
    [params setValue:@"desc" forKey:@"sord"];
    
    [XPHTTPRequestTool requestMothedWithPost:replyURL params:params success:^(id responseObject) {
        
        if (_replyTableView.header.isRefreshing || _replyTableView.footer.isRefreshing) {
            [self endrefreshWithTableView:_replyTableView];
        }
        if ([[responseObject valueForKey:@"rows"] count] < 8) {
            [_replyTableView.footer noticeNoMoreData];
        }
        
        
        if (_datalist.count == 0 || _replyTableView.header.isRefreshing) {
            _datalist = [ReplyModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]];
        } else {
            _datalist = [_datalist arrayByAddingObjectsFromArray:[ReplyModel mj_keyValuesArrayWithObjectArray:[responseObject valueForKey:@"rows"]]];
        }
        
        _page = [[responseObject valueForKey:@"page"] doubleValue];
        _pages = [[responseObject valueForKey:@"pages"] doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_datalist.count == 0) {
                [self initNoreplyView];
            } else {
                [self initReplyTableView];
                _replyTableView.datalist = _datalist;
                [_replyTableView reloadData];
            }
        });
        
        
    } failure:^(NSError *error) {
        NSLog(@"回复失败");
        [BasicControls showNDKNotifyWithMsg:@"当前网络不给力 请检查网络" WithDuration:0.5f speed:0.5f];
    }];
    
}

#pragma mark - 下拉刷新，上拉加载更多
- (void)footerAction
{
    //判断是哪一个表示图
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [self getrefreshdataWithHead:NO];
}

- (void)headerAction
{
    [self getrefreshdataWithHead:YES];
}

#pragma mark - 关闭刷新
- (void)endrefreshWithTableView:(ReplyTableView *)replyTableView
{
    if (replyTableView.header.isRefreshing) {
        //正在下拉刷新
        //关闭
        [replyTableView.header endRefreshing];
        [replyTableView.footer resetNoMoreData];
    } else {
        [replyTableView.footer endRefreshing];
    }
}

#pragma mark - 提取方法
- (void)getrefreshdataWithHead:(BOOL)head
{
    
    if (head == YES) {
        //是下拉刷新
        [self getReplyDataWithPage:1];
        
    } else {
        //上拉加载更多
        if (_page <= _pages - 1) {
            [self getReplyDataWithPage:_page + 1];
        } else {
            [_replyTableView.footer noticeNoMoreData];
        }
        
    }
}

/**
 *  当附件为文档的点击事件
 *
 *  @param button nil
 */
- (void)wendangtapAction:(UIButton *)button
{
    TxtViewController *knowledVC = [[TxtViewController alloc] init];
    NSString *filepropstring = [_dic valueForKey:@"fileprop"];
    NSArray *fileprop = [filepropstring objectFromJSONString];
    knowledVC.txtString = [[fileprop[button.tag - 5100] valueForKey:@"name"] substringFromIndex:37];
    [self.navigationController pushViewController:knowledVC animated:YES];
}


@end
