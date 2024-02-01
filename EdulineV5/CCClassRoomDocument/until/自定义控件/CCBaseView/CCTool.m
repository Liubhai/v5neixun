//
//  CCTool.m
//  CCClassRoom
//
//  Created by cc on 18/6/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCTool.h"
#import "HDSTool.h"
#import "AppDelegate.h"
#import "HDAlertView.h"
#import <CCFuncTool/CCFuncTool.h>

//网络抖动
#define CCNET_ERROR_STABLE           HDClassLocalizeString(@"当前网络有抖动！") //intel返回的异常
#define CCKEY_INTEL_ERROR            @"com.intel.webrtc"
#define CCKEY_INTEL_REPLACE_MSG      CCNET_ERROR_STABLE

@implementation CCTool

static CCTool *_tool = nil;
+ (instancetype)sharedTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[CCTool alloc]init];
    });
    return _tool;
}

+ (BOOL)controllerIsShow:(UIViewController *)controller
{
    CCTool *tool = [CCTool sharedTool];
    UIViewController *nowController = tool.navController.topViewController;
    if ([nowController isKindOfClass:[controller class]])
    {
        return YES;
    }
    return NO;
}

//创建label
+ (UILabel *)createLabelText:(NSString *)text
{
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.text = text;
    label.font = [UIFont systemFontOfSize:FontSizeClass_15];
    return label;
}

+ (UIButton *)createButtonText:(NSString *)text tag:(int)tag
{
    UIButton *btn = [UIButton new];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (tag != -1) {
        btn.tag = tag;
    }
    if (tag == -2) {
        UIImage *imageNormal = [self createImageWithColor:[UIColor lightGrayColor]];
        UIImage *imageSelect = [self createImageWithColor:[UIColor orangeColor]];
        
        [btn setBackgroundImage:imageNormal forState:UIControlStateNormal];
        [btn setBackgroundImage:imageSelect forState:UIControlStateSelected];
    }
    
    [btn setTitle:text forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)createButton:(NSString *)title target:(id)target action:(SEL)selector
{
    if (!title)
    {
        title = @"title";
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = CCGetRealFromPt(30);
    btn.layer.masksToBounds = YES;
    btn.clipsToBounds = YES;
    //    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"" forState:UIControlStateNormal];
    //    [btn setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    //    [btn setBackgroundImage:[UIImage imageNamed:@"start_touch"] forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 10, 10);  //图片尺寸
    
    UIGraphicsBeginImageContext(rect.size); //填充画笔
    
    CGContextRef context = UIGraphicsGetCurrentContext(); //根据所传颜色绘制
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect); //联系显示区域
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext(); // 得到图片信息
    
    UIGraphicsEndImageContext(); //消除画笔
    
    return image;
}

+ (NSString *)toolErrorMessage:(NSError *)error
{
    NSString *title = @"";
    if ([error.domain containsString:@"ErrorDomain"])
    {
        title = [NSString stringWithFormat:@"%@",CCNET_ERROR_STABLE];
    }
    else
    {
        title = error.domain;
    }
    if (title.length == 0)
    {
        title = [NSString stringWithFormat:@"%@_2",CCNET_ERROR_STABLE];
        title = CCNET_ERROR_STABLE;
    }
    if ([title isEqualToString:@"com.intel.webrtc"])
    {
        title = [NSString stringWithFormat:@"%@_3",CCNET_ERROR_STABLE];
        title = CCNET_ERROR_STABLE;
    }
    if ([title containsString:@"com.alamofire"]) {
        title = HDClassLocalizeString(@"当前网络不稳定，请重试！") ;
    }
    return title;
}

+ (NSInteger)roleFromRoleString:(NSString *)str
{
    if ([str isEqualToString:KKEY_CCRole_Teacher]) {
        return CCRole_Teacher;
    }
    else if ([str isEqualToString:KKEY_CCRole_Student]) {
        return CCRole_Student;
    }
    else if ([str isEqualToString:KKEY_CCRole_Inspector]) {
        return CCRole_Inspector;
    }
    else if([str isEqualToString:KKEY_CCRole_Assistant]) {
        return CCRole_Assistant;
    }
    else if ([str isEqualToString:KKEY_HDRole_au_low]) {
        return CCRole_au_low;
    }

    return -1;
}

+ (void)showMessage:(NSString *)msg
{
    [CCTool showTitle:@"" message:msg sure:nil];
}

+ (void)showMessageError:(NSError *)error
{
    NSString *msg = [CCTool toolErrorMessage:error];
    [CCTool  showMessage:msg];
}

+ (void)showTitle:(NSString *)title message:(NSString *)msg
{
    [CCTool showTitle:title message:msg sure:nil];
}
+ (void)showTitle:(NSString *)title message:(NSString *)msg sure:(NSString *)sure
{
    title = title ? title : HDClassLocalizeString(@"提示") ;
    msg = msg ? msg : @"";
    sure = sure ? sure : HDClassLocalizeString(@"知道了") ;
    /*
    if ([msg isEqualToString:CCKEY_INTEL_ERROR])
    {
        msg = CCNET_ERROR_STABLE;
    }*/
    [HDSTool showAlertTitle:title msg:msg isOneBtn:NO];
}

+ (void)showTitle:(NSString *)title message:(NSString *)msg isOne:(BOOL)isOne
{
    title = title ? title : HDClassLocalizeString(@"提示") ;
    msg = msg ? msg : @"";
    [HDSTool showAlertTitle:title msg:msg isOneBtn:isOne];
}

#pragma mark -- 助教相关
//房间是否存在助教
+ (BOOL)tool_roomHasAssistant
{
    CCRoom *room = [[CCStreamerBasic sharedStreamer]getRoomInfo];
    return room.room_assist_on;
}
+ (BOOL)tool_roomTeacherIsPublishing
{
    NSArray *userList = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_userList;
    for (CCUser *user in userList)
    {
        if (user.user_role == CCRole_Teacher)
        {
            if (user.user_status == 3)
            {
                return YES;
            }
        }
    }
    return NO;
}
+ (BOOL)tool_roomCopyTIsPublishing
{
    NSArray *userList = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_userList;
    for (CCUser *user in userList)
    {
        if (user.user_role == CCRole_Assistant)
        {
            if (user.user_status == 3)
            {
                return YES;
            }
        }
    }
    return NO;
}

+ (CCRoom *)tool_room
{
    return [[CCStreamerBasic sharedStreamer]getRoomInfo];
}

+ (CCUser *)tool_room_user_userid:(NSString *)uid
{
    NSArray *userList = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_userList;
    for (CCUser *user in userList)
    {
        if ([user.user_id isEqualToString:uid])
        {
            return user;
        }
    }
    return nil;
}
+ (CCUser *)tool_room_user_role:(CCRole)roleType
{
    NSArray *userList = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_userList;
    for (CCUser *user in userList)
    {
        if (user.user_role == roleType)
        {
            return user;
        }
    }
    return nil;
}


+ (CGFloat)tool_MainWindowSafeArea_Top {
    CGFloat topOff = CCGetRealFromPt(60.0);
    return topOff > 25.0 ? 25.0 :topOff;
    if (@available(iOS 11.0, *)) {
        return [(UIWindow *)[UIApplication sharedApplication].delegate window].safeAreaInsets.top;
    } else {
        return 60.0;
    }
}

+ (CGFloat)tool_MainWindowIphoneXSafeArea_Top {
    
    return Height_StatusBar;
    
}

+ (CGFloat)tool_MainWindowSafeArea_Bottom {
    if (@available(iOS 11.0, *)) {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdelegate.shouldNeedLandscape) {
            return [(UIWindow *)[UIApplication sharedApplication].delegate window].safeAreaInsets.left;
        } else {
            return [(UIWindow *)[UIApplication sharedApplication].delegate window].safeAreaInsets.bottom;
        }
    } else {
        return 0;
    }
}

