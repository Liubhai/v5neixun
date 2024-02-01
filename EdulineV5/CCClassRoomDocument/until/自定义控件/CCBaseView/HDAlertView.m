//
//  CCAlertView.m
//  CCClassRoom
//
//  Created by 刘强强 on 2020/8/31.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HDAlertView.h"

static const CGFloat AlertViewWidth = 270.0;
static const CGFloat AlertViewContentMargin = 9;
static const CGFloat AlertViewVerticalElementSpace = 10;
static const CGFloat AlertViewButtonHeight = 44;
static const CGFloat AlertViewLineLayerWidth = 0.5;

@interface CCAlertViewStack : NSObject

@property (nonatomic) NSMutableArray *alertViews;

+ (CCAlertViewStack *)sharedInstance;

- (void)push:(HDAlertView *)alertView;
- (void)pop:(HDAlertView *)alertView;

@end

@interface HDAlertView ()

@property (nonatomic) BOOL buttonsShouldStack;
@property (nonatomic) UIWindow *mainWindow;
@property (nonatomic) UIWindow *alertWindow;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;
@property (nonatomic) NSArray *buttons;
@property (nonatomic) CGFloat buttonsY;
@property (nonatomic) CALayer *verticalLine;
@property (nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic, copy) void (^completion)(BOOL cancelled, NSInteger buttonIndex);

@end

@implementation HDAlertView

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.windowLevel == windowLevel) {
            return window;
        }
    }
    return nil;
}

