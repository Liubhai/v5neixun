//
//  JustCircleProgress.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/31.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JustCircleProgress : UIView

@property(nonatomic)CGFloat totalProgress;
@property(nonatomic)CGFloat progress;
@property(nonatomic)CGFloat lineWidth;
@property(nonatomic)BOOL isSetLineCapRound;
@property(nonatomic,strong)UIColor *bgColor;
@property(nonatomic,strong)UIColor *progressColor;


@end

NS_ASSUME_NONNULL_END
