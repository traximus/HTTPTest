//
//  HTTPParameters.h
//  NetcoreCloud
//
//  Created by traximus on 14-11-5.
//  Copyright (c) 2014年 traximus. All rights reserved.
//

#ifndef NetcoreCloud_HTTPParameters_h
#define NetcoreCloud_HTTPParameters_h


/*******************
        HTTP
 ********************/

//notifications
#define kCNNetHTTPNetworkChangeNotification   @"network.status.change.cnnet.netcoretec"
#define kNeedReloadDeviceListNotification       @"need.reload.devices.cnnet.netcoretec"
#define kNeedStartSpeedInfoTimerNotification    @"need.start.speedtimer.cnnet.netcoretec"



//URLs
#define kBaseURL_User           @"https://user.noswifi.cn"
#define kBaseURL_App            @"https://app.noswifi.cn"

//test
#define kBaseURL_Test           @"https://192.168.1.1"


//operation parameters
#define kDefaultAppSign                 @"nos_appstore"
#define Device_Type_Default_All         @"0"
#define kDefaultHTTPTimeoutInterval     15  //每次http请求的超时时间为15秒
#define kDefaultResponseType            @"token"
#define kDefaultRedirectURI             @"nos"
#define kDefaultScope                   @"basic"
#define kDefaultCard                    @""
#define kDefaultPluginName              @""
#define kDefaultVersion                 @"1.0"
#define kDefaultControlCycle            @"DAY" //e8c定时的默认控制周期 - 暂定1天

//system
#define kSystemGetCGI           @"/router/system_application_info.cgi"
#define kSystemSetCGI           @"/router/system_application_config.cgi"
#define kSystemAppSign          @"system"





#warning 目前的clientID&clientSecret都仅供测试
#define kDefault_Login_ClientID         @"aa04754581fa81d8f457302372371fec"
#define kDefault_Client_Secrect         @"AwBaUFZiVkVWZVJvBSRVYlMGUicFQFc1"

#define kDefault_Register_ClientID      @"73dcef21-d30c-43fa-98ef-bbf559a72eda"


#define kWiFi_All_Module                @"0" //用于wifi关闭
#define kWiFi_Single_Module             @"1"

#define kUpdate_Model_App               @"ctcplugmanager"
#define kUpdate_Model_Gateway           @"gateway"




#endif
