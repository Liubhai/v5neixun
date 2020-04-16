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
#import "CourseDetailPlayVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCommentListVC : BaseViewController

@property (strong, nonatomic) NSString *courseId;

@property (strong, nonatomic) UITableView *tableView;
/** 所有数据源 */
@property (strong, nonatomic) NSDictionary *allCommentInfo;
/** 当前显示的数据列表 */
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic) CourseMainViewController *vc;
@property (weak, nonatomic) CourseDetailPlayVC *detailVC;

@property (assign, nonatomic) CGFloat tabelHeight;
@property (assign, nonatomic) BOOL canScroll;

/** 视频播放了之后整个外部tableview就不允许滚动了 */
@property (assign, nonatomic) BOOL canScrollAfterVideoPlay;
@property (assign, nonatomic) BOOL cellTabelCanScroll;

@property (assign, nonatomic) BOOL cellType;// yes 是笔记 no 是点评


@end

NS_ASSUME_NONNULL_END
