//
//  Net_API.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EdulineV5Client.h"

NS_ASSUME_NONNULL_BEGIN

@interface Net_API : NSObject

// GET
+ (void)requestGETSuperAPIWithURLStr:(NSString *)urlStr
                   WithAuthorization:(NSString *)authorization
                            paramDic:(NSDictionary *)paramDic
                              finish:(void(^)(id responseObject))finish
                             enError:(void(^)(NSError *error))enError;

// POST
+ (void)requestPOSTWithURLStr:(NSString *)urlStr
            WithAuthorization:(NSString *)authorization
                     paramDic:(NSDictionary *)paramDic
                       finish:(void(^)(id responseObject))finish
                      enError:(void(^)(NSError *error))enError;

// POST File
+ (NSURLSessionDataTask * _Nonnull)POST:(NSString * _Nonnull)URLString
               parameters:(id _Nonnull)parameters
constructingBodyWithBlock:(void (^ _Nonnull)(id <AFMultipartFormData> _Nonnull formData))block
                 progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress))uploadProgressBlock
                  success:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject))success
                  failure:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;

// PUT
+ (void)requestPUTWithURLStr:(NSString *)urlStr
                    paramDic:(NSDictionary *)paramDic
                     Api_key:(NSString *)api_key
                      finish:(void(^)(id responseObject))finish
                     enError:(void(^)(NSError *error))enError;

// DELETE
+ (void)requestDeleteWithURLStr:(NSString *)urlStr
                       paramDic:(NSDictionary *)paramDic
                        Api_key:(NSString *)api_key
                         finish:(void(^)(id responseObject))finish
                        enError:(void(^)(NSError *error))enError;

@end

NS_ASSUME_NONNULL_END
