//
//  EdulineV5Client.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "EdulineV5Client.h"
#import "Api_Config.h"

@implementation EdulineV5Client

+ (instancetype)sharedClient {
    static EdulineV5Client *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EdulineV5Client alloc] initWithBaseURL:[NSURL URLWithString:HeaderUrl_V5]];
//        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    
    _sharedClient.responseSerializer = responseSerializer;
    _sharedClient.requestSerializer = requestSerializer;

    return _sharedClient;
}

@end
