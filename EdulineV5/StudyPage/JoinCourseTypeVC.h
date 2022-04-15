//
//  JoinCourseTypeVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/11.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^userFaceJoinCourseTypeVerify)(BOOL result);

@interface JoinCourseTypeVC : BaseViewController

@property (nonatomic, strong) userFaceJoinCourseTypeVerify userFaceJoinCourseTypeVerify;
@property (strong, nonatomic) NSString *courseType;
@property (strong, nonatomic) NSString *typeString;

@end

NS_ASSUME_NONNULL_END
