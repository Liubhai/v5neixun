//
//  Net_API.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "Net_API.h"
#import "EdulineV5_Tool.h"
#import "V5_UserModel.h"
#import "AppDelegate.h"

//#define HeaderUrl_V5_Api @"https://api.51eduline.com"// 单机构
//#define HeaderUrl_V5_Api @"https://saas-api.51eduline.com"//saas版本
//#define HeaderUrl_V5_Api @"https://tv5-api.51eduline.com"//saas测试版本
#define HeaderUrl_V5_Api @"https://qipei.api.51eduline.com"//内训版

#define VUE_APP_ID @"BPvfj1SI5tU50lgLEx"
#define VUE_APP_KEY @"OtKFHXHAzCLpNzWL6k"

#define SWNOTEmptyArr_Api(X) (NOTNULL_Api(X)&&[X isKindOfClass:[NSArray class]]&&[X count])
#define SWNOTEmptyDictionary_Api(X) (NOTNULL_Api(X)&&[X isKindOfClass:[NSDictionary class]]&&[[X allKeys]count])
#define SWNOTEmptyStr_Api(X) (NOTNULL_Api(X)&&[X isKindOfClass:[NSString class]]&&((NSString *)X).length)
#define NOTNULL_Api(x) ((![x isKindOfClass:[NSNull class]])&&x)

@implementation Net_API

+ (void)requestGETSuperAPIWithURLStr:(NSString *)urlStr WithAuthorization:(NSString *)authorization paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
   
    NSString *randomString = [EdulineV5_Tool getRandomString];
    NSString *currentTime = [EdulineV5_Tool currentdateInterval];
    NSString *fullString = [NSString stringWithFormat:@"%@|%@|%@|%@",VUE_APP_KEY,[EdulineV5_Tool sortedDictionary:paramDic],currentTime,randomString];
    NSString *final = [NSString stringWithFormat:@"%@?timestamp=%@&nonce_str=%@&sign=%@",HeaderUrl_V5_Api,[EdulineV5_Tool currentdateInterval],[EdulineV5_Tool getRandomString],[EdulineV5_Tool getmd5WithString:fullString]];
    NSLog(@"%@ ==== %@ ===  %@",fullString,final,[EdulineV5_Tool getmd5WithString:fullString]);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HeaderUrl_V5_Api]];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    if (SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
        [manager.requestSerializer setValue:[V5_UserModel oauthToken] forHTTPHeaderField:@"E-USER-AK"];
        [manager.requestSerializer setValue:[V5_UserModel oauthTokenSecret] forHTTPHeaderField:@"E-USER-SK"];
    }
    [manager.requestSerializer setValue:VUE_APP_ID forHTTPHeaderField:@"E-APP-ID"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"E-DEVICE-TYPE"];
    
    [manager.requestSerializer setValue:currentTime forHTTPHeaderField:@"E-APP-timestamp"];
    [manager.requestSerializer setValue:randomString forHTTPHeaderField:@"E-APP-nonce"];
    [manager.requestSerializer setValue:[EdulineV5_Tool getmd5WithString:fullString] forHTTPHeaderField:@"E-APP-sign"];
    
    if ([regardlessOrNot isEqualToString:@"1"] && [urlStr isEqualToString:@"category/tree"]) {
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"E-MHM-ID"];
    } else {
        if ([Show_Config isEqualToString:@"1"]) {
            [manager.requestSerializer setValue:Institution_Id forHTTPHeaderField:@"E-MHM-ID"];
        } else {
            [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"E-MHM-ID"];
        }
    }
    
    if ([usersharecode isEqualToString:@"0"]) {
        
    } else {
        [manager.requestSerializer setValue:usersharecode forHTTPHeaderField:@"E-SHARE-CODE"];
    }
    
    if ([regardlessOrNot isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"regardless_mhm_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [manager GET:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
        NSLog(@"EdulineV4 GET request succece \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        // 成功回调
        finish(responseObject);
        // 如果superapikey过期，重新保存加密获取新的
        // 如果用户apikey过期，则重新登录
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    #ifdef DEBUG
        NSLog(@"EdulineV4 GET request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        // 失败回调
        NSData *errorData = [NSData dataWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]];
        NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSJSONSerialization *dicJson = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *pass = [NSDictionary dictionaryWithDictionary:(NSDictionary *)dicJson];
        if ([[pass allKeys] count]) {
            if (SWNOTEmptyDictionary([pass objectForKey:@"data"])) {
                NSString *error_code = [NSString stringWithFormat:@"%@",[[pass objectForKey:@"data"] objectForKey:@"error_code"]];
                if ([error_code isEqualToString:@"402"] && SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
                    // 展示提示框
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.noticeLogoutAlert show];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
                }
            }
        }
        enError(error);
       
   }];
}

