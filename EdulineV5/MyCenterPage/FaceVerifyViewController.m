//
//  FaceVerifyViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2021/11/29.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "FaceVerifyViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "VideoCaptureDevice.h"

@interface FaceVerifyViewController ()<CaptureDataOutputProtocol>

@property (nonatomic, readwrite, retain) VideoCaptureDevice *videoCapture;

@property (strong, nonatomic) UIImageView *finalFaceImage;

@property (strong, nonatomic) UIImageView *cameraImage;
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;

@property (strong, nonatomic) UIButton *photoButton;
@property (strong, nonatomic) UIButton *rephotographButton;
@property (strong, nonatomic) UIButton *verifyButton;

@property (strong, nonatomic) UIButton *unboundButton;
@property (strong, nonatomic) UIButton *verifyingButton;

@end

@implementation FaceVerifyViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hasFinished = YES;
    self.videoCapture.runningStatus = NO;
    [self.videoCapture stopSession];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasFinished = NO;
    self.videoCapture.runningStatus = YES;
    [self.videoCapture startSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleLabel.text = _isVerify ? @"人脸认证" : @"人脸验证";
    _lineTL.hidden = YES;
    [self makeSubView];
    // 初始化相机处理类
    self.videoCapture = [[VideoCaptureDevice alloc] init];
    self.videoCapture.delegate = self;
    
    // 监听重新返回APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)makeSubView {
    _cameraImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 40, 306, 306)];
    _cameraImage.image = Image(@"circle_bg");
    [self.view addSubview:_cameraImage];
    _cameraImage.centerX = MainScreenWidth / 2.0;
    
    _finalFaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 238, 238)];
    _finalFaceImage.backgroundColor = [UIColor clearColor];
    _finalFaceImage.layer.masksToBounds = YES;
    _finalFaceImage.layer.cornerRadius = _finalFaceImage.width / 2.0;
    _finalFaceImage.center = _cameraImage.center;
    [self.view addSubview:_finalFaceImage];
    
    NSArray *buttonTitle = @[@"正对手机",@"光线充足",@"脸无遮挡"];
    NSArray *buttonImage = @[@"phone_icon",@"light_icon",@"face_icon"];
    CGFloat xx = (MainScreenWidth - 50.0 * buttonTitle.count) / 4.0;
    for (int i = 0; i<buttonTitle.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(xx + (50.0 + xx) * i, _cameraImage.bottom + 64, 50, 22 + 12 + 20)];
        [btn setTitle:buttonTitle[i] forState:0];
        [btn setImage:Image(buttonImage[i]) forState:0];
        btn.titleLabel.font = SYSTEMFONT(12);
        [btn setTitleColor:EdlineV5_Color.textSecendColor forState:0];
        
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = btn.titleLabel.intrinsicContentSize.width;
            labelHeight = btn.titleLabel.intrinsicContentSize.height;
        } else {
            labelWidth = btn.titleLabel.frame.size.width;
            labelHeight = btn.titleLabel.frame.size.height;
        }
        btn.imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-10/2.0, 0, 0, -labelWidth);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-10/2.0, 0);
        btn.tag = 66 + i;
        [self.view addSubview:btn];
    }
    
    _photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _cameraImage.bottom + 64 + (22 + 12 + 20) + 50, 128, 40)];
    _photoButton.backgroundColor = EdlineV5_Color.themeColor;
    _photoButton.layer.masksToBounds = YES;
    _photoButton.layer.cornerRadius = 5.0;
    [_photoButton setImage:Image(@"camera_icon") forState:0];
    [_photoButton setTitle:@"拍照" forState:0];
    _photoButton.titleLabel.font = SYSTEMFONT(15);
    [_photoButton setTitleColor:[UIColor whiteColor] forState:0];
    _photoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -1.5, 0, 1.5);
    _photoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 1.5, 0, -1.5);
    [_photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_photoButton];
    _photoButton.centerX = MainScreenWidth / 2.0;
    
    _unboundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _photoButton.top, 128, 40)];
    _unboundButton.backgroundColor = [UIColor whiteColor];
    _unboundButton.layer.masksToBounds = YES;
    _unboundButton.layer.cornerRadius = 5.0;
    _unboundButton.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
    _unboundButton.layer.borderWidth = 1.0;
    [_unboundButton setTitle:@"解除绑定" forState:0];
    _unboundButton.titleLabel.font = SYSTEMFONT(15);
    [_unboundButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_unboundButton addTarget:self action:@selector(unboundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_unboundButton];
    _unboundButton.centerX = MainScreenWidth / 2.0;
    _unboundButton.hidden = YES;
    
    _verifyingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _photoButton.top, 128, 40)];
    _verifyingButton.backgroundColor = EdlineV5_Color.themeColor;
    _verifyingButton.layer.masksToBounds = YES;
    _verifyingButton.layer.cornerRadius = 5.0;
    [_verifyingButton setTitle:@"验证中..." forState:0];
    _verifyingButton.titleLabel.font = SYSTEMFONT(15);
    [_verifyingButton setTitleColor:[UIColor whiteColor] forState:0];
    [_verifyingButton addTarget:self action:@selector(verifyingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verifyingButton];
    _verifyingButton.centerX = MainScreenWidth / 2.0;
    _verifyingButton.hidden = YES;
    
    _rephotographButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0 - 8 - 128, _photoButton.top, 128, 40)];
    _rephotographButton.backgroundColor = [UIColor whiteColor];
    _rephotographButton.layer.masksToBounds = YES;
    _rephotographButton.layer.cornerRadius = 5.0;
    _rephotographButton.layer.borderColor = EdlineV5_Color.themeColor.CGColor;
    _rephotographButton.layer.borderWidth = 1.0;
    [_rephotographButton setTitle:@"重拍" forState:0];
    _rephotographButton.titleLabel.font = SYSTEMFONT(15);
    [_rephotographButton setTitleColor:EdlineV5_Color.themeColor forState:0];
    [_rephotographButton addTarget:self action:@selector(rephotographButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rephotographButton];
    
    _verifyButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2.0 + 8, _photoButton.top, 128, 40)];
    _verifyButton.backgroundColor = EdlineV5_Color.themeColor;
    _verifyButton.layer.masksToBounds = YES;
    _verifyButton.layer.cornerRadius = 5.0;
    [_verifyButton setTitle:@"确认" forState:0];
    _verifyButton.titleLabel.font = SYSTEMFONT(15);
    [_verifyButton setTitleColor:[UIColor whiteColor] forState:0];
    [_verifyButton addTarget:self action:@selector(verifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verifyButton];
    
    _rephotographButton.hidden = YES;
    _verifyButton.hidden = YES;
}

