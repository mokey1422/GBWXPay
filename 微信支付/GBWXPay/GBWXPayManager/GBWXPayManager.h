//
//  GBWXPayManager.h
//  微信支付
//
//  Created by 张国兵 on 15/7/25.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBWXPayManagerConfig.h"

/**
 *  使用说明
 *1、直接把GBWXPay文件拖到你的工程里面
 *2、配置一下系统库libsqlite3.0.dylib、libz.dzlib、CoreTelephony.framework、SystemConfiguration.frame添加到自己的项目中去，编译一下如果没有问题，就进行下一步，如果有问题可能提示查无此类，不要紧在相应的类里面包含一下#import <UIKit/UIKit.h>就ok了，如果你的pch里面包含了那就更好了这个地方就不会报错
 *3、编译无错的话那就在应用的地方包含一下我的管理文件的头文件#import "GBWXPayManager.h"，直接调用里面的方法实现支付功能
 *4、配置appdelegate,先包含#import "GBWXPayManager.h"头文件，此外注意微信支付调用回调的时候用的时*协议代理，这里要在appdelegate里面包含一下代理协议，复制以下代码：
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
 //向微信注册
 [WXApi registerApp:APP_ID withDescription:nil];
 return YES;
 }
 #pragma mark - 微信支付回调
 -(void) onResp:(BaseResp*)resp
 {
 NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
 NSString *strTitle;
 
 if([resp isKindOfClass:[SendMessageToWXResp class]])
 {
 strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
 }
 if([resp isKindOfClass:[PayResp class]]){
 //支付返回结果，实际支付结果需要去微信服务器端查询
 strTitle = [NSString stringWithFormat:@"支付结果"];
 
 switch (resp.errCode) {
 case WXSuccess:
 strMsg = @"支付结果：成功！";
 NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
 [[NSNotificationCenter defaultCenter] postNotificationName:@"WXpayresult" object:@"1"];
 break;
 
 default:
 strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
 NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
 break;
 }
 }
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
 }
 
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
 return  [WXApi handleOpenURL:url delegate:self];
 }
 *5、在实现支付功能的类里面注册监听处理支付成功回调和失败回调，具体看demo
 
 *6、接下来就要设置回调参数，实现app支付完成的回调了
  点击项目名称,点击“Info”选项卡，在URL types里面添加一项，Identifier可以不填，URL schemes就是appid直接复制进去就ok了；
 *7、iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
 *   在“Info.plist”里增加如下代码：
 
 <key>LSApplicationQueriesSchemes</key>
 <array>
 <string>weixin</string>
 </array>
 
 <key>NSAppTransportSecurity</key>
 <dict>
 <key>NSAllowsArbitraryLoads</key>
 <true/>
 </dict>
 *8、解决bitcode编译不过问题
 *   在Build Setting将Enable Bitcode 设置为No
 */

@interface GBWXPayManager : NSObject
/**
 *  针对多个商户的支付
 *
 *  @param orderID    支付订单号
 *  @param orderTitle 订单的商品描述
 *  @param amount     订单总额
 *  @param seller     商户号（收款账号）
 */
+(void)wxpayWithOrderID:(NSString*)orderID
             orderTitle:(NSString*)orderTitle
                 amount:(NSString*)amount
               sellerID:(NSString *)sellerID
                  appID:(NSString*)appID
              partnerID:(NSString*)partnerID

;

/**
 *  单一用户
 *
 *  @param orderID    支付订单号
 *  @param orderTitle 订单的商品描述
 *  @param amount     订单总额
 */
+(void)wxpayWithOrderID:(NSString*)orderID
             orderTitle:(NSString*)orderTitle
                 amount:(NSString*)amount;
@end
