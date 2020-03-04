//
//  RootV5VC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RootV5VC : UITabBarController

@property (nonatomic, strong) UIImageView *imageView;
+(RootV5VC *)sharedBaseTabBarViewController;
+(RootV5VC *)destoryShared;

- (void)isHiddenCustomTabBarByBoolean:(BOOL)boolean;

- (void)rootVcIndexWithNum:(NSInteger)Num;

@end

NS_ASSUME_NONNULL_END
