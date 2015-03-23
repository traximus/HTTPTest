//
//  ViewController.m
//  HTTPTest
//
//  Created by traximus on 14-12-4.
//  Copyright (c) 2014年 netcoretec. All rights reserved.
//

#import "ViewController.h"

//HTTP Test
#import "MyHTTPClient.h"
#import "HTTPParameters.h"






#pragma mark - 
#pragma mark - class extension
@interface ViewController ()<MyHTTPDelegate>
{
    MyHTTPClient *httpClient;
}
@end







@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    httpClient = [MyHTTPClient sharedClient];
    
    NSTimer *testTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(testConnect) userInfo:nil repeats:YES];
    [testTimer fire];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








#pragma mark - 
#pragma mark - custom methods
-(void)testConnect
{
    httpClient.baseURL = [NSURL URLWithString:kBaseURL_Test];
    httpClient.delegate = self;
    
    [httpClient testPOST];
    
//    
//    NSDictionary *itemTemp = @{@"IsNormal": @"True",
//                               @"IsValueEnum":@"True",
//                               @"ItemTemp":@{@"Id":@"32"},
//                               @"ItemTempId":@"32",
//                               @"Proposal":@"treat",
//                               @"SelectUnit":@{@"Id":@"7"},
//                               @"SelectValue":@{@"Id":@"6"},
//                               @"TxtValue":@"",
//                               @"UnusualReason":@"normal"};
//    NSArray *indicateItems = @[itemTemp];
//    NSDictionary *indicateTemp = @{@"Id":@"7",
//                                   @"TempName":@"尿常规"};
//    
//    NSDictionary *dicT = @{@"AulixExam": @{@"Id": @"399"},
//                           @"ExamContent":@"content",
//                           @"ExamDate":@"2014-12-03",
//                           @"ExamUnit":@"department",
//                           @"IndicateItems":indicateItems,
//                           @"IndicateTemp":indicateTemp};
//    
//    NSDictionary *para = @{@"data": dicT};
//    NSLog(@"dicT:\n%@",para);
//    [httpClient testConnectWithParameters:para];
}




#pragma mark -
#pragma mark - HTTP Delegate
-(void)httpclientTestConnectFailedWithError:(NSError *)err
{
    NSLog(@"%@\nerror:%@",NSStringFromSelector(_cmd),err);
}
-(void)httpclientTestConnectSucceedWithResponse:(NSDictionary *)response
{
    NSLog(@"%@\nresponse:%@",NSStringFromSelector(_cmd),response);
}
@end
