//
//  CommonPopView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/22.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonPopView : UIView<UITextViewDelegate> {
    
}

@property (strong, nonatomic) UIView *popWhiteView;
@property (strong, nonatomic) UIView *popTextBackView;
@property (strong, nonatomic) UITextView *popTextView;
@property (strong, nonatomic) UILabel *popTextPlaceholderLabel;
@property (strong, nonatomic) UILabel *popTextMaxCountView;
@property (strong, nonatomic) UIView *popLine1View;
@property (strong, nonatomic) UIButton *popCancelButton;
@property (strong, nonatomic) UIView *popLine2View;
@property (strong, nonatomic) UIButton *popSureButton;
@property (assign, nonatomic) NSInteger wordMax;

@end

NS_ASSUME_NONNULL_END
