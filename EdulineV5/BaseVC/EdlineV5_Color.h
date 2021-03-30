//
//  EdlineV5_Color.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EdlineV5_Color : NSObject {
    
}

+ (UIColor *)statebarColor;

/** 基本色 */
+ (UIColor *)baseColor;

/** 主题色 */
+ (UIColor *)themeColor;

/** 主题色弱化 */
+ (UIColor *)themeWeakColor;

/** 不可操作时候颜色 */
+ (UIColor *)disableColor;

/** 普通色 */
+ (UIColor *)normalColor;

/** 分割线颜色 */
+ (UIColor *)fengeLineColor;

/** 线框边框颜色 */
+ (UIColor *)layarLineColor;

/** 成功颜色 */
+ (UIColor *)successColor;

/** 警告颜色 */
+ (UIColor *)warningColor;

/** 失败颜色 */
+ (UIColor *)faildColor;

/** 价格颜色 */
+ (UIColor *)textPriceColor;

/** 免费颜色 */
+ (UIColor *)textfreeColor;

/** 活动、点赞、收藏颜色 */
+ (UIColor *)textzanColor;

/** 大标题颜色 */
+ (UIColor *)textFirstColor;

/** 次要文字颜色 */
+ (UIColor *)textSecendColor;

/** 辅助颜色 */
+ (UIColor *)textThirdColor;

/** 背景颜色 */
+ (UIColor *)backColor;

/** 按钮可点击颜色 */
+ (UIColor *)buttonNormalColor;

/** 按钮不可点击颜色 */
+ (UIColor *)buttonDisableColor;

/** 按钮弱化颜色 */
+ (UIColor *)buttonWeakeColor;

/**星星评分颜色*/
+ (UIColor *)starPreColor;

+ (UIColor *)starNoColor;

/** 输入框边框颜色 */
+ (UIColor *)enterLayerBorderColor;

/** 优惠卷内文字颜色 */
+ (UIColor *)youhuijuanColor;
/** 打折卡内文字颜色 */
+ (UIColor *)dazhekaColor;
/** 课程卡内文字颜色 */
+ (UIColor *)kechengkaColor;

/** 价格免费颜色 */
+ (UIColor *)priceFreeColor;

/** 课程活动-开团 文字颜色 */
+ (UIColor *)courseActivityGroupColor;

/** 背景色 课程活动-开团  */
+ (UIColor *)courseActivityBackColor;

@end

NS_ASSUME_NONNULL_END
