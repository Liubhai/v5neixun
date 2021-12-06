//
//  CourseTestListVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/26.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseMainViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^courseTestListUserFaceVerify)(BOOL result);

@interface CourseTestListVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) courseTestListUserFaceVerify courseTestListUserFaceVerifyResult;

@property (strong, nonatomic) NSString *courseId;
@property (assign, nonatomic) CGFloat tabelHeight;

@property (weak, nonatomic) CourseMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (assign, nonatomic) BOOL canPlayRecordVideo;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)getCourseTestListInfo:(NSDictionary *)courseInfo;

@end

NS_ASSUME_NONNULL_END
