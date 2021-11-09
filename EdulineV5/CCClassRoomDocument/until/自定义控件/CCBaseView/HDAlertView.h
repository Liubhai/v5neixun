//
//  CCAlertView.h
//  CCClassRoom
//
//  Created by 刘强强 on 2020/8/31.
//  Copyright © 2020 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CCAlertViewCompletionBlock)(BOOL cancelled, NSInteger buttonIndex);

NS_ASSUME_NONNULL_BEGIN

@interface HDAlertView : UIViewController

@property (nonatomic, getter = isVisible) BOOL visible;

/**
 * @param otherTitles Must be a NSArray containing type NSString, or set to nil for no otherTitles.
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                       contentView:(UIView *)view
                        completion:(CCAlertViewCompletionBlock)completion;

- (void)setTapToDismissEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
