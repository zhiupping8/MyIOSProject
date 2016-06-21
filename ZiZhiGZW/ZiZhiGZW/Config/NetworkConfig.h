//
//  NetworkConfig.h
//  ZiZhiLaku2
//
//  Created by zyz on 11/29/15.
//  Copyright © 2015 zizhi. All rights reserved.
//

#ifndef NetworkConfig_h
#define NetworkConfig_h

//blocks
typedef void(^ZiZhiResponseErrorBlock)( NSInteger errorCode, NSString * errorMsg); //error block
typedef void(^ZiZhiResponseSuccessArrayBlock)( NSArray * array); //return array
typedef void(^ZiZhiResponseSuccessDictionaryBlock )( NSDictionary * dictionary ); //return dictionary
typedef void(^ZiZhiResponseSuccessStringBlock)(NSString * string); //return string
typedef void(^ZiZhiResponseSuccessEmptyBlock)(); //return block

//network status tips
#define K_INTERNET_ERROR @"网络连接失败"
#define K_SEVICE_ERROR @"服务器未知异常"

#define kMBProgressHUDTipsTime 4.0f

//#define K_NETWORK_BASE @"http://192.168.1.102:8080"  //network address119.10.9.17
#define K_NETWORK_BASE @"http://119.10.9.17:8080"  //network address

#define K_BASE_FIELD @"/cctvgz/"

//home
/**
 *  获取启动页广告
 *  @param lasttime
 */
static NSString * const k_url_startadv = @"/cctvgz/client/adv/startadv.do";

/**
 *  获取banner内容
 *  @param type=1申请赠票 2栏目报名
 */
static NSString * const k_url_advlist = @"/cctvgz/client/adv/advlist.do";

/**
 *  获取公告
 *  @param type=1申请赠票 2栏目报名
 */
static NSString * const k_url_notlist = @"/cctvgz/client/adv/notlist.do";

static NSString * const k_url_mainal = @"/cctvgz/client/ticket/apply/mainal.do"; //获取首页赠票列表

static NSString * const k_url_apply_detail = @"/cctvgz/client/ticket/apply/detail.do"; //普通赠票详情

static NSString * const k_url_apply_vipdetail = @"/cctvgz/client/ticket/apply/vipdetail.do"; //vip报名详情

/**
 *  首页栏目报名列表
 *  @param page 页码从1开始
 */
static NSString * const k_url_program_mainpl = @"/cctvgz/client/program/mainpl.do";

/**
 *  栏目报名详情
 *  @param programid 栏目id
 */
static NSString * const k_url_program_detail = @"/cctvgz/client/program/detail.do";

/**
 *  登录接口-----
 *
 *  @param idcardnumber    身份证号
 *  @param phone   手机号
 *  @param devicetype 手机系统类型(android or ios)
 *  @param buserid   百度与推送的两个相关值(下同)
 *  @param bchannelid   <#errorBlock description#>
 */
static NSString * const k_url_login = @"/cctvgz/client/user/operate/login.do";

/**
 *  注册接口
 *
 *  @param idcardnumber    身份证号
 *  @param phone   手机号
 */
static NSString * const k_url_regist = @"/cctvgz/client/user/operate/regist.do";

/**
 *  查看赠票列表信息
 *
 *  @param idcardnumber    身份证号
 *  @param page   页码
 */
static NSString * const k_url_apply_infolist = @"/cctvgz/client/ticket/apply/infolist.do";

/**
 *  申请赠票
 *
 *  @param name   姓名
 *  @param idcardnumber    身份证号
 *  @param phone   手机号
 *  @param address 收货地址
 *  @param loginedidcardnumber   <#errorBlock description#>
 */
static NSString * const k_url_apply_apply = @"/cctvgz/client/ticket/apply/apply.do";

/**
 *  观众评委申请
 *
 *  @param name   姓名
 *  @param idcardnumber    身份证号
 *  @param phone   手机号
 *  @param address 收货地址
 *  @param loginedidcardnumber   <#errorBlock description#>
 */
static NSString * const k_url_userrater_apply = @"/cctvgz/client/order/userrater/apply.do";

/**
 *  观众评委申请列表
 *
 *  @param idnumber    身份证号
 *  @param page   页码
 *  @param phone 手机号
 */
static NSString * const k_url_userrater_listinfo = @"/cctvgz/client/order/userrater/listinfo.do";

/**
 *  节目报名
 *
 *  @param name   姓名
 *  @param idcardnumber    身份证号
 *  @param phone   手机号
 *  @param secretkey
 *  @param programupdateid   节目id
 *  @param loginedidcardnumber
 */
static NSString * const k_url_program_enroll = @"/cctvgz/client/program/enroll.do";

/**
 *  节目报名列表
 *
 *  @param idnumber   id
 *  @param page    页码
 */
static NSString * const k_url_programenroll_listinfo = @"/cctvgz/client/program/programenroll/listinfo.do";

/**
 *  支付信息获取
 *
 *  @param ordernumber   订单号
 *  @param paytype    支付类型（1支付宝  2微信）
 */
static NSString * const k_url_userrater_payinfo = @"/cctvgz/client/order/userrater/payinfo.do";

/**
 *  好评
 *
 *  @param userid   用户id
 *  @param content    评价内容
 *  @param pdegree
 */
static NSString * const k_url_prize_goodprize = @"/cctvgz/client/user/operate/prize/goodprize.do";

/**
 *  意见反馈
 *
 *  @param userid   用户id
 *  @param content    意见内容
 */
static NSString * const k_url_prize_feedback = @"/cctvgz/client/user/operate/prize/feedback.do";

/**
 *  获取设置页面信息
 */
static NSString * const k_url_setting_setting = @"/cctvgz/client/setting/setting.do";

/**
 *  获取赠票物流信息
 *  @param ticketapplyid
 */
static NSString * const k_url_ticket_apply_logistic = @"http://119.10.9.17:8080/cctvgz/client/order/logistic.do?ticketapplyid=%@";

/**
 *  获取vip物流信息
 *  @param orderraterid
 */
static NSString * const k_url_vip_apply_logistic = @"http://119.10.9.17:8080/cctvgz/client/order/logistic.do?orderraterid=%@";

/**
 *  获取第三方物流信息(分赠票和vip)
 *  @param type=logistictype&postid=logisticno（申请赠票用的是ZiZhiTicketApplyModel中的数据)
 *  @param type=logistictype&postid=logisticno（观众评委用的是ZiZhiOrderModel中的数据)
 */
static NSString * const k_url_third_logistic = @"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@";

#endif /* NetworkConfig_h */
