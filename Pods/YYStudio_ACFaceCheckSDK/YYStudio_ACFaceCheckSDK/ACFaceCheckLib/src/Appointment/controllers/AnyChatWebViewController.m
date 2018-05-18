//
//  AnyChatWebViewController.m
//  ACFaceCheckLib
//
//  Created by 黄世光 on 2018/3/12.
//  Copyright © 2018年 宫健(金融壹账通客户端研发团队). All rights reserved.
//

#import "AnyChatWebViewController.h"

@interface AnyChatWebViewController ()

@end

@implementation AnyChatWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ACNScreenWidth, ACNScreenHeight-64)];
    self.webStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"anychatHelpUrl"];
    NSString *prod = @"https://rmgs.pingan.com/loan/page/tocapporderlist/index.html?t=yjkProductInfo";
    NSURL *url = [NSURL URLWithString:self.webStr ? self.webStr:prod];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
