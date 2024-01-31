//
//  HDSSupportView.m
//  CCLiveCloud
//
//  Created by Richard Lee on 8/11/21.
//  Copyright © 2021 MacBook Pro. All rights reserved.
//

#import "HDSSupportView.h"
#import "HDSAudioModeView.h"
#import "HDSSpeedModeView.h"
#import "HDSPlayerErrorModeView.h"

@interface HDSSupportView ()

@property (nonatomic, strong) UIView                    *contentView;

@property (nonatomic, strong) UIView                    *boardView;

@property (nonatomic, strong) HDSAudioModeView          *audioView;

@property (nonatomic, strong) HDSSpeedModeView          *speedView;

@property (nonatomic, strong) HDSPlayerErrorModeView    *playErrorView;

@property (nonatomic, assign) BOOL                      isAudio;

@property (nonatomic, copy)   ActionClosure             actionClosure;

@end

@implementation HDSSupportView

// MARK: - API
/// 初始化
/// @param frame 布局
/// @param actionClosure 回调
- (instancetype)initWithFrame:(CGRect)frame actionClosure:(ActionClosure)actionClosure {
    if (self = [super initWithFrame:frame]) {
        [self customUI];
        self.userInteractionEnabled = YES;
        if (actionClosure) {
            _actionClosure = actionClosure;
        }
        //NSLog(@"🟡 %s",__func__);
    }
    return self;
}

/// 设置类型
/// @param baseType     类型
/// @param boardView    父视图
- (void)setSupportBaseType:(HDSSupportViewBaseType)baseType boardView:(nonnull UIView *)boardView {
//    NSLog(@"🟡 %s",__func__);
    _boardView = boardView;
    [self removeFromSuperview];
    self.frame = _boardView.bounds;
    self.contentView.frame = _boardView.bounds;
    if (_speedView.hidden == NO) {
        [_speedView updateFrame:self.bounds];
    }
    [_boardView addSubview:self];
    _isAudio = baseType == HDSSupportViewBaseTypeAudio ? YES : NO;
    [self updateSubView:baseType];
}

/// 缓存速度
/// @param speed 速度
- (void)setSpeed:(NSString *)speed {
//    NSLog(@"🟡 %s",__func__);
    if (_playErrorView) {
        [_playErrorView removeFromSuperview];
        _playErrorView = nil;
    }
    if (!_speedView) {
        _speedView = [[HDSSpeedModeView alloc]initWithFrame:self.bounds];
        [self addSubview:_speedView];
    }
    if (_speedView.hidden) {
        _speedView.hidden = NO;
    }
    if (self.width != _speedView.width) {
        [_speedView updateFrame:self.bounds];
    }
    [_speedView setSpeed:speed];
}

/// 隐藏速度
- (void)hiddenSpeed {
//    NSLog(@"🟡 %s",__func__);
    if (!_speedView.hidden) {
        _speedView.hidden = YES;
    }
}

// MARK: - CustionMethod
/// 自定义UI
- (void)customUI {
//    NSLog(@"🟡 %s",__func__);
    _contentView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:_contentView];
    
    _speedView = [[HDSSpeedModeView alloc]initWithFrame:self.bounds];
    [self addSubview:_speedView];
    _speedView.hidden = YES;
}

/// 更新子视图
/// @param baseType 类型
- (void)updateSubView:(HDSSupportViewBaseType)baseType {
//    NSLog(@"🟡 %s",__func__);
    switch (baseType) {
        case HDSSupportViewBaseTypeAudio:
            [self updateAudioView];
            break;
        case HDSSupportViewBaseTypePlayError:
            [self updatePlayErrorView];
            break;
        default:
            [self killAll];
            break;
    }
}

- (void)killAll {
//    NSLog(@"🟡 %s",__func__);
    if (_playErrorView) {
        [_playErrorView removeFromSuperview];
        _playErrorView = nil;
    }
    if (_audioView) {
        [_audioView removeFromSuperview];
        _audioView = nil;
    }
}

/// 更新音频模块
- (void)updateAudioView {
//    NSLog(@"🟡 %s",__func__);
    if (_playErrorView) {
        [_playErrorView removeFromSuperview];
        _playErrorView = nil;
    }
    [self hiddenSpeed];
    if (_audioView) {
        [self.contentView addSubview:_audioView];
        [_audioView updateFrame:self.bounds];
        return;
    }
    _audioView = [[HDSAudioModeView alloc]initWithFrame:self.bounds];
    [_contentView addSubview:_audioView];
}

/// 更新音频模块
- (void)updatePlayErrorView {
//    NSLog(@"🟡 %s",__func__);
    WS(weakSelf)
    if (_audioView) {
        [_audioView removeFromSuperview];
        _audioView = nil;
    }
    [self hiddenSpeed];
    if (_playErrorView) {
        _playErrorView.frame = self.bounds;
        _playErrorView.isAudio = _isAudio;
        [_playErrorView reset];
        [_playErrorView updateFrame:self.bounds];
        _playErrorView.btnActionClosure = ^{
            if (weakSelf.actionClosure) {
                weakSelf.actionClosure();
            }
        };
        return;
    }
    _playErrorView = [[HDSPlayerErrorModeView alloc]initWithFrame:self.bounds];
    _playErrorView.isAudio = _isAudio;
    [_playErrorView reset];
    [_playErrorView updateFrame:self.bounds];
    [_contentView addSubview:_playErrorView];
    _playErrorView.btnActionClosure = ^{
        if (weakSelf.actionClosure) {
            weakSelf.actionClosure();
        }
    };
}

- (void)kRelease {
//    NSLog(@"🟡  %s",__func__);
    if (_audioView) {
        [_audioView removeFromSuperview];
        _audioView = nil;
    }
    
    if (_playErrorView) {
        [_playErrorView removeFromSuperview];
        _playErrorView = nil;
    }
    
    if (_speedView) {
        [_speedView removeFromSuperview];
        _speedView = nil;
    }
}

- (void)dealloc {
    //NSLog(@"🟡  %s",__func__);
}

@end
