//
//  CCManagerTool.h
//  CCClassRoom
//
//  Created by 刘强强 on 2021/4/17.
//  Copyright © 2021 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCManagerTool : NSObject
+ (instancetype)shared;
///远端
@property(nonatomic, strong)NSMutableArray *soundLevels;
///自己
@property(nonatomic, strong)HDSoundLevelInfo *captureSoundLevel;

- (int)getSoundInfoLeveWith:(NSString *)userId uid:(NSString *)uid streamId:(NSString *)streamId;

@end

NS_ASSUME_NONNULL_END
