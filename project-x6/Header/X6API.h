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
#define APP_URL @"http://itunes.apple.com/lookup?id=1103122494"

//主服务器上线地址和测试地址
//#define X6basemain_API @"http://192.168.1.199:8080"
#define X6basemain_API @"http://www.x6pt.cn:8080"

//注册（取验证吗）
#define X6register_getsmscode @"/x6RegistAction_getMobileJzm.action"

//注册（验证码校验）
#define X6register_checksmscode @"/x6RegistAction_checkMobileJzm.action"

//注册
#define X6register @"/x6RegistAction_regist.action"

//忘记密码（取验证吗）
#define X6forgetps_getsmscode @"/pwdAction_getMobileJzm.action"

//忘记密码（验证码校验）
#define X6forgetps_checksmscode @"/pwdAction_checkMobileJzm.action"

//忘记密码（修改密码）
#define X6forgetps @"/pwdAction_ModifyX6UserPwd.action"

//登陆接口
#define X6_API_loadmain [NSString stringWithFormat:@"%@/yxmain/getAppUrl.action",X6basemain_API]

#define X6_API_load @"/manageLogin.action"

//1.首页数据
//个人的消息图片和url + 公司代码 ＋ 登陆返回数据对应的接口
#define X6_personMessage @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/msg/"

//员工头像url接口
#define X6_ygURL @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/ygpic/"

//操作员头像url接口
#define X6_czyURL @"http://x6pt.oss-cn-hangzhou.aliyuncs.com/userpic/"

//判断是否已经关注
#define X6_whetherConcerned @"/msg/attentionAction_hadAttention.action"

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

//2.联系人页面
#define X6_persons @"/xtgl/appSelectPersonAction_SelectPerson.action"

//3.业务员页面
//供应商
#define X6_supplier @"/jcxx/dmJgAction_getGysList.action"
//供应商详情
#define X6_supplierdetail @"/jcxx/dmJgAction_getGysDetail.action"
//供应商保存
#define X6_addsupplier @"/jcxx/dmJgAction_SaveGys.action"

//客户
#define X6_customer @"/jcxx/dmJgAction_getKhList.action"
//客户详情
#define X6_customerdetail @"/jcxx/dmJgAction_getKhxxDetail.action"
//客户保存
#define X6_addcustomer @"/jcxx/dmJgAction_SaveKhxx.action"

//订单（未审核）
#define X6_orderreviewone @"/jxc/jxcPreInStockAction_getDsList.action"
//审核
#define X6_examineOrder @"/jxc/jxcPreInStockAction_shBill.action"
//订单（审核）
#define X6_orderreviewtwo @"/jxc/jxcPreInStockAction_getYsList.action"
//撤审
#define X6_revokeOrder @"/jxc/jxcPreInStockAction_QxShBill.action"


//批发订单（未审核）
#define X6_wholesalenoOrder @"/jxc/jxcPreOutStockAction_getDsList.action"
//批发订单(审核)
#define X6_wholesaleOrder @"/jxc/jxcPreOutStockAction_getYsList.action"
//批发订单审核
#define X6_wholesaleexamineOrder @"/jxc/jxcPreOutStockAction_shBill.action"
//批发订单撤审
#define X6_wholesalerevokeOrder @"/jxc/jxcPreOutStockAction_QxShBill.action"


//银行存款
#define X6_deposit @"/cw/cwMddkAction_getList.action"
//银行存款保存
#define X6_savedeposit @"/cw/cwMddkAction_save.action"
//银行存款删除
#define X6_deletedeposit @"/cw/cwMddkAction_delete.action"

//银行账户列表
#define X6_banksList @"/jcxx/dmYhzhAction_getMyDkzh.action"
//门店列表
#define X6_storesList @"/xtgl/xtGsAction_getMyMd.action"
//经办人列表
#define X6_personsList @"/jcxx/dmYgAction_getYgList.action"



//一键设置考核价
#define X6_resetPrice @"/jcxx/dmPriceAction_setkhPrice.action"
//最后一次设置考核价的时间
#define X6_lastsetPrice @"/jcxx/dmPriceAction_getLastSetDate.action"



//4.报表页面
//我的库存
#define X6_mykucun @"/report/reportKcRb_doSearchManage.action"
//我的库存详情
#define X6_mykucunDetail @"/report/reportKcRb_kcDetail.action"

//今日战报
#define X6_today @"/report/reportMySell_Jrzb.action"
//今日战报详情
#define X6_todayDetail @"/report/reportMySell_JrzbDetail.action"

//今日销量
#define X6_todaySales @"/report/reportMySell_Jrxs.action"
//今日销量详情
#define X6_todaySalesDetail @"/report/reportMySell_JrxsDetail.action"

//今日营业款
#define X6_todayMoney @"/report/reportMySell_JrYjk.action"
//今日营业款详情
#define X6_todayMoneyDetail @"/report/reportMySell_JrYjkDetail.action"

//今日付款
#define X6_todayPay @"/report/reportCwAction_myfk.action"

//我的帐户
#define X6_myAcount @"/report/reportCwAction_myzh.action"

//今日存款
#define X6_todaydeposit @"/cw/cwMddkAction_getTodayList.action"

//批发战报
#define X6_WholesaleUnits @"/report/reportPfAction_pfzb.action"

//批发销量
#define X6_WholesaleSales @"/report/reportPfAction_pfxl.action"

//批发汇总
#define X6_WholesaleSummary @"/report/reportPfAction_pfhz.action"

//应收明细
#define X6_MissyReceivable @"/report/reportCwAction_myysk.action"

//今日收款
#define X6_todayReceivable @"/report/reportCwAction_mysk.action"

//我的提醒

//异常条数
#define X6_EarlyWarningNumber @"/report/reportXttxAction_getTxcount.action"
//清除异常条数
#define X6_removeWarningNumber @"/report/reportXttxAction_removeTxcount.action"

//出库异常
#define X6_Outbound @"/report/reportXttxAction_lsckyc.action"
//出库异常详情
#define X6_Outbounddetail @"/report/reportXttxAction_lsckycDetail.action"
//出库异常明细
#define X6_OutboundMoredetail @"/report/reportXttxAction_lsckycMx.action"

//库龄逾期
#define X6_Oldlibrary @"/report/reportXttxAction_klyj.action"
//库龄逾期详细
#define X6_Oldlibrarydetail @"/report/reportXttxAction_klyjDetail.action"

//采购异常
#define X6_Purchase @"/report/reportXttxAction_cgjgyc.action"

//零售异常
#define X6_Retail @"/report/reportXttxAction_lsjgyc.action"

#define X6_ignore @"/report/reportXttxAction_txpass.action"

//应收逾期
#define X6_OverdueRecieved @"/report/reportXttxAction_ysyqtx.action"



//5.个人页面数据
//修改头像接口
#define X6_changeHeaderView @"/xtgl/xtuserAction_updatePhoto.action"

//修改密码接口
#define X6_changePassword @"/xtgl/xtuserAction_modifyPwd.action"

//知识库接口
#define X6_collectionView @"/msg/msgAction_getMyKnowledge.action"



//6.检测权限变化
#define X6_userQXchange @"/xtgl/xtuserAction_CheckMbQxChanged.action"

#define X6_hadChangeQX @"/xtgl/xtuserAction_getMyMbSsgsAndQx.action"
#endif /* X6API_h */


