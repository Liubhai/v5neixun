//
//  BaseViewController.h
//  zlydoc-iphone
//
//  Created by Ryan on 14-5-23.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowAlertProtocol <NSObject>
- (void)showAlert:(NSString * _Nonnull)message handle:(void(^_Nullable)(UIAlertAction * _Nullable))handle;
- (void)showAlert:(NSString * _Nonnull)message;
@end

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate, ShowAlertProtocol>
{
    UILabel *_titleLabel;
    UIButton *_rightButton;
    UIButton *_leftButton;
    UIImageView *_titleImage;
    UIView *_lineTL;
	
}
@property (nonatomic,retain) UIButton *leftButton;
@property (nonatomic,retain) UIButton *rightButton;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *titleImage;
@property (nonatomic,retain) UIView *lineTL;
@property (nonatomic, assign) BOOL notHiddenNav;
@property (nonatomic, assign) BOOL hiddenNavDisappear;

- (void)leftButtonClick:(id)sender;
- (void)rightButtonClick:(id)sender;

@end
