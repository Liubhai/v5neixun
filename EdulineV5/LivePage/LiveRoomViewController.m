//
//  LiveRoomViewController.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveRoomViewController.h"
#import "LiveRoomPersonCell.h"
#import "V5_Constant.h"
#import "AppDelegate.h"
#import <TEduBoard/TEduBoard.h>

@interface LiveRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TEduBoardDelegate>

@property (assign, nonatomic) BOOL isFullScreen;
@property (strong, nonatomic) NSMutableArray *livePersonArray;
@property (strong, nonatomic) UIView *boardView;

@end

@implementation LiveRoomViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    
    _livePersonArray = [NSMutableArray new];
    
    [self makeLiveSubView];
    // 接收屏幕方向改变通知,监听屏幕方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationHandler) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc {
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [[[TICManager sharedInstance] getBoardController] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[TICManager sharedInstance] removeEventListener:self];
    [[TICManager sharedInstance] removeMessageListener:self];
    [[TICManager sharedInstance] quitClassroom:NO callback:^(TICModule module, int code, NSString *desc) {
        if(code == 0){
            //退出课堂成功
        }
        else{
            //退出课堂失败
        }
    }];
}

- (void)makeLiveSubView {
    _liveBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_STATUSBAR_HEIGHT, MainScreenWidth, (MainScreenWidth - 113)*3/4.0 + 37 * 2)];//画板高度+上下黑色背景高度
    _liveBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_liveBackView];
    
    _topBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _liveBackView.width, 37)];
    _topBlackView.backgroundColor = EdlineV5_Color.textFirstColor;
    [_liveBackView addSubview:_topBlackView];
    
    [self makeBoardView];
    
    _topToolBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _liveBackView.width, 37)];
    _topToolBackView.layer.masksToBounds = YES;
    _topToolBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    [_liveBackView addSubview:_topToolBackView];
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    [_leftBtn setImage:Image(@"nav_back_white") forState:0];
    [_leftBtn addTarget:self action:@selector(onQuitClassRoom) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBackView addSubview:_leftBtn];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftBtn.right, 0, MainScreenWidth, 37)];
    _themeLabel.textColor = [UIColor whiteColor];
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.text = @"欢迎来到本直播间";
    [_topToolBackView addSubview:_themeLabel];
    
    _cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 7.5 - 37, 0, 37, 37)];
    [_cameraBtn setImage:Image(@"cam_open") forState:UIControlStateSelected];
    [_cameraBtn setImage:Image(@"cam_close") forState:0];
    [_cameraBtn addTarget:self action:@selector(swicthCamera:) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBackView addSubview:_cameraBtn];
    
    _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cameraBtn.left - 37, 0, 37, 37)];
    [_voiceBtn setImage:Image(@"mic_open") forState:UIControlStateSelected];
    [_voiceBtn setImage:Image(@"mic_close") forState:0];
    [_voiceBtn addTarget:self action:@selector(switchVoice:) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBackView addSubview:_voiceBtn];
    
    _lianmaiBtn = [[UIButton alloc] initWithFrame:CGRectMake(_voiceBtn.left - 100, 0, 100, 22)];
    _lianmaiBtn.layer.masksToBounds = YES;
    _lianmaiBtn.layer.cornerRadius = 11;
    _lianmaiBtn.backgroundColor = HEXCOLOR(0x67C23A);
    _lianmaiBtn.titleLabel.font = SYSTEMFONT(14);
    
    NSString *commentCount = @"连麦";
    CGFloat commentWidth = [commentCount sizeWithFont:SYSTEMFONT(14)].width + 4 + 11 + 7.5 *2;
    CGFloat space = 5.0;
    _lianmaiBtn.frame = CGRectMake(_voiceBtn.left - 7.5 - commentWidth, 0, commentWidth, 22);
    _lianmaiBtn.centerY = 37/2.0;
    [_lianmaiBtn setImage:Image(@"live_phone") forState:0];
    [_lianmaiBtn setTitle:commentCount forState:0];
    [_lianmaiBtn setTitleColor:[UIColor whiteColor] forState:0];
    _lianmaiBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    _lianmaiBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    [_topToolBackView addSubview:_lianmaiBtn];
    
    _bottomBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, (MainScreenWidth - 113)*3/4.0 + 37, _liveBackView.width, 37)];
    _bottomBlackView.backgroundColor = EdlineV5_Color.textFirstColor;
    [_liveBackView addSubview:_bottomBlackView];
    
    _bottomToolBackView = [[UIView alloc] initWithFrame:CGRectMake(0, (MainScreenWidth - 113)*3/4.0 + 37, _liveBackView.width, 37)];
    _bottomToolBackView.layer.masksToBounds = YES;
    _bottomToolBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    [_liveBackView addSubview:_bottomToolBackView];
    
    _fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 7.5 - 37, 0, 37, 37)];
    [_fullScreenBtn setImage:Image(@"play_full_icon") forState:0];
    [_fullScreenBtn setImage:Image(@"play_suoxiao_icon") forState:UIControlStateSelected];
    [_fullScreenBtn addTarget:self action:@selector(fullButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBackView addSubview:_fullScreenBtn];
    
    NSString *roomMember = @"90";
    CGFloat roomMemberWidth = [roomMember sizeWithFont:SYSTEMFONT(14)].width + 4 + 11 + 7.5 *2;
    CGFloat space1 = 5.0;
    _roomPersonCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(_fullScreenBtn.left - 7.5 - roomMemberWidth, 0, roomMemberWidth, 37)];
    _roomPersonCountBtn.centerY = 37/2.0;
    _roomPersonCountBtn.titleLabel.font = SYSTEMFONT(14);
    [_roomPersonCountBtn setImage:Image(@"live_member") forState:0];
    [_roomPersonCountBtn setTitle:roomMember forState:0];
    [_roomPersonCountBtn setTitleColor:[UIColor whiteColor] forState:0];
    _roomPersonCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space1/2.0, 0, space1/2.0);
    _roomPersonCountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space1/2.0, 0, -space1/2.0);
    [_bottomToolBackView addSubview:_roomPersonCountBtn];
    
    [self makeCollectionView];
}

