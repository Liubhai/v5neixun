//
//  CCScanViewController.m
//  CCClassRoom
//
//  Created by cc on 17/1/22.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCLoginScanViewController.h"
#import "CCScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CCLoginViewController.h"
#import "CCLoginDirectionViewController.h"
#import "TextFieldUserInfo.h"
#import <CCClassRoomBasic/CCClassRoomBasic.h>
#import <HSRoomUI/HSRoomUI.h>
#import "CCTicketVoteView.h"
#import "CCTickeResultView.h"
#import "CCBrainView.h"
#import "CCClassCodeView.h"
#import "CCUrlLoginView.h"
#import "CCRoomDecModel.h"
#import <MJExtension/MJExtension.h>
#import "CCPlayViewController.h"
#import "CCPushViewController.h"
#import "AppDelegate.h"
#import "YUNLanguage.h"

@interface CCLoginScanViewController ()<CCClassCodeViewDelegate, CCUrlLoginViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property(nonatomic, strong)UIImageView *topImgView;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property(nonatomic, strong)UIScrollView *bgScrollView;
@property(nonatomic, strong)UIScrollView *contentScrollView;
@property(nonatomic, strong)UIButton *urlLoginBtn;
@property(nonatomic, strong)UIButton *classCodeLoginBtn;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)CCClassCodeView *classCodeView;
@property(nonatomic, strong)CCUrlLoginView *urlLoginView;
@property(nonatomic, strong)CCRoomDecModel *descModel;
@property(nonatomic, assign)BOOL isUrlLogin;
@property(nonatomic, strong) CCPlayViewController *playVC;
@property(nonatomic, strong) CCPushViewController *pushVC;
@property(nonatomic,strong)LoadingView          *loadingView;

@property(nonatomic,strong)HSLiveViewController *liveVC;
@property (assign, nonatomic) CCRole role;//角色
@property(nonatomic, assign)BOOL needPassword;
@property(nonatomic, copy)NSString *sessionID;
@property(nonatomic, strong)id loginInfo;
@property(nonatomic, assign)BOOL isLandSpace;
@property(nonatomic, assign)BOOL isLoading;

@property(nonatomic,strong)UIButton *btnLanguage;

@end

@implementation CCLoginScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isUrlLogin = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ScanSuccess:) name:@"ScanSuccess" object:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@", app_build];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(reportHDSLog) forControlEvents:UIControlEventTouchUpInside];
    [self.versionLabel addSubview:btn];
    self.versionLabel.userInteractionEnabled = YES;
    
    WS(ws);
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(ws.versionLabel);
//    }];
    
    [self.view addSubview:self.loginBtn];
    //make.bottom.equalTo(self.versionLabel.mas_top).offset(-20);
    [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).with.offset(15);
        make.right.mas_equalTo(ws.view).with.offset(-15);
        make.bottom.mas_equalTo(ws.view).height.offset(-70);
        make.height.mas_equalTo(50);
    }];
    self.loginBtn.enabled = NO;
    
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.loginBtn.mas_top).offset(-10);
    }];
    
    [self.bgScrollView addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(255);//205
    }];
    
    [self.bgScrollView addSubview:self.urlLoginBtn];
    [self.urlLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgScrollView);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        make.top.equalTo(self.topImgView.mas_bottom).offset(20);
    }];
    
    [self.bgScrollView addSubview:self.classCodeLoginBtn];
    [self.classCodeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.urlLoginBtn.mas_right);
        make.right.equalTo(self.bgScrollView);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.topImgView.mas_bottom).offset(20);
    }];
    
    [self.bgScrollView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.urlLoginBtn).offset(0);
        make.bottom.equalTo(self.urlLoginBtn.mas_bottom).offset(-9.5);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(100);
    }];
    
    [self.bgScrollView insertSubview:self.lineView belowSubview:self.urlLoginBtn];
    
    [self.bgScrollView addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgScrollView);
        make.top.equalTo(self.urlLoginBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(245);
        make.bottom.equalTo(self.bgScrollView);
    }];
    
    [self.contentScrollView addSubview:self.urlLoginView];
    [self.urlLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScrollView);
        make.top.equalTo(self.contentScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(50);
    }];
    
    [self.contentScrollView addSubview:self.classCodeView];
    [self.classCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.urlLoginView.mas_right);
        make.right.equalTo(self.contentScrollView);
        make.top.equalTo(self.contentScrollView);
        make.bottom.equalTo(self.contentScrollView);
        make.height.mas_equalTo(245);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.view addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.view).offset(14.f + [CCTool tool_MainWindowSafeArea_Bottom]);
        make.right.mas_equalTo(ws.view).offset(-10.f);
    }];
    [self versionCheck];
    
    [self.view addSubview:self.btnLanguage];
}

