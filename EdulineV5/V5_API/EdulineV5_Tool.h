//
//  EdulineV5_Tool.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EdulineV5_Tool : NSObject {
    
@private NSMutableDictionary *_data;
    
}

// 需要展示的屏幕高度
@property (assign, nonatomic) CGFloat tsShowWindowsHeight;
// 需要展示的屏幕宽度
@property (assign, nonatomic) CGFloat tsShowWindowsWidth;
// 屏幕高度
@property (assign, nonatomic) CGFloat tsMainScreenHeight;
// 屏幕宽度
@property (assign, nonatomic) CGFloat tsMainScreenWidth;

+ (EdulineV5_Tool *)sharedInstance;
/********************* iPhoneX 高度判断 **********************/
+ (float)safeAreaWithIPhoneX;
+ (float)bottomHeightWithIPhoneX;
+ (float)upHeightWithIPhoneX;
+ (float)liuhaiHeightWithIPhoneX;
+ (float)statusBarAddHeightWithIPhoneX;
+ (float)statusBarHeightWithIPhoneX;
+ (BOOL)isIPhoneX;
+ (BOOL)judgeIphoneX;

// 字符串 高度
+ (float) heightForString:(NSString *)value fontSize:(UIFont*)font andWidth:(float)width;

// 字符串 宽度
+ (float) widthForString:(NSString *)value fontSize:(UIFont*)font andHeight:(float)height;

+ (NSString*)timeChangeWithSeconds:(NSInteger)seconds;
/* 倒计时显示 **/
+ (NSString*)timeChangeTimerWithSeconds:(NSInteger)seconds;
/** 分离出 日  时 分 秒 */
+ (NSArray *)timeChangeTimerDayHoursMinuteSeconds:(NSInteger)seconds;
// isMinite 是否从分钟数开始 还是秒数开始
+ (NSAttributedString*)attributionTimeChangeWithSeconds:(NSInteger)seconds isMinite:(BOOL)isMinite;
+ (NSString*)timeChangeWithSecondsFormat:(NSInteger)seconds;
+ (NSString *)getLocalTime;
+ (NSString *)formateTime:(NSString *)time;
+ (NSString *)formateYYYYMMDDHHMMTime:(NSString *)time;
+ (NSString *)timeForHHmm:(NSString *)time;
+ (NSString *)timeForYYYYMMDD:(NSString *)time;
+ (NSString *)timeFormatterYYYYMMDD:(NSString *)time;
+ (NSString *)formatterDate:(NSString *)time;
+ (NSString *)timeForYYYY:(NSString *)time;
+ (NSString *)timeForYYYYMMDDNianYueRI:(NSString *)time;
+ (NSString *)timeForMMDD:(NSString *)time;
+ (NSString *)timeForBalanceYYMMDDHHMM:(NSString *)time;

+ (NSString *)currentdateInterval;
+ (NSString *)getRandomString;

+ (NSString *)sortedDictionary:(NSDictionary *)dict;

+ (NSString *)getImageFieldMD5:(NSData *)imageData;

+ (NSString *)getmd5WithString:(NSString *)string;

// > `APP_KEY` | `stringA` | `timestamp`|`nonce_str`
+ (NSString *)getSignFourthString;

+ (BOOL)validatePassWord:(NSString *)pw;

+ (void)adapterOfIOS11With:(UITableView *)tableView;

+ (void)dealButtonImageAndTitleUI:(UIButton *)sender;

+ (void)dealButtonImageAndTitleUIWidthSpace:(UIButton *)sender space:(CGFloat)space;

+ (NSString *)timeForYYYYMMDDHHMM:(NSString *)time;

/** 获取某个颜色值的rgb值 */
+ (const CGFloat *)getColorRGB:(UIColor *)currentColor;

// 字典转字符串
+ (NSString *)dictConvertToJsonData:(NSDictionary *)dict;

// MARK: - 显示两个时间戳之间的时间段
+ (NSString *)evaluateStarTime:(NSString *)starTime endTime:(NSString *)eTime;

//MARK: - 考试列表时间
+ (NSString *)examEvaluateStarTime:(NSString *)starTime endTime:(NSString *)eTime;

/** 移除普通标签 */
+ (NSString *)removeFilterHTML:(NSString *)html;

+ (NSString *)reviseString: (NSString *)str;

@end
