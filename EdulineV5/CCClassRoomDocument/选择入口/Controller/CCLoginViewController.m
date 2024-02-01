//
//  LiveViewController.m
//  NewCCDemo
//
//  Created by cc on 2016/11/23.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "CCLoginViewController.h"
#import "TextFieldUserInfo.h"
#import "CCPlayViewController.h"
#import "CCPushViewController.h"
#import "CCTeachCopyViewController.h"
#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import "CCServerListViewController.h"
#import "STDPingServices.h"
#import "LoadingView.h"
#import "AppDelegate.h"
#import <HSRoomUI/HSRoomUI.h>
//存储用户信息
#define KKEY_User_name  @"kkuserName"
#define KKEY_User_pwd   @"kkuserpwd"

@implementation CCServerModel

@end

#define InfomationTop  74

@interface CCLoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView          *iconImageView;
@property(nonatomic,strong)UILabel              *roomNameLabel;
@property(nonatomic,strong)UILabel              *descLabel;
@property(nonatomic,strong)UILabel              *informationLabel;
@property(nonatomic,strong)TextFieldUserInfo    *textFieldUserName;
@property(nonatomic,strong)TextFieldUserInfo    *textFieldUserPassword;
@property(nonatomic,strong)UIButton             *loginBtn;
@property(nonatomic,strong)LoadingView          *loadingView;
@property(nonatomic,strong)NSArray       *serverList;
@property(nonatomic,strong)id loginInfo;
@property(nonatomic,copy)NSString *sessionID;
@property(nonatomic, strong) CCPlayViewController *playVC;
@property(nonatomic, strong) CCPushViewController *pushVC;
@property(nonatomic, strong) CCTeachCopyViewController *teacherCopyVC;

@property(nonatomic,strong)HSLiveViewController *liveVC;

@end

@implementation CCLoginViewController
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = HDClassLocalizeString(@"登录") ;
    [self setupUI];
    [self addObserver];
}

-(void)landscapeRight:(BOOL)isLandscapeRight {
    BOOL willland = isLandscapeRight;
    UIInterfaceOrientation org = willland ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.shouldNeedLandscape = willland;
    
    int por = (int)org;
    NSNumber *orientationTarget = [NSNumber numberWithInt:por];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _playVC = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self landscapeRight:NO];

    //填充用户名、密码
    self.textFieldUserName.text = GetFromUserDefaults(SET_USER_NAME);
    self.textFieldUserPassword.text = GetFromUserDefaults(SET_USER_PWD);
    [self.videoAndAudioNoti removeAllObjects];
    self.navigationController.navigationBarHidden = NO;
    if (self.needPassword)
    {
        if(StrNotEmpty(_textFieldUserName.text) && StrNotEmpty(_textFieldUserPassword.text))
        {
            self.loginBtn.enabled = YES;
            [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,1) CGColor]];
        } else {
            self.loginBtn.enabled = NO;
            [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,0.6) CGColor]];
        }
    }
    else
    {
        if(StrNotEmpty(_textFieldUserName.text))
        {
            self.loginBtn.enabled = YES;
            [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,1) CGColor]];
        } else {
            self.loginBtn.enabled = NO;
            [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,0.6) CGColor]];
        }
    }
    NSString *domian_name = GetFromUserDefaults(SERVER_DOMAIN_NAME);
    if (domian_name.length == 0)
    {
        domian_name = HDClassLocalizeString(@"线路切换") ;
        [self getServerData:self.userID];
    } else if ([domian_name isEqualToString:@"北京"]) {
        domian_name = HDClassLocalizeString(@"北京") ;
    }

    [self setRightBarItem:domian_name];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RESOLUTION];
}

