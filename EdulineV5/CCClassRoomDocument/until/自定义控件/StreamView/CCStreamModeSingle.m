//
//  CCStreamModeSingle.m
//  CCClassRoom
//
//  Created by cc on 17/4/10.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCStreamModeSingle.h"
#import "CCDocViewController.h"
#import "CCPlayViewController.h"
#import "AppDelegate.h"
#import "CCPlayViewController.h"
#import "CCCollectionViewCellSingle.h"
#import "CCPushViewController.h"
#import "CCTeachCopyViewController.h"

#define TAG 10001
#define BIGViewTag 10002
#define BIGViewLabel 10003

@interface CCStreamModeSingle()<UICollectionViewDelegate, UICollectionViewDataSource, CCCollectionViewCellSingleDelegate>
@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) CCStreamView *bigView;//大屏显示的视图
//@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL isShow;
@property (assign, nonatomic) CCRole role;
@property (strong, nonatomic) NSString *mainViewID;
@property (strong, nonatomic) UILabel *bigViewLabel;
@property (assign, nonatomic) float cellWidth;
@property (strong, nonatomic) UILabel *noTeacherStreamLabel;//学生端，老师的流没有了，给出提示
@end

@implementation CCStreamModeSingle
- (id)initWithLandspace:(BOOL)isLandSpace
{
    if (self = [super init])
    {
        self.isShow = YES;
        self.isLandSpace = isLandSpace;
        [self initUI];
        self.mainViewID = [[CCStreamerBasic sharedStreamer] getRoomInfo].teacherFllowUserID;
        self.role = (CCRole)[GetFromUserDefaults(LIVE_ROLE) integerValue];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSocketEvent:) name:CCNotiReceiveSocketEvent object:nil];
        //        [self startTimer];
        
        [self performSelector:@selector(startTimer) withObject:nil afterDelay:1.f];
    }
    return self;
}

- (void)initUI
{
    self.noTeacherStreamLabel = [UILabel new];
    self.noTeacherStreamLabel.text = HDClassLocalizeString(@"老师暂时离开了，请稍等") ;
    self.noTeacherStreamLabel.textAlignment = NSTextAlignmentCenter;
    self.noTeacherStreamLabel.font = [UIFont systemFontOfSize:FontSizeClass_16];
    self.noTeacherStreamLabel.textColor = [UIColor whiteColor];
    self.noTeacherStreamLabel.layer.shadowColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3f].CGColor;
    self.noTeacherStreamLabel.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self addSubview:self.noTeacherStreamLabel];
    self.noTeacherStreamLabel.hidden = YES;
    __weak typeof(self) weakSelf = self;
    [self.noTeacherStreamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
    }];
    
    self.backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    _collectionView = ({
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        if (self.isLandSpace)
        {
            CGFloat h = [CCCollectionViewCellSingle getHeightWithWidth:160.f showBtn:NO isLandspace:self.isLandSpace];
            h+=2.f;
            layout.itemSize = CGSizeMake(162.f, h);
            self.cellWidth = 162.f;
        }
        else
        {
            CGFloat h = [CCCollectionViewCellSingle getHeightWithWidth:90.f showBtn:NO isLandspace:self.isLandSpace];
            h+=2.f;
            layout.itemSize = CGSizeMake(92.f, h);
            self.cellWidth = 92.f;
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        }
        
        layout.minimumLineSpacing = 5.f;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 162.f,self.frame.size.height) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollsToTop = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[CCCollectionViewCellSingle class] forCellWithReuseIdentifier:@"cell"];
        collectionView;
    });
    
    self.backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [self.backView addGestureRecognizer:tap];
    
    [self addSubview:self.backView];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).offset(0.f);
    }];
    [self addSubview:self.collectionView];
    if (self.isLandSpace)
    {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf).offset(0.f);
            make.bottom.mas_equalTo(weakSelf).offset(0.f);
            make.top.mas_equalTo(weakSelf).offset(CCGetRealFromPt(80) + 35 + 10);
            make.width.mas_equalTo(162.f);
        }];
    }
    else
    {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf).offset(0.f);
            make.bottom.mas_equalTo(weakSelf).offset(0.f);
            make.top.mas_equalTo(weakSelf).offset(CCGetRealFromPt(80) + 35 + 10);
            make.width.mas_equalTo(92.f);
        }];
    }
    
    
    //    [self bringSubviewToFront:self.noTeacherStreamLabel];
    //    self.noTeacherStreamLabel.hidden = NO;
    
}

