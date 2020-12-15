//
//  KeyCenter.m
//  AgoraEducation
//
//  Created by SRS on 2020/3/26.
//  Copyright © 2020 yangmoumou. All rights reserved.
//

#import "KeyCenter.h"
#import "URL.h"
#import "V5_Constant.h"

@implementation KeyCenter

+ (NSString *)agoraAppid {
    return @"149f7636178140d5821bf0d2b61a480b";//shengwangAppid;
}

+ (NSString *)authorization {
    NSString *auth = @"9711a4961e4749d781f7ce4cdaf8221f:d21a5b18ffd348729d3005e816ae41a0";//shengwangAuth;//
    NSData *data = [auth dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64AuthCredentials = [data base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
    return base64AuthCredentials;
}

+ (NSString *)boardInfoApiURL {
    return HTTP_WHITE_ROOM_INFO;
}

@end
