//
//  CCDocView.m
//  CCLiveCloud
//
//  Created by 何龙 on 2019/3/21.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

#import "CCDocView.h"

@interface CCDocView ()

/*      是否是文档小窗模式       */
@property (nonatomic, assign) BOOL isSmallVideo;

@property (nonatomic, strong) UIButton *smallCloseBtn;
@end

@implementation CCDocView

-(instancetype)initWithType:(BOOL)smallVideo{
    self = [super init];
    if (self) {
        _isSmallVideo = smallVideo;
        self.userInteractionEnabled = YES;
        //剪掉超出的部分
        self.clipsToBounds = YES;
        [self setUpUI];
    }
    return self;
}
-(void)dealloc{
}
#pragma mark - 设置文档视图
-(void)setUpUI{
    if (_isSmallVideo) {
        //设置文档小窗视图样式
        [self setSmallVideoUI];
    }else{
        //设置文档在下视图样式
        self.backgroundColor = CCRGBColor(250,250,250);
    }
}
-(void)setSmallVideoUI{
    /// 3.17.3 new
    _hdContentView = [[UIView alloc]init];
    [self addSubview:_hdContentView];
    
    //文档小窗
    CGRect rect = [UIScreen mainScreen].bounds;
    CGRect smallVideoRect = CGRectMake(rect.size.width - 110, HDGetRealHeight + 41 +(IS_IPHONE_X? 44:20), 100, 75);
    self.frame = smallVideoRect;
    /// 3.17.3 new
    _hdContentView.frame = self.bounds;
    _headerView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:_headerView];
    
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"dddddd" alpha:1.0f].CGColor;
    // 阴影颜色
    self.layer.shadowColor = [UIColor colorWithHexString:@"dddddd" alpha:1.0f].CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = CGSizeMake(0,3);
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0.7f;
    // 阴影半径，默认3
    self.layer.shadowRadius = 3;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [self addGestureRecognizer:panGestureRecognizer];
    //为小窗视图添加关闭按钮
    [self addSubview:self.smallCloseBtn];
}
-(UIButton *)smallCloseBtn{
    if (!_smallCloseBtn) {
        _smallCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _smallCloseBtn.frame = CGRectMake(5, 5, 25, 25);
        _smallCloseBtn.hidden = YES;
        [_smallCloseBtn setBackgroundImage:[UIImage imageNamed:@"fenestrule_delete"] forState:UIControlStateNormal];
        _smallCloseBtn.backgroundColor = [UIColor clearColor];
        //        _smallCloseBtn.layer.cornerRadius = 12.5;
        //        _smallCloseBtn.layer.masksToBounds = YES;
        [_smallCloseBtn addTarget:self action:@selector(hiddenSmallVideoview) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smallCloseBtn;
}
-(void)hiddenSmallVideoview{
    //todo 回调给playerView
    if (_hiddenSmallVideoBlock) {
        _hiddenSmallVideoBlock();
    }
//    _smallVideoView.hidden = YES;
//    NSString *title = _changeButton.tag == 1 ? PLAY_SHOWDOC : PLAY_SHOWVIDEO;
//    [_changeButton setTitle:title forState:UIControlStateNormal];
}
//拖拽小屏
- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self bringSubviewToFront:self.smallCloseBtn];
            _smallCloseBtn.hidden = NO;
            break;
        case UIGestureRecognizerStateChanged:
        {
            _smallCloseBtn.hidden = NO;
            CGPoint translation = [recognizer translationInView:APPDelegate.window];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                                 recognizer.view.center.y + translation.y);
            [recognizer setTranslation:CGPointZero inView:APPDelegate.window];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGRect smallVideoRect = self.frame;
            CGRect frame = [UIScreen mainScreen].bounds;
            CGFloat x = smallVideoRect.origin.x < frame.origin.x ? 0 : smallVideoRect.origin.x;
            
            CGFloat y = smallVideoRect.origin.y < frame.origin.y ? 0 : smallVideoRect.origin.y;
            
            x = (x + smallVideoRect.size.width) > (frame.origin.x + frame.size.width) ? (frame.origin.x + frame.size.width - smallVideoRect.size.width) : x;
            
            y = (y + smallVideoRect.size.height) > (frame.origin.y + frame.size.height) ? (frame.origin.y + frame.size.height - smallVideoRect.size.height) : y;
            
            [UIView animateWithDuration:0.25f animations:^{
                [self setFrame:CGRectMake(x, y, smallVideoRect.size.width, smallVideoRect.size.height)];
            } completion:^(BOOL finished) {
            }];
            //            NSLog(@"拖动smallVideoView结束");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _smallCloseBtn.hidden = YES;
            });
        }
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
}
@end