// MARK: - 白板
- (void)makeBoardView {
    //白板视图
    [[[TICManager sharedInstance] getBoardController] addDelegate:self];
    _boardView = [[[TICManager sharedInstance] getBoardController] getBoardRenderView];
    _boardView.frame = CGRectMake(0, _topBlackView.bottom, MainScreenWidth - 113, (MainScreenWidth - 113)*3/4.0);
    [_liveBackView addSubview:_boardView];
}

- (void)makeCollectionView {
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake(113, 64);
    cellLayout.minimumInteritemSpacing = 0;
    cellLayout.minimumLineSpacing = 2;
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(MainScreenWidth - 113, _topBlackView.bottom, 113, (MainScreenWidth - 113)*3/4.0) collectionViewLayout:cellLayout];
    if (_isFullScreen) {
        [_collectionView setSize:CGSizeMake(113 * 2 + 2, (MainScreenWidth - 113)*3/4.0)];
    } else {
        [_collectionView setSize:CGSizeMake(113, (MainScreenWidth - 113)*3/4.0)];
    }
    [_collectionView registerClass:[LiveRoomPersonCell class] forCellWithReuseIdentifier:@"LiveRoomPersonCell"];
    _collectionView.backgroundColor = EdlineV5_Color.textFirstColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_liveBackView addSubview:_collectionView];
    [_collectionView reloadData];
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self changeRoomMenberCountUI];
    return _livePersonArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LiveRoomPersonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveRoomPersonCell" forIndexPath:indexPath];
    [cell setLiveUserInfo:_livePersonArray[indexPath.row] localUserId:_userId];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

// MARK: - 全屏切换按钮点击事件