- (void)reportHDSLog
{
    NSString *uid = GetFromUserDefaults(Login_UID);
    [[CCStreamerBasic sharedStreamer]reportLogInfo:uid];
    dispatch_async(dispatch_get_main_queue(), ^{
        [CCTool showMessage:HDClassLocalizeString(@"日志已上报！") ];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self landscapeRight:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isUrlLogin) {
        [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else {
        [self.contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
}

- (void)ScanSuccess:(NSNotification *)noti
{
    NSString *userId = noti.userInfo[@"userID"];
    NSString *roomId = noti.userInfo[@"roomID"];
    NSString *role = noti.userInfo[@"role"];
    NSInteger authtype = [noti.userInfo[@"authtype"] integerValue];
    BOOL needPassword = authtype == 2 ? NO : YES;
    NSInteger role1 = [CCTool roleFromRoleString:role];
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CCLoginDirectionViewController *directionVC = (CCLoginDirectionViewController *)[mainStory instantiateViewControllerWithIdentifier:@"Direction"];
    if (role1 == CCRole_Teacher || role1 == CCRole_Assistant)
    {
        directionVC.needPassword = YES;
    }
    else
    {
        if (role1 == CCRole_Teacher)
        {
            directionVC.needPassword = YES;
        }
        else
        {
            directionVC.needPassword = needPassword;
        }
    }
    directionVC.role = role1;
    SaveToUserDefaults(LIVE_ROLE, @(directionVC.role));
    SaveToUserDefaults(LIVE_ROOMID, roomId);
    directionVC.userID = userId;
    directionVC.roomID = roomId;
    main_async_safe(^{
        [self.navigationController pushViewController:directionVC animated:YES];
    });
}

- (IBAction)touchScan:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        main_async_safe(^{
                            CCScanViewController *scanViewController = [[CCScanViewController alloc] initWithType:1];
                            [weakSelf.navigationController pushViewController:scanViewController animated:YES];
                        });
                    }else{
                        main_async_safe(^{
                            //用户拒绝
                            CCScanViewController *scanViewController = [[CCScanViewController alloc] initWithType:1];
                            [weakSelf.navigationController pushViewController:scanViewController animated:YES];
                            
                        });                        
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            dispatch_async(dispatch_get_main_queue(), ^{
                CCScanViewController *scanViewController = [[CCScanViewController alloc] initWithType:1];
                [weakSelf.navigationController pushViewController:scanViewController animated:YES];
            });
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            // 用户明确地拒绝授权，或者相机设备无法访问
            dispatch_async(dispatch_get_main_queue(), ^{
                CCScanViewController *scanViewController = [[CCScanViewController alloc] initWithType:1];
                [weakSelf.navigationController pushViewController:scanViewController animated:YES];
            });
        }
            break;
        default:
            break;
    }
}

- (IBAction)leftBtnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"LoginScanToUserGuide" sender:self];
}

