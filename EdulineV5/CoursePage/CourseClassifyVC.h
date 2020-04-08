//
//  CourseClassifyVC.h
//  EdulineV5
//
//  Created by 刘邦海 on 2020/4/7.
//  Copyright © 2020 刘邦海. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CourseClassifyVCDelegate <NSObject>

@optional
- (void)chooseCourseClassify:(NSDictionary *)info;

@end

@interface CourseClassifyVC : BaseViewController

@property (weak, nonatomic) id<CourseClassifyVCDelegate> delegate;
@property (assign, nonatomic) BOOL isMainPage;// 是不是课程主页
@property (strong, nonatomic) NSString *typeId;// 当前选中的类型

@end

NS_ASSUME_NONNULL_END
