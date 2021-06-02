//
//  UserCircleListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/6/2.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCircleListVC : BaseViewController

@property (strong, nonatomic) NSString *user_id;// 圈子所属用户 ID
@property (assign, nonatomic) CGFloat tabelHeight;

@end

NS_ASSUME_NONNULL_END
