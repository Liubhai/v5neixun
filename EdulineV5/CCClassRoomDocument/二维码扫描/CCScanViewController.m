//
//  ScanViewController.m
//  NewCCDemo
//
//  Created by cc on 2016/12/4.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "CCScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "CCScanOverViewController.h"
#import "CCPhotoNotPermissionVC.h"
#import "TZImagePickerController.h"
#import "CCBaseViewController.h"
#import "HDSTool.h"
#import "CCRoomDecModel.h"
#import <CCFuncTool/CCFuncTool.h>
#import "LoadingView.h"


//标注是否是测试环境
#define ENV_TEST    1

@interface CCScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate>

@property(nonatomic,strong)UIBarButtonItem              *leftBarBtn;
@property(nonatomic,strong)UIBarButtonItem              *rightBarPicBtn;
@property(strong,nonatomic)AVCaptureDevice              *device;
@property(strong,nonatomic)AVCaptureDeviceInput         *input;
@property(strong,nonatomic)AVCaptureMetadataOutput      *output;
@property(strong,nonatomic)AVCaptureSession             *session;
@property(strong,nonatomic)AVCaptureVideoPreviewLayer   *preview;
@property(strong,nonatomic)NSTimer                      *timer;
@property(strong,nonatomic)NSTimer                      *scanTimer;

@property(strong,nonatomic)UIView                       *overView;
@property(strong,nonatomic)UIImageView                  *centerView;
@property(strong,nonatomic)UIImageView                  *scanLine;
@property(strong,nonatomic)UILabel                      *bottomLabel;

@property(strong,nonatomic)UILabel                      *overCenterViewTopLabel;
@property(strong,nonatomic)UILabel                      *overCenterViewBottomLabel;

@property(strong,nonatomic)UIView                       *topView;
@property(strong,nonatomic)UIView                       *bottomView;
@property(strong,nonatomic)UIView                       *leftView;
@property(strong,nonatomic)UIView                       *rightView;

@property(strong,nonatomic)UITapGestureRecognizer       *singleRecognizer;
@property(strong,nonatomic)CCScanOverViewController       *scanOverViewController;
@property(strong,nonatomic)CCPhotoNotPermissionVC         *photoNotPermissionVC;
@property(strong,nonatomic)UIImagePickerController      *picker;
@property(assign,nonatomic)NSInteger                    index;

@property(nonatomic,strong)LoadingView *loadingView;

@end

@implementation CCScanViewController

-(instancetype)initWithType:(NSInteger)index {
    self = [super init];
    if(self) {
        self.index = index;
    }
    return self;
}

- (LoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc]initWithLabel:HDClassLocalizeString(@"加载中...") ];
    }
    return _loadingView;
}

- (void)loadingViewShow {
    [self.view addSubview:self.loadingView];
    [_loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)loadViewRemove {
    [_loadingView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem=self.leftBarBtn;
    self.navigationItem.rightBarButtonItem=self.rightBarPicBtn;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationController.navigationBarHidden = NO;
    self.title = HDClassLocalizeString(@"扫描二维码") ;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FontSizeClass_18],NSFontAttributeName,nil]];
    [self.navigationController.navigationBar setBackgroundImage:
     [self createImageWithColor:MainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self judgeCameraStatus];
    
    [self performSelector:@selector(enableRightBtn) withObject:nil afterDelay:1.f];
}

- (void)enableRightBtn
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

-(void)startTimer {
    [self stopTimer];
    WS(ws)
    if(!_scanLine) {
        [_centerView addSubview:self.scanLine];
        [_scanLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.mas_equalTo(ws.centerView);
            make.height.mas_equalTo(CCGetRealFromPt(4));
        }];
    }
    [self startScaneLine];
    CCWeakProxy *weakProxy = [CCWeakProxy proxyWithTarget:self];
    _timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:weakProxy selector:@selector(stopScaneCode) userInfo:nil repeats:NO];
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:weakProxy selector:@selector(startScaneLine) userInfo:nil repeats:YES];
}

