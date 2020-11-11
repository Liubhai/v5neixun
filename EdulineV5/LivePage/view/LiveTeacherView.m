//
//  LiveTeacherView.m
//  EdulineV5
//
//  Created by 刘邦海 on 2020/11/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "LiveTeacherView.h"
#import "V5_Constant.h"

@implementation LiveTeacherView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {
    
    _videoRenderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:_videoRenderView];
    
    _defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _defaultImageView.image = Image(@"cam_off_slices");
    _defaultImageView.clipsToBounds = YES;
    _defaultImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_defaultImageView];
    
}

@end
