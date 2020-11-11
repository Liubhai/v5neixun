//
//  LiveRoomPersonCell.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveRoomPersonCell.h"
#import "V5_Constant.h"

@implementation LiveRoomPersonCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews {
//    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 113, 64)];
//    _faceImageView.clipsToBounds = YES;
//    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
//    _faceImageView.image = DefaultImage;
//    [self.contentView addSubview:_faceImageView];
    
    UIView *videoCanvasView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 113, 64)];
    [self.contentView addSubview:videoCanvasView];
    _videoCanvasView = videoCanvasView;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 113, 64)];
    [self.contentView addSubview:backImageView];
    backImageView.image = Image(@"cam_off_slices");
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backImageView = backImageView;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 - 16, 113, 16)];
    _nameLabel.layer.masksToBounds = YES;
    _nameLabel.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4].CGColor;
    _nameLabel.font = SYSTEMFONT(11);
    _nameLabel.text = @" 傻子一号";
    _nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_nameLabel];
}

- (void)setLiveUserInfo:(NSString *)userid localUserId:(nonnull NSString *)localUserId {
    if ([userid isEqualToString:localUserId]) {
        [[[TICManager sharedInstance] getTRTCCloud] stopLocalPreview];
    } else {
        [[[TICManager sharedInstance] getTRTCCloud] stopRemoteView:userid];
    }
    _nameLabel.text = userid;
    _render.userId = userid;
    _render.streamType = TICStreamType_Main;
    if ([userid isEqualToString:localUserId]) {
        [[[TICManager sharedInstance] getTRTCCloud] startLocalPreview:YES view:_render];
    } else {
        [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:userid view:_render];
    }
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    self.nameLabel.text = userModel.userName;
    self.backImageView.hidden = userModel.enableVideo ? YES : NO;
    self.videoCanvasView.hidden = userModel.enableVideo ? NO : YES;
}

@end
