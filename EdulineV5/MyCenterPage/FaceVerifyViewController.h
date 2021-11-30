//
//  FaceVerifyViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/11/29.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceVerifyViewController : BaseViewController

@property (nonatomic, readwrite, assign) BOOL hasFinished;
@property (nonatomic, assign) BOOL isVerify;// 是否是人脸绑定 yes 是人脸绑定 no 是人脸对比(已经绑定人脸)

@end

NS_ASSUME_NONNULL_END
