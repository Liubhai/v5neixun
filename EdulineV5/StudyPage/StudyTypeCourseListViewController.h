//
//  StudyTypeCourseListViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2021/9/23.
//  Copyright © 2021 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "StudyRootVC.h"
#import "V5_Constant.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^userFaceStudyTypeCourseListVerify)(BOOL result);

@interface StudyTypeCourseListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) userFaceStudyTypeCourseListVerify userFaceStudyTypeCourseListVerifyResult;
@property (weak, nonatomic) StudyRootVC *vc;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSString *courseType;// 课程类型
@property (strong, nonatomic) NSString *screenType;// 最近加入优先还是最近学习优先

- (void)getFirstStudyCourseData;

@end

NS_ASSUME_NONNULL_END
