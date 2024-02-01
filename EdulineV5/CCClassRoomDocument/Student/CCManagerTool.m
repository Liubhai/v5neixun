//
//  CCManagerTool.m
//  CCClassRoom
//
//  Created by 刘强强 on 2021/4/17.
//  Copyright © 2021 cc. All rights reserved.
//

#import "CCManagerTool.h"

static CCManagerTool *_manager = nil;
@implementation CCManagerTool

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CCManagerTool alloc]init];
    });
    return _manager;
}

- (int)getSoundInfoLeveWith:(NSString *)userId uid:(NSString *)uid streamId:(NSString *)streamId {
    if ([self.captureSoundLevel.streamID containsString:userId] || [self.captureSoundLevel.streamID containsString:uid] || [self.captureSoundLevel.streamID containsString:streamId]) {
        
        return [self getSoundLeave:self.captureSoundLevel.soundLevel];
    }else {
        for (HDSoundLevelInfo *info in self.soundLevels) {
            if ([info.streamID containsString:userId] || [info.streamID containsString:uid] || [info.streamID containsString:streamId]) {
                return [self getSoundLeave:info.soundLevel];
            }
        }
    }
    return 0;
}

- (int)getSoundLeave:(float)leave {
    if (leave < 1) {
        return 0;
    }else if (leave >=1 && leave < 5) {
        return 1;
    }else if (leave >=5 && leave < 10) {
        return 2;
    }else if (leave >=10 && leave < 40) {
        return 3;
    }else if (leave >=40 && leave < 60) {
        return 4;
    }else if (leave >=60) {
        return 5;
    }
    return 0;
}

@end