/**
 * @param otherTitles Must be a NSArray containing type NSString, or set to nil for no otherTitles.
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                       contentView:(UIView *)view
                        completion:(CCAlertViewCompletionBlock)completion {
    
    HDAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                             cancelTitle:cancelTitle
                                             otherTitles:otherTitles
                                      buttonsShouldStack:NO
                                             contentView:view
                                              completion:completion];
    [alertView show];
    return alertView;
    
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        otherTitles:(NSArray *)otherTitles
 buttonsShouldStack:(BOOL)shouldstack
        contentView:(UIView *)contentView
         completion:(CCAlertViewCompletionBlock)completion
{
    self = [super init];
    if (self) {
        self.mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        self.alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if (!self.alertWindow) {
            self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.alertWindow.windowLevel = UIWindowLevelAlert;
            self.alertWindow.backgroundColor = [UIColor clearColor];
        }
        
//        self.alertWindow.rootViewController = self;
        [self.alertWindow.rootViewController presentViewController:self animated:YES completion:nil];
        
        CGRect frame = [self frameForOrientation:self.interfaceOrientation];
        self.view.frame = frame;
        
        self.backgroundView = [[UIView alloc] initWithFrame:frame];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        self.backgroundView.alpha = 0;
        [self.view addSubview:self.backgroundView];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
        self.alertView.layer.cornerRadius = 8.0;
        self.alertView.layer.opacity = .95;
        self.alertView.clipsToBounds = YES;
        [self.view addSubview:self.alertView];
        
        // Title
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                    AlertViewVerticalElementSpace,
                                                                    AlertViewWidth - AlertViewContentMargin*2,
                                                                    44)];
        self.titleLabel.text = title;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
        [self.alertView addSubview:self.titleLabel];
        
        CGFloat messageLabelY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + AlertViewVerticalElementSpace;
        
        // Optional Content View
        if (contentView) {
            self.contentView = contentView;
            self.contentView.frame = CGRectMake(0,
                                                messageLabelY,
                                                self.contentView.frame.size.width,
                                                self.contentView.frame.size.height);
            self.contentView.center = CGPointMake(AlertViewWidth/2, self.contentView.center.y);
            [self.alertView addSubview:self.contentView];
            messageLabelY += contentView.frame.size.height + AlertViewVerticalElementSpace;
        }

        // Message
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                      messageLabelY,
                                                                      AlertViewWidth - AlertViewContentMargin*2,
                                                                      44)];
        self.messageLabel.text = message;
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont systemFontOfSize:15];
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.frame = [self adjustLabelFrameHeight:self.messageLabel];
        [self.alertView addSubview:self.messageLabel];
        
        // Line
        CALayer *lineLayer = [self lineLayer];
        lineLayer.frame = CGRectMake(0, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + AlertViewVerticalElementSpace, AlertViewWidth, AlertViewLineLayerWidth);
        [self.alertView.layer addSublayer:lineLayer];
        
        self.buttonsY = lineLayer.frame.origin.y + lineLayer.frame.size.height;
        
        // Buttons
        self.buttonsShouldStack = shouldstack;
        
        if (cancelTitle) {
            [self addButtonWithTitle:cancelTitle];
        } else {
            [self addButtonWithTitle:NSLocalizedString(@"Ok", nil)];
        }
        
        if (otherTitles && [otherTitles count] > 0) {
            for (id otherTitle in otherTitles) {
                NSParameterAssert([otherTitle isKindOfClass:[NSString class]]);
                [self addButtonWithTitle:(NSString *)otherTitle];
            }
        }
        
        self.alertView.bounds = CGRectMake(0, 0, AlertViewWidth, 150);
        
        if (completion) {
            self.completion = completion;
        }

        [self resizeViews];
        
        self.alertView.center = [self centerWithFrame:frame];
        
        [self setupGestures];
    }
    return self;
}

- (void)setupGestures
{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.tap setNumberOfTapsRequired:1];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView setMultipleTouchEnabled:NO];
    [self.backgroundView addGestureRecognizer:self.tap];
}

- (void)setTapToDismissEnabled:(BOOL)enabled
{
    self.tap.enabled = enabled;
}

- (void)dismiss:(id)sender
{
    [self dismiss:sender animated:YES];
}

- (void)dismiss:(id)sender animated:(BOOL)animated
{
    self.visible = NO;

    if ([[[CCAlertViewStack sharedInstance] alertViews] count] == 1) {
        if (animated) {
            [self dismissAlertAnimation];
        }
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [self.mainWindow tintColorDidChange];
        }
        [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
//            [self.alertWindow setHidden:YES];
//            [self.alertWindow removeFromSuperview];
//            self.alertWindow.rootViewController = nil;
//            self.alertWindow = nil;
//            [self.mainWindow makeKeyAndVisible];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [[CCAlertViewStack sharedInstance] pop:self];
        [self.view removeFromSuperview];
    }];

    if (self.completion) {
        BOOL cancelled = NO;
        if (sender == self.cancelButton || sender == self.tap) {
            cancelled = YES;
        }
        NSInteger buttonIndex = -1;
        if (self.buttons) {
            NSUInteger index = [self.buttons indexOfObject:sender];
            if (buttonIndex != NSNotFound) {
                buttonIndex = index;
            }
        }
        self.completion(cancelled, buttonIndex);
    }
}

- (CGPoint)centerWithFrame:(CGRect)frame
{
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - [self statusBarOffset]);
}

- (CGFloat)statusBarOffset
{
    CGFloat statusBarOffset = 0;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        statusBarOffset = 20;
    }
    return statusBarOffset;
}

- (CGRect)frameForOrientation:(UIInterfaceOrientation)orientation
{
//    CGRect frame;
//    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
//        CGRect bounds = [UIScreen mainScreen].bounds;
//        frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
//    } else {
//        frame = [UIScreen mainScreen].bounds;
//    }
    return [UIScreen mainScreen].bounds;
}

- (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGFloat height;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [label.text sizeWithFont:label.font
                             constrainedToSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];

        height = size.height;
        #pragma clang diagnostic pop
    } else {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        context.minimumScaleFactor = 1.0;
        CGRect bounds = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:label.font}
                                                 context:context];
        height = bounds.size.height;
    }
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

- (CALayer *)lineLayer
{
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [[UIColor colorWithWhite:0.90 alpha:0.3] CGColor];
    return lineLayer;
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    UIButton *button = [self genericButton];
    [button setTitle:title forState:UIControlStateNormal];

    if (!self.cancelButton) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.cancelButton = button;
        self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth, AlertViewButtonHeight);
    } else if (self.buttonsShouldStack) {
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        self.otherButton = button;
        
        button.frame = self.cancelButton.frame;
        
        CGFloat lastButtonYOffset = self.cancelButton.frame.origin.y + AlertViewButtonHeight;
        self.cancelButton.frame = CGRectMake(0, lastButtonYOffset, AlertViewWidth, AlertViewButtonHeight);
        
        CALayer *lineLayer = [self lineLayer];
        lineLayer.frame = CGRectMake(0, lastButtonYOffset, AlertViewWidth, AlertViewLineLayerWidth);
        [self.alertView.layer addSublayer:lineLayer];
    } else if (self.buttons && [self.buttons count] > 1) {
        UIButton *lastButton = (UIButton *)[self.buttons lastObject];
        lastButton.titleLabel.font = [UIFont systemFontOfSize:17];
        if ([self.buttons count] == 2) {
            [self.verticalLine removeFromSuperlayer];
            CALayer *lineLayer = [self lineLayer];
            lineLayer.frame = CGRectMake(0, self.buttonsY + AlertViewButtonHeight, AlertViewWidth, AlertViewLineLayerWidth);
            [self.alertView.layer addSublayer:lineLayer];
            lastButton.frame = CGRectMake(0, self.buttonsY + AlertViewButtonHeight, AlertViewWidth, AlertViewButtonHeight);
            self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth, AlertViewButtonHeight);
        }
        CGFloat lastButtonYOffset = lastButton.frame.origin.y + AlertViewButtonHeight;
        button.frame = CGRectMake(0, lastButtonYOffset, AlertViewWidth, AlertViewButtonHeight);
    } else {
        self.verticalLine = [self lineLayer];
        self.verticalLine.frame = CGRectMake(AlertViewWidth/2, self.buttonsY, AlertViewLineLayerWidth, AlertViewButtonHeight);
        [self.alertView.layer addSublayer:self.verticalLine];
        button.frame = CGRectMake(AlertViewWidth/2, self.buttonsY, AlertViewWidth/2, AlertViewButtonHeight);
        self.otherButton = button;
        self.cancelButton.frame = CGRectMake(0, self.buttonsY, AlertViewWidth/2, AlertViewButtonHeight);
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    
    [self.alertView addSubview:button];
    self.buttons = (self.buttons) ? [self.buttons arrayByAddingObject:button] : @[ button ];
    return [self.buttons count] - 1;
}

- (UIButton *)genericButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    return button;
}

- (void)setBackgroundColorForButton:(id)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1.0]];
}

- (void)clearBackgroundColorForButton:(id)sender
{
    [sender setBackgroundColor:[UIColor clearColor]];
}

- (void)resizeViews
{
    CGFloat totalHeight = 0;
    for (UIView *view in [self.alertView subviews]) {
        if ([view class] != [UIButton class]) {
            totalHeight += view.frame.size.height + AlertViewVerticalElementSpace;
        }
    }
    if (self.buttons) {
        NSUInteger otherButtonsCount = [self.buttons count];
        if (self.buttonsShouldStack) {
            totalHeight += AlertViewButtonHeight * otherButtonsCount;
        } else {
            totalHeight += AlertViewButtonHeight * (otherButtonsCount > 2 ? otherButtonsCount : 1);
        }
    }
    totalHeight += AlertViewVerticalElementSpace;
    
    self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                      self.alertView.frame.origin.y,
                                      self.alertView.frame.size.width,
                                      totalHeight);
}

- (void)show
{
    [[CCAlertViewStack sharedInstance] push:self];
}

- (void)showInternal
{
    [self.alertWindow addSubview:self.view];
    [self.alertWindow makeKeyAndVisible];
    self.visible = YES;
    [self showBackgroundView];
    [self showAlertAnimation];
}

- (void)showBackgroundView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self.mainWindow tintColorDidChange];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1;
    }];
}

- (void)showAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;

    [self.alertView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;

    [self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}


- (void)hide
{
    [self.view removeFromSuperview];
}

@end


@implementation CCAlertViewStack

+ (instancetype)sharedInstance
{
    static CCAlertViewStack *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CCAlertViewStack alloc] init];
        _sharedInstance.alertViews = [NSMutableArray array];
    });

    return _sharedInstance;
}

- (void)push:(HDAlertView *)alertView
{
    [self.alertViews addObject:alertView];
    [alertView showInternal];
    for (HDAlertView *av in self.alertViews) {
        if (av != alertView) {
            [av hide];
        }
    }
}

- (void)pop:(HDAlertView *)alertView
{
    [self.alertViews removeObject:alertView];
    HDAlertView *last = [self.alertViews lastObject];
    if (last) {
        [last showInternal];
    }
}

@end
