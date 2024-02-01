//
//  CCUser+CCSound.m
//  CCClassRoom
//
//  Created by 刘强强 on 2021/4/20.
//  Copyright © 2021 cc. All rights reserved.
//

#import "CCUser+CCSound.h"
#import <objc/runtime.h>

static const void *KSoundCCLeave = @"KSoundCCLeave";

@implementation CCUser (CCSound)

- (void)setSoundccLeave:(int)soundccLeave {
    
    objc_setAssociatedObject(self, &KSoundCCLeave, @(soundccLeave), OBJC_ASSOCIATION_ASSIGN);
}
- (int)soundccLeave {
    NSNumber *numVaue = objc_getAssociatedObject(self, &KSoundCCLeave);
    return [numVaue intValue];
}

@end