- (void)photoButtonClick:(UIButton *)sender {
    _hasFinished = YES;
    _rephotographButton.hidden = NO;
    _verifyButton.hidden = NO;
    _photoButton.hidden = YES;
}

- (void)rephotographButtonClick:(UIButton *)sender {
    _hasFinished = NO;
    _rephotographButton.hidden = YES;
    _verifyButton.hidden = YES;
    _photoButton.hidden = NO;
}

- (void)verifyButtonClick:(UIButton *)sender {
    if (_finalFaceImage.image) {
        _rephotographButton.hidden = YES;
        _verifyButton.hidden = YES;
        _photoButton.hidden = YES;
        _verifyingButton.hidden = NO;
        [self faceProcesss:_finalFaceImage.image];
    }
}

- (void)unboundButtonClick:(UIButton *)sender {
    
}

- (void)verifyingButtonClick:(UIButton *)sender {
    
}

#pragma mark - CaptureDataOutputProtocol

- (void)captureOutputSampleBuffer:(UIImage *)image {
    if (_hasFinished) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.finalFaceImage.image = image;
    });
}

- (void)captureError {
    NSString *errorStr = @"出现未知错误，请检查相机设置";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        errorStr = @"相机权限受限,请在设置中启用";
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"知道啦");
        }];
        [alert addAction:action];
        UIViewController* fatherViewController = weakSelf.presentingViewController;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [fatherViewController presentViewController:alert animated:YES completion:nil];
        }];
    });
}

// MARK: - 请求借口校验
- (void)faceProcesss:(UIImage *)image {
    
}

// MARK: - Notification

- (void)onAppWillResignAction {
    _hasFinished = YES;
}

- (void)onAppBecomeActive {
    _hasFinished = NO;
}

- (void)setHasFinished:(BOOL)hasFinished {
    _hasFinished = hasFinished;
    if (hasFinished) {
        [self.videoCapture stopSession];
        self.videoCapture.delegate = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
