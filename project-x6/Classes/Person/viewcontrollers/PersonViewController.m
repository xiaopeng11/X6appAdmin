//
//  PersonViewController.m
//  project-x6
//
//  Created by Apple on 15/11/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PersonViewController.h"
#import "HeaderView.h"
#import "PersonTableViewCell.h"


#import "LoadViewController.h"
#import "AllDynamicViewController.h"

#import "MyDynamicViewController.h"
#import "MyFocusViewController.h"
#import "MyCollectionViewController.h"
#import "ChangePasswordViewController.h"
#import "KnowledgesViewController.h"

@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)HeaderView *headerView;
@property(nonatomic,copy)NSArray *datalist;

@end

@implementation PersonViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeHeaderView" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviTitleWhiteColorWithText:@"个人中心"];

    [self initWithSubViews];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderView) name:@"changeHeaderView" object:nil];

}

- (void)changeHeaderView
{
    [_headerView initSubViews];
}

//初始化子视图
- (void)initWithSubViews
{
    _datalist = @[@{@"Title":@"我的动态",@"ImageName":@"btn_wode_n.png"},
                 @{@"Title":@"我的关注",@"ImageName":@"btn_guanzhu_n.png"},
                 @{@"Title":@"我的收藏",@"ImageName":@"btn_shoucang_n.png"},
                 @{@"Title":@"我的知识库",@"ImageName":@"btn_zhishiku_n.png"},
                 @{@"Title":@"修改密码",@"ImageName":@"btn_xiuma_n.png"}];

    _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    [self.view addSubview:_headerView];

    //创建表示图
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 80, KScreenWidth, 250);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //附件
    UIImageView *imaegView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    imaegView.image = [UIImage imageNamed:@"do_arrow"];
    [self.view addSubview:tableView];
    
    //添加按钮
    UIButton *unloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isDevice4_4s) {
        unloadButton.frame = CGRectMake(10, tableView.bottom + 10, KScreenWidth - 20, 40);
    } else {
        unloadButton.frame = CGRectMake(10, tableView.bottom + 10, KScreenWidth - 20, 50);
    }
    unloadButton.layer.cornerRadius = 10;
    [unloadButton setBackgroundColor:Mycolor];
    [unloadButton addTarget:self action:@selector(unloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [unloadButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    [unloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:unloadButton];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return _datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idented = @"ident";
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idented];
    if (cell == nil) {
        cell = [[PersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idented];
    }
    cell.dic = _datalist[indexPath.row];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"我的页面内存泄漏");
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window) {
            for (UIViewController *viewVC in self.navigationController.viewControllers) {
                viewVC.view = nil;
            }
            self.view = nil;
        }
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyDynamicViewController *MyDynamicVC = [[MyDynamicViewController alloc] init];
        [self.navigationController pushViewController:MyDynamicVC animated:YES];
    } else if (indexPath.row == 1) {
        MyFocusViewController *MyFocusVC = [[MyFocusViewController alloc] init];
        [self.navigationController pushViewController:MyFocusVC animated:YES];
    } else if (indexPath.row == 2) {
        MyCollectionViewController *MyColloctionVC = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:MyColloctionVC animated:YES];
    } else if (indexPath.row == 3) {
        KnowledgesViewController *knowledgeVC = [[KnowledgesViewController alloc] init];
        [self.navigationController pushViewController:knowledgeVC animated:YES];
    } else {
        ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }
}

#pragma mark - 退出登录
- (void)unloadAction:(UIButton *)button
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //移除本地的数据
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
  
        [userdefaults removeObjectForKey:X6_UseUrl];         
        [userdefaults removeObjectForKey:X6_Cookie];
        [userdefaults removeObjectForKey:X6_refresh];
        [userdefaults removeObjectForKey:X6_Contactlist];
        [userdefaults removeObjectForKey:X6_UserQXList];
        [userdefaults synchronize];
        
        //点击的时确定按钮
        NSFileManager *filemanager = [NSFileManager defaultManager];
        //删除文件的路径
        NSString *cachefilepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        //删除文件
        [filemanager removeItemAtPath:cachefilepath error:nil];
        [filemanager removeItemAtPath:DOCSFOLDER error:nil];
        
        //推出环信账号
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
          
        } onQueue:nil];
        
        
        LoadViewController *loadVC = [[LoadViewController alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = loadVC;
        
    }];
    
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertcontroller addAction:cancelaction];
    [alertcontroller addAction:okaction];
    [self presentViewController:alertcontroller animated:YES completion:nil];

}



@end
