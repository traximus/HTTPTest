//
//  MyHTTPClient.h
//  NetcoreCloud
//
//  Created by traximus on 14-4-16.
//  Copyright (c) 2014年 netcoretec. All rights reserved.
//
//
//  MyHTTPClient - 封装HTTP操作
//



#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"




typedef NS_ENUM(NSInteger, HTTPType) {
    HTTPTypeLocal,
    HTTPTypeRemote,
    HTTPTypeDefault = HTTPTypeLocal
};




@protocol MyHTTPDelegate <NSObject>
@optional
// test
-(void)httpclientTestConnectSucceedWithResponse:(NSDictionary *)response;
-(void)httpclientTestConnectFailedWithError:(NSError *)err;
@end





@interface MyHTTPClient : AFHTTPRequestOperationManager

//property
@property (retain, nonatomic) id<MyHTTPDelegate>delegate;
@property (nonatomic) BOOL isOperating;
@property (nonatomic) HTTPType type;

@property (retain, nonatomic) AFHTTPRequestOperation *currentOperation;
@property (retain, nonatomic) AFJSONRequestSerializer *appRequest;
@property (retain, nonatomic) AFJSONRequestSerializer *userRequest;
@property (retain, nonatomic) AFHTTPRequestSerializer *testRequest;

@property (retain, nonatomic) AFSecurityPolicy *localSecurityPolicy;
@property (retain, nonatomic) AFSecurityPolicy *remoteSecurityPolicy;


//singleton
+(instancetype)sharedClient;


//for test
-(void)testConnectWithParameters:(NSDictionary *)parameters;

//test post
-(void)testPOST;
@end