-(void)setupUI {
    [CCTool sharedTool].navController = self.navigationController;
    [self.view addSubview:self.informationLabel];
    
    WS(ws);
    [_informationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));
        make.top.mas_equalTo(ws.view).offset(InfomationTop);;
        make.width.mas_equalTo(ws.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(CCGetRealFromPt(24));
    }];
    
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.roomNameLabel];
    [self.view addSubview:self.descLabel];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.view).offset(0.f);
        make.top.mas_equalTo(ws.informationLabel.mas_bottom).offset(0.f);
    }];
    [self.roomNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(10.f);
        make.right.mas_equalTo(ws.view).offset(-10.f);
        make.top.mas_equalTo(ws.iconImageView.mas_bottom).offset(10.f);
    }];
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(10.f);
        make.right.mas_equalTo(ws.view).offset(-10.f);
        make.top.mas_equalTo(ws.roomNameLabel.mas_bottom).offset(10.f);
    }];
    
    [self.view addSubview:self.textFieldUserName];
    [self.textFieldUserName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.descLabel.mas_bottom).with.offset(CCGetRealFromPt(22));
        make.height.mas_equalTo(CCGetRealFromPt(92));
    }];
    
    UIView *line1 = [UIView new];
    [self.view addSubview:line1];
    [line1 setBackgroundColor:CCRGBColor(238,238,238)];
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.view);
        make.top.mas_equalTo(ws.textFieldUserName.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    if (self.needPassword)
    {
        [self.view addSubview:self.textFieldUserPassword];
        [self.textFieldUserPassword mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(ws.textFieldUserName);
            make.top.mas_equalTo(ws.textFieldUserName.mas_bottom);
            make.height.mas_equalTo(ws.textFieldUserName);
        }];
        
        UIView *line = [UIView new];
        [self.view addSubview:line];
        [line setBackgroundColor:CCRGBColor(238,238,238)];
        [line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.top.mas_equalTo(ws.textFieldUserPassword.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        [self.view addSubview:self.loginBtn];
        [_loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(65));
            make.right.mas_equalTo(ws.view).with.offset(-CCGetRealFromPt(65));
            make.top.mas_equalTo(line.mas_bottom).with.offset(CCGetRealFromPt(70));
            make.height.mas_equalTo(CCGetRealFromPt(86));
        }];
    }
    else
    {
        UIView *line = [UIView new];
        [self.view addSubview:line];
        [line setBackgroundColor:CCRGBColor(238,238,238)];
        [line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(ws.view);
            make.top.mas_equalTo(ws.textFieldUserName.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        [self.view addSubview:self.loginBtn];
        [_loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(65));
            make.right.mas_equalTo(ws.view).with.offset(-CCGetRealFromPt(65));
            make.top.mas_equalTo(line.mas_bottom).with.offset(CCGetRealFromPt(70));
            make.height.mas_equalTo(CCGetRealFromPt(86));
        }];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:CONTROLLER_INDEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)receiveSocketEvent:(NSNotification *)noti
{
    CCSocketEvent event = (CCSocketEvent)[noti.userInfo[@"event"] integerValue];
    if (event == CCSocketEvent_SocketConnected)
    {
//        if (self.navigationController.visibleViewController == self)
//        {
//            __weak typeof(self) weakSelf = self;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf streamLoginSuccess:weakSelf.loginInfo];
//            });
//        }
    }
    else if (event == CCSocketEvent_ReciveInterCutAudioOrVideo)
    {
        if (!self.videoAndAudioNoti)
        {
            self.videoAndAudioNoti = [NSMutableArray array];
        }
        [self.videoAndAudioNoti addObject:noti];
    }
    else if (event == CCSocketEvent_SocketReconnectedFailed)
    {
        [self streamLoginFail:[NSError errorWithDomain:HDClassLocalizeString(@"消息系统连接失败，请稍候重试") code:1000 userInfo:nil]];
    }
}

- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//监听touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self keyboardHide];
}

