//
//  CNNetHTTPClient.m
//  CNNetManager
//
//  Created by traximus on 14-4-16.
//  Copyright (c) 2014年 netcoretec. All rights reserved.
//

#import "MyHTTPClient.h"

#import "HTTPParameters.h"
//#import "UserData.h"
//#import "Base64.h"
//#import "NSString+MD5.h"






#pragma mark -
#pragma mark - class extension
@interface MyHTTPClient ()
@end









@implementation MyHTTPClient
@synthesize delegate;








#pragma mark -
#pragma mark - init methods

//singleton
+(instancetype)sharedClient
{
    static MyHTTPClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MyHTTPClient alloc]init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_sharedClient setReachMonitor];
        });
    });
    
    return _sharedClient;
}

-(id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    //多个requestSerializer，是为了切换服务器后兼容不同的服务器
    
    
    //user - 用户中心requestSerializer
    _userRequest = [AFJSONRequestSerializer serializer];
    [_userRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [_userRequest setAuthorizationHeaderFieldWithUsername:kDefault_Login_ClientID password:kDefault_Client_Secrect];
    [_userRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    _userRequest.timeoutInterval = kDefaultHTTPTimeoutInterval;
    self.requestSerializer = _userRequest;
    
    
    //app - 插件中心的requestSerializer
    _appRequest = [AFJSONRequestSerializer serializer];
    [_appRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [_appRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    _appRequest.timeoutInterval = kDefaultHTTPTimeoutInterval;
    
    
    //test
    _testRequest = [AFHTTPRequestSerializer serializer];
    [_appRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [_appRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    _testRequest.timeoutInterval = kDefaultHTTPTimeoutInterval;
    
    
    
    //responseSerializer
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *acceptContentType = [[responseSerializer acceptableContentTypes] mutableCopy];
    [acceptContentType addObject:@"text/plain"];
    [acceptContentType addObject:@"text/html"];
    [acceptContentType addObject:@"application/json"];
    [acceptContentType addObject:@"text/json"];
    [acceptContentType addObject:@"text/javascript"];
    [responseSerializer setAcceptableContentTypes:acceptContentType];
    self.responseSerializer = responseSerializer;
    
    
    
    //securityPolicy
    _localSecurityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _localSecurityPolicy.allowInvalidCertificates = YES;
    _localSecurityPolicy.validatesCertificateChain = NO;
    
    _remoteSecurityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _remoteSecurityPolicy.allowInvalidCertificates = YES;
    
    
    return self;
}

//网络状态转换检测和网络操作暂停/恢复 - 取决于baseURL的连通性
-(void)setReachMonitor
{
    self.reachabilityManager = nil;
    //监听baidu.com的访问连通性
    self.reachabilityManager = [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];
    [self.reachabilityManager startMonitoring];
    NSOperationQueue *operationQueue = self.operationQueue;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [operationQueue setSuspended:NO];
                NSLog(@"network reachable");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [operationQueue setSuspended:NO];
                NSLog(@"network reachable");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
            {
                [operationQueue setSuspended:YES];
                NSLog(@"network not reachable");
            }
                break;
        }
    }];
}








#pragma mark -
#pragma mark - operations

//---------------------------
//    operation - 用户中心
//
//  注册，登陆，获取token为web方式
//  编辑用户信息为web方式
//  设备绑定-网关本地发起，为web方式
//---------------------------

//test post
-(void)testPOST
{
    _isOperating = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"/router/web_login.cgi"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"user":@"guest",@"pass":@"ss"};
    
    //request start
    __block NSDictionary *result = nil;
    self.requestSerializer = _testRequest;
    self.securityPolicy = (_type==HTTPTypeLocal)?_localSecurityPolicy:_remoteSecurityPolicy;
    _currentOperation = [self GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        result = (NSDictionary *)responseObject;
        NSLog(@"sucess:%@",result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail:%@",error.description);
    }];    
}

//for test
-(void)testConnectWithParameters:(NSDictionary *)parameters
{
    _isOperating = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"/app/uploadavatar?token=777BD4E0D87F654E20BFD75F756955F78FFC011CCE2ABE7064DBA0DB6A0539877547E03153FAE5A78B6BE6799F89182ADFA114D868EB9AFB386BB36C81319982525F5DFDB3A47B9D8F4298D4B6286D3C1365C2423175658369AA7860BE1E835F"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    __block NSDictionary *result = nil;
    self.requestSerializer = _userRequest;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"avatar" ofType:@"png"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    _currentOperation = [self POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:fileURL name:@"avatar" error:nil];
        [formData appendPartWithFormData:[@"110100" dataUsingEncoding:NSUTF8StringEncoding] name:@"city"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        result = (NSDictionary *)responseObject;
        NSLog(@"Success: %@", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