+ (void)requestPOSTWithURLStr:(NSString *)urlStr WithAuthorization:(NSString *)authorization paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
    
    // > `APP_KEY` | `stringA` | `timestamp`|`nonce_str`
    NSString *randomString = [EdulineV5_Tool getRandomString];
    NSString *currentTime = [EdulineV5_Tool currentdateInterval];
    NSString *fullString = [NSString stringWithFormat:@"%@|%@|%@|%@",VUE_APP_KEY,[EdulineV5_Tool sortedDictionary:paramDic],currentTime,randomString];
    NSString *final = [NSString stringWithFormat:@"%@?timestamp=%@&nonce_str=%@&sign=%@",HeaderUrl_V5_Api,[EdulineV5_Tool currentdateInterval],[EdulineV5_Tool getRandomString],[EdulineV5_Tool getmd5WithString:fullString]];
    NSLog(@"%@ ==== %@ ===  %@",fullString,final,[EdulineV5_Tool getmd5WithString:fullString]);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HeaderUrl_V5_Api]];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    if (SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
        [manager.requestSerializer setValue:[V5_UserModel oauthToken] forHTTPHeaderField:@"E-USER-AK"];
        [manager.requestSerializer setValue:[V5_UserModel oauthTokenSecret] forHTTPHeaderField:@"E-USER-SK"];
    }
    [manager.requestSerializer setValue:VUE_APP_ID forHTTPHeaderField:@"E-APP-ID"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"E-DEVICE-TYPE"];
    [manager.requestSerializer setValue:currentTime forHTTPHeaderField:@"E-APP-timestamp"];
    [manager.requestSerializer setValue:randomString forHTTPHeaderField:@"E-APP-nonce"];
    [manager.requestSerializer setValue:[EdulineV5_Tool getmd5WithString:fullString] forHTTPHeaderField:@"E-APP-sign"];
    if ([Show_Config isEqualToString:@"1"]) {
        [manager.requestSerializer setValue:Institution_Id forHTTPHeaderField:@"E-MHM-ID"];
    } else {
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"E-MHM-ID"];
    }
    
    if ([usersharecode isEqualToString:@"0"]) {
        
    } else {
        [manager.requestSerializer setValue:usersharecode forHTTPHeaderField:@"E-SHARE-CODE"];
    }
    
   [manager POST:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 POST request succece \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
       NSString *errcode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
       if ([errcode isEqualToString:@"1"]) {
           finish(responseObject);
       }else {
           #ifdef DEBUG
               NSString *errmsg = [responseObject objectForKey:@"msg"];
               NSLog(@"EdulineV4 DELETE request failure \n%@\n",errmsg);
           #endif
           finish(responseObject);
       }
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       #ifdef DEBUG
          NSLog(@"EdulineV4 POST request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
       #endif
       // 失败回调
       NSData *errorData = [NSData dataWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]];
       NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
       NSJSONSerialization *dicJson = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
       NSDictionary *pass = [NSDictionary dictionaryWithDictionary:(NSDictionary *)dicJson];
       if ([[pass allKeys] count]) {
           if (SWNOTEmptyDictionary([pass objectForKey:@"data"])) {
               NSString *error_code = [NSString stringWithFormat:@"%@",[[pass objectForKey:@"data"] objectForKey:@"error_code"]];
               if ([error_code isEqualToString:@"402"] && SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
                   // 展示提示框
                   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                   [appDelegate.noticeLogoutAlert show];
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
               }
           }
       }
       enError(error);
   }];
}

