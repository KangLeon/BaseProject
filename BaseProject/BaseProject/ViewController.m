//
//  ViewController.m
//  Test
//
//  Created by 吉腾蛟 on 2019/1/22.
//  Copyright © 2019 mj. All rights reserved.
//
#define SNWeakSelf __weak typeof(self) weakSelf = self;

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#define GREEN_BACKGROUND RGBA(104,199,46,1.0)

#define RE_RGBA(r, g, b) [UIColor colorWithRed:r green:g blue:b alpha:1.0]
#define ORANGE_BACKGROUND RE_RGBA(0.992,0.839,0.431)

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define SNUDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

/*1024.000000,768.000000*/
//根据iPad Pro宽度适配
#define SNTrueWidth(initialWidth) initialWidth*(SCREEN_WIDTH/1024)
//根据iPad Pro高度适配
#define SNTrueHeight(initialHeight) initialHeight*(SCREEN_HEIGHT/768)
#import "ViewController.h"
#import <WebKit/WebKit.h>

#import "AFNetworking.h"
@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)loadRequest{
    
}

-(void)loadWebView{
    //相当于登出
    //强制清除缓存，不清除打不开
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
    
    [self.view addSubview:self.webView];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    ///超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", @"text/html" ,@"image/jpeg", nil];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    //    [manager.requestSerializer setValue:@"get_players" forHTTPHeaderField:@"scope"];
    //    [manager.requestSerializer setValue:@"koov-api@koov.io" forHTTPHeaderField:@"client_id"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"get_players" forKey:@"scope"];
    [dic setObject:@"koov-api@koov.io" forKey:@"client_id"];
    NSURLSessionTask *task = [manager POST:@"https://koovdev.csmc-cloud.com/koov/v1/login/getUserCode" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error;
        NSDictionary *newJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        
        NSURL *url=[NSURL URLWithString:newJson[@"data"][@"loginUrl"]];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
        
        //NSURLConnection
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        [connection start];
        
        [self.webView loadRequest:request];
        NSLog(@"%@",newJson);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
        NSString *errorStr = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"请求失败============%@",errorStr);
    }];
}

-(WKWebView *)webView{
    if (!_webView) {
        _webView=[[WKWebView alloc] initWithFrame:CGRectMake(0, SNTrueHeight(100), SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.backgroundColor=[UIColor clearColor];
        _webView.UIDelegate=self;
        _webView.navigationDelegate=self;
    }
    return _webView;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //receive a authenticate and challenge with the user credential
    //&& [challenge previousFailureCount] == 0
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:@"NSURLAuthenticationMethodHTTPBasic"] )
    {

        NSURLCredential *credentail = [NSURLCredential
                                       credentialWithUser:@"hero-user"
                                       password:@"hero1901!"
                                       persistence:NSURLCredentialPersistencePermanent];


        [[challenge sender] useCredential:credentail forAuthenticationChallenge:challenge];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Message" message:@"Invalid credentails" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end

