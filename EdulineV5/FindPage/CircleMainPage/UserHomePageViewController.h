//
//  UserHomePageViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/6/17.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserHomePageViewController : BaseViewController

@property (strong, nonatomic) NSString *teacherId;
@property (strong, nonatomic) NSDictionary *teacherInfoDict;

@end

NS_ASSUME_NONNULL_END
