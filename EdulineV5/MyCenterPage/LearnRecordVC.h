//
//  LearnRecordVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/5/12.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^userFaceLearnRecordVerify)(BOOL result);

@interface LearnRecordVC : BaseViewController

@property (nonatomic, strong) userFaceLearnRecordVerify userFaceLearnRecordVerifyResult;

@end

NS_ASSUME_NONNULL_END