-(void)startScaneLine {
    WS(ws)
    [_scanLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.centerView);
        make.top.mas_equalTo(ws.centerView).offset(ws.centerView.frame.size.height);
        make.height.mas_equalTo(CCGetRealFromPt(4));
    }];
    
    [UIView animateWithDuration:1.9f animations:^{
        [self.centerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_scanLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.mas_equalTo(ws.centerView);
            make.height.mas_equalTo(CCGetRealFromPt(4));
        }];
    }];
}

-(void)stopScaneCode {
    [self stopTimer];
    [_session stopRunning];
    [_scanLine removeFromSuperview];
    _scanLine = nil;
    
    [self.centerView setImage:[UIImage imageNamed:@"scan_black"]];
    self.centerView.userInteractionEnabled = YES;
    [self.centerView addSubview:self.overCenterViewTopLabel];
    [self.centerView addSubview:self.overCenterViewBottomLabel];
    WS(ws)
    [_overCenterViewTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.centerView);
        make.top.mas_equalTo(ws.centerView).offset(CCGetRealFromPt(150));
        make.height.mas_equalTo(CCGetRealFromPt(50));
    }];
    
    [_overCenterViewBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.centerView);
        make.bottom.mas_equalTo(ws.centerView).offset(-CCGetRealFromPt(150));
        make.height.mas_equalTo(CCGetRealFromPt(46));
    }];
    
    [self.centerView addGestureRecognizer:self.singleRecognizer];
}

-(void)singleTap {
    [self.centerView setImage:[UIImage imageNamed:@"scan_white"]];
    [_overCenterViewTopLabel removeFromSuperview];
    [_overCenterViewBottomLabel removeFromSuperview];
    self.centerView.userInteractionEnabled = NO;
    [self.centerView removeGestureRecognizer:self.singleRecognizer];
    [_session startRunning];
    
    [self startTimer];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self stopTimer];
    NSString *result = nil;
    if ([metadataObjects count] >0){
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        result = metadataObject.stringValue;
    }
    
    [self parseCodeStr:result];
}

- (void)stopSession
{
    [self stopTimer];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_scanLine removeFromSuperview];
        _scanLine = nil;
    });
}

//处理url host
- (NSString *)dealURLClassToCCAPI:(NSString *)result
{
    NSURL *qrURL = [NSURL URLWithString:result];
    NSString *host = qrURL.host;
    return host;
}

-(void)parseCodeStr:(NSString *)result
{
    if (ENV_TEST == 1)
    {
        result = [result stringByReplacingOccurrencesOfString:@"cloudclass.csslcloud" withString:@"class.csslcloud"];
    }
    NSURL *url = [NSURL URLWithString:result];
    NSString *host = [url host];
    
    NSString *bothString = @"cloudclass.csslcloud";
    if ([host containsString:bothString])
    {
        [self parseCodeStringBoth:result];
    }
    else
    {
        [self parseCodeStrAfter:result];
    }
}

