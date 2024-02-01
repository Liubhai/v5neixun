//
//  HRewardView.h
//  CCClassRoom
//
//  Created by Chenfy on 2020/7/14.
//  Copyright © 2020 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HRewardView : UIView

//初始化
- (instancetype)initWithImage:(UIImage *)image count:(NSInteger)count;
//更新数目
- (void)updateCount:(NSInteger)count;
- (void)addCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
