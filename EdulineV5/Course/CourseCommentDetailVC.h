//
//  CourseCommentDetailVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/18.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCommentDetailVC : BaseViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

NS_ASSUME_NONNULL_END