- (void)rightBtnClicked:(UIButton *)btn
{
    [self touchScan:btn];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    if (scrollView.tag == 10002) {
        CGFloat offsetX =  scrollView.contentOffset.x * 0.5;
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.urlLoginBtn).offset(offsetX);
        }];
        if (scrollView.contentOffset.x > (SCREEN_WIDTH * 0.5)) {
            self.isUrlLogin = NO;
        }else {
            self.isUrlLogin = YES;
        }
    }else {
        if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset = CGPointMake(0, 0);
            return;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 10002) {
        
        [self updateViewConstraintsBtnStatus:self.isUrlLogin];
        [self updateLogin];
    }
}

- (void)updateLogin {
    if (self.isUrlLogin) {
        [self.urlLoginView scrollerViewUpdate];
    }else {
        [self.classCodeView scrollerViewUpdate];
    }
}

- (void)loginAction
{
    self.loginBtn.enabled = NO;
    if (self.isUrlLogin) {
        if ([self.urlLoginView.textFieldUserName.text isEqualToString:@"Apple"] || [self.urlLoginView.textFieldUserName.text isEqualToString:@"apple"]) {
            ///苹果审核员理解错误,导致输入错误,进行兼容
            NSString *result = @"http://cloudclass.csslcloud.net/index/presenter/?roomid=11208805CF0207139C33DC5901307461&userid=3D6D13FB0C0456F7";

            [self parseCodeStr:result];
        } else {

            [self parseCodeStr:self.urlLoginView.textFieldUserName.text];
        }
    }else {
        //codedenglu直接调用auth和join
        [self loginActionJoin];
    }
}