- (void)receiveSocketEvent:(NSNotification *)noti
{
    CCSocketEvent event = (CCSocketEvent)[noti.userInfo[@"event"] integerValue];
    if (event == CCSocketEvent_PublishEnd)
    {
        UIViewController *vc = self.showVC.visibleViewController;
        if ([vc isKindOfClass:[CCDocViewController class]])
        {
            
        }
    }
    else if (event == CCSocketEvent_MainStreamChanged)
    {
        if (self.role == CCRole_Student)
        {
            NSString *userID = noti.userInfo[@"value"];
            self.mainViewID = userID;
            if (userID.length == 0)
            {
                //关闭跟随，把老师的切位大屏
                //                int i = 0;
                //                for (CCStreamView *newBigInfo in self.data)
                //                {
                //                    CCRole role = newBigInfo.stream.role;
                //                    if (role == CCRole_Teacher)
                //                    {
                //                        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
                //                        [self changeViewAtIndexPath:indexpath];
                //                        break;
                //                    }
                //                    i++;
                //                }
            }
            else
            {
                //开启或者切换
                int i = 0;
                for (CCStreamView *newBigInfo in self.data)
                {
                    if ([newBigInfo.stream.userID isEqualToString:userID])
                    {
                        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
                        [self changeViewAtIndexPath:indexpath];
                        break;
                    }
                    i++;
                }
            }
        }
    }
}

- (void)showStreamView:(CCStreamView *)view
{
    if ([[CCStreamerBasic sharedStreamer] getRoomInfo].user_role == CCRole_Student)
    {
        if (view.stream.role == CCRole_Teacher || view.stream.role == CCRole_Assistant)
        {
            CCLog(HDClassLocalizeString(@"老师的流来了") );
            [self sendSubviewToBack:self.noTeacherStreamLabel];
            self.noTeacherStreamLabel.hidden = YES;
        }
    }
    if (!self.data)
    {
        self.data = [NSMutableArray array];
    }
    
    
    if (!self.bigView)
    {
        self.bigView = view;
        [self showBigView:self.bigView];
        return;
    }
    else
    {
        if ([self.bigView.stream.userID isEqualToString:self.mainViewID])
        {
            //存在主视频在大屏,这个时候只需要放在列表
            ///校验是否已存在
            BOOL isHave = NO;
            CCStreamView *tempView = view;
            NSInteger i = 0;
            for (CCStreamView *view in self.data) {
                if ([view.stream.userID isEqualToString:tempView.stream.userID]) {
                    isHave = YES;
                    [self.data replaceObjectAtIndex:i withObject:tempView];
                    break;
                }
                i ++;
            }
            
            if ([tempView.stream.userID isEqualToString:self.bigView.stream.userID]) {
                isHave = YES;
            }
            
            if (!isHave) {
                
                [self.data addObject:view];
            }
            
            [self.collectionView reloadData];
        }
        else
        {
            CCRole role = view.stream.role;
            NSString *userID = view.stream.userID;
            if (role == CCRole_Teacher || [userID isEqualToString:self.mainViewID])
            {
                ///校验是否已存在
                BOOL isHave = NO;
                NSInteger i = 0;
                for (CCStreamView *view in self.data) {
                    if ([view.stream.userID isEqualToString:self.bigView.stream.userID]) {
                        isHave = YES;
                        [self.data replaceObjectAtIndex:i withObject:self.bigView];
                        break;
                    }
                    i ++;
                }
                
                if ([userID isEqualToString:self.bigView.stream.userID]) {
                    isHave = YES;
                }
                
                if (!isHave) {
                    
                    [self.data addObject:self.bigView];
                }
                
                self.bigView = view;
                [self showBigView:self.bigView];
            }
            else
            {
                ///校验是否已存在
                BOOL isHave = NO;
                NSInteger i = 0;
                CCStreamView *tempView = view;
                for (CCStreamView *view in self.data) {
                    if ([view.stream.userID isEqualToString:tempView.stream.userID]) {
                        isHave = YES;
                        [self.data replaceObjectAtIndex:i withObject:tempView];
                        break;
                    }
                    i ++;
                }
                
                if ([tempView.stream.userID isEqualToString:self.bigView.stream.userID]) {
                    isHave = YES;
                }
                
                if (!isHave) {
                    
                    [self.data addObject:view];
                }
                
            }
            [self.collectionView reloadData];
        }
    }
}