// MARK: 点击btn按钮
- (void)fullButtonClick:(UIButton *)sender {
    // 这里我是通过按钮的selected状态来判定横屏竖屏的,并不是唯一的判断标准
    if (sender.selected) {
        [self changeOrientation:UIInterfaceOrientationPortrait];
    }else{
        [self changeOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

- (void)changeOrientation:(UIInterfaceOrientation)orientation
{
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

// 通知方法
- (void)orientationHandler {
    
// 在这里可进行屏幕旋转时的处理

    // 获取当前设备方向
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    // 动画时长
    NSTimeInterval duration = 0.3;
    // 获取宽高
    CGFloat w = CGRectGetWidth(self.view.bounds);
    CGFloat h = CGRectGetHeight(self.view.bounds);
    
    // 处理方法,该方法参数根据跟人情况而定
    [self fullScreenWithUIDeviceOrientation:orient duration:duration width:w height:h];
    
}

// 处理横屏竖屏
- (void)fullScreenWithUIDeviceOrientation:(UIDeviceOrientation)orientation duration:(NSTimeInterval)duration width:(CGFloat)width height:(CGFloat)height {
    
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationPortraitUpsideDown) return;
    
    if (orientation == UIDeviceOrientationPortrait) {
        // 竖屏
        // 处理方法
        _isFullScreen = NO;
        [self showFullScreen];
    }else{
        // 向左旋转或向右旋转
        // 处理方法
        _isFullScreen = YES;
        [self showFullScreen];
    }
}

- (void)showFullScreen {
    if (_isFullScreen) {
        
        _liveBackView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        _topBlackView.frame = CGRectMake(0, 0, _liveBackView.width, 24);
        _topToolBackView.frame = CGRectMake(0, 0, _liveBackView.width, 37);
        
        _leftBtn.frame = CGRectMake(0, 0, 37, 37);
        
        _themeLabel.frame = CGRectMake(_leftBtn.right, 0, _liveBackView.width, 37);
        
        _cameraBtn.frame = CGRectMake(_liveBackView.width - 7.5 - 37, 0, 37, 37);
        
        _voiceBtn.frame = CGRectMake(_cameraBtn.left - 37, 0, 37, 37);
        [_lianmaiBtn setRight:_voiceBtn.left - 7.5];
        
        _boardView.frame = CGRectMake(0, _topBlackView.bottom, _liveBackView.width - (113 * 2 + 2), _liveBackView.height - 24 * 2);
        
        _bottomBlackView.frame = CGRectMake(0, _liveBackView.height - 24, _liveBackView.width, 24);
        
        _bottomToolBackView.frame = CGRectMake(0, _liveBackView.height - 37, _liveBackView.width, 37);
        
        _fullScreenBtn.frame = CGRectMake(_liveBackView.width - 7.5 - 37, 0, 37, 37);
        _fullScreenBtn.selected = YES;
        
        [_roomPersonCountBtn setRight:_fullScreenBtn.left - 7.5];
        
        _collectionView.frame = CGRectMake(_liveBackView.width - (113 * 2 + 2), _topBlackView.bottom, 113 * 2 + 2, _boardView.height);
    } else {
        
        _liveBackView.frame = CGRectMake(0, MACRO_UI_STATUSBAR_HEIGHT, MainScreenWidth, (MainScreenWidth - 113)*3/4.0 + 37 * 2);//画板高度+上下黑色背景高度
        
        _topBlackView.frame = CGRectMake(0, 0, _liveBackView.width, 37);
        _topToolBackView.frame = CGRectMake(0, 0, _liveBackView.width, 37);
        
        _leftBtn.frame = CGRectMake(0, 0, 37, 37);
        
        _themeLabel.frame = CGRectMake(_leftBtn.right, 0, _liveBackView.width, 37);
        
        _cameraBtn.frame = CGRectMake(_liveBackView.width - 7.5 - 37, 0, 37, 37);
        
        _voiceBtn.frame = CGRectMake(_cameraBtn.left - 37, 0, 37, 37);
        [_lianmaiBtn setRight:_voiceBtn.left - 7.5];
        
        _boardView.frame = CGRectMake(0, _topBlackView.bottom, _liveBackView.width - 113, _liveBackView.height - 37 * 2);
        
        _bottomBlackView.frame = CGRectMake(0, _liveBackView.height - 37, _liveBackView.width, 37);
        
        _bottomToolBackView.frame = CGRectMake(0, _liveBackView.height - 37, _liveBackView.width, 37);
        
        _fullScreenBtn.frame = CGRectMake(_liveBackView.width - 7.5 - 37, 0, 37, 37);
        _fullScreenBtn.selected = NO;
        [_roomPersonCountBtn setRight:_fullScreenBtn.left - 7.5];
        
        _collectionView.frame = CGRectMake(_liveBackView.width - 113, _topBlackView.bottom, 113, _boardView.height);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CATransaction setDisableActions:YES];
        
        [_collectionView reloadData];
        
        [CATransaction commit];
    });
}

// MARK: - 白板代理
#pragma mark - board delegate
- (void)onTEBRedoStatusChanged:(BOOL)canRedo
{
    
}

- (void)onTEBUndoStatusChanged:(BOOL)canUndo
{
    
}

// MARK: - 退出互动课堂
- (void)onQuitClassRoom
{
    if (_isFullScreen) {
        [self fullButtonClick:_fullScreenBtn];
        return;
    }
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    [[[TICManager sharedInstance] getBoardController] removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[TICManager sharedInstance] removeEventListener:self];
    [[TICManager sharedInstance] removeMessageListener:self];
    __weak typeof(self) ws = self;
    [[TICManager sharedInstance] quitClassroom:NO callback:^(TICModule module, int code, NSString *desc) {
        if(code == 0){
            //退出课堂成功
        }
        else{
            //退出课堂失败
        }
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

// MARK: - 开关摄像头
- (void)swicthCamera:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_livePersonArray removeObject:_userId];
    if (sender.selected) {
        [_livePersonArray addObject:_userId];
    } else {
        [[[TICManager sharedInstance] getTRTCCloud] stopLocalPreview];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CATransaction setDisableActions:YES];
        
        [_collectionView reloadData];
        
        [CATransaction commit];
    });
}