+ (void)requestPUTWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic Api_key:(NSString *)api_key finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{

    // > `APP_KEY` | `stringA` | `timestamp`|`nonce_str`
    NSString *randomString = [EdulineV5_Tool getRandomString];
    NSString *currentTime = [EdulineV5_Tool currentdateInterval];
    NSString *fullString = [NSString stringWithFormat:@"%@|%@|%@|%@",VUE_APP_KEY,[EdulineV5_Tool sortedDictionary:paramDic],currentTime,randomString];
    NSString *final = [NSString stringWithFormat:@"%@?timestamp=%@&nonce_str=%@&sign=%@",HeaderUrl_V5_Api,[EdulineV5_Tool currentdateInterval],[EdulineV5_Tool getRandomString],[EdulineV5_Tool getmd5WithString:fullString]];
    NSLog(@"%@ ==== %@ ===  %@",fullString,final,[EdulineV5_Tool getmd5WithString:fullString]);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HeaderUrl_V5_Api]];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    if (SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
        [manager.requestSerializer setValue:[V5_UserModel oauthToken] forHTTPHeaderField:@"E-USER-AK"];
        [manager.requestSerializer setValue:[V5_UserModel oauthTokenSecret] forHTTPHeaderField:@"E-USER-SK"];
    }
    [manager.requestSerializer setValue:VUE_APP_ID forHTTPHeaderField:@"E-APP-ID"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"E-DEVICE-TYPE"];
    
    [manager.requestSerializer setValue:currentTime forHTTPHeaderField:@"E-APP-timestamp"];
    [manager.requestSerializer setValue:randomString forHTTPHeaderField:@"E-APP-nonce"];
    [manager.requestSerializer setValue:[EdulineV5_Tool getmd5WithString:fullString] forHTTPHeaderField:@"E-APP-sign"];
    if ([Show_Config isEqualToString:@"1"]) {
        [manager.requestSerializer setValue:Institution_Id forHTTPHeaderField:@"E-MHM-ID"];
    } else {
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"E-MHM-ID"];
    }
    if ([usersharecode isEqualToString:@"0"]) {
        
    } else {
        [manager.requestSerializer setValue:usersharecode forHTTPHeaderField:@"E-SHARE-CODE"];
    }
    
    [manager PUT:urlStr parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 PUT request succece \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        NSString *errcode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        
        if ([errcode isEqualToString:@"1"]) {
            
            finish(responseObject);
            
        }else{
            finish(responseObject);
            #ifdef DEBUG
                NSString *errmsg = [responseObject objectForKey:@"msg"];
                NSLog(@"EdulineV4 DELETE request failure \n%@\n",errmsg);
            #endif
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 PUT request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        NSData *errorData = [NSData dataWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]];
        NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSJSONSerialization *dicJson = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *pass = [NSDictionary dictionaryWithDictionary:(NSDictionary *)dicJson];
        if ([[pass allKeys] count]) {
            if (SWNOTEmptyDictionary([pass objectForKey:@"data"])) {
                NSString *error_code = [NSString stringWithFormat:@"%@",[[pass objectForKey:@"data"] objectForKey:@"error_code"]];
                if ([error_code isEqualToString:@"402"] && SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
                    // 展示提示框
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.noticeLogoutAlert show];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
                }
            }
        }
        enError(error);
    }];
}

