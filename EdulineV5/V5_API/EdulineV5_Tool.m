//
//  EdulineV5_Tool.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/3.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "EdulineV5_Tool.h"
#import <sys/utsname.h>

#import <CommonCrypto/CommonCrypto.h>
#define CC_MD5_DIGEST_LENGTH 16

#define kRandomLength 10

@implementation EdulineV5_Tool

static EdulineV5_Tool *_sharedInstance;

- (id)init
{
    if ((self = [super init]))
    {
        _data  = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (EdulineV5_Tool *)sharedInstance
{
    if (!_sharedInstance)
    {
        _sharedInstance = [[EdulineV5_Tool alloc] init];
    }
    return _sharedInstance;
}

// iPhoneX底部安全区
+ (float)safeAreaWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 34.0;
    } else {
        return 0;
    }
}

// iPhoneX底部视图高度
+ (float)bottomHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 49.0+34.0;
    } else {
        return 49.0;
    }
}

// iPhoneX顶部视图高度
+ (float)upHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 64.0+24.0;
    } else {
        return 64.0;
    }
}

// iPhoneX顶部视图高度
+ (float)liuhaiHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 30.0;
    } else {
        return 0;
    }
}

// iPhoneX状态栏高出的距离
+ (float)statusBarAddHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 24.0;
    } else {
        return 0;
    }
}

// iPhoneX状态栏高度
+ (float)statusBarHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 44.0;
    } else {
        return 20.0;
    }
}

+ (BOOL)isIPhoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // 模拟器下采用屏幕的高度来判断
        return [UIScreen mainScreen].bounds.size.height >= 812;
    }
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}

+ (float) heightForString:(NSString *)value fontSize:(UIFont*)font andWidth:(float)width
{
    
    if ( [[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [paragraphStyle setLineSpacing:0.001];
        NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGRect rectToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
            return 0.0;
        }else{
            return rectToFit.size.height;
        }
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        CGSize sizeToFit = [value sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
#pragma clang diagnostic pop
        if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
            return 0.0;
        }else{
            return sizeToFit.height;
        }
        
    }
}

+ (BOOL)judgeIphoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return YES;
    } else {
        return NO;
    }
}

