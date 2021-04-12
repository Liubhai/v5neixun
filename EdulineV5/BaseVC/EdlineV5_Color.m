//
//  EdlineV5_Color.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/6.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "EdlineV5_Color.h"
#import "EdulineV5_Tool.h"

/**
{ name: 'haiyanglan', color: '#5191FF' },
{ name: 'shenhailan', color: '#2C5DFF' },
{ name: 'tiankonglan', color: '#43C7F9' },
{ name: 'shiliuhong', color: '#EC0000' },
{ name: 'shanchahong', color: '#FA648D' },
{ name: 'zhulv', color: '#00AD82' },
{ name: 'caolv', color: '#19C349' },
{ name: 'bohelv', color: '#00D3B5' },
{ name: 'nanguacheng', color: '#FF7C03'},
{ name: 'zise', color: '#6665FF' }
 */

#define HEXCOLORV5(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation EdlineV5_Color

+ (UIColor *)statebarColor {
    return [UIColor whiteColor];
}

/** 基本色 */
+ (UIColor *)baseColor {
    NSString *themeColorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    if ([themeColorString isEqualToString:@"haiyanglan"]) {
        return HEXCOLORV5(0x5191FF);
    } else if ([themeColorString isEqualToString:@"shenhailan"]) {
        return HEXCOLORV5(0x2C5DFF);
    } else if ([themeColorString isEqualToString:@"tiankonglan"]) {
        return HEXCOLORV5(0x43C7F9);
    } else if ([themeColorString isEqualToString:@"shiliuhong"]) {
        return HEXCOLORV5(0xEC0000);
    } else if ([themeColorString isEqualToString:@"shanchahong"]) {
        return HEXCOLORV5(0xFA648D);
    } else if ([themeColorString isEqualToString:@"zhulv"]) {
        return HEXCOLORV5(0x00AD82);
    } else if ([themeColorString isEqualToString:@"caolv"]) {
        return HEXCOLORV5(0x19C349);
    } else if ([themeColorString isEqualToString:@"bohelv"]) {
        return HEXCOLORV5(0x00D3B5);
    } else if ([themeColorString isEqualToString:@"nanguacheng"]) {
        return HEXCOLORV5(0xFF7C03);
    } else if ([themeColorString isEqualToString:@"zise"]) {
        return HEXCOLORV5(0x6665FF);
    }
    return HEXCOLORV5(0x5191FF);
}

/** 主题色 */
+ (UIColor *)themeColor {
    NSString *themeColorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    if ([themeColorString isEqualToString:@"haiyanglan"]) {
        return HEXCOLORV5(0x5191FF);
    } else if ([themeColorString isEqualToString:@"shenhailan"]) {
        return HEXCOLORV5(0x2C5DFF);
    } else if ([themeColorString isEqualToString:@"tiankonglan"]) {
        return HEXCOLORV5(0x43C7F9);
    } else if ([themeColorString isEqualToString:@"shiliuhong"]) {
        return HEXCOLORV5(0xEC0000);
    } else if ([themeColorString isEqualToString:@"shanchahong"]) {
        return HEXCOLORV5(0xFA648D);
    } else if ([themeColorString isEqualToString:@"zhulv"]) {
        return HEXCOLORV5(0x00AD82);
    } else if ([themeColorString isEqualToString:@"caolv"]) {
        return HEXCOLORV5(0x19C349);
    } else if ([themeColorString isEqualToString:@"bohelv"]) {
        return HEXCOLORV5(0x00D3B5);
    } else if ([themeColorString isEqualToString:@"nanguacheng"]) {
        return HEXCOLORV5(0xFF7C03);
    } else if ([themeColorString isEqualToString:@"zise"]) {
        return HEXCOLORV5(0x6665FF);
    }
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
    return HEXCOLORV5(0xF7F7F7);
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
    NSString *themeColorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    if ([themeColorString isEqualToString:@"haiyanglan"]) {
        return HEXCOLORV5(0x5191FF);
    } else if ([themeColorString isEqualToString:@"shenhailan"]) {
        return HEXCOLORV5(0x2C5DFF);
    } else if ([themeColorString isEqualToString:@"tiankonglan"]) {
        return HEXCOLORV5(0x43C7F9);
    } else if ([themeColorString isEqualToString:@"shiliuhong"]) {
        return HEXCOLORV5(0xEC0000);
    } else if ([themeColorString isEqualToString:@"shanchahong"]) {
        return HEXCOLORV5(0xFA648D);
    } else if ([themeColorString isEqualToString:@"zhulv"]) {
        return HEXCOLORV5(0x00AD82);
    } else if ([themeColorString isEqualToString:@"caolv"]) {
        return HEXCOLORV5(0x19C349);
    } else if ([themeColorString isEqualToString:@"bohelv"]) {
        return HEXCOLORV5(0x00D3B5);
    } else if ([themeColorString isEqualToString:@"nanguacheng"]) {
        return HEXCOLORV5(0xFF7C03);
    } else if ([themeColorString isEqualToString:@"zise"]) {
        return HEXCOLORV5(0x6665FF);
    }
    return HEXCOLORV5(0x5191FF);
}