-(void)loginAction
{
    if (self.textFieldUserName.text.length > 20) {
        [CCTool showMessage:HDClassLocalizeString(@"名称不能差超过20字符") ];
        return;
    }
    self.loginBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loginBtn.userInteractionEnabled = YES;
    });
    [self.view endEditing:YES];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:NONETWORK] isEqualToString:@"noNetwork"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CCTool showMessage:HDClassLocalizeString(@"网络已断开，请检查网络设置！") ];
        });
        return;
    }
    [self keyboardHide];
    _loadingView = [[LoadingView alloc] initWithLabel:HDClassLocalizeString(@"正在登录...") ];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_loadingView];
    [_loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    SaveToUserDefaults(SET_USER_NAME, self.textFieldUserName.text);
    SaveToUserDefaults(SET_USER_PWD, self.textFieldUserPassword.text);
    SaveToUserDefaults(LIVE_USERID, self.userID);
    SaveToUserDefaults(LIVE_ROOMID, self.roomID);
    
    NSString *isp = GetFromUserDefaults(SERVER_AREA_NAME);
    
    NSString *uname = self.textFieldUserName.text;
    NSString *upwd = (self.needPassword ? self.textFieldUserPassword.text : @"");
    
    __weak typeof(self) weakSelf = self;
    __block NSString *sessionStr = nil;
    [[CCStreamerBasic sharedStreamer] authWithRoomId:self.roomID accountId:self.userID role:self.role password:upwd nickName:uname completion:^(BOOL result, NSError *error, id info) {
        if (!result)
        {
            [weakSelf.loadingView removeFromSuperview];
            [CCTool showMessageError:error];
            return;
        }
        NSDictionary *dic = (NSDictionary *)info;
        NSString *res = dic[@"result"];
        NSString *errmsg = @"";
        if ([res isEqualToString:@"FAIL"])
        {
            [weakSelf.loadingView removeFromSuperview];
            errmsg  = dic[@"errorMsg"];
            [CCTool showMessage:errmsg];
            return ;
        }
        NSDictionary *dataDic = dic[@"data"];
        sessionStr = [dataDic objectForKey:@"sessionid"];
        SaveToUserDefaults(Login_UID, [dataDic objectForKey:@"userid"]);
        {
            weakSelf.sessionID = sessionStr;
            CCEncodeConfig *config = [[CCEncodeConfig alloc] init];
            config.reslution = CCResolution_240;
            [weakSelf initVC];
            
            NSString *accountid = self.userID;
            NSString *sessionid = self.sessionID;
            [[CCStreamerBasic sharedStreamer] joinWithAccountID:accountid sessionID:sessionid roomId:weakSelf.roomID config:config areaCode:isp events:@[] updateRtmpLayout:NO completion:^(BOOL result, NSError *error, id info) {
                BOOL modeGravity = [HDSDocManager sharedDoc].isPreviewGravityFollow;
                [[CCStreamerBasic sharedStreamer]setPreviewGravityFollow:modeGravity];
                
                HDSTool *tool = [HDSTool sharedTool];
                if (tool.roomMode != 32) {
                    [tool updateLocalPushResolution];
                    [tool resetSDKPushResolution];
                }
                
                [weakSelf.loadingView removeFromSuperview];
                if (result) {
                    weakSelf.loginInfo = info;
                    NSLog(HDClassLocalizeString(@"登录获取的info：%@") ,info);
                    main_async_safe(^{
                        if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {
                            
                            [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                        }
                    });
                }else{
                    if (error.code == 22002) {
                        
                        int version_check = [info[@"version_check"] intValue];
                        if (version_check == 1) {
                            NSString *update_desc = [NSString stringWithFormat:HDClassLocalizeString(@"当前版本太老了，请更新至最新版本后再进入教室！\n温馨提示：如若不更新，部分功能将无法正常使用，请尽快升级！\n\n%@") ,info[@"update_desc"]];
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:HDClassLocalizeString(@"版本更新") message:update_desc preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *action = [UIAlertAction actionWithTitle:HDClassLocalizeString(@"立即更新") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1239642978"]];
                            }];
                            
                            [alert addAction:action];
                            
                            [weakSelf presentViewController:alert animated:YES completion:nil];
                            return;
                        }
                    }
                    [self joinRoomRetry:error];
                }
            }];
        }
    }];
}
#pragma mark -- 重新加入直播间
- (void)joinRoomRetry:(NSError *)error
{
    NSString *errMessage = error.domain;
    if (!errMessage) {
        errMessage = HDClassLocalizeString(@"网络不稳定,请重试!") ;
    }
    NSInteger errCode = error.code;
    
    NSString *message = [NSString stringWithFormat:@"%@<%d>",errMessage,errCode];
    [HDSTool showAlertTitle:@"" msg:message completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            [self loginAction];
        }
    }];
}

