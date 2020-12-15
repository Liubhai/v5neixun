//
//  LiveStudentView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveStudentView.h"
#import "V5_Constant.h"

@implementation LiveStudentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _studentRenderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:_studentRenderView];
    
    _defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _defaultImageView.image = Image(@"cam_off_slices");
    _defaultImageView.clipsToBounds = YES;
    _defaultImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_defaultImageView];
    
    _closeStudentViewButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 22 - 3, 3, 22, 22)];
    [_closeStudentViewButton setImage:Image(@"live_close_icon") forState:0];
    [_closeStudentViewButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeStudentViewButton];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 16, self.bounds.size.width, 16)];
    _nameLabel.layer.masksToBounds = YES;
    _nameLabel.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    _nameLabel.font = SYSTEMFONT(11);
    _nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_nameLabel];
    
}

- (void)updateVideoImageWithMuted:(BOOL)muted {
//    NSString *imageName = muted ? @"icon-video-off-min" : @"icon-video-on-min";
    self.defaultImageView.hidden = !muted;
//    [self.videoMuteButton setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
}

- (void)updateAudioImageWithMuted:(BOOL)muted {
//    NSString *imageName = muted ? @"icon-speakeroff-dark" : @"icon-speaker3";
//    [self.audioMuteButton setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
}

- (void)setButtonEnabled:(BOOL)enabled {
//    [self.videoMuteButton setEnabled:enabled];
//    [self.audioMuteButton setEnabled:enabled];
}

- (void)buttonClick:(UIButton *)sender {
    
}

@end
