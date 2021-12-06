//
//  TaojuanDetailListViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/22.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TaojuanDetailListUserFaceVerify)(BOOL result);

@interface TaojuanDetailListViewController : BaseViewController

@property (nonatomic, strong) TaojuanDetailListUserFaceVerify TaojuanDetailListUserFaceVerifyResult;

@property (strong, nonatomic) NSString *rollup_id;
@property (strong, nonatomic) NSString *module_title;

@end

NS_ASSUME_NONNULL_END