// MARK: - 开关麦克风
- (void)switchVoice:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[[TICManager sharedInstance] getTRTCCloud] startLocalAudio];
    } else {
        [[[TICManager sharedInstance] getTRTCCloud] stopLocalAudio];
    }
}

// MARK: - event listener
- (void)onTICUserVideoAvailable:(NSString *)userId available:(BOOL)available
{
    if(available){
        [_livePersonArray addObject:userId];
    }
    else{
        [_livePersonArray removeObject:userId];
        [[[TICManager sharedInstance] getTRTCCloud] stopRemoteView:userId];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [CATransaction setDisableActions:YES];
        
        [_collectionView reloadData];
        
        [CATransaction commit];
    });
}

- (void)onTICUserSubStreamAvailable:(NSString *)userId available:(BOOL)available
{
//    if(available){
//        [_livePersonArray addObject:userId];
//    }
//    else{
//        [_livePersonArray removeObject:userId];
//        [[[TICManager sharedInstance] getTRTCCloud] stopRemoteView:userId];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [CATransaction setDisableActions:YES];
//
//        [_collectionView reloadData];
//
//        [CATransaction commit];
//    });
}


-(void)onTICMemberJoin:(NSArray*)members {
    NSString *msgInfo = [NSString stringWithFormat:@"[%@] %@",members.firstObject, @"加入了房间"];
    [self showHudInView:self.view showHint:msgInfo];
//    self.chatView.text = [NSString stringWithFormat:@"%@\n%@",self.chatView.text, msgInfo];;
}

-(void)onTICMemberQuit:(NSArray*)members {

    if ([members.firstObject isEqualToString:[[TIMManager sharedInstance] getLoginUser]]) {
        [self showAlertWithTitle:@"退出课堂" msg:@"你被老师踢出了房间" handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    NSString *msgInfo = [NSString stringWithFormat:@"[%@] %@",members.firstObject, @"退出了房间"];
    [self showHudInView:self.view showHint:msgInfo];
//    self.chatView.text = [NSString stringWithFormat:@"%@\n%@",self.chatView.text, msgInfo];;
}


-(void)onTICClassroomDestroy {
    [self showAlertWithTitle:@"课程结束" msg:@"老师已经结束了该堂课程" handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

// MARK: - 改变房间人数显示UI
- (void)changeRoomMenberCountUI {
    NSInteger roomcount = 0;
    if ([_livePersonArray containsObject:_userId]) {
        roomcount = _livePersonArray.count;
    } else {
        roomcount = _livePersonArray.count + 1;
    }
    NSString *roomMember = [NSString stringWithFormat:@"%@",@(roomcount)];
    CGFloat roomMemberWidth = [roomMember sizeWithFont:SYSTEMFONT(14)].width + 4 + 11 + 7.5 *2;
    CGFloat space1 = 5.0;
    _roomPersonCountBtn.frame= CGRectMake(_fullScreenBtn.left - 7.5 - roomMemberWidth, 0, roomMemberWidth, 37);
    _roomPersonCountBtn.centerY = 37/2.0;
    [_roomPersonCountBtn setImage:Image(@"live_member") forState:0];
    [_roomPersonCountBtn setTitle:roomMember forState:0];
    _roomPersonCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -space1/2.0, 0, space1/2.0);
    _roomPersonCountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, space1/2.0, 0, -space1/2.0);
}

@end
