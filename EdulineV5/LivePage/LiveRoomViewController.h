//
//  LiveRoomViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveRoomViewController : BaseViewController

@property (strong, nonatomic) UIView *liveBackView;

@property (strong, nonatomic) UIView *topBlackView;
@property (strong, nonatomic) UIView *bottomBlackView;

@property (strong, nonatomic) UIView *topToolBackView;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIButton *cameraBtn;
@property (strong, nonatomic) UIButton *voiceBtn;
@property (strong, nonatomic) UIButton *lianmaiBtn;

@property (strong, nonatomic) UIView *bottomToolBackView;
@property (strong, nonatomic) UIButton *fullScreenBtn;
@property (strong, nonatomic) UIButton *roomPersonCountBtn;

@property (strong, nonatomic) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