+ (void)requestDeleteWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic Api_key:(NSString *)api_key finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
    
    // > `APP_KEY` | `stringA` | `timestamp`|`nonce_str`
    NSString *randomString = [EdulineV5_Tool getRandomString];
    NSString *currentTime = [EdulineV5_Tool currentdateInterval];
    NSString *fullString = [NSString stringWithFormat:@"%@|%@|%@|%@",VUE_APP_KEY,[EdulineV5_Tool sortedDictionary:paramDic],currentTime,randomString];
    NSString *final = [NSString stringWithFormat:@"%@?timestamp=%@&nonce_str=%@&sign=%@",HeaderUrl_V5_Api,[EdulineV5_Tool currentdateInterval],[EdulineV5_Tool getRandomString],[EdulineV5_Tool getmd5WithString:fullString]];
    NSLog(@"%@ ==== %@ ===  %@",fullString,final,[EdulineV5_Tool getmd5WithString:fullString]);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HeaderUrl_V5_Api]];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    if (SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
        [manager.requestSerializer setValue:[V5_UserModel oauthToken] forHTTPHeaderField:@"E-USER-AK"];
        [manager.requestSerializer setValue:[V5_UserModel oauthTokenSecret] forHTTPHeaderField:@"E-USER-SK"];
    }
    [manager.requestSerializer setValue:VUE_APP_ID forHTTPHeaderField:@"E-APP-ID"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"E-DEVICE-TYPE"];
    
    [manager.requestSerializer setValue:currentTime forHTTPHeaderField:@"E-APP-timestamp"];
    [manager.requestSerializer setValue:randomString forHTTPHeaderField:@"E-APP-nonce"];
    [manager.requestSerializer setValue:[EdulineV5_Tool getmd5WithString:fullString] forHTTPHeaderField:@"E-APP-sign"];
    if ([Show_Config isEqualToString:@"1"]) {
        [manager.requestSerializer setValue:Institution_Id forHTTPHeaderField:@"E-MHM-ID"];
    } else {
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"E-MHM-ID"];
    }
    if ([usersharecode isEqualToString:@"0"]) {
        
    } else {
        [manager.requestSerializer setValue:usersharecode forHTTPHeaderField:@"E-SHARE-CODE"];
    }
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@""]];
 
    [manager DELETE:urlStr parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 DELETE request succece \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        NSString *errcode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        
        if ([errcode isEqualToString:@"1"]) {
            
            finish(responseObject);
            
        }else{
            #ifdef DEBUG
                NSString *errmsg = [responseObject objectForKey:@"msg"];
                NSLog(@"EdulineV4 DELETE request failure \n%@\n",errmsg);
            #endif
            finish(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 DELETE request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        // 失败回调
        NSData *errorData = [NSData dataWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]];
        NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSJSONSerialization *dicJson = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *pass = [NSDictionary dictionaryWithDictionary:(NSDictionary *)dicJson];
        if ([[pass allKeys] count]) {
            if (SWNOTEmptyDictionary([pass objectForKey:@"data"])) {
                NSString *error_code = [NSString stringWithFormat:@"%@",[[pass objectForKey:@"data"] objectForKey:@"error_code"]];
                if ([error_code isEqualToString:@"402"] && SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
                    // 展示提示框
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.noticeLogoutAlert show];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
                }
            }
        }
        enError(error);
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgressBlock
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
  
    NSMutableDictionary* mutaDic = [[NSMutableDictionary alloc]initWithDictionary:parameters];

    // 增加API分类和版本号
//    [mutaDic setObject:API_TYPE forKey:@"api_type"];
//    [mutaDic setObject:API_VERSION forKey:@"api_version"];
    
    // > `APP_KEY` | `stringA` | `timestamp`|`nonce_str`
    NSString *randomString = [EdulineV5_Tool getRandomString];
    NSString *currentTime = [EdulineV5_Tool currentdateInterval];
    NSString *fullString = [NSString stringWithFormat:@"%@|%@|%@|%@",VUE_APP_KEY,[EdulineV5_Tool sortedDictionary:parameters],currentTime,randomString];
    NSString *final = [NSString stringWithFormat:@"%@?timestamp=%@&nonce_str=%@&sign=%@",HeaderUrl_V5_Api,[EdulineV5_Tool currentdateInterval],[EdulineV5_Tool getRandomString],[EdulineV5_Tool getmd5WithString:fullString]];
    NSLog(@"%@ ==== %@ ===  %@",fullString,final,[EdulineV5_Tool getmd5WithString:fullString]);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HeaderUrl_V5_Api]];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    if (SWNOTEmptyStr_Api([V5_UserModel oauthToken])) {
        [manager.requestSerializer setValue:[V5_UserModel oauthToken] forHTTPHeaderField:@"E-USER-AK"];
        [manager.requestSerializer setValue:[V5_UserModel oauthTokenSecret] forHTTPHeaderField:@"E-USER-SK"];
    }
    [manager.requestSerializer setValue:VUE_APP_ID forHTTPHeaderField:@"E-APP-ID"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"E-DEVICE-TYPE"];
    
    [manager.requestSerializer setValue:currentTime forHTTPHeaderField:@"E-APP-timestamp"];
    [manager.requestSerializer setValue:randomString forHTTPHeaderField:@"E-APP-nonce"];
    [manager.requestSerializer setValue:[EdulineV5_Tool getmd5WithString:fullString] forHTTPHeaderField:@"E-APP-sign"];
    if ([Show_Config isEqualToString:@"1"]) {
        [manager.requestSerializer setValue:Institution_Id forHTTPHeaderField:@"E-MHM-ID"];
    } else {
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"E-MHM-ID"];
    }
    if ([usersharecode isEqualToString:@"0"]) {
        
    } else {
        [manager.requestSerializer setValue:usersharecode forHTTPHeaderField:@"E-SHARE-CODE"];
    }
    
    return  [manager POST:URLString parameters:mutaDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //
        block(formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            uploadProgressBlock(uploadProgress);

        });

        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
    #ifdef DEBUG
       NSLog(@"EdulineV4 POSTFILE request succece \n%@\n%@",task.currentRequest.URL.absoluteString,parameters);
    #endif
        dispatch_async(dispatch_get_main_queue(), ^{
           
            success(task,responseObject);
 
        });

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    #ifdef DEBUG
       NSLog(@"EdulineV4 POSTFILE request failure \n%@\n%@",task.currentRequest.URL.absoluteString,parameters);
    #endif
        dispatch_async(dispatch_get_main_queue(), ^{
            
            failure(task,error);

        });

    }];
}

@end
