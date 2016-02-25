//
//  X6API.h
//  project-x6
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 Apple. All rights reserved.
//

#ifndef X6API_h
#define X6API_h


//appstore中的代码
#define APP_URL @"http://itunes.apple.com/lookup?id=com.xiaopeng.X6ptdemo"

//主服务器上线地址和测试地址
//#define X6basemain_API @"http://192.168.1.111:8080"
#define X6basemain_API @"http://www.x6pt.cn"

//登陆接口
#define X6_API_loadmain [NSString stringWithFormat:@"%@/yxmain/getAppUrl.action",X6basemain_API]

#define X6_API_load [NSString stringWithFormat:@"ygLogin.action",X6basemain_API]

//1.首页数据
//个人的消息图片和url + 公司代码 ＋ 登陆返回数据对应的接口
#define X6_personMessage @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/msg/"

//员工头像url接口
#define X6_ygURL @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/ygpic/"

//操作员头像url接口
#define X6_czyURL @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/userpic/"

//关注接口
#define X6_focus @"/msg/attentionAction_attention.action"

//消息列表
#define X6_Dynamiclist @"/msg/msgAction_getAppMsg.action"

//新消息条数
#define X6_NewMessageCount @"/msg/msgAction_getMsgNum.action"

//个人动态接口
#define X6_personDynamic @"/msg/msgAction_getUserAppMsg.action"

//发送消息接口
#define X6_sendMessage @"/msg/msgAction_sentMsg.action"

//回复列表接口
#define X6_replyList @"/msg/msgReplyAction_getMsgReply.action"

//删除消息接口
#define X6_deleteMessage @"/msg/msgAction_delMsg.action"

//收藏接口
#define X6_collection @"/msg/msgReplyAction_collectionMsg.action"

//上传接口
#define X6_unloadFile @"/servlet/uploadFile"

//回复接口
#define X6_reply @"/msg/msgReplyAction_saveMsgReply.action"

//2.个人页面数据
//修改头像接口
#define X6_changeHeaderView @"/jcxx/dmYgAction_updatePhoto.action"

//修改密码接口
#define X6_changePassword @"/jcxx/dmYgAction_modifyPwd.action"

//知识库接口
#define X6_collectionView @"/msg/msgAction_getMyKnowledge.action"

//3.联系人页面
#define X6_persons @"/xtgl/appSelectPersonAction_SelectPerson.action"


//4.报表页面
//今日库存接口
#define X6_today @"/report/reportKcRb_doSearch.action"

//我的销量接口
#define X6_MySales @"/report/reportMySell_doSearch.action"

//销量排名接口
#define X6_allSales @"/report/reportMySell_sellSort.action"






#endif /* X6API_h */


