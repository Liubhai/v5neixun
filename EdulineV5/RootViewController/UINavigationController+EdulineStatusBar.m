//
//  UINavigationController+EdulineStatusBar.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/22.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "UINavigationController+EdulineStatusBar.h"

@implementation UINavigationController (EdulineStatusBar)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

@end
