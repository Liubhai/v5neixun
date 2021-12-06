//
//  SpecialProjectExamList.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/12/25.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^specialUserFaceVerify)(BOOL result);

@interface SpecialProjectExamList : BaseViewController

@property (nonatomic, strong) specialUserFaceVerify specialuserFaceVerifyResult;
@property (strong, nonatomic) NSString *examTypeString;
@property (strong, nonatomic) NSString *examTypeId;// 板块类型 1 2 3 4

@property (strong, nonatomic) NSString *examModuleId;// 模块ID(每个板块可以添加很多模块)
@end

NS_ASSUME_NONNULL_END
