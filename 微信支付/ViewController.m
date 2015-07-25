//
//  ViewController.m
//  微信支付
//
//  Created by 张国兵 on 15/7/24.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "ViewController.h"
#import "GBWXPayManager.h"

@interface ViewController ()

@end

@implementation ViewController
-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton*pay=[UIButton buttonWithType:UIButtonTypeCustom];
    pay.backgroundColor=[UIColor orangeColor];
    pay.frame=CGRectMake(100, 100, 100, 40);
    [pay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pay setTitle:@"微信支付" forState:UIControlStateNormal];
    [pay addTarget:self action:@selector(weixinSendPay) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pay];
    
    //注册监听-微信
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealWXpayResult:) name:@"WXpayresult" object:nil];
    

    

    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - 微信支付
- (void)weixinSendPay
{
    
    
    NSString *orderno   = [NSString stringWithFormat:@"%ld",time(0)];
    
    [GBWXPayManager wxpayWithOrderID:orderno orderTitle:@"测试" amount:@"0.01"];

    

}

-(void)dealWXpayResult:(NSNotification*)notification{
    NSString*result=notification.object;
    if([result isEqualToString:@"1"]){
        
        //在这里写支付成功之后的回调操作
        NSLog(@"微信支付成功");
        
    }else{
        //在这里写支付失败之后的回调操作
        NSLog(@"微信支付失败");
    }
    
    
    
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
