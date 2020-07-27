//
//  CourseStudentListViewController.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/7/27.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"
#import "V5_Constant.h"
#import "Net_Path.h"
#import "CourseMainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseStudentListViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSString *courseId;
@property (assign, nonatomic) CGFloat tabelHeight;

@property (strong, nonatomic) CourseMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
@property (assign, nonatomic) BOOL canPlayRecordVideo;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;



@end

NS_ASSUME_NONNULL_END
