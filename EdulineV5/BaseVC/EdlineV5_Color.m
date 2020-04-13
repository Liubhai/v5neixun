//
//  EdlineV5_Color.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "EdlineV5_Color.h"

#define HEXCOLORV5(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation EdlineV5_Color

+ (UIColor *)statebarColor {
    return [UIColor whiteColor];
}

/** 基本色 */
+ (UIColor *)baseColor {
    return HEXCOLORV5(0x5191FF);
}

/** 主题色 */
+ (UIColor *)themeColor {
    return HEXCOLORV5(0x5191FF);
}

+ (UIColor *)themeWeakColor {
    return HEXCOLORV5(0x2C92F8);
}

/** 不可操作时候颜色 */
+ (UIColor *)disableColor {
    return HEXCOLORV5(0x97BDFF);
}

/** 普通色 */
+ (UIColor *)normalColor {
    return HEXCOLORV5(0x5191FF);
}

/** 分割线颜色 */
+ (UIColor *)fengeLineColor {
    return HEXCOLORV5(0xEBEEF5);
}

/** 线框边框颜色 */
+ (UIColor *)layarLineColor {
    return HEXCOLORV5(0xE4E7ED);
}

/** 成功颜色 */
+ (UIColor *)successColor {
    return HEXCOLORV5(0x67C23A);
}

/** 警告颜色 */
+ (UIColor *)warningColor {
    return HEXCOLORV5(0xE6A23C);
}

/** 失败颜色 */
+ (UIColor *)faildColor {
    return HEXCOLORV5(0xF54030);
}

/** 价格颜色 */
+ (UIColor *)textPriceColor {
    return HEXCOLORV5(0xF54030);
}

/** 免费颜色 */
+ (UIColor *)textfreeColor {
    return HEXCOLORV5(0x67C23A);
}

/** 活动、点赞、收藏颜色 */
+ (UIColor *)textzanColor {
    return HEXCOLORV5(0xFF8A52);
}

/** 大标题颜色 */
+ (UIColor *)textFirstColor {
    return HEXCOLORV5(0x303133);
}

/** 次要文字颜色 */
+ (UIColor *)textSecendColor {
    return HEXCOLORV5(0x606266);
}

/** 辅助颜色 */
+ (UIColor *)textThirdColor {
    return HEXCOLORV5(0x909399);
}

/** 背景颜色 */
+ (UIColor *)backColor {
    return HEXCOLORV5(0xF7F7F7);
}

/** 按钮可点击颜色 */
+ (UIColor *)buttonNormalColor {
    return HEXCOLORV5(0x5191FF);
}

/** 按钮不可点击颜色 */
+ (UIColor *)buttonDisableColor {
    return HEXCOLORV5(0x97BDFF);
}

/** 按钮弱化颜色 */
+ (UIColor *)buttonWeakeColor {
    return HEXCOLORV5(0x5191FF);
}

+ (UIColor *)starPreColor {
    return HEXCOLORV5(0xFF8A52);
}

+ (UIColor *)starNoColor {
    return HEXCOLORV5(0xDCDFE6);
}

+ (UIColor *)courseTipBackColor1 {
    return HEXCOLORV5(0xDCDFE6);
}

+ (UIColor *)enterLayerBorderColor {
    return HEXCOLORV5(0xE4E7ED);
}

/** 优惠卷内文字颜色 */
+ (UIColor *)youhuijuanColor {
    return HEXCOLORV5(0xFF8A52);
}
/** 打折卡内文字颜色 */
+ (UIColor *)dazhekaColor {
    return HEXCOLORV5(0xFF9431);
}
/** 课程卡内文字颜色 */
+ (UIColor *)kechengkaColor {
    return HEXCOLORV5(0x67C23A);
}
@end