+ (float) widthForString:(NSString *)value fontSize:(UIFont*)font andHeight:(float)height
{
    
    if ( [[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [paragraphStyle setLineSpacing:0.001];
        NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGRect rectToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
            return 0.0;
        }else{
            return rectToFit.size.width;
        }
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        CGSize sizeToFit = [value sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX,height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
#pragma clang diagnostic pop
        if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
            return 0.0;
        }else{
            return sizeToFit.width;
        }
        
    }
    
}

+ (NSString*)timeChangeWithSeconds:(NSInteger)seconds {
    NSInteger temp1 = seconds/60;
    NSInteger temp2 = temp1/ 60;
    NSInteger d = temp2 / 24;
    NSInteger h = temp2 % 24;
    NSInteger m = temp1 % 60;
    NSInteger s = seconds %60;
    NSString * hour = h< 9 ? [NSString stringWithFormat:@"0%ld",(long)h] :[NSString stringWithFormat:@"%ld",(long)h];
    NSString *day = d < 9 ? [NSString stringWithFormat:@"%ld",(long)d] : [NSString stringWithFormat:@"%ld",(long)d];
    NSString *minite = m < 9 ? [NSString stringWithFormat:@"0%ld",(long)m] : [NSString stringWithFormat:@"%ld",(long)m];
    NSString *second = s < 9 ? [NSString stringWithFormat:@"0%ld",(long)s] : [NSString stringWithFormat:@"%ld",(long)s];
    if ([day integerValue]>0) {
        return [NSString stringWithFormat:@"%@天%@小时%@分%@秒",day,hour,minite,second];
    }
    return [NSString stringWithFormat:@"%@小时%@分%@秒",hour,minite,second];
}

+ (NSString*)timeChangeWithSecondsFormat:(NSInteger)seconds {
    NSInteger temp1 = seconds/60;
    NSInteger temp2 = temp1/ 60;
    NSInteger d = temp2 / 24;
    NSInteger h = temp2 % 24;
    NSInteger m = temp1 % 60;
    NSInteger s = seconds %60;
    NSString * hour = h< 9 ? [NSString stringWithFormat:@"0%ld",(long)h] :[NSString stringWithFormat:@"%ld",(long)h];
    NSString *day = d < 9 ? [NSString stringWithFormat:@"%ld",(long)d] : [NSString stringWithFormat:@"%ld",(long)d];
    NSString *minite = m < 9 ? [NSString stringWithFormat:@"0%ld",(long)m] : [NSString stringWithFormat:@"%ld",(long)m];
    NSString *second = s < 9 ? [NSString stringWithFormat:@"0%ld",(long)s] : [NSString stringWithFormat:@"%ld",(long)s];
    if ([day integerValue]>0) {
        return [NSString stringWithFormat:@"%@:%@:%@:%@",day,hour,minite,second];
    }
    return [NSString stringWithFormat:@"%@:%@:%@",hour,minite,second];
}

-(CGFloat)tsShowWindowsWidth{
    
    if (_tsShowWindowsWidth == 0) {
        _tsShowWindowsWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return _tsShowWindowsWidth;
}

- (CGFloat)tsShowWindowsHeight{
    
    if (_tsShowWindowsHeight == 0) {
        _tsShowWindowsHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return _tsShowWindowsHeight;
}

- (CGFloat)tsMainScreenWidth{
    
    if (_tsMainScreenWidth == 0) {
        _tsMainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return _tsMainScreenWidth;
}


- (CGFloat)tsMainScreenHeight{
    
    if (_tsMainScreenHeight == 0) {
        _tsMainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return _tsMainScreenHeight;
}

+ (NSString *)getLocalTime {
    //获取本地时间
    
    NSDate *date = [NSDate date];                            //实际上获得的是：UTC时间，协调世界时，亚州的时间与UTC的时差均为+8
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];                  //zone为当前时区信息  在我的程序中打印的是@"Asia/Shanghai"
    
    NSInteger interval = [zone secondsFromGMTForDate: date];      //28800 //所在地区时间与协调世界时差距
    
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];  //加上时差，得到本地时间
    
    //get seconds since 1970
    
    NSTimeInterval intervalWith1970 = [localeDate timeIntervalSince1970];     //本地时间与1970年的时间差（秒数）
    
    int daySeconds = 24 * 60 * 60;                                            //每天秒数
    
    NSInteger allDays = intervalWith1970 / daySeconds;                        //这一步是为了舍去后面的时分秒
    
    localeDate = [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";   //创建日期格式（年-月-日）
    
    NSString *temp = [fmt stringFromDate:localeDate];       //得到当地当时的时间（年月日）
    
    return temp;
}

//时间戳转换成字符串
+ (NSString *)formateTime:(NSString *)time
{
    if (!time) {
        return @"";
    }
    NSTimeInterval secondsPer = 24*60*60;
    NSDate *today = [[NSDate alloc]init];
    NSDate *yesterday = [today dateByAddingTimeInterval:-secondsPer];
    NSString *yesterdayString = [[yesterday description]substringToIndex:10];
    NSString *todayString = [[today description]substringToIndex:10];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSString *dateString = [[date description]substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSString *theDay = [dateFormatter stringFromDate:nowDate];//日期的年月日
    
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    NSString *nowYearStr = [currentDay substringToIndex:4];
    NSString *yearStr = [theDay substringToIndex:4];
    if ([dateString isEqualToString:todayString]) {
        return [NSString stringWithFormat:@"%@",[theDay substringFromIndex:11]];
    }else if ([dateString isEqualToString:yesterdayString]){
        return [NSString stringWithFormat:@"昨天 %@",[theDay substringFromIndex:11]];
    }else{
        if ([yearStr isEqualToString:nowYearStr]) {
            return [theDay substringFromIndex:5];
        }
        return [theDay substringToIndex:10];
    }
}

+ (NSString *)timeForHHmm:(NSString *)time {
    if (!time) {
        return @"";
    }
    NSTimeInterval secondsPer = 24*60*60;
    NSDate *today = [[NSDate alloc]init];
    NSDate *yesterday = [today dateByAddingTimeInterval:-secondsPer];
    NSString *yesterdayString = [[yesterday description]substringToIndex:10];
    NSString *todayString = [[today description]substringToIndex:10];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSString *dateString = [[date description]substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSString *theDay = [dateFormatter stringFromDate:nowDate];//日期的年月日
    return theDay;
}

+ (NSString *)timeForYYYYMMDD:(NSString *)time {
    if (!time) {
        return @"";
    }
    NSTimeInterval secondsPer = 24*60*60;
    NSDate *today = [[NSDate alloc]init];
    NSDate *yesterday = [today dateByAddingTimeInterval:-secondsPer];
    NSString *yesterdayString = [[yesterday description]substringToIndex:10];
    NSString *todayString = [[today description]substringToIndex:10];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSString *dateString = [[date description]substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSString *theDay = [dateFormatter stringFromDate:nowDate];//日期的年月日
    
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    NSString *nowYearStr = [currentDay substringToIndex:4];
    NSString *yearStr = [theDay substringToIndex:4];
    if ([yearStr isEqualToString:nowYearStr]) {
        return [theDay substringFromIndex:5];
    }
    return [theDay substringToIndex:10];
}

+ (NSString *)currentdateInterval {
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970])];
    return timeSp;
}

+ (NSString *)getRandomString {
    //3.随机字符串kRandomLength位
    static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: kRandomLength];
    for (int i = 0; i < kRandomLength; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    return randomString;
}

+ (NSString *)sortedDictionary:(NSDictionary *)dict {
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id
                                                                                             _Nonnull obj2) {
        /**
         In the compare: methods, the range argument specifies the
         subrange, rather than the whole, of the receiver to use in the
         comparison. The range is not applied to the search string.  For
         example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
         compares "A" to "ABC", not "A" to "A", and will return
         NSOrderedAscending. It is an error to specify a range that is
         outside of the receiver's bounds, and an exception may be raised.
         
         - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    //排序好的字典
    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
    NSString *tempStr = @"";
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        //格式化一下 防止有些value不是string
        NSString *valueString = [NSString stringWithFormat:@"%@",[dict objectForKey:sortsing]];
        if(valueString.length>0){
            [valueArray addObject:valueString];
            tempStr=[NSString stringWithFormat:@"%@%@=%@&",tempStr,sortsing,valueString];
        }
    }
    //去除最后一个&符号
    if(tempStr.length>0){
        tempStr=[tempStr substringToIndex:([tempStr length]-1)];
    }
    //排序好的对应值
    //  NSLog(@"valueArray:%@",valueArray);
    //最终参数
    NSLog(@"tempStr:%@",tempStr);
    //md5加密
    // NSLog(@"tempStr:%@",[self getmd5WithString:tempStr]);
    return tempStr;
}


//字符串MD5加密
+ (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02X", digist[i]];
    }
   // return [outPutStr lowercaseString];
    return outPutStr;
}

+ (BOOL)validatePassWord:(NSString *)pw {
    NSString *emailRegex = @"^[^ \u4e00-\u9fa5]{6,20}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:pw];
}




















@end
