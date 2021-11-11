//
//  CCLoadingView.m
//  CCClassRoom
//
//  Created by cc on 2018/8/23.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCLoadingView.h"
#import "AppDelegate.h"
#import "UIImage+GIF.h"
#import "UITouchView.h"
#import "UIImageView+WebCache.h"
@interface CCLoadingView ()
@property (nonatomic, strong)UIActivityIndicatorView  *loadingView;
@property (strong, nonatomic) UILabel *tipGestureLabel;
@property(nonatomic,strong)UIView                   *centerView;

@end

@implementation CCLoadingView

+ (instancetype)createLoadingView
{
    CCLoadingView *lv = [[CCLoadingView alloc]init];
    return lv;
}
+ (instancetype)createLoadingView:(NSString *)sid
{
    CCLoadingView *lv = [[CCLoadingView alloc]init];
    lv.sid = sid;
    return lv;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self addSubview:self.loadingView];

    __weak typeof(self)weakSelf = self;
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf);

    }];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        _loadingView.color = [UIColor whiteColor];
        _loadingView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

-  (UILabel *)tipGestureLabel {
    if (!_tipGestureLabel) {
        _tipGestureLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 , CGRectGetHeight(self.frame) - 30, CGRectGetWidth(self.frame) - 20, 15)];
        _tipGestureLabel.text = _tipString;
        [_tipGestureLabel setTextColor:[UIColor whiteColor]];
        _tipGestureLabel.backgroundColor = [UIColor orangeColor];
        _tipGestureLabel.font = [UIFont systemFontOfSize:12];
        _tipGestureLabel.hidden = YES;
        _tipGestureLabel.textAlignment = NSTextAlignmentCenter;
        _tipGestureLabel.layer.cornerRadius = 15 / 2;
        _tipGestureLabel.layer.masksToBounds = YES;
    }
    return _tipGestureLabel;
}

- (void)setTipString:(NSString *)tipString {
    _tipString = tipString;
    if (_tipString) {
        [self addSubview:self.tipGestureLabel];
        __weak typeof(self)weakSelf = self;

        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdelegate.shouldNeedLandscape) {
            self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [self.loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(weakSelf);
                make.centerY.mas_equalTo(weakSelf).offset(-40);
            }];
            [self.tipGestureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(weakSelf).offset(20);
                make.left.mas_equalTo(weakSelf.mas_left).offset(20);
                make.right.mas_equalTo(weakSelf.mas_right).offset(-20);
                make.height.mas_equalTo(15);
            }];
        }
         else
         {
            [self.tipGestureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(weakSelf).offset(40);
                make.left.mas_equalTo(weakSelf.mas_left).offset(10);
                make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
                make.height.mas_equalTo(15);
            }];
         }
    }
}

- (void)startLoading
{
    if (![self.loadingView isAnimating])
    {
        [self.loadingView startAnimating];
        self.tipGestureLabel.hidden = NO;
    }
}

- (void)stopLoading
{
    if ([self.loadingView isAnimating])
    {
        [self.loadingView stopAnimating];
    }
    self.tipGestureLabel.hidden = YES;
}

- (BOOL)isAnimating {
    return self.loadingView.isAnimating;
}

-(instancetype)initWithLabel:(NSString *)str centerY:(BOOL)centerY{
    self = [super init];
    if(self) {
        WS(ws)
//        [self addSubview:self.view];
//        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(ws);
//        }];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealSingleTap:)];
        [self addGestureRecognizer:singleTap];
        
        self.userInteractionEnabled = YES;
        CGSize size = [self getTitleSizeByFont:str font:[UIFont systemFontOfSize:FontSize_28]];
        size.width = ceilf(size.width);
        size.height = ceilf(size.height);
        [self addSubview:self.centerView];
        [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws);
            if(centerY) {
                make.centerY.mas_equalTo(ws);
            } else {
                make.centerY.mas_equalTo(ws.mas_bottom).offset(-323);
            }
            make.size.mas_equalTo(CGSizeMake(75 + size.width,60));
        }];
        
        [self.centerView addSubview:self.label];
        [self.label setText:str];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ws.centerView);
            make.left.mas_equalTo(ws.centerView).offset(50);
        }];

        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.centerView addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"loading1"];
        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i = 1; i < 9; i ++) {
            NSString *imageName = [NSString stringWithFormat:@"loading%d",i];
            [imageArray addObject:[UIImage imageNamed:imageName]];
        }
        imageView.animationImages = imageArray;
        imageView.animationDuration = 1.0;
        imageView.animationRepeatCount = 3000;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imageView startAnimating];
        });
    
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.centerView).offset(25);
            make.centerY.mas_equalTo(ws.centerView);
            make.size.mas_equalTo(CGSizeMake(20,20));
        }];
    }
    return self;
}


-(void)runAnimate {
    WS(ws)
    [UIView animateWithDuration:0.5 animations:^{
        ws.centerView.alpha = 0.0f;
    }];
}

- (void)dealSingleTap:(UITapGestureRecognizer *)tap {
}

-(CGSize)getTitleSizeByFont:(NSString *)str font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(20000.0f, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

-(UIView *)centerView {
    if(_centerView == nil) {
        _centerView = [[UIView alloc] init];
        _centerView.layer.cornerRadius = 5;
        _centerView.layer.masksToBounds = YES;
        [_centerView.layer setShadowOffset:CGSizeMake(2.5, 7.5)];
        [_centerView.layer setShadowColor:[CCRGBAColor(102, 102, 102,0.5) CGColor]];
        [_centerView.layer setBackgroundColor:[CCRGBAColor(20, 20, 20, 0.89) CGColor]];
    }
    return _centerView;
}

-(UILabel *)label {
    if(_label == nil) {
        _label = [[UILabel alloc] init];
        [_label setBackgroundColor:CCClearColor];
        [_label setFont:[UIFont systemFontOfSize:FontSize_28]];
        [_label setTextColor:CCRGBAColor(255, 255, 255, 0.69)];
        [_label setTextAlignment:NSTextAlignmentCenter];
    }
    return _label;
}

@end