- (void)showBigView:(CCStreamView *)info
{
    UIView *bigView = [self.backView viewWithTag:BIGViewTag];
    if (bigView)
    {
        [bigView  removeFromSuperview];
    }
    CCCollectionViewCellSingle *cell = [[CCCollectionViewCellSingle alloc] init];
    [cell loadwith:info showBtn:NO showNameAtTop:YES];
    cell.tag = BIGViewTag;
    [self.backView addSubview:cell];
    __weak typeof(self) weakSelf = self;
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.backView);
    }];
    if ([[CCStreamerBasic sharedStreamer] getRoomInfo].user_role == CCRole_Teacher)
    {
        [[CCStreamerBasic sharedStreamer] setRegion:info.stream.streamID completion:^(BOOL result, NSError *error, id info) {
            CCLog(@"%s_result:%@__%@__%@", __func__, @(result), error, info);
        }];
    }
    CCRole role = [CCStreamerBasic sharedStreamer].getRoomInfo.user_role;
    if (role == CCRole_Teacher)
    {
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBigView)];
        [cell addGestureRecognizer:ges];
    }
    
}

- (void)removeBigView
{
    UIView *bigView = [self.backView viewWithTag:BIGViewTag];
    if (bigView)
    {
        [bigView  removeFromSuperview];
    }
}

- (void)touchBigView
{
    if ([CCStreamerBasic sharedStreamer].getRoomInfo.user_role == CCRole_Teacher)
    {
        if (![self.bigView.stream.userID isEqualToString:[CCStreamerBasic sharedStreamer].getRoomInfo.user_id])
        {
            NSDictionary *info = @{@"type":NSStringFromClass([self class]), @"userID":self.bigView.stream.userID};
            [[NSNotificationCenter defaultCenter] postNotificationName:CLICKMOVIE object:nil userInfo:info];
        }else {
            [self showMenuView];
        }
    }
}
///显示和隐藏操作栏
-(void)showMenuView {
    //全屏转为半屏的时候，要考虑是不是有未开始上课图片
    UIView *backView = [self viewWithTag:SpeakModeStopBackViewTag];
    if (backView)
    {
        return;
    }
    UIViewController *vc;
    for (UIViewController *viewc in self.showVC.viewControllers)
    {
        if ([viewc isKindOfClass:[CCPushViewController class]] || [viewc isKindOfClass:[CCPlayViewController class]] || [viewc isKindOfClass:[CCTeachCopyViewController class]])
        {
            vc = viewc;
        }
    }
    if (self.isShow)
    {
        //隐藏
        CCPushViewController *playVC = (CCPushViewController *)vc;
        if ([playVC isKindOfClass:[CCPushViewController class]] ||
            [playVC isKindOfClass:[CCPlayViewController class]] ||
            [playVC isKindOfClass:[CCTeachCopyViewController class]])
        {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^{
                [playVC.topContentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(playVC.view.mas_top).offset(0.f);
                    //                    make.left.mas_equalTo(playVC.view);
                    if ([playVC isKindOfClass:[CCPlayViewController class]])
                    {
                        CCPlayViewController *playVC = (CCPlayViewController *)vc;
                        make.left.mas_equalTo(playVC.timerView.mas_right);
                    }
                    else
                    {
                        make.left.mas_equalTo(playVC.view);
                    }
                    make.right.mas_equalTo(playVC.view);
                    make.height.mas_equalTo(35);
                }];
                [playVC.contentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(playVC.view);
                    make.top.mas_equalTo(playVC.view.mas_bottom);
                    make.height.mas_equalTo(CCGetRealFromPt(130));
                }];
                [playVC.chatView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(playVC.view).offset(CCGetRealFromPt(30));
                    make.bottom.mas_equalTo(playVC.view);
                    make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
                }];
                [weakSelf.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(weakSelf).offset(0.f);
                    make.bottom.mas_equalTo(weakSelf).offset(0.f);
                    make.top.mas_equalTo(weakSelf).offset(20);
                    make.width.mas_equalTo(weakSelf.cellWidth);
                }];
                [weakSelf.bigViewLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(weakSelf).offset(10.f);
                    //                    make.width.mas_equalTo(60.f);
                    make.top.mas_equalTo(weakSelf).offset(20);
                }];
                
                
                CCCollectionViewCellSingle *cell = [self.backView viewWithTag:BIGViewTag];
                if (cell)
                {
                    [cell moveLabelToTop:YES];
                }
                
                [playVC.view layoutIfNeeded];
                [weakSelf layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
    }
    else
    {
        //显示
        CCPushViewController *playVC = (CCPushViewController *)vc;
        if ([playVC isKindOfClass:[CCPushViewController class]] || [playVC isKindOfClass:[CCPlayViewController class]] || [playVC isKindOfClass:[CCTeachCopyViewController class]])
        {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^{
                [playVC.topContentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    //                    make.top.mas_equalTo(playVC.view).offset(CCGetRealFromPt(60));
                    make.top.mas_equalTo(playVC.view).offset(Height_StatusBar);
                    
                    //                    make.left.mas_equalTo(playVC.view);
                    if ([playVC isKindOfClass:[CCPlayViewController class]])
                    {
                        CCPlayViewController *playVC = (CCPlayViewController *)vc;
                        make.left.mas_equalTo(playVC.timerView.mas_right);
                    }
                    else
                    {
                        make.left.mas_equalTo(playVC.view);
                    }
                    make.right.mas_equalTo(playVC.view);
                    make.height.mas_equalTo(35);
                }];
                [playVC.contentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.bottom.and.right.mas_equalTo(playVC.view);
                    make.height.mas_equalTo(CCGetRealFromPt(130));
                }];
                [playVC.chatView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(playVC.view).offset(CCGetRealFromPt(30));
                    make.bottom.mas_equalTo(playVC.contentBtnView.mas_top);
                    make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
                }];
                [weakSelf.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(weakSelf).offset(0.f);
                    make.bottom.mas_equalTo(weakSelf).offset(0.f);
                    make.top.mas_equalTo(weakSelf).offset(CCGetRealFromPt(80) + 35 + 10);
                    make.width.mas_equalTo(weakSelf.cellWidth);
                }];
                [weakSelf.bigViewLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(weakSelf).offset(10.f);
                    //                    make.width.mas_equalTo(60.f);
                    make.top.mas_equalTo(CCGetRealFromPt(80) + 35 + 10);
                }];
                CCCollectionViewCellSingle *cell = [self.backView viewWithTag:BIGViewTag];
                if (cell)
                {
                    [cell moveLabelToTop:NO];
                }
                [playVC.view layoutIfNeeded];
                [weakSelf layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self startTimer];
            }];
        }
    }
    self.isShow = !self.isShow;
}

