//
//  LiveCourseListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/10/26.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LiveCourseListVCDelegate <NSObject>

@optional
- (void)liveRoomJumpCourseDetailPage:(NSDictionary *)dict;

@end

@interface LiveCourseListVC : BaseViewController

@property (assign, nonatomic) id<LiveCourseListVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