/** 按钮不可点击颜色 */
+ (UIColor *)buttonDisableColor {
    NSString *themeColorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    if ([themeColorString isEqualToString:@"haiyanglan"]) {
        return HEXCOLORV5(0x97BDFF);
    } else if ([themeColorString isEqualToString:@"shenhailan"]) {
        return HEXCOLORV5(0x809EFF);
    } else if ([themeColorString isEqualToString:@"tiankonglan"]) {
        return HEXCOLORV5(0x8EDDFB);
    } else if ([themeColorString isEqualToString:@"shiliuhong"]) {
        return HEXCOLORV5(0xF46666);
    } else if ([themeColorString isEqualToString:@"shanchahong"]) {
        return HEXCOLORV5(0xFCA2BB);
    } else if ([themeColorString isEqualToString:@"zhulv"]) {
        return HEXCOLORV5(0x66CEB4);
    } else if ([themeColorString isEqualToString:@"caolv"]) {
        return HEXCOLORV5(0x75DB92);
    } else if ([themeColorString isEqualToString:@"bohelv"]) {
        return HEXCOLORV5(0x66E5D3);
    } else if ([themeColorString isEqualToString:@"nanguacheng"]) {
        return HEXCOLORV5(0xFFB068);
    } else if ([themeColorString isEqualToString:@"zise"]) {
        return HEXCOLORV5(0xA3A3FF);
    }
    return HEXCOLORV5(0x97BDFF);
}

/** 按钮弱化颜色 */
+ (UIColor *)buttonWeakeColor {
    NSString *themeColorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
    if ([themeColorString isEqualToString:@"haiyanglan"]) {
        return HEXCOLORV5(0x97BDFF);
    } else if ([themeColorString isEqualToString:@"shenhailan"]) {
        return HEXCOLORV5(0x809EFF);
    } else if ([themeColorString isEqualToString:@"tiankonglan"]) {
        return HEXCOLORV5(0x8EDDFB);
    } else if ([themeColorString isEqualToString:@"shiliuhong"]) {
        return HEXCOLORV5(0xF46666);
    } else if ([themeColorString isEqualToString:@"shanchahong"]) {
        return HEXCOLORV5(0xFCA2BB);
    } else if ([themeColorString isEqualToString:@"zhulv"]) {
        return HEXCOLORV5(0x66CEB4);
    } else if ([themeColorString isEqualToString:@"caolv"]) {
        return HEXCOLORV5(0x75DB92);
    } else if ([themeColorString isEqualToString:@"bohelv"]) {
        return HEXCOLORV5(0x66E5D3);
    } else if ([themeColorString isEqualToString:@"nanguacheng"]) {
        return HEXCOLORV5(0xFFB068);
    } else if ([themeColorString isEqualToString:@"zise"]) {
        return HEXCOLORV5(0xA3A3FF);
    }
    return HEXCOLORV5(0x97BDFF);
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

/** 价格免费颜色 */
+ (UIColor *)priceFreeColor {
    return HEXCOLORV5(0x67C23A);
}

/** 课程活动-开团 文字颜色 */
+ (UIColor *)courseActivityGroupColor {
    return HEXCOLORV5(0xFF6B25);
}

/** 背景色 课程活动-开团  */
+ (UIColor *)courseActivityBackColor {
    return HEXCOLORV5(0xFFECE3);
}

/** 富贵色 */
+ (UIColor *)questionSeeButtonLayerColor {
    return HEXCOLORV5(0xCA9D66);
}

@end