-(void)parseCodeStr:(NSString *)result {
    NSRange rangeRoomId = [result rangeOfString:@"roomid="];
    NSRange rangeUserId = [result rangeOfString:@"userid="];
    WS(ws)
    if (!StrNotEmpty(result) || rangeRoomId.location == NSNotFound || rangeUserId.location == NSNotFound)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HDClassLocalizeString(@"解析错误错误") message:HDClassLocalizeString(@"课堂链接错误") preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:HDClassLocalizeString(@"好") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [ws.urlLoginView.textFieldUserName becomeFirstResponder];
        }];
        [alertController addAction:okAction];
        [ws presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *resultNew = [result stringByReplacingOccurrencesOfString:@"#" withString:@"index"];

        NSDictionary *roomInfo = [HDSTool parseURLParam:resultNew];
        NSString *roomId = roomInfo[@"roomid"];
        NSString *userId = roomInfo[@"userid"];
        NSInteger mode = [roomInfo[@"template"]integerValue];

        HDSTool *tool = [HDSTool sharedTool];
        tool.rid = roomId;
        tool.uid = userId;
        tool.roomMode = mode;

        if (!roomId || !userId) {
            return;
        }
        resultNew = [HDSTool getUrlStringWithString:resultNew];
        NSURL *url = [NSURL URLWithString:resultNew];
        NSString *path = [[url path]lastPathComponent];
        NSString *role = path;

        SaveToUserDefaults(LIVE_USERID,userId);
        SaveToUserDefaults(LIVE_ROOMID,roomId);

        NSString *urlDealed = [[CCScanViewController new]dealURLClassToCCAPI:result];
        [[CCStreamerBasic sharedStreamer]setServerDomain:urlDealed area:nil];
        
        __weak typeof(self) weakSelf = self;
        userId = [userId stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [self getRoomDescWithRoomID:roomId classNo:nil completion:^(BOOL result, NSError *error, id info) {
            weakSelf.loginBtn.enabled = YES;
            CCRoomDecModel *model = (CCRoomDecModel *)info;
            if (result)
            {
                if ([model.result isEqualToString:@"OK"])
                {
                    HDSTool *tool = [HDSTool sharedTool];
                    tool.roomSubMode = model.data.layout_mode;

                    SaveToUserDefaults(LIVE_ROOMNAME, model.data.name);
                    SaveToUserDefaults(LIVE_ROOMDESC, model.data.desc);
                    [ws.navigationController popViewControllerAnimated:NO];
                    NSInteger authKey = [CCRoomDecModel authTypeKeyForRole:role model:model.data];
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[@"userID"] = userId;
                    userInfo[@"roomID"] = roomId;
                    userInfo[@"role"] = role;
                    userInfo[@"authtype"] = @(authKey);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanSuccess" object:nil userInfo:userInfo];
                }
                else
                {
                    [CCTool showMessage:model.errorMsg];
                    [ws.navigationController popViewControllerAnimated:NO];
                }
            }
            else
            {
                [ws.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)getRoomIdAndDesc:(NSString *)classNo {
    if (classNo.length == 0) {
        return;
    }
    if (classNo.length != 9) {
        [CCTool showMessage:HDClassLocalizeString(@"请输入9位参课码") ];
        return;
    }
//    if ([classNo hasSuffix:@"4"]) {
//        [CCTool showMessage:HDClassLocalizeString(@"暂不支持助教") ];
//        return;
//    }
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    _loadingView = [[LoadingView alloc] initWithLabel:HDClassLocalizeString(@"正在获取房间信息...") ];
    [self.view addSubview:_loadingView];
    [_loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    WeakSelf(weakSelf);
    [self getRoomDescWithRoomID:nil classNo:classNo completion:^(BOOL result, NSError *error, id info) {
        weakSelf.isLoading = NO;
        [_loadingView removeFromSuperview];
        _loadingView.hidden = YES;
        weakSelf.descModel = (CCRoomDecModel *)info;
        if (result)
        {
            if ([weakSelf.descModel.result isEqualToString:@"OK"])
            {
                weakSelf.descModel.data.classNo = classNo;
                HDSTool *tool = [HDSTool sharedTool];
                tool.roomSubMode = weakSelf.descModel.data.layout_mode;
                tool.rid = weakSelf.descModel.data.live_roomid;
                tool.uid = weakSelf.descModel.data.userid;
                tool.roomMode = weakSelf.descModel.data.templatetype;
                if (tool.roomMode != 32) {
                    [tool updateLocalPushResolution];
                    [tool resetSDKPushResolution];
                }
                if ([classNo hasSuffix:@"4"]) {
                    if (tool.roomMode != 32) {
                        [CCTool showMessage:HDClassLocalizeString(@"暂不支持助教") ];
                        return;
                    } else {
                        if (tool.roomSubMode > 0) {
                            [CCTool showMessage:HDClassLocalizeString(@"暂不支持助教") ];
                            return;
                        }
                    }
                }

                SaveToUserDefaults(LIVE_ROOMNAME, weakSelf.descModel.data.name);
                SaveToUserDefaults(LIVE_ROOMDESC, weakSelf.descModel.data.desc);
                [weakSelf updateClassCodeView];
            }
            else
            {
                [CCTool showMessage:weakSelf.descModel.errorMsg];
            }
        }
        else
        {
            NSString *errMessage = error.domain;
            if (!errMessage) {
                errMessage = HDClassLocalizeString(@"网络不稳定,请重试!") ;
            }
            NSInteger errCode = error.code;
            
            NSString *message = [NSString stringWithFormat:@"%@<%d>",errMessage,errCode];
            [HDSTool showAlertTitle:@"" msg:message completion:^(BOOL cancelled, NSInteger buttonIndex) {
                
            }];
        }
    }];
}

- (void)landSpaceSelect:(BOOL)isLandSpace {
    self.isLandSpace = isLandSpace;
}

- (void)classCodeViewEditEndUpdateLogin:(BOOL)canLogin {
    [self updateLogin:canLogin];
}

- (void)urlPathEditUpdateLogin:(BOOL)canLogin {
    [self updateLogin:canLogin];
}

- (void)updateLogin:(BOOL)canLogin {
    if(canLogin)
    {
        self.loginBtn.enabled = YES;
        [self.loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,1) CGColor]];
    } else {
        self.loginBtn.enabled = NO;
        [_loginBtn.layer setBorderColor:[CCRGBAColor(255,71,0,0.6) CGColor]];
    }
}

- (void)updateClassCodeView {
    [self.classCodeView updateView:self.descModel];
}

- (void)getRoomDescWithRoomID:(NSString *)roomId classNo:(NSString *)classNo completion:(CCComletionBlock)completion {
    [CCRoomDecModel getRoomDescWithRoomID:roomId classCode:classNo completion:^(BOOL result, NSError *error, id info) {
        completion(result, error, info);
    }];
}

//监听touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)urlLoginBtnAction:(UIButton *)btn {
    [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self updateViewConstraintsBtnStatus:YES];
    self.isUrlLogin = YES;
    [self updateLogin];
}

- (void)classCodeLoginBtnAction:(UIButton *)btn {
    [self.contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    [self updateViewConstraintsBtnStatus:NO];
    self.isUrlLogin = NO;
    [self updateLogin];
}

- (void)updateViewConstraintsBtnStatus:(BOOL)selectUrl {
    self.urlLoginBtn.selected = selectUrl;
    self.classCodeLoginBtn.selected = !selectUrl;
    if (selectUrl) {
        self.urlLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.classCodeLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }else {
        self.urlLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.classCodeLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 {
   "result": "OK",
   "error": null,
   "data": {
     "update_info": " ",
     "url": "",
     "is_force": false,
     "version": "",
     "code": 10
   },
   "errorMsg": ""
 }
 
 is_force 是否强更，true强更，false不强更 code  10无更新，20有更新
 */
- (void)versionCheck {
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *version = infoDic[@"CFBundleShortVersionString"];
    NSString *client_type = @"ios";

    NSString *urlString = @"https://ccapi.csslcloud.net/cloudclass-core-api/api/common/app_version/check?";
    NSString *param = [NSString stringWithFormat:@"client_type=%@&version=%@",client_type,version];

    NSString *urlFinal = [NSString stringWithFormat:@"%@%@",urlString,param];
    NSURL *url = [NSURL URLWithString:urlFinal];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !data) {
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", dict);
        if (!dict) {
            return;
        }
        NSString *res = dict[@"result"];
        if (![res isEqualToString:@"OK"]) {
            return;
        }
        NSDictionary *dataInfo = dict[@"data"];
        NSInteger code = [dataInfo[@"code"]integerValue];
        if (code == 10) {
            return;
        }
        if (code == 20) {
            BOOL is_force = [dataInfo[@"is_force"]boolValue];
            NSString *text = dataInfo[@"update_info"];
            NSString *v_url = dataInfo[@"url"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showUpdate:is_force text:text url:v_url];
            });
        }
    }] resume];
}

- (void)showUpdate:(BOOL)force text:(NSString *)text url:(NSString *)urlValue {
    if (!urlValue) {
        return;
    }
    NSString*hString = [urlValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:hString];
    
    NSString *title = HDClassLocalizeString(@"发现新版本哦～") ;
    NSString *message = text;
    NSString *cancelButtonTitle = HDClassLocalizeString(@"取消") ;
    NSString *otherButtonTitle = HDClassLocalizeString(@"更新") ;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        [[UIApplication sharedApplication]openURL:url];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }];
    
    if (!force) {
        // Add the actions.
        [alertController addAction:cancelAction];
    }
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 懒加载

