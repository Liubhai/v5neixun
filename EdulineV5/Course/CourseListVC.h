//
//  CourseListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/3/19.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseMainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseListVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isClassCourse;// 是否是班级课列表
@property (strong, nonatomic) NSString *courseId;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) CourseMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (strong ,nonatomic)NSDictionary    *videoInfoDict;//这个课程的详情

@property (strong ,nonatomic)UITableView     *tableView;
@property (strong, nonatomic) NSMutableArray *courseListArray;
//学习记录那边传进来的课时id
@property (strong, nonatomic)NSString *sid;
@property (assign, nonatomic) BOOL canPlayRecordVideo;

@property (strong, nonatomic) NSString *courselayer; // 1 一层 2 二层 3 三层(涉及到目录布局)
@property (assign, nonatomic) BOOL isMainPage; // yes 详情页面目录 no 播放页面目录

@end

NS_ASSUME_NONNULL_END
