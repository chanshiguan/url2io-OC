//
//  ViewController.m
//  URL2ioDemo
//
//  Created by 李朋远 on 2017/5/23.
//  Copyright © 2017年 owen_Lee. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()
{
    __weak IBOutlet UITextField *_urlTF;
    __weak IBOutlet UILabel *_titleLB;
    __weak IBOutlet UIWebView *_webView;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)parseAction:(id)sender
{
    NSString *url = @"http://news.haiwainet.cn/n/2017/0523/c3541083-30928298.html";
    if (_urlTF.text && ![_urlTF.text isEqualToString:@""]) {
        url = _urlTF.text;
    }
    
    AFHTTPRequestOperationManager *request = [[AFHTTPRequestOperationManager alloc] init];
    request.requestSerializer = [AFHTTPRequestSerializer serializer];
    request.responseSerializer  = [AFJSONResponseSerializer serializer];
    
    request.responseSerializer.acceptableContentTypes =  [request.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json",nil]];
    
    NSDictionary *param = @{@"token":@"8IEHomngTPWI0k7Tj2GgsA",
                            @"url":url};
    [request GET:@"http://api.url2io.com/article" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([NSThread isMainThread])
        {
            _titleLB.text = [responseObject objectForKey:@"title"];
            [_webView loadHTMLString:[responseObject objectForKey:@"content"] baseURL:nil];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                _titleLB.text = [responseObject objectForKey:@"title"];
                [_webView loadHTMLString:[responseObject objectForKey:@"content"] baseURL:nil];
            });  
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}









@end
