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

@interface LiveRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (assign, nonatomic) BOOL isFullScreen;
@property (strong, nonatomic) NSMutableArray *livePersonArray;

@end

@implementation LiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.hidden = YES;
    
    _livePersonArray = [NSMutableArray new];
    
    [self makeLiveSubView];
}

- (void)makeLiveSubView {
    _liveBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_STATUSBAR_HEIGHT, MainScreenWidth, (MainScreenWidth - 113)*3/4.0 + 37 * 2)];//画板高度+上下黑色背景高度
    _liveBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_liveBackView];
    
    _topBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _liveBackView.width, 37)];
    _topBlackView.backgroundColor = EdlineV5_Color.textFirstColor;
    [_liveBackView addSubview:_topBlackView];
    
    _topToolBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _liveBackView.width, 37)];
    _topToolBackView.layer.masksToBounds = YES;
    _topToolBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    [_liveBackView addSubview:_topToolBackView];
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    [_leftBtn setImage:Image(@"nav_back_white") forState:0];
    [_topToolBackView addSubview:_leftBtn];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftBtn.right, 0, MainScreenWidth, 37)];
    _themeLabel.textColor = [UIColor whiteColor];
    _themeLabel.font = SYSTEMFONT(14);
    _themeLabel.text = @"欢迎来到本直播间";
    [_topToolBackView addSubview:_themeLabel];
    
    _cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 7.5 - 37, 0, 37, 37)];
    [_cameraBtn setImage:Image(@"cam_open") forState:0];
    [_cameraBtn setImage:Image(@"cam_close") forState:UIControlStateSelected];
    [_topToolBackView addSubview:_cameraBtn];
    
    _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cameraBtn.left - 37, 0, 37, 37)];
    [_voiceBtn setImage:Image(@"mic_open") forState:0];
    [_voiceBtn setImage:Image(@"mic_close") forState:UIControlStateSelected];
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
    [_fullScreenBtn addTarget:self action:@selector(showFullScreen:) forControlEvents:UIControlEventTouchUpInside];
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
}

// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;//_livePersonArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LiveRoomPersonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveRoomPersonCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

// MARK: - 全屏切换按钮点击事件
- (void)showFullScreen:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isFullScreen = sender.selected;
    if (_isFullScreen) {
        _collectionView.frame = CGRectMake(MainScreenWidth - (113 * 2 + 2), _topBlackView.bottom, 113 * 2 + 2, (MainScreenWidth - 113)*3/4.0);
    } else {
        _collectionView.frame = CGRectMake(MainScreenWidth - 113, _topBlackView.bottom, 113, (MainScreenWidth - 113)*3/4.0);
    }
    [_collectionView reloadData];
}

@end
