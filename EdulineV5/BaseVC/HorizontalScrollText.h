//
//  HorizontalScrollText.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 描述字符串滚动前端起始位置：
 */
typedef enum {
    LMJTextScrollContinuous,     // 从控件内开始连续滚动
    LMJTextScrollIntermittent,   // 从控件内开始间断滚动
    LMJTextScrollFromOutside,    // 从控件外开始滚动
    LMJTextScrollWandering       // 在控件中往返滚动（不受设置方向影响）
}LMJTextScrollMode;

/**
 描述字符串移动的方向
 */
typedef enum {
    LMJTextScrollMoveLeft,
    LMJTextScrollMoveRight
}LMJTextScrollMoveDirection;

@interface HorizontalScrollText : UIView

@property (nonatomic,copy)   NSString  * text;
@property (nonatomic,copy)   UIFont  * textFont;
@property (nonatomic,copy)   UIColor * textColor;

@property (nonatomic,assign) CGFloat speed;
@property (nonatomic,assign) CGFloat rightTimeInterval;

@property (nonatomic,assign) LMJTextScrollMode moveMode;
@property (nonatomic,assign) LMJTextScrollMoveDirection moveDirection;

- (void)move;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
