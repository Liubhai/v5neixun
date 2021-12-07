//
//  StudyRootVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/2.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^userFaceStudyRootVerify)(BOOL result);

@interface StudyRootVC : BaseViewController
@property (assign, nonatomic) BOOL canScroll;
/** 视频播放了之后整个外部tableview就不允许滚动了 */
@property (assign, nonatomic) BOOL canScrollAfterVideoPlay;

@property (nonatomic, strong) userFaceStudyRootVerify userFaceStudyRootVerifyResult;

@end

NS_ASSUME_NONNULL_END
