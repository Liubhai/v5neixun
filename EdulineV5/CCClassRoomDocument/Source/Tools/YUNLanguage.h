//
//  HDSLanguage.h
//  TWK
//
//  Created by Chenfy on 2021/9/10.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//课堂模式
typedef NS_ENUM(NSInteger,YUNLanguageMode) {
    YUNLanguageMode_system,     //跟随系统
    YUNLanguageMode_chiness,    //中文
    YUNLanguageMode_english,    //英文
};

@interface YUNLanguage : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


/** @return Singleton Config instance */
+ (instancetype)manager;
+ (void)setBundlePathMainForClass:(Class)cls;

/** 设置语言模式 */
+ (void)setLanguageMode:(YUNLanguageMode)mode;
/** 当前模式 */
+ (YUNLanguageMode)currentMode;

+ (NSString *)hds_localizedStringForKey:(NSString *)key;

+ (NSString *)hds_imagePath:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