-(UIButton *)loginBtn {
    if(_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = CCRGBColor(255, 132, 47);
        _loginBtn.layer.cornerRadius = 25;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitle:HDClassLocalizeString(@"进入课堂") forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSizeClass_16]];
        [_loginBtn setTitleColor:CCRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:CCRGBAColor(255, 255, 255, 0.4) forState:UIControlStateDisabled];
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_loginBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(255, 132, 47)] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[self createImageWithColor:CCRGBAColor(242,124,25,0.2)] forState:UIControlStateDisabled];
        [_loginBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(229,118,25)] forState:UIControlStateHighlighted];
    }
    return _loginBtn;
}

- (UIButton *)rightBtn
{
    if(_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"" forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:(@"扫一扫") ] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        _bgScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _bgScrollView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.tag = 10002;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

- (UIButton *)urlLoginBtn {
    if (!_urlLoginBtn) {
        _urlLoginBtn = [[UIButton alloc] init];
        _urlLoginBtn.backgroundColor = UIColor.clearColor;
        [_urlLoginBtn setTitle:HDClassLocalizeString(@"链接登录") forState:UIControlStateNormal];
        [_urlLoginBtn setTitleColor:CCRGBColor(102, 102, 102) forState:UIControlStateNormal];
        [_urlLoginBtn setTitleColor:CCRGBColor(18, 31, 44) forState:UIControlStateSelected];
        [_urlLoginBtn addTarget:self action:@selector(urlLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self updateViewConstraintsBtnStatus:YES];
    }
    return _urlLoginBtn;
}

- (UIButton *)classCodeLoginBtn {
    if (!_classCodeLoginBtn) {
        _classCodeLoginBtn = [[UIButton alloc] init];
        _classCodeLoginBtn.backgroundColor = UIColor.clearColor;
        [_classCodeLoginBtn setTitle:HDClassLocalizeString(@"参课码登录") forState:UIControlStateNormal];
        [_classCodeLoginBtn setTitleColor:CCRGBColor(102, 102, 102) forState:UIControlStateNormal];
        [_classCodeLoginBtn setTitleColor:CCRGBColor(18, 31, 44) forState:UIControlStateSelected];
        [_classCodeLoginBtn addTarget:self action:@selector(classCodeLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _classCodeLoginBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        UIColor *color = [UIColor colorWithRed:255/225.0 green:110/255.0 blue:10/255.0 alpha:0.5];
        _lineView.backgroundColor = color;
        _lineView.layer.cornerRadius = 1;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

- (UIImageView *)topImgView {
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc] init];
        _topImgView.contentMode = UIViewContentModeScaleAspectFill;
        _topImgView.image = [UIImage imageNamed:(@"iphone6竖屏1") ];
    }
    return _topImgView;
}

- (CCClassCodeView *)classCodeView {
    if (!_classCodeView) {
        _classCodeView = [[CCClassCodeView alloc] init];
        _classCodeView.delegate = self;
    }
    return _classCodeView;
}

- (CCUrlLoginView *)urlLoginView {
    if (!_urlLoginView) {
        _urlLoginView = [[CCUrlLoginView alloc] init];
        _urlLoginView.delegate = self;
    }
    return _urlLoginView;
}


-(void)loginActionJoin
{
    if (self.classCodeView.userNameTF.text.length > 20) {
        [CCTool showMessage:HDClassLocalizeString(@"名称不能差超过20字符") ];
        return;
    }
    if (self.classCodeView.classCodeTF.text.length != 9) {
        [CCTool showMessage:HDClassLocalizeString(@"请输入9位参课码") ];
        return;
    }
    self.loginBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loginBtn.userInteractionEnabled = YES;
    });
    [self.view endEditing:YES];
//#warning 4.1.0关闭助教
    self.needPassword = YES;
    if ([self.classCodeView.classCodeTF.text hasSuffix:@"0"]) {///老师 助教
        ///需要密码
        self.role = CCRole_Teacher;
        self.needPassword = YES;
    }else if ([self.classCodeView.classCodeTF.text hasSuffix:@"1"]) {///学生
        self.role = CCRole_Student;
        self.needPassword = self.descModel.data.talker_authtype == 2 ? NO : YES;
    }else if ([self.classCodeView.classCodeTF.text hasSuffix:@"7"]) {///麦下观众
        self.role = CCRole_au_low;
        self.needPassword = self.descModel.data.talker_authtype == 2 ? NO : YES;
    }else if ([self.classCodeView.classCodeTF.text hasSuffix:@"3"]) {///隐身者
        if (self.descModel.data.templatetype == 32) {
            [CCTool showMessage:HDClassLocalizeString(@"暂不支持隐身者") ];
            return;
        }
        self.role = CCRole_Inspector;
        self.needPassword = self.descModel.data.inspector_authtype == 2 ? NO : YES;
    } else if ([self.classCodeView.classCodeTF.text hasSuffix:@"4"]) {
        self.role = CCRole_Assistant;
        self.needPassword = YES;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:NONETWORK] isEqualToString:@"noNetwork"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CCTool showMessage:HDClassLocalizeString(@"网络已断开，请检查网络设置！") ];
        });
        return;
    }
