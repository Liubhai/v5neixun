//
//  SharePosterViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/1/15.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SharePosterViewController : BaseViewController

@property (strong, nonatomic) NSString *type;// 1 课程 2 资讯 3；砍价 4 拼团
@property (strong, nonatomic) NSString *courseType;// 课程类型
@property (strong, nonatomic) NSString *sourceId;// 资源ID

@property (strong, nonatomic) NSString *activityId;// 活动ID
@property (strong, nonatomic) NSString *activityType;// 活动类型


@end

NS_ASSUME_NONNULL_END
