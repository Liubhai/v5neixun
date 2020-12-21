//
//  SHLineView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/21.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHLineView : UIView

/** 下划线 执行动画 */
- (void)line_animation;

/** 密码字体 执行动画 */
+ (void)font_animation:(UILabel *)label;

/** 验证是否是合法数字 */
+ (BOOL)validateNumber:(NSString *)number;
//
@property (nonatomic, strong) UIView *colorView;

@end

NS_ASSUME_NONNULL_END