///初始化控制器
-(void)initVC {
    HDSTool *tool = [HDSTool sharedTool];
    if (tool.roomMode == 32) {
        self.liveVC = [HSLiveViewController sharedLiveRoom];
        if (tool.roomSubMode == 1) {
//            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_1V1_16_9];
            [self.liveVC setLiveRoomType:HSRoomType_1V1_16_9];
        }else if (tool.roomSubMode == 2) {
//            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_1V1_4_3];
            [self.liveVC setLiveRoomType:HSRoomType_1V1_4_3];
        } else {
//            self.liveVC = [HSLiveViewController createLiveController:HSRoomType_saas];
            [self.liveVC setLiveRoomType:HSRoomType_saas];
        }
//        self.liveVC.allowTakePhotoInLibrary = YES;
//
//        HSRoomConfig *roomInfo = [[HSRoomConfig alloc]init];
//        roomInfo.bleLicense = @"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxsaWNlbnNlIHZlcnNpb249InYxLjAiIGlkPSI2MDU5YTE3Y2I1YmE3ZDhmMjExZmUyODAiPgogICAgPG93bmVyPuWIm+ebm+inhuiBlOaVsOeggeenkeaKgO+8iOWMl+S6rO+8ieaciemZkOWFrOWPuDwvb3duZXI+CiAgICA8dXNlcj5jaGVuZnk8L3VzZXI+CiAgICA8ZW1haWw+Y2hlbmZ5QGJva2VjYy5jb208L2VtYWlsPgogICAgPGJ1bmRsZUlkPmNvbS5jbGFzcy5yb29tPC9idW5kbGVJZD4KICAgIDxhcHBOYW1lPmNjPC9hcHBOYW1lPgogICAgPGRyaXZlclR5cGVzPgogICAgICAgIDxkcml2ZXJUeXBlPklPUzwvZHJpdmVyVHlwZT4KICAgIDwvZHJpdmVyVHlwZXM+CiAgICA8cGVuVHlwZXM+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iQURQXzEwMSIgSUQ9IjUiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQURQXzYwMSIgSUQ9IjYiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQVBEXzYxMSIgSUQ9IjciIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iVEVfMzAxIiBJRD0iOCIgLz4KICAgICAgICA8cGVuVHlwZSBwZW5OYW1lPSJURV8zMDIiIElEPSI5IiAvPgogICAgICAgIDxwZW5UeXBlIHBlbk5hbWU9IlREXzEwMiIgSUQ9IjEwIiAvPgogICAgPC9wZW5UeXBlcz4KICAgIDxsaWNlbnNlZERhdGU+MTk3MDAxMDE8L2xpY2Vuc2VkRGF0ZT4KICAgIDxleHBpcmVkRGF0ZT45OTk5MTIzMTwvZXhwaXJlZERhdGU+CiAgICA8YXV0aElkPjYwNTk5YzQwYjViYTdkOGYyMTFmZTI3ZjwvYXV0aElkPgogICAgPHNlY3JldD5jU0VoY3kxQU1pTTRmaVFvY0g1ZU1USjJlVzEwWkNseUl6RnlJemN4TWw0PTwvc2VjcmV0PgogICAgPHBhZ2VBZGRyZXNzIHN0YXJ0PSI3MC4wLjE3LjAiIGVuZD0iNzAuMC4xNy4xOSIgcGFnZUNvdW50PSIyMCIgLz4KICAgIDxhdXRob3JpemVyIGNvbXBhbnk9IuWMl+S6rOaLk+aAneW+t+enkeaKgOaciemZkOWFrOWPuCIgd2Vic2l0ZT0iaHR0cDovL3d3dy50c3R1ZHkuY29tLmNuIiAvPgo8L2xpY2Vuc2U+Cg==";
//        roomInfo.bleSignature = @"57E8A02D4FB158106F27FD1ECE5063753FAC2E096E49CB8A53B48B58DDA03A6CC9901865D0BC6DB313AE3AE8CEEFDCC426313ED5FDE8904DB5BACA83658A3F6AC6B360BF676D1EE7C47E9D6471540D8ECF4948680D30C54DC9766960516A7DE2F64594A25A0CF6C74A4872C765E7FC57ED076B8376EAE16682C5A94A432612EA";
//        [ self.liveVC setLiveRoomConfig:roomInfo];

        return;
    }
    if (self.role == CCRole_Teacher)
    {
        if (self.pushVC) {
            [self.pushVC removeObserver];
        }
        self.pushVC = [[CCPushViewController alloc] initWithLandspace:self.isLandSpace];
    }
    else if (self.role == CCRole_Student)
    {
        if (self.playVC) {
            [self.playVC removeObserver];
        }
        self.playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.roleType = CCRole_Student;
    }
    else if (self.role == CCRole_Inspector)
    {
        if (self.playVC) {
            [self.playVC removeObserver];
        }
        self.playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.roleType = CCRole_Inspector;
    }
    else if (self.role == CCRole_Assistant)
    {
        if (self.teacherCopyVC) {
            [self.teacherCopyVC removeObserver];
        }
        self.teacherCopyVC = [[CCTeachCopyViewController alloc]initWithLandspace:self.isLandSpace];
    }
}
#pragma mark -
- (void)streamLoginSuccess:(NSDictionary *)info {
    HDSTool *tool = [HDSTool sharedTool];
    if (tool.roomMode == 32) {
        [self landscapeRight:YES];
        
        HSRoomConfig *roomInfo = [[HSRoomConfig alloc]init];
        roomInfo.bleLicense = @"PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxsaWNlbnNlIHZlcnNpb249InYxLjAiIGlkPSI2MDU5YTE3Y2I1YmE3ZDhmMjExZmUyODAiPgogICAgPG93bmVyPuWIm+ebm+inhuiBlOaVsOeggeenkeaKgO+8iOWMl+S6rO+8ieaciemZkOWFrOWPuDwvb3duZXI+CiAgICA8dXNlcj5jaGVuZnk8L3VzZXI+CiAgICA8ZW1haWw+Y2hlbmZ5QGJva2VjYy5jb208L2VtYWlsPgogICAgPGJ1bmRsZUlkPmNvbS5jbGFzcy5yb29tPC9idW5kbGVJZD4KICAgIDxhcHBOYW1lPmNjPC9hcHBOYW1lPgogICAgPGRyaXZlclR5cGVzPgogICAgICAgIDxkcml2ZXJUeXBlPklPUzwvZHJpdmVyVHlwZT4KICAgIDwvZHJpdmVyVHlwZXM+CiAgICA8cGVuVHlwZXM+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iQURQXzEwMSIgSUQ9IjUiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQURQXzYwMSIgSUQ9IjYiIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iRU5fQVBEXzYxMSIgSUQ9IjciIC8+CiAgICAgICAgPHBlblR5cGUgcGVuTmFtZT0iVEVfMzAxIiBJRD0iOCIgLz4KICAgICAgICA8cGVuVHlwZSBwZW5OYW1lPSJURV8zMDIiIElEPSI5IiAvPgogICAgICAgIDxwZW5UeXBlIHBlbk5hbWU9IlREXzEwMiIgSUQ9IjEwIiAvPgogICAgPC9wZW5UeXBlcz4KICAgIDxsaWNlbnNlZERhdGU+MTk3MDAxMDE8L2xpY2Vuc2VkRGF0ZT4KICAgIDxleHBpcmVkRGF0ZT45OTk5MTIzMTwvZXhwaXJlZERhdGU+CiAgICA8YXV0aElkPjYwNTk5YzQwYjViYTdkOGYyMTFmZTI3ZjwvYXV0aElkPgogICAgPHNlY3JldD5jU0VoY3kxQU1pTTRmaVFvY0g1ZU1USjJlVzEwWkNseUl6RnlJemN4TWw0PTwvc2VjcmV0PgogICAgPHBhZ2VBZGRyZXNzIHN0YXJ0PSI3MC4wLjE3LjAiIGVuZD0iNzAuMC4xNy4xOSIgcGFnZUNvdW50PSIyMCIgLz4KICAgIDxhdXRob3JpemVyIGNvbXBhbnk9IuWMl+S6rOaLk+aAneW+t+enkeaKgOaciemZkOWFrOWPuCIgd2Vic2l0ZT0iaHR0cDovL3d3dy50c3R1ZHkuY29tLmNuIiAvPgo8L2xpY2Vuc2U+Cg==";
        roomInfo.bleSignature = @"57E8A02D4FB158106F27FD1ECE5063753FAC2E096E49CB8A53B48B58DDA03A6CC9901865D0BC6DB313AE3AE8CEEFDCC426313ED5FDE8904DB5BACA83658A3F6AC6B360BF676D1EE7C47E9D6471540D8ECF4948680D30C54DC9766960516A7DE2F64594A25A0CF6C74A4872C765E7FC57ED076B8376EAE16682C5A94A432612EA";
        roomInfo.version_info = info;
        roomInfo.allowTakePhotoInLibrary = YES;
        roomInfo.openUrl = @"itms-apps://itunes.apple.com/app/id1239642978";
        [self.liveVC joinLiveRoom:roomInfo withPush:self.navigationController animated:YES];
        
//        self.liveVC.version_info = info;
//        self.liveVC.openUrl = @"itms-apps://itunes.apple.com/app/id1239642978";
//        if ([[self.navigationController.viewControllers lastObject] isKindOfClass:self.class]) {
//            [self.navigationController pushViewController:self.liveVC animated:YES];
//        }
        return;
    }

    //存储用户名、密码
    NSString *userName = self.textFieldUserName.text;
    NSString *userpwd = self.textFieldUserPassword.text;
    SaveToUserDefaults(KKEY_User_name, userName);
    SaveToUserDefaults(KKEY_User_pwd, userpwd);
    NSString *userID =  self.userID;
    SaveToUserDefaults(LIVE_USERNAME, userName);
    //    SaveToUserDefaults(LIVE_ROOMNAME, name);
    //    SaveToUserDefaults(LIVE_ROOMDESC, desc);
    [_loadingView removeFromSuperview];
    if (self.role == CCRole_Teacher || self.role == CCRole_Assistant)
    {
        [CCDrawMenuView teacherResetDefaultColor];
    }
    else
    {
        [CCDrawMenuView resetDefaultColor];
    }
    if (self.role == CCRole_Teacher)
    {
        //        CCPushViewController *pushVC = [[CCPushViewController alloc] initWithLandspace:self.isLandSpace];
        self.pushVC.sessionId =  self.sessionID;
        self.pushVC.viewerId = userID;
        self.pushVC.isLandSpace = self.isLandSpace;
        self.pushVC.roomID = self.roomID;
        self.pushVC.videoOriMode = self.isLandSpace ? CCVideoLandscape : CCVideoPortrait;
        self.pushVC.videoOriMode = CCVideoChangeByInterface;
        if ([self isControllerPresented:[CCPushViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:self.pushVC animated:YES];
    }
    else if (self.role == CCRole_Student)
    {
        //        CCPlayViewController *playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        //        self.playVC.loginInfo = infoDic;
        self.playVC.sessionId =  self.sessionID;
        self.playVC.viewerId = userID;
        self.playVC.videoAndAudioNoti = self.videoAndAudioNoti;
        self.videoAndAudioNoti = nil;
        self.playVC.isLandSpace = self.isLandSpace;
        
        self.playVC.isNeedPWD = self.needPassword;
        self.playVC.roleType = CCRole_Student;
        self.playVC.talker_audio = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_talker_audio;
        
        if ([self isControllerPresented:[CCLoginViewController class]]) {
            [self.navigationController pushViewController:self.playVC animated:YES];
        }
    }
    else if (self.role == CCRole_Inspector)
    {
        //        CCPlayViewController *playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.loginInfo  =  info;
        self.playVC.viewerId = userID;
        self.playVC.sessionId =  self.sessionID;
        self.playVC.videoAndAudioNoti = self.videoAndAudioNoti;
        self.videoAndAudioNoti = nil;
        self.playVC.isLandSpace = self.isLandSpace;
        self.playVC.roleType = CCRole_Inspector;
        self.playVC.talker_audio = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_talker_audio;
        if ([self isControllerPresented:[CCPlayViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:self.playVC animated:YES];
    }
    else if (self.role == CCRole_Assistant)
    {
        //        CCTeachCopyViewController *teacherCopyVC = [[CCTeachCopyViewController alloc]initWithLandspace:self.isLandSpace];
        self.teacherCopyVC.viewerId = userID;
        self.teacherCopyVC.sessionId =  self.sessionID;
        self.teacherCopyVC.isLandSpace = self.isLandSpace;
        self.teacherCopyVC.roomID = self.roomID;
        self.teacherCopyVC.videoOriMode = self.isLandSpace ? CCVideoLandscape : CCVideoPortrait;
        self.teacherCopyVC.videoOriMode = CCVideoChangeByInterface;

        if ([self isControllerPresented:[CCTeachCopyViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:self.teacherCopyVC animated:YES];
    }
}

- (BOOL)isControllerPresented:(Class)class {
    UIViewController *vc = [HDSTool currentViewController];
    if ([vc isKindOfClass:class]) {
        NSLog(@"UIViewController---ERROR!---:%@",class);
        return YES;
    }
    return NO;
}

- (void)streamLoginFail:(NSError *)error
{
    [_loadingView removeFromSuperview];
    [CCTool showMessage:error.domain];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

+(int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

#define kMaxLength 64
- (void) textFieldDidChange:(UITextField *) TextField
{
    if (self.needPassword)
    {
        if(StrNotEmpty(_textFieldUserName.text) && StrNotEmpty(_textFieldUserPassword.text))
        {
            self.loginBtn.enabled = YES;
            [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,1) CGColor]];
        } else {
            self.loginBtn.enabled = NO;
            [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,0.6) CGColor]];
        }
    }
    else
    {
        if(StrNotEmpty(_textFieldUserName.text))
        {
            self.loginBtn.enabled = YES;
            [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,1) CGColor]];
        } else {
            self.loginBtn.enabled = NO;
            [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,0.6) CGColor]];
        }
    }
    NSString *toBeString = TextField.text;
    int length = [CCLoginViewController convertToInt:toBeString];
    UITextRange *selectedRange = [TextField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [TextField positionFromPosition:selectedRange.start offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if(!position)
    {
        if(length > kMaxLength)
        {
            for (int i = 1; i < toBeString.length; i++)
            {
                NSString *str = [toBeString substringToIndex:toBeString.length - i];
                int length = [CCLoginViewController convertToInt:str];
                if (length <= kMaxLength)
                {
                    TextField.text = str;
                    break;
                }
            }
        }
    }
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notif {
    if(![self.textFieldUserName isFirstResponder] && ![self.textFieldUserPassword isFirstResponder])
    {
        return;
    }
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat y = keyboardRect.size.height;
    for (int i = 1; i <= 4; i++) {
        UITextField *textField = [self.view viewWithTag:i];
        if ([textField isFirstResponder] == true && (SCREENH_HEIGHT - (CGRectGetMaxY(textField.frame) + CCGetRealFromPt(10))) < y) {
            WS(ws)
            [self.informationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));
                make.top.mas_equalTo(ws.view).with.offset( - (y - (SCREENH_HEIGHT - (CGRectGetMaxY(textField.frame) + CCGetRealFromPt(10)))));
                make.width.mas_equalTo(ws.view.mas_width).multipliedBy(0.5);
                make.height.mas_equalTo(CCGetRealFromPt(24));
            }];
            
            [UIView animateWithDuration:0.25f animations:^{
                [ws.view layoutIfNeeded];
            }];
        }
    }
}