-(void)parseCodeStringBoth:(NSString *)result
{
    WS(weakSelf);
    NSString *originUrl = result;
    // 快捷方式获得session对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:result];
    NSString *originHost = [url host];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadingViewShow];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSURL *url = [response URL];
        [self loadViewRemove];
        if (error || !url)
        {
            [CCTool showMessage:HDClassLocalizeString(@"扫描地址异常！") ];
            return ;
        }
        NSString *newHost = [url host];
        NSString *finalUrl = [originUrl stringByReplacingOccurrencesOfString:originHost withString:newHost];
        NSLog(@"real request url :%@",finalUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf parseCodeStrAfter:finalUrl];
        });
    }];
    [task resume];
}
- (void)scanError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:HDClassLocalizeString(@"扫描错误") message:HDClassLocalizeString(@"没有识别到有效的二维码信息") preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:HDClassLocalizeString(@"好") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self singleTap];
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)parseCodeStrAfter:(NSString *)result {
    NSLog(@"result = %@",result);
    //http://cloudclass.csslcloud.net/index/talker/?roomid=7BB77011E61154E39C33DC5901307461&userid=83F203DAC2468694&template=32
    WS(ws)
    if (!StrNotEmpty(result) && ![result hasPrefix:@"http"])
    {
        [self scanError];
        return;
    }
    
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
        [self scanError];
        return;
    }
    resultNew = [HDSTool getUrlStringWithString:resultNew];
    NSURL *url = [NSURL URLWithString:resultNew];
    NSString *path = [[url path]lastPathComponent];
    NSString *role = path;
    NSLog(@"roomId = %@,userId = %@,role = %@",roomId,userId,role);
    
    SaveToUserDefaults(LIVE_USERID,userId);
    SaveToUserDefaults(LIVE_ROOMID,roomId);
    
    //设置服务器地址
    NSString *urlDealed = [self dealURLClassToCCAPI:resultNew];
    [[CCStreamerBasic sharedStreamer]setServerDomain:urlDealed area:nil];
    [[CCStreamerBasic sharedStreamer]setNeedJoinMixStream:YES];
    
    [self stopSession];
    NSLog(@"%@", roomId);
    [self loadingViewShow];
    [CCRoomDecModel getRoomDescWithRoomID:roomId classCode:@"" completion:^(BOOL result, NSError *error, id info) {
        CCRoomDecModel *model = (CCRoomDecModel *)info;
        [self loadViewRemove];
        if (result) {
            if ([model.result isEqualToString:@"OK"]) {
                HDSTool *tool = [HDSTool sharedTool];
                tool.roomSubMode = model.data.layout_mode;
                
                SaveToUserDefaults(LIVE_ROOMNAME, model.data.name);
                SaveToUserDefaults(LIVE_ROOMDESC, model.data.desc);
                
                NSInteger authKey = [CCRoomDecModel authTypeKeyForRole:role model:model.data];
                
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                userInfo[@"userID"] = userId;
                userInfo[@"roomID"] = roomId;
                userInfo[@"role"] = role;
                userInfo[@"authtype"] = @(authKey);
                [ws.navigationController popViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanSuccess" object:nil userInfo:userInfo];
            }
            else
            {
                [CCTool showMessage:model.errorMsg];
                [ws.navigationController popViewControllerAnimated:NO];
            }
        }else {
            [HDSTool showAlertTitle:HDClassLocalizeString(@"注意") msg:error.localizedDescription completion:^(BOOL cancelled, NSInteger buttonIndex) {
                [ws.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

-(void)stopTimer {
    if([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
    
    if([_scanTimer isValid]) {
        [_scanTimer invalidate];
    }
    _scanTimer = nil;
}

-(void)judgeCameraStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            NSError *error;
            // Input
            _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
            if (error)
            {
                [HDSTool showAlertTitle:@"" msg:HDClassLocalizeString(@"相机打开失败") completion:^(BOOL cancelled, NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:NO];
                }];
            }
            else
            {
                // Output
                _output = [[AVCaptureMetadataOutput alloc]init];
                [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
                
                // Session
                _session = [[AVCaptureSession alloc]init];
                [_session setSessionPreset:AVCaptureSessionPresetHigh];
                
                if ([_session canAddInput:self.input])
                {
                    [_session addInput:self.input];
                }
                
                if ([_session canAddOutput:self.output])
                {
                    [_session addOutput:self.output];
                }
                BOOL supportScan = NO;
                for (NSString *type in _output.availableMetadataObjectTypes)
                {
                    if ([type isEqualToString:AVMetadataObjectTypeQRCode])
                    {
                        supportScan = YES;
                        break;
                    }
                }
                if (supportScan)
                {
                    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
                    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
                    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
                    _preview.frame =self.view.layer.bounds;
                    [self.view.layer insertSublayer:_preview atIndex:0];
                    [_session startRunning];
                    
                    [self addScanViews];
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self startTimer];
                    });
                }
                else
                {
                    [HDSTool showAlertTitle:@"" msg:HDClassLocalizeString(@"相机打开失败") completion:^(BOOL cancelled, NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:NO];
                    }];
                }
            }
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            [self addCannotScanViews];
            
            _scanOverViewController = [[CCScanOverViewController alloc] initWithBlock:^{
                [_scanOverViewController removeFromParentViewController];
                [self.navigationController popViewControllerAnimated:NO];
            }];
            [self.navigationController addChildViewController:_scanOverViewController];
        }
            break;
        default:
            break;
    }
}

-(void)onSelectVC {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onSelectPic {
    WS(ws)
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch(status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status == PHAuthorizationStatusAuthorized) {
                    [ws pickImage];
                } else if(status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                    [self pushNoCCPhotoNotPermissionVC];
                }
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized: {
            [ws pickImage];
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied: {
            NSLog(@"4");
            [self pushNoCCPhotoNotPermissionVC];
        }
            break;
        default:
            break;
    }
}
- (void)pushNoCCPhotoNotPermissionVC
{
    main_async_safe(^{
        _photoNotPermissionVC = [CCPhotoNotPermissionVC new];
        [self.navigationController pushViewController:_photoNotPermissionVC animated:NO];
    });
}

-(void)addCannotScanViews {
    WS(ws)
    [self.view addSubview:self.overView];
    [_overView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.view);
    }];
    
    [_overView addSubview:self.centerView];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(175));
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(398));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(400), CCGetRealFromPt(400)));
    }];
    
    [_overView addSubview:self.bottomLabel];
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.centerView.mas_bottom);
        make.left.mas_equalTo(ws.view);
        make.right.mas_equalTo(ws.view);
        make.height.mas_equalTo(CCGetRealFromPt(108));
    }];
}

