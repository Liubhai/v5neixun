//
//  EdulineV5Client.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface EdulineV5Client : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

NS_ASSUME_NONNULL_END
