//
//  CourseTreeListViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/23.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseMainViewController.h"
#import "CourseDetailPlayVC.h"
#import "V5_Constant.h"
#import "MYTreeTableManager.h"
#import "CourseListModel.h"
#import "NewClassCourseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CourseTreeListViewControllerDelegate <NSObject>

@optional
- (void)newClassCourseCellDidSelected:(CourseListModel *)model indexpath:(NSIndexPath *)indexpath;

@end

@interface CourseTreeListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) id<CourseTreeListViewControllerDelegate> delegate;

@property (nonatomic, strong) MYTreeTableManager *manager;
@property (strong, nonatomic) NSString *courseId;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (weak, nonatomic) CourseMainViewController *vc;
@property (weak, nonatomic) CourseDetailPlayVC *detailVC;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (strong ,nonatomic)NSDictionary    *videoInfoDict;//这个课程的详情

@property (strong ,nonatomic)UITableView     *tableView;
@property (strong, nonatomic) NSMutableArray *courseListArray;
//学习记录那边传进来的课时id
@property (strong, nonatomic)NSString *sid;
@property (assign, nonatomic) BOOL canPlayRecordVideo;

@property (strong, nonatomic) NSString *courselayer; // 1 一层 2 二层 3 三层(涉及到目录布局)
@property (assign, nonatomic) BOOL isMainPage; // yes 详情页面目录 no 播放页面目录

- (void)getClassCourseList;

@end

NS_ASSUME_NONNULL_END