+ (CGFloat)tool_MainWindowSafeArea_Left {
    if (@available(iOS 11.0, *)) {
        return [(UIWindow *)[UIApplication sharedApplication].delegate window].safeAreaInsets.left;
    } else {
        return 0;
    }
}

+ (CGFloat)tool_MainWindowSafeArea_Right {
    if (@available(iOS 11.0, *)) {
        return [(UIWindow *)[UIApplication sharedApplication].delegate window].safeAreaInsets.right;
    } else {
        return 0;
    }
}

/**
 *竖屏  top : 44.000000
 //    left : 0.000000
 //    bottom : 34.000000
 //    right : 0.000000
 *
 *横屏  top : 0.000000
 //    left : 44.000000
 //    bottom : 21.000000
 //    right : 44.000000
 */

+ (UIEdgeInsets)tool_MainWindowSafeArea {
    if (@available(iOS 11.0, *)) {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdelegate.shouldNeedLandscape) {
            return UIEdgeInsetsMake(0, [CCTool tool_MainWindowSafeArea_Left], 0, [CCTool tool_MainWindowSafeArea_Right]);
        } else {
            UIEdgeInsets insets = [(UIWindow *)[UIApplication sharedApplication].delegate window].safeAreaInsets;
            NSLog(@"xxx---%f--%f--%f--%f--",insets.top,insets.left,insets.right,insets.bottom);
            if (insets.top > 20 || insets.bottom > 0)
            { //正常机型
                return insets;
            }
            //刘海机型
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


/** 获取对应角色的auth类型 */
#define KEY_AUTH_TYPE   @"authtype"
+ (NSString *)authTypeKeyForRole:(NSString *)role
{
    if (!role || role.length == 0)
    {
        return KEY_AUTH_TYPE;
    }
    if ([role isEqualToString:KKEY_CCRole_Teacher])
    {
        return [NSString stringWithFormat:@"%@_%@",@"publisher",KEY_AUTH_TYPE];
    }
    NSString *authKey = [NSString stringWithFormat:@"%@_%@",role,KEY_AUTH_TYPE];
    return authKey;
}

//时间转字符串
+ (NSString *)timerStringForTime:(NSTimeInterval)time
{
    if (time < 0)
    {
        return @"00:00";
    }
    NSInteger seconds = time/1000.f;
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}

+ (CGSize)getTitleSizeByFont:(NSString *)str font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(20000.0f, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

+ (CGSize)getTitleSizeByFont:(NSString *)str width:(CGFloat)width font:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];;
    [text addAttributes:attributes range:NSMakeRange(0, text.length)];
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return size;
}


@end
