//
//  Net_API.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "Net_API.h"

@implementation Net_API

+ (void)requestGETSuperAPIWithURLStr:(NSString *)urlStr WithAuthorization:(NSString *)authorization paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
   
    // 设置请求头
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
   
    [manager GET:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
        NSLog(@"EdulineV4 GET request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
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
        enError(error);
       
   }];
}

+ (void)requestPOSTWithURLStr:(NSString *)urlStr WithAuthorization:(NSString *)authorization paramDic:(NSDictionary *)paramDic finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
   
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
   manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
 
   // 设置请求头
   [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
   [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
   [manager POST:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 POST request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
       NSString *errcode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errcode"]];
       if ([errcode isEqualToString:@"0"]) {
           finish(responseObject);
       }else {
           #ifdef DEBUG
               NSString *errmsg = [responseObject objectForKey:@"errmsg"];
               NSLog(@"EdulineV4 DELETE request failure \n%@\n",errmsg);
           #endif
       }
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       #ifdef DEBUG
          NSLog(@"EdulineV4 POST request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
       #endif
       // 失败回调
       enError(error);
   }];
}

+ (void)requestPUTWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic Api_key:(NSString *)api_key finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain", nil];
    
    // 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:api_key forHTTPHeaderField:@"api_key"];
    [manager PUT:urlStr parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 PUT request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        NSString *errcode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errcode"]];
        
        if ([errcode isEqualToString:@"0"]) {
            
            finish(responseObject);
            
        }else{
            #ifdef DEBUG
                NSString *errmsg = [responseObject objectForKey:@"errmsg"];
                NSLog(@"EdulineV4 DELETE request failure \n%@\n",errmsg);
            #endif
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 PUT request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        enError(error);
    }];
}

+ (void)requestDeleteWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic Api_key:(NSString *)api_key finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError{
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain", nil];
    
    // 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:api_key forHTTPHeaderField:@"api_key"];
    [manager DELETE:urlStr parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 DELETE request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
        NSString *errcode = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errcode"]];
        
        if ([errcode isEqualToString:@"0"]) {
            
            finish(responseObject);
            
        }else{
            #ifdef DEBUG
                NSString *errmsg = [responseObject objectForKey:@"errmsg"];
                NSLog(@"EdulineV4 DELETE request failure \n%@\n",errmsg);
            #endif
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    #ifdef DEBUG
       NSLog(@"EdulineV4 DELETE request failure \n%@\n%@",task.currentRequest.URL.absoluteString,paramDic);
    #endif
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
    
    return  [[EdulineV5Client sharedClient] POST:URLString parameters:mutaDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
       NSLog(@"EdulineV4 POSTFILE request failure \n%@\n%@",task.currentRequest.URL.absoluteString,parameters);
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
