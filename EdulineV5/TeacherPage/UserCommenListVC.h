//
//  UserCommenListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/6/9.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCommenListVC : BaseViewController

@property (strong, nonatomic) NSString *themeString;// 到底是什么类型的用户列表(公用)
@property (strong, nonatomic) NSString *userId;// 当前页面是请求谁的关注粉丝访客列表

@end

NS_ASSUME_NONNULL_END