-(void)addScanViews {
    WS(ws)
    [self.view addSubview:self.overView];
    [_overView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.view);
    }];
    
    [_overView addSubview:self.centerView];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(CCGetRealFromPt(175));
        make.top.mas_equalTo(ws.view).offset(CCGetRealFromPt(398));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(400), CCGetRealFromPt(400)));
    }];
    
    [_centerView addSubview:self.scanLine];
    [_scanLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(ws.centerView);
        make.height.mas_equalTo(CCGetRealFromPt(4));
    }];
    
    _topView = [UIView new];
    _topView.backgroundColor = CCRGBAColor(0, 0, 0, 0.8);
    [_overView addSubview:_topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(ws.overView);
        make.bottom.mas_equalTo(ws.centerView.mas_top);
    }];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = CCRGBAColor(0, 0, 0, 0.8);
    [_overView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(ws.overView);
        make.top.mas_equalTo(ws.centerView.mas_bottom);
    }];
    
    _leftView = [UIView new];
    _leftView.backgroundColor = CCRGBAColor(0, 0, 0, 0.8);
    [_overView addSubview:_leftView];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(ws.centerView);
        make.left.mas_equalTo(ws.overView);
        make.right.mas_equalTo(ws.centerView.mas_left);
    }];
    
    _rightView = [UIView new];
    _rightView.backgroundColor = CCRGBAColor(0, 0, 0, 0.8);
    [_overView addSubview:_rightView];
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(ws.centerView);
        make.right.mas_equalTo(ws.overView);
        make.left.mas_equalTo(ws.centerView.mas_right);
    }];
    
    [self.overView addSubview:self.bottomLabel];
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.centerView.mas_bottom);
        make.left.mas_equalTo(ws.view);
        make.right.mas_equalTo(ws.view);
        make.height.mas_equalTo(CCGetRealFromPt(108));
    }];
}


#pragma mark - 读取图片中的二维码
/**
 *  读取图片中的二维码
 *
 *  @param image 图片
 *
 *  @return 图片中的二维码数据集合 CIQRCodeFeature对象
 */
- (NSArray *)readQRCodeFromImageFilter:(UIImage *)image{
    // 创建一个CIImage对象
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
    // 注意这里的CIDetectorTypeQRCode
    NSArray *features = [detector featuresInImage:ciImage];
    NSLog(@"features = %@",features); // 识别后的结果集
    for (CIQRCodeFeature *feature in features) {
        NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
    }
    
    return features;
}

- (void)readQRCodeFromImage:(UIImage *)image
{
    // 读取图片中的二维码
    NSArray *array = [self readQRCodeFromImageFilter:image];
    // 显示二维码中的信息
    NSMutableString *str = [[NSMutableString alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CIQRCodeFeature *temp = (CIQRCodeFeature *)obj;
        [str appendFormat:@"%@",temp.messageString];
    }];
    
    [self parseCodeStr:str];
}
-(void)pickImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pickImageOnMainThread];
    });
}

-(void)pickImageOnMainThread {
#ifndef USELOCALPHOTOLIBARY
    [self pushImagePickerController];
#else
    if([self isPhotoLibraryAvailable]) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.view.backgroundColor = [UIColor clearColor];
        UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _picker.sourceType = sourcheType;
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        [self presentViewController:_picker animated:YES completion:nil];
    }
