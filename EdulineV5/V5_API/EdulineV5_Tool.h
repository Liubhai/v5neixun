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
+ (NSString*)timeChangeWithSecondsFormat:(NSInteger)seconds;
+ (NSString *)getLocalTime;
+ (NSString *)formateTime:(NSString *)time;
+ (NSString *)timeForHHmm:(NSString *)time;
+ (NSString *)timeForYYYYMMDD:(NSString *)time;

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

@end
