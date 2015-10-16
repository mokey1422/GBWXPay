//
//  GBWXPayManager.m
//  微信支付
//
//  Created by 张国兵 on 15/7/25.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBWXPayManager.h"

@implementation GBWXPayManager
/**
 *  针对多个商户的支付
 *
 *  @param orderID    支付订单号
 *  @param orderTitle 订单的商品描述
 *  @param amount     订单总额
 *  @param notifyURL  支付结果异步通知
 *  @param seller     商户号（收款账号）
 */
+(void)wxpayWithOrderID:(NSString*)orderID
             orderTitle:(NSString*)orderTitle
                 amount:(NSString*)amount
               sellerID:(NSString *)sellerID
                  appID:(NSString*)appID
              partnerID:(NSString*)partnerID{
    
    //微信支付的金额单位是分转化成我们比较常用的'元'
    NSString*realPrice=[NSString stringWithFormat:@"%.f",amount.floatValue*100];
    
    if(realPrice.floatValue<=0){
        return;
    }
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:appID mch_id:sellerID];
    //设置密钥
    [req setKey:partnerID];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:orderID title:orderTitle price: realPrice];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        BOOL status = [WXApi sendReq:req];
        NSLog(@"%d",status);
        
    }
    
}
/**
 *  单一用户
 *
 *  @param orderID    支付订单号
 *  @param orderTitle 订单的商品描述
 *  @param amount     订单总额
 */
+(void)wxpayWithOrderID:(NSString*)orderID
             orderTitle:(NSString*)orderTitle
                 amount:(NSString*)amount{
    
   
  
    //微信支付的金额单位是分转化成我们比较常用的'元'
    NSString*realPrice=[NSString stringWithFormat:@"%.f",amount.floatValue*100];
  
    if(realPrice.floatValue<=0){
        return;
    }
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:orderID title:orderTitle price: realPrice];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        BOOL status = [WXApi sendReq:req];
        NSLog(@"%d",status);
        
    }
    
    
    
    
}


//客户端提示信息
+ (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}
@end