- (void)removeStreamView:(CCStreamView *)view
{
    CCLog(@"LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
    CCLog(@"%s__%d__%@", __func__, __LINE__, view.stream.streamID);
    if (view == nil) {
        //移除预览
        for (CCStreamView *localInfo in self.data)
        {
            if (localInfo.stream.type == CCStreamType_Local)
            {
                [self.data removeObject:localInfo];
                [self.collectionView reloadData];
                break;
            }
        }
    }
    //这里要考虑移除的是大屏显示的视图
    if ([self.bigView.stream.streamID isEqualToString:view.stream.streamID] || self.bigView == view)
    {
        self.bigView = nil;
        if (self.data.count > 0)
        {
            //有老师的流把老师的流放在大屏
            for (CCStreamView *info in self.data)
            {
                CCRole role = info.stream.role;
                if (role == CCRole_Teacher)
                {
                    self.bigView = info;
                    break;
                }
            }
            if (!self.bigView)
            {
                self.bigView = self.data[0];
            }
            NSArray *localShowViews = [NSArray arrayWithArray:self.data];
            for (CCStreamView *localView in localShowViews)
            {
                if ([localView.stream.streamID isEqualToString:view.stream.streamID])
                {
                    CCLog(@"%s__%d__%@", __func__, __LINE__, view.stream.streamID);
                    [self.data removeObject:localView];
                    break;
                }
            }
            [self.data removeObject:self.bigView];
            [self showBigView:self.bigView];
        }
        else
        {
            [self removeBigView];
        }
    }
    else
    {
        NSArray *localShowViews = [NSArray arrayWithArray:self.data];
        for (CCStreamView *localView in localShowViews)
        {
            CCLog(@"%s__%d__%@", __func__, __LINE__, view.stream.streamID);
            if ([localView.stream.streamID isEqualToString:view.stream.streamID] || localView == view)
            {
                [self.data removeObject:localView];
                break;
            }
        }
        [self.data removeObject:view];
    }
    [self.collectionView reloadData];
    
    if ([[CCStreamerBasic sharedStreamer] getRoomInfo].user_role == CCRole_Student)
    {
        if (!view)
        {
            CCLog(HDClassLocalizeString(@"视图为空__CC") );
            return;
        }
        if (view.stream.role == CCRole_Teacher || view.stream.role == CCRole_Assistant)
        {
            CCLog(HDClassLocalizeString(@"老师的流走了__CC") );
            [self bringSubviewToFront:self.noTeacherStreamLabel];
            self.noTeacherStreamLabel.hidden = NO;
        }
    }
}
- (void)removeStreamViewAll
{
    [self removeBigView];
    self.bigView = nil;
    [self.data removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCCollectionViewCellSingle *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell loadwith:self.data[indexPath.item] showBtn:NO showNameAtTop:NO];
    cell.delegate = self;
    return cell;
}

- (CCStreamView *)changeViewAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.data.count > 0)
    {
        CCStreamView *newBigInfo = self.data[indexPath.item];
        [self.data removeObject:newBigInfo];
        if (self.data.count >= indexPath.item)
        {
            [self.data insertObject:self.bigView atIndex:indexPath.item];
        }
        [self.collectionView reloadData];
        self.bigView = newBigInfo;
        [self showBigView:self.bigView];
        return newBigInfo;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.role == CCRole_Teacher || self.role == CCRole_Assistant)
    {
        CCStreamView *view = [self.data objectAtIndex:indexPath.item];
        if ([view.stream.userID isEqualToString:[CCStreamerBasic sharedStreamer].getRoomInfo.user_id]) //单个讲师模式
        {
            [self changeTogBig:indexPath];
        }
        //处理助教的角色
        else if (view.stream.role == CCRole_Assistant || view.stream.role == CCRole_Teacher)
        {
            [self changeTogBig:indexPath];
        }
        else
        {
            NSDictionary *info = @{@"type":NSStringFromClass([self class]), @"userID":view.stream.userID, @"indexPath":indexPath};
            [[NSNotificationCenter defaultCenter] postNotificationName:CLICKMOVIE object:nil userInfo:info];
        }
        return;
    }
    else if (self.role == CCRole_Student)
    {
        NSString *userID = [[CCStreamerBasic sharedStreamer] getRoomInfo].teacherFllowUserID;
        if (userID.length == 0)
        {
            [self changeViewAtIndexPath:indexPath];
        }
        else
        {
            [HDSTool showAlertTitle:@"" msg:HDClassLocalizeString(@"跟随模式下不能切换视频") isOneBtn:YES];
        }
    }
}

