//
//  StarEvaluator.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/16.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class StarEvaluator;
@protocol StarEvaluatorDelegate <NSObject>

@optional
- (void)anotherStarEvaluator:(StarEvaluator *)evaluator currentValue:(float)value;

@end

@interface StarEvaluator : UIControl

@property (assign, nonatomic) id<StarEvaluatorDelegate> delegate;

- (void)setStarValue:(float)starvalue;

@end

NS_ASSUME_NONNULL_END