#endif
}

//支持相片库
- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    WS(ws)
    [_picker dismissViewControllerAnimated:YES completion:^{
        [ws readQRCodeFromImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    WS(ws)
    [_picker dismissViewControllerAnimated:YES completion:^{
        [ws singleTap];
    }];
}

#pragma mark - tz
- (void)pushImagePickerController
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;
//    imagePickerVc.allowEdited = YES;
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(TZImagePickerController *) weakPicker = imagePickerVc;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakPicker dismissViewControllerAnimated:YES completion:^{
            if (photos.count > 0)
            {
                [weakSelf readQRCodeFromImage:photos.lastObject];
            }
        }];
    }];
    [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        
    }];
    imagePickerVc.modalPresentationStyle = 0;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 懒加载
-(UIBarButtonItem *)leftBarBtn {
    if(_leftBarBtn == nil) {
        UIImage *aimage = [UIImage imageNamed:@"nav_ic_back_nor"];
        UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _leftBarBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onSelectVC)];
    }
    return _leftBarBtn;
}

-(UIBarButtonItem *)rightBarPicBtn {
    if(_rightBarPicBtn == nil) {
        _rightBarPicBtn = [[UIBarButtonItem alloc] initWithTitle:HDClassLocalizeString(@"相册") style:UIBarButtonItemStylePlain target:self action:@selector(onSelectPic)];
        [_rightBarPicBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:FontSizeClass_16],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    }
    return _rightBarPicBtn;
}

-(UIView *)overView {
    if(!_overView) {
        _overView = [UIView new];
        _overView.backgroundColor = CCClearColor;
    }
    return _overView;
}

-(UIImageView *)centerView {
    if(!_centerView) {
        _centerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_white"]];
        _centerView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerView;
}

-(UIImageView *)scanLine {
    if(!_scanLine) {
        _scanLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QRCodeLine"]];
        _centerView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _scanLine;
}

-(UILabel *)bottomLabel {
    if(!_bottomLabel) {
        _bottomLabel = [UILabel new];
        _bottomLabel.text = HDClassLocalizeString(@"将二维码置于框中，即可自动扫描") ;
        _bottomLabel.font = [UIFont systemFontOfSize:FontSizeClass_13];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.numberOfLines = 1;
        _bottomLabel.textColor = CCRGBAColor(255,255,255,0.4);
    }
    return _bottomLabel;
}

-(UILabel *)overCenterViewTopLabel {
    if(!_overCenterViewTopLabel) {
        _overCenterViewTopLabel = [UILabel new];
        _overCenterViewTopLabel.text = HDClassLocalizeString(@"未发现二维码") ;
        _overCenterViewTopLabel.font = [UIFont systemFontOfSize:FontSizeClass_14];
        _overCenterViewTopLabel.textAlignment = NSTextAlignmentCenter;
        _overCenterViewTopLabel.numberOfLines = 1;
        _overCenterViewTopLabel.textColor = [UIColor whiteColor];
    }
    return _overCenterViewTopLabel;
}

-(UILabel *)overCenterViewBottomLabel {
    if(!_overCenterViewBottomLabel) {
        _overCenterViewBottomLabel = [UILabel new];
        _overCenterViewBottomLabel.text = HDClassLocalizeString(@"轻触屏幕继续扫描") ;
        _overCenterViewBottomLabel.font = [UIFont systemFontOfSize:FontSizeClass_13];
        _overCenterViewBottomLabel.textAlignment = NSTextAlignmentCenter;
        _overCenterViewBottomLabel.numberOfLines = 1;
        _overCenterViewBottomLabel.textColor = CCRGBAColor(255, 255, 255, 0.69);
    }
    return _overCenterViewBottomLabel;
}

-(UITapGestureRecognizer *)singleRecognizer {
    if(!_singleRecognizer) {
        _singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        _singleRecognizer.numberOfTapsRequired = 1; // 单击
    }
    return _singleRecognizer;
}
#pragma mark - 生命结束
-(void)dealloc {
    [_session stopRunning];
    [_scanLine removeFromSuperview];
    _scanLine = nil;
    [self stopTimer];
}

@end