#pragma mark - cell delegate
- (void)clickMicBtn:(UIButton *)btn info:(CCStreamView *)info
{
    btn.selected = !btn.selected;
    NSString *userID = info.stream.userID;
    for (CCUser *user in [[CCStreamerBasic sharedStreamer] getRoomInfo].room_userList)
    {
        if ([userID isEqualToString:user.user_id])
        {
            //设置音频状态
            //            [[CCStreamerBasic sharedStreamer] setAudioOpened:!user.user_audioState userID:userID];
            [[CCStreamerBasic sharedStreamer] changeStream:info.stream audioState:!user.user_audioState completion:^(BOOL result, NSError *error, id info) {
                
            }];
        }
    }
}

- (void)clickPhoneBtn:(UIButton *)btn info:(NSDictionary *)info
{
    [HDSTool showAlertTitle:@"" msg:HDClassLocalizeString(@"确定挂断连麦?") cancel:HDClassLocalizeString(@"取消") other:@[HDClassLocalizeString(@"确定") ] completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            NSString *userID = info[@"userID"];
            //踢下麦
            [[CCBarleyManager sharedBarley] kickUserFromSpeak:userID completion:^(BOOL result, NSError *error, id info) {
                
            }];
        }
    }];
}

#pragma mark - hidden btn
- (void)addBack
{
    UIViewController *vc;
    for (UIViewController *viewc in self.showVC.viewControllers)
    {
        if ([viewc isKindOfClass:[CCPushViewController class]] || [viewc isKindOfClass:[CCPlayViewController class]] || [viewc isKindOfClass:[CCTeachCopyViewController class]])
        {
            vc = viewc;
        }
    }
    __weak typeof(self) weakSelf = self;
    if ([vc isKindOfClass:[CCPushViewController class]])
    {
        CCPushViewController *playVC = (CCPushViewController *)vc;
        playVC.contentBtnView.hidden = NO;
        [playVC hiddenChatView:NO];
        playVC.topContentBtnView.hidden = NO;
        if ([[CCStreamerBasic sharedStreamer] getRoomInfo].room_template == CCRoomTemplateSingle)
        {
            playVC.fllowBtn.hidden = NO;
        }
        else
        {
            playVC.fllowBtn.hidden = YES;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [playVC.topContentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                //                make.top.mas_equalTo(playVC.view).offset(CCGetRealFromPt(60));
                make.top.mas_equalTo(playVC.view).offset(Height_StatusBar);
                make.left.mas_equalTo(playVC.view);
                make.right.mas_equalTo(playVC.view);
                make.height.mas_equalTo(35);
            }];
            [playVC.contentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.bottom.and.right.mas_equalTo(playVC.view);
                make.height.mas_equalTo(CCGetRealFromPt(130));
            }];
            [playVC.chatView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(playVC.view).offset(CCGetRealFromPt(30));
                make.bottom.mas_equalTo(playVC.contentBtnView.mas_top);
                make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
            }];
            [weakSelf.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(0.f);
                make.bottom.mas_equalTo(weakSelf).offset(0.f);
                make.top.mas_equalTo(weakSelf).offset(CCGetRealFromPt(80) + 35 + 10);
                make.width.mas_equalTo(weakSelf.cellWidth);
            }];
            [weakSelf.bigViewLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf).offset(10.f);
                //                make.width.mas_equalTo(60.f);
                make.top.mas_equalTo(CCGetRealFromPt(80) + 35 + 10);
            }];
            
            //            UIView *bigView = [self.backView viewWithTag:BIGViewTag];
            //            UIImageView *audioImageView = [bigView viewWithTag:AudioImageViewTag];
            //            [audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.centerX.mas_equalTo(bigView);
            //                make.bottom.mas_equalTo(bigView.mas_bottom).offset(-20);
            //            }];
            
            [weakSelf layoutIfNeeded];
            [playVC.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
        self.isShow = YES;
    }
    else if ([vc isKindOfClass:[CCTeachCopyViewController class]])
    {
        CCTeachCopyViewController *playVC = (CCTeachCopyViewController *)vc;
        playVC.contentBtnView.hidden = NO;
        playVC.tableView.hidden = NO;
        playVC.topContentBtnView.hidden = NO;
        if ([[CCStreamerBasic sharedStreamer] getRoomInfo].room_template == CCRoomTemplateSingle)
        {
            playVC.fllowBtn.hidden = NO;
        }
        else
        {
            playVC.fllowBtn.hidden = YES;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [playVC.topContentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                //                make.top.mas_equalTo(playVC.view).offset(CCGetRealFromPt(60));
                make.top.mas_equalTo(playVC.view).offset(Height_StatusBar);
                
                make.left.mas_equalTo(playVC.view);
                make.right.mas_equalTo(playVC.view);
                make.height.mas_equalTo(35);
            }];
            [playVC.contentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.bottom.and.right.mas_equalTo(playVC.view);
                make.height.mas_equalTo(CCGetRealFromPt(130));
            }];
            [playVC.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(playVC.view).offset(CCGetRealFromPt(30));
                make.bottom.mas_equalTo(playVC.contentBtnView.mas_top);
                make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
            }];
            [weakSelf.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(0.f);
                make.bottom.mas_equalTo(weakSelf).offset(0.f);
                make.top.mas_equalTo(weakSelf).offset(CCGetRealFromPt(80) + 35 + 10);
                make.width.mas_equalTo(weakSelf.cellWidth);
            }];
            [weakSelf.bigViewLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf).offset(10.f);
                //                make.width.mas_equalTo(60.f);
                make.top.mas_equalTo(CCGetRealFromPt(80) + 35 + 10);
            }];
            
            //            UIView *bigView = [self.backView viewWithTag:BIGViewTag];
            //            UIImageView *audioImageView = [bigView viewWithTag:AudioImageViewTag];
            //            [audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.centerX.mas_equalTo(bigView);
            //                make.bottom.mas_equalTo(bigView.mas_bottom).offset(-20);
            //            }];
            
            [weakSelf layoutIfNeeded];
            [playVC.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
        self.isShow = YES;
    }
    else if ([vc isKindOfClass:[CCPlayViewController class]])
    {
        CCPlayViewController *playVC = (CCPlayViewController *)vc;
        playVC.contentBtnView.hidden = NO;
        [playVC hiddenChatView:NO];
        playVC.topContentBtnView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            [playVC.topContentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                //                make.top.mas_equalTo(playVC.view).offset(CCGetRealFromPt(60));
                make.top.mas_equalTo(playVC.view).offset(Height_StatusBar);
                //                make.left.mas_equalTo(playVC.view);
                make.left.mas_equalTo(playVC.timerView.mas_right).offset(0.f);
                make.right.mas_equalTo(playVC.view);
                make.height.mas_equalTo(35);
            }];
            [playVC.contentBtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.bottom.and.right.mas_equalTo(playVC.view);
                make.height.mas_equalTo(CCGetRealFromPt(130));
            }];
            [playVC.chatView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(playVC.view).offset(CCGetRealFromPt(30));
                make.bottom.mas_equalTo(playVC.contentBtnView.mas_top);
                make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(640),CCGetRealFromPt(300)));
            }];
            
            [weakSelf.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(0.f);
                make.bottom.mas_equalTo(weakSelf).offset(0.f);
                make.top.mas_equalTo(weakSelf).offset(CCGetRealFromPt(80) + 35 + 10);
                make.width.mas_equalTo(weakSelf.cellWidth);
            }];
            [weakSelf.bigViewLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf).offset(10.f);
                //                make.width.mas_equalTo(60.f);
                make.top.mas_equalTo(CCGetRealFromPt(80) + 35 + 10);
            }];
            
            CCCollectionViewCellSingle *cell = [self.backView viewWithTag:BIGViewTag];
            if (cell)
            {
                [cell moveLabelToTop:NO];
            }
            
            [playVC.view layoutIfNeeded];
            [weakSelf layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
        self.isShow = YES;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startTimer) object:nil];
    CCStreamerView *streamView = (CCStreamerView *)self.superview;
    [streamView stopTimer];
}

