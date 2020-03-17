//
//  CourseCommentListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/17.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"
#import "CourseMainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCommentListVC : BaseViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) CourseMainViewController *vc;

@property (assign, nonatomic) CGFloat tabelHeight;
@property (assign, nonatomic) BOOL canScroll;

/** 视频播放了之后整个外部tableview就不允许滚动了 */
@property (assign, nonatomic) BOOL canScrollAfterVideoPlay;
@property (assign, nonatomic) BOOL cellTabelCanScroll;


@end

NS_ASSUME_NONNULL_END