-(void)keyboardHide {
    WS(ws)
    [self.informationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).with.offset(CCGetRealFromPt(40));
        make.top.mas_equalTo(ws.view).offset(InfomationTop);;
        make.width.mas_equalTo(ws.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(CCGetRealFromPt(24));
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [ws.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [self keyboardHide];
}

#pragma mark - get server
- (void)getServerData:(NSString *)accountID
{
    __weak typeof(self) weakSelf = self;
    [[CCStreamerBasic sharedStreamer] getRoomServerWithAccountID:accountID completion:^(BOOL result, NSError *error, id info) {
        if (result)
        {
            NSDictionary *firstDic = [info[@"data"] firstObject];
            NSString *domian_name = [firstDic objectForKey:@"loc"];
            SaveToUserDefaults(SERVER_DOMAIN_NAME, domian_name);
            NSString *domain = [firstDic objectForKey:@"area_code"];
            SaveToUserDefaults(SERVER_DOMAIN, domain);
            if (domian_name.length == 0)
            {
                domian_name = HDClassLocalizeString(@"线路切换") ;
            }
            [weakSelf setRightBarItem:domian_name];
        }
    }];
}

- (void)setRightBarItem:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (![title isEqualToString:HDClassLocalizeString(@"线路切换") ])
    {
        [button setImage:[UIImage imageNamed:@"arrows3"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrows3_touch"] forState:UIControlStateHighlighted];
        CGFloat labelWidth = [CCTool getTitleSizeByFont:title width:button.frame.size.width font:button.titleLabel.font].width;
        button.imageEdgeInsets = UIEdgeInsetsMake(0,0 + labelWidth,0,0 - labelWidth);
        CGFloat imageViewWidth = [UIImage imageNamed:@"arrows3"].size.width;
        button.titleEdgeInsets = UIEdgeInsetsMake(0,0 - imageViewWidth,0, 0 + imageViewWidth);
    }
    [button sizeToFit];
    [button addTarget:self action:@selector(toServerList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - change server
- (void)toServerList
{
    CCServerListViewController *vc = [[CCServerListViewController alloc] init];
    vc.accountID = self.userID;
    main_async_safe(^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

#pragma mark - 懒加载
-(UIButton *)loginBtn {
    if(_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = MainColor;
        _loginBtn.layer.cornerRadius = CCGetRealFromPt(43);
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitle:HDClassLocalizeString(@"进入教室") forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSizeClass_18]];
        [_loginBtn setTitleColor:CCRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:CCRGBAColor(255, 255, 255, 0.4) forState:UIControlStateDisabled];
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn setBackgroundImage:[self createImageWithColor:MainColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[self createImageWithColor:CCRGBAColor(242,124,25,0.2)] forState:UIControlStateDisabled];
        [_loginBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(229,118,25)] forState:UIControlStateHighlighted];
    }
    return _loginBtn;
}

+ (AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

-(UILabel *)informationLabel
{
    if(_informationLabel == nil)
    {
        _informationLabel = [UILabel new];
        [_informationLabel setBackgroundColor:CCRGBColor(250, 250, 250)];
        [_informationLabel setFont:[UIFont systemFontOfSize:FontSizeClass_12]];
        [_informationLabel setTextColor:CCRGBColor(102, 102, 102)];
        [_informationLabel setTextAlignment:NSTextAlignmentLeft];
        [_informationLabel setText:@""];
    }
    return _informationLabel;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView)
    {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"portrait"]];
    }
    return _iconImageView;
}

- (UILabel *)roomNameLabel
{
    if (!_roomNameLabel)
    {
        _roomNameLabel = [UILabel new];
        _roomNameLabel.font = [UIFont systemFontOfSize:FontSizeClass_18];
        _roomNameLabel.textAlignment = NSTextAlignmentCenter;
        _roomNameLabel.numberOfLines = 1;
        _roomNameLabel.text = GetFromUserDefaults(LIVE_ROOMNAME);
    }
    return _roomNameLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel)
    {
        _descLabel = [UILabel new];
        _descLabel.font = [UIFont systemFontOfSize:FontSizeClass_15];
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 2;
        NSString *desc = GetFromUserDefaults(LIVE_ROOMDESC);
        desc = [self filterHTML:desc];
        _descLabel.text = desc;
    }
    return _descLabel;
}

-(TextFieldUserInfo *)textFieldUserName
{
    if(_textFieldUserName == nil) {
        _textFieldUserName = [TextFieldUserInfo new];
        [_textFieldUserName textFieldWithLeftText:@"" placeholder:HDClassLocalizeString(@"请输入昵称") lineLong:NO text:nil];
        _textFieldUserName.delegate = self;
        _textFieldUserName.tag = 3;
        _textFieldUserName.text = HDClassLocalizeString(@"我叫MT") ;
        [_textFieldUserName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldUserName;
}

-(TextFieldUserInfo *)textFieldUserPassword {
    if(_textFieldUserPassword == nil) {
        _textFieldUserPassword = [TextFieldUserInfo new];
        [_textFieldUserPassword textFieldWithLeftText:@"" placeholder:HDClassLocalizeString(@"请输入密码") lineLong:NO text:nil];
        _textFieldUserPassword.delegate = self;
        _textFieldUserPassword.tag = 4;
        _textFieldUserPassword.secureTextEntry = YES;
        [_textFieldUserPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textFieldUserPassword;
}

#pragma mark - 添加监听_和_移除监听
-(void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSocketEvent:) name:CCNotiReceiveSocketEvent object:nil];
}

-(void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CCNotiReceiveSocketEvent object:nil];
}

- (void)hdsRemveLoadView
{
    [self.loadingView removeFromSuperview];
}
#pragma mark - 内存警告和生命结束
-(void)dealloc {
    [self removeObserver];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
