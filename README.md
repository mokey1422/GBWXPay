#GBWXPay<br>
##如果觉得有用的话请点个星谢谢支持，会继续出一些功能性的框架，如有bug也请指出群号：433060483欢迎加入组织
#简介:<br>
## 鉴于微信支付官方文档写的比较乱，特意总结了一下微信支付，即使你没有看过微信支付的官方文档只要按照使用说明来操作也可以为你的项目添加微信支付功能<br>
#使用说明<br>
* 直接把GBWXPay文件拖到你的工程里面<br>
* 配置一下系统库libsqlite3.0.dylib、libz.dzlib、SystemConfiguration.frame添加到自己的项目中去，编译一下如果没有问题，就进行下一步，如果有问题可能提示查无此类，不要紧在相应的类里面包含一下#import <UIKit/UIKit.h>就ok了，如果你的pch里面包含了那就更好了这个地方就不会报错<br>
* 编译无错的话那就在应用的地方包含一下我的管理文件的头文件#import "GBWXPayManager.h"，直接调用里面的方法实现支付功能<br>
* 配置appdelegate,先包含#import "GBWXPayManager.h"头文件，此外注意微信支付调用回调的时候用的时协议代理，这里要在appdelegate里面包含一下代理协议，复制以下代码：<br>
```
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
```
* 在实现支付功能的类里面注册监听处理支付成功回调和失败回调，具体看demo<br>
* 接下来就要设置回调参数，实现app支付完成的回调了
  点击项目名称,点击“Info”选项卡，在URL types里面添加一项，Identifier可以不填，URL schemes就是appid直接复制进去就ok了<br>

##具体的使用说明在代码里面也有，如果你参数要写在本地的话，请在GBWXPayManagerConfig.h里完成配置，这样便于维护你的代码<br>
##调用的时候复制代码：<br>
```
 [GBWXPayManager wxpayWithOrderID:orderno orderTitle:@"测试" amount:@"0.01"];
```
#更新说明：<br>
* 更新最新的SDK避免因为IPV6的原因被拒的风险<br>
* 账号密钥被商户改了不能给大家提供免费测试账户了，现在会报签名失败的错误，自己替换自己的账号即可。<br>


# 看一下效果图：<br>
![image](https://github.com/mokey1422/gifResource/blob/master/weixinpay.gif)

