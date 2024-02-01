//
//  HDSLanguage.m
//  TWK
//
//  Created by Chenfy on 2021/9/10.
//  Copyright © 2021 Chenfy. All rights reserved.
//

#import "YUNLanguage.h"

@interface YUNLanguage ()
/** 默认使用的语言版本, 默认为 nil. 将随系统的语言自动改变 */
@property (copy, nonatomic, nullable) NSString *languageCode;
//资源文件所在bundle
@property(nonatomic,strong)NSBundle *bundlePath;
//对应语言对应bundle
@property(nonatomic,strong)NSBundle *bundleLanguage;

@end

@implementation YUNLanguage

static YUNLanguage *hds_language = nil;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hds_language = [[self alloc] init];
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        hds_language.languageCode = [self __hds_language_for_mode:YUNLanguageMode_system];
        hds_language.bundlePath = [NSBundle mainBundle];
        hds_language.bundleLanguage = [NSBundle mainBundle];
    });
    return hds_language;
}

+ (void)setBundlePathMainForClass:(Class)cls {
    YUNLanguage *lg = [self manager];
    NSBundle *bundlePath = [self __bundlePathSourceForClass:cls];
    lg.bundlePath = bundlePath;
}

+ (YUNLanguageMode)currentMode {
    YUNLanguage *lg = [self manager];
    NSString *code = lg.languageCode;

    return [self __hds_mode_for_language:code];
}

+ (void)setLanguageMode:(YUNLanguageMode)mode {
    YUNLanguage *lg = [self manager];
    NSString *language = [self __hds_language_for_mode:mode];
    lg.languageCode = language;
    
    NSBundle *bundlePath = lg.bundlePath;
    NSBundle *bundle = [NSBundle bundleWithPath:[bundlePath pathForResource:language ofType:@"lproj"]];
    
    lg.bundleLanguage = bundle;
}

+ (NSString *)hds_localizedStringForKey:(NSString *)key {
    YUNLanguage *lg = [self manager];
    return [lg.bundleLanguage localizedStringForKey:key value:nil table:nil];
}

#pragma mark -- private
+ (NSString *)__hds_language_for_mode :(YUNLanguageMode)mode {
    NSString *lg_code = nil;
    if (mode == YUNLanguageMode_system) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
         if ([language hasPrefix:@"en"]) {
             language = @"en";
         } else if ([language hasPrefix:@"zh"]) {
             language = @"zh-Hans"; // 简体中文
         } else {
             language = @"en";
         }
        lg_code = language;
    }
    else if (mode == YUNLanguageMode_chiness) {
        lg_code = @"zh-Hans";
    }
    else if (mode == YUNLanguageMode_english) {
        lg_code = @"en";
    }
    return lg_code;
}

+ (YUNLanguageMode)__hds_mode_for_language:(NSString *)language {
    YUNLanguageMode mode;
    if ([language isEqualToString:@"en"]) {
        mode = YUNLanguageMode_english;
    }
    else if ([language isEqualToString:@"zh-Hans"]) {
        mode = YUNLanguageMode_chiness;
    }
    else {
        mode = YUNLanguageMode_english;
    }

    return mode;
}

+ (NSBundle *)__bundlePathSourceForClass:(Class)cls {
    NSBundle *bundlePath = [NSBundle bundleForClass:cls];
    return bundlePath;
}

+ (NSString *)hds_imagePath:(NSString *)imageName {
    NSString *dealRes = imageName;
    if (![dealRes containsString:@".png"]) {
        dealRes = [NSString stringWithFormat:@"%@.png",imageName];
    }

    YUNLanguage *lg = [self manager];
    int scale = (int)[[UIScreen mainScreen]scale];
#pragma mark -- 切图尺寸不准确，直接采用三倍图
    scale = 3;
    NSString *repl = [NSString stringWithFormat:@"@%dx.",scale];
    NSLog(@"scale---%f---nativeScale--%f",[[UIScreen mainScreen]scale],[[UIScreen mainScreen]nativeScale]);
    NSString *iName = [dealRes stringByReplacingOccurrencesOfString:@"." withString:repl];
    return [lg.bundleLanguage pathForResource:iName ofType:nil];
}

@end
