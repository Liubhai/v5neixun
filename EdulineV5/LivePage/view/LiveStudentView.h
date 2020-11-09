//
//  LiveStudentView.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveStudentView : UIView

@property (weak, nonatomic) id<RoomProtocol> delegate;
@property (strong, nonatomic) UIImageView *defaultImageView;
@property (strong, nonatomic) UIView *studentRenderView;
@property (strong, nonatomic) UIButton *closeStudentViewButton;
- (void)setButtonEnabled:(BOOL)enabled;
- (void)updateVideoImageWithMuted:(BOOL)muted;
- (void)updateAudioImageWithMuted:(BOOL)muted;

@end

NS_ASSUME_NONNULL_END