- (void)removeBack
{
    [self startTimer];
}

- (void)startTimer
{
    CCStreamerView *streamView = (CCStreamerView *)self.superview;
    [streamView startTimer];
}

- (void)fire
{
    CCRole role = [CCStreamerBasic sharedStreamer].getRoomInfo.user_role;
    if (role != CCRole_Teacher)
    {
        if (self.isShow)
        {
            [self tapGes:nil];
        }
    }
}

- (void)tapGes:(UITapGestureRecognizer *)ges
{
    [self showMenuView];
}

- (NSString *)touchFllow
{
    return self.bigView.stream.userID;
}
- (void)reloadDataSound {
    for (CCCollectionViewCellSingle *cell in [self.collectionView visibleCells]) {
        [cell updateSound];
    }
}

- (void)reloadData
{
    [self.collectionView reloadData];
    
    if (self.bigView)
    {
        [self removeBigView];
        [self showBigView:self.bigView];
    }
}

- (void)changeTogBig:(NSIndexPath *)indexPath
{
    CCStreamView *newBigInfo = [self changeViewAtIndexPath:indexPath];
    NSString *userID = [[CCStreamerBasic sharedStreamer] getRoomInfo].teacherFllowUserID;
    if (userID.length == 0)
    {
        //表示未开始跟随
    }
    else
    {
        NSString *userID = newBigInfo.stream.userID;
        if (userID.length > 0)
        {
            //老师开启跟随模式下使用
            [[CCBarleyManager sharedBarley]changeMainStreamInSigleTemplate:userID completion:^(BOOL result, NSError *error, id info) {
                
            }];
        }
    }
}
#pragma mark -
- (void)dealloc
{
    NSLog(@"%@__%s", NSStringFromClass([self class]), __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CCNotiReceiveSocketEvent object:nil];
    //    if (self.timer)
    //    {
    //        [self.timer invalidate];
    //        self.timer = nil;
    //    }
    CCStreamerView *streamView = (CCStreamerView *)self.superview;
    [streamView stopTimer];
    
    [self.data removeAllObjects];
    self.data = nil;
}
@end