//    [self keyboardHide];
    _loadingView = [[LoadingView alloc] initWithLabel:HDClassLocalizeString(@"正在登录...") ];
    [self.view addSubview:_loadingView];
    [_loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    SaveToUserDefaults(SET_USER_NAME, self.classCodeView.userNameTF.text);
    SaveToUserDefaults(SET_USER_PWD, self.classCodeView.passWordTF.text);
    SaveToUserDefaults(LIVE_USERID, self.descModel.data.userid);
    SaveToUserDefaults(LIVE_ROOMID, self.descModel.data.live_roomid);
    
    NSString *isp = GetFromUserDefaults(SERVER_AREA_NAME);
    
    NSString *uname = self.classCodeView.userNameTF.text;
    
    
    NSString *upwd = (self.needPassword ? self.classCodeView.passWordTF.text : @"");
    
    __weak typeof(self) weakSelf = self;
    __block NSString *sessionStr = nil;
    [[CCStreamerBasic sharedStreamer] authWithRoomId:self.descModel.data.live_roomid accountId:self.descModel.data.userid role:self.role password:upwd nickName:uname completion:^(BOOL result, NSError *error, id info) {
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
            
            NSString *accountid = self.descModel.data.userid;
            NSString *sessionid = self.sessionID;
            [[CCStreamerBasic sharedStreamer] joinWithAccountID:accountid sessionID:sessionid roomId:weakSelf.descModel.data.live_roomid config:config areaCode:isp events:@[] updateRtmpLayout:NO completion:^(BOOL result, NSError *error, id info) {
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
                    if ([NSThread isMainThread]) {
                        if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {
                            
                            [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                        }
                    }else {
                        main_async_safe(^{
                            if ([[weakSelf.navigationController.viewControllers lastObject] isKindOfClass:weakSelf.class]) {
                                
                                [weakSelf streamLoginSuccess:weakSelf.loginInfo];
                            }
                        });
                    }
                    
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
- (void)initVC {
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
        self.pushVC.isQuick = YES;
    }
    else if (self.role == CCRole_Student)
    {
        if (self.playVC) {
            [self.playVC removeObserver];
        }
        self.playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.roleType = CCRole_Student;
        self.playVC.isQuick = YES;
    }
    else if (self.role == CCRole_Inspector)
    {
        if (self.playVC) {
            [self.playVC removeObserver];
        }
        self.playVC = [[CCPlayViewController alloc] initWithLandspace:self.isLandSpace];
        self.playVC.roleType = CCRole_Inspector;
        self.playVC.isQuick = YES;
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
//            [self.loginBtn setEnabled:YES];
//        }
        return;
    }
    //存储用户名、密码
    NSString *userName = self.classCodeView.userNameTF.text;
    NSString *userpwd = self.classCodeView.passWordTF.text;
    SaveToUserDefaults(@"kkuserName", userName);
    SaveToUserDefaults(@"kkuserpwd", userpwd);
    NSString *userID =  self.descModel.data.userid;
    SaveToUserDefaults(LIVE_USERNAME, userName);
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
        self.pushVC.sessionId =  self.sessionID;
        self.pushVC.viewerId = userID;
        self.pushVC.isLandSpace = self.isLandSpace;
        self.pushVC.roomID = self.descModel.data.live_roomid;
        self.pushVC.videoOriMode = self.isLandSpace ? CCVideoLandscape : CCVideoPortrait;
        self.pushVC.videoOriMode = CCVideoChangeByInterface;
        if ([self isControllerPresented:[CCPushViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:self.pushVC animated:YES];
    }
    else if (self.role == CCRole_Student)
    {
        self.playVC.sessionId =  self.sessionID;
        self.playVC.viewerId = userID;
//        self.playVC.videoAndAudioNoti = self.videoAndAudioNoti;
//        self.videoAndAudioNoti = nil;
        self.playVC.isLandSpace = self.isLandSpace;
        
        self.playVC.isNeedPWD = self.needPassword;
        self.playVC.roleType = CCRole_Student;
        self.playVC.talker_audio = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_talker_audio;
        
        if ([self isControllerPresented:[CCLoginScanViewController class]]) {
            [self.navigationController pushViewController:self.playVC animated:YES];
        }
    }
    else if (self.role == CCRole_Inspector)
    {
        self.playVC.loginInfo = info;
        self.playVC.viewerId = userID;
        self.playVC.sessionId =  self.sessionID;
//        self.playVC.videoAndAudioNoti = self.videoAndAudioNoti;
//        self.videoAndAudioNoti = nil;
        self.playVC.isLandSpace = self.isLandSpace;
        self.playVC.roleType = CCRole_Inspector;
        self.playVC.talker_audio = [[CCStreamerBasic sharedStreamer]getRoomInfo].room_talker_audio;
        if ([self isControllerPresented:[CCPlayViewController class]]) {
            return;
        }
        [self.navigationController pushViewController:self.playVC animated:YES];
    }
    
    [self.loginBtn setEnabled:YES];
}
- (BOOL)isControllerPresented:(Class)class {
    UIViewController *vc = [HDSTool currentViewController];
    if ([vc isKindOfClass:class]) {
        NSLog(@"UIViewController---ERROR!---:%@",class);
        return YES;
    }
    return NO;
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


#pragma mark -- 语言切换
- (UIButton *)btnLanguage {
    if (!_btnLanguage) {
        _btnLanguage = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLanguage.frame = CGRectMake(15,32.5,116,35);
        _btnLanguage.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.1].CGColor;
        _btnLanguage.layer.cornerRadius = 17.5;

        [_btnLanguage addTarget:self action:@selector(buttonLanguageClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = [UIImage imageNamed:@"Y_Language"];
        [_btnLanguage setImage:img forState:UIControlStateNormal];
        
        [YUNLanguage  setBundlePathMainForClass:[CCPlayViewController class]];
        [HDSLanguage setBundlePathMainForClass:[HDSLanguage class]];
        [self updateBtnLanguageTitle];
        
#pragma mark -- 功能暂未开放
        _btnLanguage.hidden = YES;
    }
    return _btnLanguage;
}

- (void)updateBtnLanguageTitle {
    NSString *title = HDClassLocalizeString(@"Y_language");
    [_btnLanguage setTitle:title forState:UIControlStateNormal];
}

- (void)buttonLanguageClicked {
    YUNLanguageMode mode = [YUNLanguage currentMode];
    YUNLanguageMode modeNew = mode == YUNLanguageMode_chiness ? YUNLanguageMode_english : YUNLanguageMode_chiness;
    HDSLanguageMode modeSDK = mode == YUNLanguageMode_chiness ? HDSLanguageMode_english : HDSLanguageMode_chiness;

    [YUNLanguage setLanguageMode:modeNew];
    [HDSLanguage setLanguageMode:modeSDK];
    
    [self.urlLoginBtn setTitle:HDClassLocalizeString(@"链接登录") forState:UIControlStateNormal];
    [self.classCodeLoginBtn setTitle:HDClassLocalizeString(@"参课码登录") forState:UIControlStateNormal];
    [self.loginBtn setTitle:HDClassLocalizeString(@"进入课堂") forState:UIControlStateNormal];

    [self.urlLoginView reloadLanguage];
    [self.classCodeView reloadLanguage];
    
    
    
    [self updateBtnLanguageTitle];
}

@end
