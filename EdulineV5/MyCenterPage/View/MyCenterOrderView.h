//
//  MyCenterOrderView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/14.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCenterOrderViewDelegate <NSObject>

@optional
- (void)goToOrderVC:(UIButton *)sender;

@end

@interface MyCenterOrderView : UIView

@property (weak, nonatomic) id<MyCenterOrderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
